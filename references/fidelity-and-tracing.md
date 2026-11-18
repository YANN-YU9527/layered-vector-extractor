# Fidelity and tracing

Read this reference for dense multicolour posters, comic or mascot collages, highly detailed character art, and any request for a near-identical vector reconstruction.

## Fidelity profiles

### Balanced vector

Use for logos, icons, simple flat illustration, and artwork with a small deliberate palette. Optimize for clean paths and easy editing.

### High-fidelity true vector

Use by default for dense illustrations. Optimize for visual similarity while retaining native vector shapes and meaningful layers.

- Start at no less than roughly 75% of the source's linear resolution. Use full source resolution when faces, small lettering, linework, or thin highlights visibly degrade.
- Use an adaptive palette. For a dense full-colour poster, begin around 48 colours and increase when skin, fur, metal, pale blue, cream, or near-white details collapse into one colour.
- Do not delete small connected components on the first pass. If cleanup is necessary, remove only confirmed isolated noise after a side-by-side review.
- Treat background white and foreground near-white as different visual roles. Never globally discard the dominant white cluster inside the artwork. Use spatial foreground segmentation, occupancy masks, or separate near-white layers so light fur and anti-aliased edges do not become background holes.
- Preserve all assigned colour regions inside the foreground mask. Unexpected white or background-coloured pinholes are a tracing failure, not acceptable simplification.
- When adjacent shapes reveal renderer seams, use compatible shared boundaries or a tiny controlled overlap rather than leaving gaps.
- Keep major subject or depth groups semantic; place palette or colour paths inside those groups rather than replacing the whole document with one path per colour.

These are starting criteria, not a reason to stop iterating. Increase resolution, palette size, or path retention whenever the preview visibly differs.

## White-speckle failure audit

Before delivery, compare source and rendered vector side by side at full view, 100%, and 200%.

Reject the result if it shows any of the following that are not present in the source:

- scattered white or background-coloured dots inside coloured subjects;
- pale fur, skin, metal, or cloud colours collapsed into pure background white;
- broken outlines or missing anti-aliased edge bands;
- holes caused by minimum-area filtering;
- faces, eyes, logos, or lettering losing their defining shapes.

If failure occurs, in this order:

1. restore every dropped component and disable minimum-area filtering;
2. separate background from near-white foreground colours spatially;
3. increase the palette or use a perceptual colour space;
4. increase tracing resolution;
5. reduce path simplification tolerance;
6. render again and repeat the comparison.

Do not hand off a structurally valid SVG that fails this visual audit.

## What “one-to-one” can mean

Explain these outcomes when the user asks for an exact match:

1. **High-fidelity true vector** — editable paths, larger files, and a close visual match, but not guaranteed pixel-identical. This is the default.
2. **Hybrid appearance match** — an embedded or linked raster plus editable key vectors. It can look pixel-identical but is not a fully vector reconstruction. Use only when the user explicitly accepts raster content.
3. **Pixel-shape reconstruction** — every pixel or tiny region becomes vector geometry. It can approach pixel identity but creates enormous files with little practical editability. Use only when the user explicitly chooses that tradeoff.

Never embed the source raster merely to claim success, and never describe a quantized or simplified vector as pixel-identical.

## Manifest disclosure

For high-fidelity work, record:

- fidelity profile;
- source and working resolution;
- palette strategy and size;
- component filtering policy;
- simplification tolerance or tracing method;
- whether a foreground/background mask was used;
- comparison preview filename;
- remaining known differences;
- whether any raster content is embedded.
