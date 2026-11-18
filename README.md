# Layered Vector Extractor

将用户提供的位图、照片、草图或插画，重绘为真正可编辑、图层分离的矢量文件。

Convert raster images, photos, sketches, and illustrations into genuinely editable, layered vector artwork.

## 主要功能

- 生成真正的矢量路径，不使用嵌入位图冒充矢量文件。
- 背景、主体、线稿、文字等内容分别放置在命名图层中。
- Logo、品牌字和特殊艺术字直接重绘为矢量路径，不使用相似字体替换。
- 普通标题和正文优先识别原始字体，并在字体授权允许时一起打包。
- 支持高精度复杂插画模式，保留人物、表情、线条和细小色块。
- 输出前检查白色斑点、背景色孔洞、轮廓断裂、颜色丢失和小图形缺失。
- 提供 Illustrator 转换脚本，可将分层 SVG 转换为图层分离的 Adobe Illustrator 文件。

## 安装方法

在 Codex 中发送下面这句话：

> 请使用 `$skill-installer` 从 `https://github.com/hugoyu18-rgb/layered-vector-extractor` 仓库根目录安装，并将 Skill 命名为 `layered-vector-extractor`。

安装完成后，在下一轮对话中即可使用。

## 手动安装

1. 点击本仓库右上方绿色的 `Code` 按钮。
2. 选择 `Download ZIP`。
3. 解压下载的 ZIP 文件。
4. 将解压后的 Skill 文件夹复制到：

```text
C:\Users\你的用户名\.codex\skills\layered-vector-extractor
```

5. 重新打开 Codex；如果 Skill 没有显示，请重启 Codex。

## 使用方法

向 Codex 上传需要处理的图片，然后发送：

> 使用 layered-vector-extractor，把这张图片重绘为图层分离、可编辑的矢量文件。

也可以补充具体要求，例如：

- 保持原图构图、比例和颜色。
- Logo 文字全部转换为矢量路径。
- 普通文字保留为可编辑文字，并打包可以合法分发的原字体。
- 输出分层 SVG 和 Adobe Illustrator 文件。
- 使用高精度模式，检查并清除意外白点和孔洞。

## 输出内容

根据任务情况，输出文件可能包括：

- `name-layered.svg`：主要的分层矢量源文件
- `name-layered.ai`：经 Adobe Illustrator 转换并检查的 AI 文件
- `name-preview.png`：矢量效果预览
- `name-comparison.png`：原图与矢量图对比
- `name-manifest.json`：画布、图层、颜色和字体信息
- `font-report.json`：字体识别、授权和文字处理记录
- `fonts/`：允许合法分发的字体及许可证

## 重要说明

复杂位图重绘成真正可编辑的矢量文件时，不能在所有情况下保证像素级完全一致。本 Skill 会优先使用高精度真矢量方案，并通过原图对比检查减少细节损失、白色斑点和意外孔洞。

原生 `.ai` 文件必须使用 Adobe Illustrator 实际转换、保存并检查。没有 Illustrator 时，不会把其他格式改名伪装成 `.ai` 文件。

## License

MIT License
