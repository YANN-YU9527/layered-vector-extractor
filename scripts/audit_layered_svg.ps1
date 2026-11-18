[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$ErrorActionPreference = 'Stop'
$resolved = (Resolve-Path -LiteralPath $Path).Path

try {
    [xml]$svg = Get-Content -Raw -LiteralPath $resolved
}
catch {
    Write-Error "Invalid SVG/XML: $($_.Exception.Message)"
    exit 1
}

$errors = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()
$root = $svg.DocumentElement

if ($null -eq $root -or $root.LocalName -ne 'svg') {
    $errors.Add('Root element must be <svg>.')
}

$images = @($svg.SelectNodes("//*[local-name()='image']"))
if ($images.Count -gt 0) {
    $errors.Add("Found $($images.Count) embedded or linked <image> element(s).")
}

$filters = @($svg.SelectNodes("//*[local-name()='filter']"))
if ($filters.Count -gt 0) {
    $warnings.Add("Found $($filters.Count) filter definition(s); Illustrator may rasterize their appearance.")
}

$foreignObjects = @($svg.SelectNodes("//*[local-name()='foreignObject']"))
if ($foreignObjects.Count -gt 0) {
    $errors.Add("Found $($foreignObjects.Count) <foreignObject> element(s).")
}

$logoGroups = @($svg.SelectNodes("//*[@data-role='logo-lettering']"))
foreach ($logoGroup in $logoGroups) {
    $logoName = $logoGroup.GetAttribute('id')
    if ([string]::IsNullOrWhiteSpace($logoName)) { $logoName = '(unnamed logo-lettering group)' }
    $liveLogoText = @($logoGroup.SelectNodes(".//*[local-name()='text']"))
    if ($liveLogoText.Count -gt 0) {
        $errors.Add("Logo lettering group '$logoName' contains $($liveLogoText.Count) live <text> element(s); reconstruct logo lettering as paths.")
    }
    $logoPaths = @($logoGroup.SelectNodes(".//*[local-name()='path' or local-name()='polygon' or local-name()='rect' or local-name()='circle' or local-name()='ellipse']"))
    if ($logoPaths.Count -eq 0) {
        $warnings.Add("Logo lettering group '$logoName' contains no vector outline geometry.")
    }
}

$layers = @()
if ($null -ne $root) {
    foreach ($node in $root.ChildNodes) {
        if ($node.NodeType -ne [System.Xml.XmlNodeType]::Element -or $node.LocalName -ne 'g') { continue }
        $id = $node.GetAttribute('id')
        $aiName = $node.GetAttribute('data-ai-layer')
        if ($id -like 'layer-*' -or -not [string]::IsNullOrWhiteSpace($aiName)) {
            $layers += $node
            if ($id -notlike 'layer-*') { $errors.Add("Layer '$aiName' needs an id beginning with 'layer-'.") }
            if ([string]::IsNullOrWhiteSpace($aiName)) { $errors.Add("Layer '$id' needs a data-ai-layer name.") }
            if ($node.SelectNodes('.//*').Count -eq 0) { $warnings.Add("Layer '$id' is empty.") }
        }
    }
}

if ($layers.Count -eq 0) {
    $errors.Add('No tagged top-level layer groups were found.')
}

$shapeCount = @($svg.SelectNodes("//*[local-name()='path' or local-name()='rect' or local-name()='circle' or local-name()='ellipse' or local-name()='polygon' or local-name()='polyline' or local-name()='line' or local-name()='text']")).Count
if ($shapeCount -eq 0) {
    $errors.Add('No editable vector shapes or text were found.')
}

$duplicateIds = @($svg.SelectNodes('//*[@id]') | Group-Object { $_.GetAttribute('id') } | Where-Object Count -gt 1)
foreach ($duplicate in $duplicateIds) {
    $errors.Add("Duplicate id '$($duplicate.Name)' appears $($duplicate.Count) times.")
}

Write-Output "SVG: $resolved"
Write-Output "Tagged layers: $($layers.Count)"
foreach ($layer in $layers) {
    Write-Output "  - $($layer.GetAttribute('data-ai-layer')) [$($layer.GetAttribute('id'))]"
}
Write-Output "Editable shapes/text: $shapeCount"
Write-Output "Logo lettering groups: $($logoGroups.Count)"

foreach ($warning in $warnings) { Write-Warning $warning }
foreach ($problem in $errors) { Write-Output "ERROR: $problem" }

if ($errors.Count -gt 0) { exit 1 }
Write-Output 'PASS: Layered SVG passed structural audit.'
exit 0
