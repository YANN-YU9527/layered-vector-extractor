---
name: layered-vector-extractor
description: Convert a user-provided raster image, photo, sketch, or illustration into genuinely editable, layered vector artwork, reconstructing logo lettering as paths and preserving ordinary text with exact licensed fonts when available. Use for image tracing, vector extraction, redraws, editable SVG, separated layers, or Illustrator-ready artwork; do not use for ordinary bitmap enhancement or simple format conversion.
---

# Layered Vector Extractor

Turn the supplied image into clean vector geometry that can be edited object by object. A bitmap embedded inside SVG, PDF, or AI is not an acceptable result.

## Interpret the request

- Treat the attached image as the source of content. Preserve its composition, silhouettes, proportions, palette, and visible text unless the user asks for a redesign.
- Default to a balanced editorial reconstruction: recognizable shapes and expressions, restrained path count, and easy editing. For logos and icons, favor geometric precision; for photos, deliberately simplify tonal detail into vector regions.
- Do not invent cropped or hidden content unless the user requests completion or outpainting.
- If the user asks to match the supplied reference aesthetic, read [references/vector-delivery-spec.md](references/vector-delivery-spec.md) and apply the closest preset. Otherwise preserve the source's own style.
- If the source is a dense multicolour poster, comic illustration, character collage, or similarly detailed artwork, read [references/fidelity-and-tracing.md](references/fidelity-and-tracing.md) and default to its high-fidelity mode.

## Choose the fidelity mode

- Use balanced mode for logos, icons, flat spot illustrations, and simple artwork where restrained paths matter more than microscopic detail.
- Use high-fidelity mode for dense illustrations. Preserve small colour regions, near-white foreground colours, anti-aliased edges, faces, linework, and micro-details instead of aggressively reducing the palette or deleting components.
- A true editable vector cannot be guaranteed pixel-identical to a complex raster. If the user asks for an exact match, explain the three outcomes in [references/fidelity-and-tracing.md](references/fidelity-and-tracing.md) and default to the high-fidelity true-vector option unless they explicitly choose a raster-containing hybrid or a pixel-shape reconstruction.

## Build the vector source

1. Inspect the source at full size before drawing. Identify the background, subjects, occlusion order, linework, text, and optional texture.
2. Reconstruct with native SVG elements and paths. Use filled shapes for color regions and stroked open paths for linework. Keep curves economical and smooth without sacrificing the selected fidelity mode.
3. Put each semantic editing unit in a named subgroup and each major depth/subject category in a top-level layer group. Follow the layer contract in [references/vector-delivery-spec.md](references/vector-delivery-spec.md).
4. Never use `<image>`, base64 raster data, bitmap filters, or a full-canvas clipping mask to disguise a raster trace. Avoid effects that Illustrator will rasterize.
5. Classify every visible word as either logo/brand lettering or ordinary supporting text, then follow [references/typography-and-fonts.md](references/typography-and-fonts.md). Logo lettering must be redrawn as paths; never approximate it with a replacement font.

Use a root structure compatible with both SVG editors and the included Illustrator converter:

```xml
<g id="layer-background" data-ai-layer="背景" inkscape:groupmode="layer" inkscape:label="背景">...</g>
<g id="layer-subject" data-ai-layer="主体" inkscape:groupmode="layer" inkscape:label="主体">...</g>
<g id="layer-linework" data-ai-layer="线稿" inkscape:groupmode="layer" inkscape:label="线稿">...</g>
```

The namespace `xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"` must be declared when those attributes are used.

## Handle lettering and fonts

- Treat dominant custom names, wordmarks, monograms, and all lettering inside a logo lockup as artwork. Reconstruct each visible glyph as native vector paths, group it by word or character, and tag the parent `data-role="logo-lettering"`. Do not leave logo lettering as `<text>` even when a similar font exists.
- For ordinary headings, captions, and body copy, identify the exact family, weight, style, and version when possible. Keep confirmed matches as live text and package the font only when redistribution is allowed or the user supplied the font.
- If exact ordinary-text font files cannot legally be packaged, keep a live-text source for editing and provide an outlined appearance version for one-to-one display. Never silently substitute a similar font and call it exact.
- Record every typography decision, font source, license, and confidence in `font-report.json` as specified in [references/typography-and-fonts.md](references/typography-and-fonts.md).

## Validate

- Render the SVG to a PNG preview and compare it visually with the source at full view and close zoom.
- For high-fidelity work, produce a source/vector side-by-side comparison and inspect it at full view, 100%, and 200%. Reject unexpected background-coloured pinholes, white speckling, broken silhouettes, missing small shapes, or palette collapse before delivery.
- Run `scripts/audit_layered_svg.ps1 -Path <svg>` in PowerShell. Fix every error; review warnings rather than ignoring them.
- Confirm that major shapes can be selected independently, paths have reasonable point counts, layer names are meaningful, no raster is embedded, and no `data-role="logo-lettering"` group contains live text.

## Produce Adobe Illustrator output

- The layered SVG is the canonical editable source.
- When Adobe Illustrator is installed and the user requests `.ai`, open Illustrator and run `scripts/svg_to_layered_ai.jsx` through **File > Scripts > Other Script**. Choose the canonical SVG. The script promotes tagged top-level SVG groups to Illustrator layers and saves a new PDF-compatible `.ai` without overwriting an existing file.
- Reopen the `.ai` and inspect the Layers panel. Confirm separate named layers and editable objects before claiming native AI delivery.
- If Illustrator is unavailable, do not rename another format to `.ai` or claim native AI output. Deliver the layered SVG plus the converter script and state that Illustrator is required for the final native save.

## Deliver

Prefer one clearly named output folder containing:

- `<name>-layered.svg` — canonical editable source
- `<name>-preview.png` — visual proof
- `<name>-comparison.png` — source/vector comparison for high-fidelity work
- `<name>-layered.ai` — only after successful Illustrator conversion and inspection
- `<name>-appearance.svg` — outlined ordinary text when the exact font cannot be packaged
- `<name>-manifest.json` — canvas size, layer order, palette, fonts, and any intentional simplifications
- `font-report.json` — role-by-role font/path decisions and license status
- `fonts/` — exact redistributable fonts plus their license files, only when allowed

In the handoff, state whether `.ai` was actually created in Illustrator, list the layer names, confirm that logo lettering is outlined, and disclose the fidelity profile, working resolution, palette strategy, component filtering, simplified texture, unresolved font, or non-exact substitution. Never call a complex vector reconstruction pixel-identical unless that claim was actually verified.
