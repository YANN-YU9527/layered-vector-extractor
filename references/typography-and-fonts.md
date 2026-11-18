# Typography and font fidelity

Read this reference whenever the source contains words, numbers, monograms, or letterforms.

## Classify before drawing

Use two categories:

### Logo or brand lettering

This includes the dominant brand name, custom display lettering, wordmarks, monograms, and secondary wording that belongs to the same logo lockup. Examples include a large stylized Chinese restaurant name and its English name directly attached to the mark.

- Reconstruct the visible glyphs as vector paths. A similar font is only a construction reference, never the delivered logo geometry.
- Preserve irregular cuts, compression, rotation, spacing, counters, and handmade distortion from the source.
- Make each character or logical letter cluster independently selectable. Use a parent group named for the wording and add `data-role="logo-lettering"`.
- Record the original Unicode wording in the manifest or `aria-label`, but do not insert hidden live text behind the paths.
- Compare silhouettes and negative spaces at close zoom. The goal is the source artwork, not typographic correctness.

### Ordinary supporting text

This includes captions, body copy, slogans outside the logo lockup, legal copy, labels, and small informational text.

- Transcribe the wording exactly, including traditional/simplified variants, punctuation, capitalization, and line breaks.
- Identify family, weight, style, width, optical size, and version. Check local fonts and user-supplied files first. When lookup is needed, verify against an official foundry, project repository, or other authoritative source.
- Confirm the match using several distinctive visible glyphs, spacing, numerals, and punctuation. Do not call a font exact from a single generic letter.
- Keep a confirmed exact match as live text in the canonical SVG/AI.

## Font packaging and licensing

Package a font file only when at least one of these is true:

- the user supplied it for the project;
- its license explicitly permits redistribution, such as a compatible OFL or Apache license;
- the user explicitly confirms they hold redistribution rights.

For packaged fonts:

- place files under `fonts/<family-name>/`;
- include the original license or copyright notice beside them;
- preserve the original filenames;
- record the font's source URL, version, PostScript name, license, and SHA-256 in `font-report.json`.

Do not copy a commercial or system font merely because it is installed. If the exact font is available locally but cannot be redistributed, keep live text linked to its precise PostScript name, make an outlined appearance variant, and state that the recipient must install or license the font to edit the text.

## When the exact font is unavailable

- Do not silently use a similar font.
- For one-to-one appearance, reconstruct the visible ordinary text as paths in `<name>-appearance.svg` when practical.
- Keep a separate live-text source only as an editing aid and label any substitute as non-exact in `font-report.json`.
- If the amount of text makes manual reconstruction unreasonable, report the unresolved font and request the font file rather than claiming a one-to-one editable match.

## Font report

Create `font-report.json` with one entry per text role:

```json
{
  "entries": [
    {
      "role": "logo-lettering",
      "wording": "山野私房菜 / MOUNTAIN WILD",
      "delivery": "vector-paths",
      "editable_as_text": false,
      "confidence": "source-traced"
    },
    {
      "role": "supporting-caption",
      "wording": "食材·自然·新鲜",
      "delivery": "live-text-and-outlined-appearance",
      "family": "Example Serif",
      "style": "Regular",
      "postscript_name": "ExampleSerif-Regular",
      "font_file": "fonts/example-serif/ExampleSerif-Regular.otf",
      "license": "OFL-1.1",
      "source_url": "https://example.invalid/official-font-source",
      "sha256": "...",
      "confidence": "exact"
    }
  ]
}
```

Omit unavailable fields rather than inventing them. Never use `exact` confidence for a visual approximation.
