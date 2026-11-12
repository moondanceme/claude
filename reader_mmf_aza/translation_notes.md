# Translation notes / 翻译与提取说明

- 来源：用户上传的 PMC 作者手稿版 PDF（22 页，可选中文本层）→ 识别为 `pdf-text`，未做 OCR。
- 已去除每页重复的页眉页脚（"Author Manuscript" 水印、"Pugashetti et al. Page N"、"available in PMC" 页脚），并合并了跨行断词（如 transplantfree → transplant-free）。
- 正文（摘要、要点速览、引言、方法、结果、讨论、结论、资助）已逐段完整双语对照，共 53 个文本块（S001–S053）。
- **Disclosures（p.11，S053）** 为概要翻译，没有逐字对照（逐作者罗列的企业名单较长）；原文全文请见 PDF 第 11 页。置信度标为 medium。
- **参考文献（p.11–15，共 47 条）** 保留原文，未翻译。
- 第 1 页的作者单位与作者贡献、通讯作者信息只放在元数据表中概述，没有逐段翻译。
- 图 1–5 为 PDF 内嵌原图，已无损提取（assets/fig1–5.jpg）。
- 表 1 在原 PDF 中为横排，跨第 21–22 页；以 200 dpi 渲染后旋转并裁剪为 table1_part1/part2.png，**裁剪为近似**（以表格边界为准自动裁边）。原文在加权 fHP 列有拼写 "n-150.8"（应为 n=150.8），原样保留。
- 补充材料（表 E1–E14、图 E1–E4）不在此 PDF 中，正文中的引用只保留编号。
- 原文 "Schonfeld residuals" 译为 Schoenfeld 残差（标准拼写）；"SSC-ILD" 按 SSc-ILD 处理。
- 原文无显示公式，因此没有 E 编号块。
- 术语表见 paper.md 的“术语表”一节及 source_map.json 的 glossary 字段。
