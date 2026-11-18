# Vector delivery specification

Read this reference when constructing the SVG, choosing a reference-inspired style, or preparing Illustrator delivery.

## Layer contract

Use only the layers needed by the artwork, ordered back to front. Each must be a direct child of the root `<svg>` and carry both `id="layer-..."` and `data-ai-layer="..."`.

Recommended names:

1. `背景`
2. `环境与道具`
3. `人物-后层`
4. `人物-前层`
5. `线稿`
6. `细节与高光`
7. `文字`
8. `矢量纹理`

Inside a layer, name meaningful groups such as `人物A-头部`, `人物A-上衣`, `桌面`, or `标题`. Do not make every small path its own layer.

Separate `标志字轮廓` from `普通文字` when both are present. Mark the logo-lettering group with `data-role="logo-lettering"`; every glyph inside it must be path geometry rather than `<text>`.

## Geometry and editability

- Set `viewBox`, width, and height explicitly.
- Prefer paths, circles, ellipses, rectangles, polygons, and editable text.
- Use consistent stroke widths, `stroke-linecap="round"`, and `stroke-linejoin="round"` for hand-drawn work unless the source calls for sharp geometry.
- Use compound paths only when they simplify editing. Avoid unnecessary clipping paths, masks, filters, and expanded micro-shapes.
- Keep opacity on the object or group that needs it; avoid global opacity that makes later editing confusing.
- Keep gradients simple and editable. Do not use mesh gradients unless the user explicitly prioritizes high fidelity over broad editor compatibility.
- Vector texture must be sparse hatching, dots, or grain shapes. Never embed a raster texture.

## Reference-derived style presets

The supplied references describe a family of everyday-life editorial illustration, not one mandatory house style. Select a preset only when the user asks for this aesthetic.

### A. Flat cutout

Large solid color fields, little or no outline, simplified facial features, bold negative space, and a compact warm palette. Best for poster-like scenes and social graphics.

### B. Monochrome ink

Black-and-white line art with a few solid black masses, lively imperfect contours, and minimal detail. Best for pose collections and spot illustrations.

### C. Cozy editorial color

Loose dark outlines, warm flat colors, rounded furniture and figures, small expressive marks, and hand-lettered headings. Best for domestic daily-life scenes.

### D. Pencil-paper vector approximation

Muted cream, camel, brown, navy, and blush colors with sparse vector hatching or stipple groups. Preserve the handmade feeling while keeping texture separately selectable. Do not simulate paper by embedding a bitmap.

## Manifest fields

Write a small JSON object with:

```json
{
  "source": "original filename",
  "canvas": {"width": 1080, "height": 1350, "viewBox": "0 0 1080 1350"},
  "layers_back_to_front": ["背景", "环境与道具", "人物-后层", "人物-前层", "线稿", "细节与高光", "文字"],
  "palette": ["#F4EFE6", "#E93424", "#0B0B0B"],
  "fonts": [],
  "font_report": "font-report.json",
  "fidelity": {
    "profile": "high-fidelity-vector",
    "working_resolution": "1200x1330",
    "palette_strategy": "adaptive-48-colour",
    "component_filtering": "none",
    "comparison_preview": "example-comparison.png"
  },
  "simplifications": ["Paper grain represented with sparse vector dots"],
  "native_ai_verified": false
}
```

Set `native_ai_verified` to true only after opening the `.ai` in Illustrator and checking its layers and objects.
