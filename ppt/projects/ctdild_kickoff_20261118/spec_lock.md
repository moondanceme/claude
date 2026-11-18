<!-- ppt-master-schema: spec-lock/v1 -->
# Execution Lock

## canvas
- viewBox: 0 0 1280 720
- format: PPT 16:9

## communication
- primary_language: zh-Hans-CN
- audience: 项目组全体参研人员、呼吸科纤支镜老师
- objective: 讲清方案要点并对齐执行规则，使每位成员掌握主要终点、职责时限与安全处置上报
- core_message: 单中心、开放标签、1:1随机的探索性先导RCT（n=20，26周），主要终点第26周FVC变化；成败取决于规范执行
- consumption_mode: balanced

## mode
- mode: custom
- mode_references: instructional, briefing
- mode_behavior: 以 instructional 的分解与步骤讲解为主线，把方案拆成设计、人群、干预、访视、终点、安全、执行的可操作模块；briefing 负责每页信息完整可速查，标题用“主题：要点”式短判断句；背景页一页收束。

## visual_style
- visual_style: custom
- visual_style_references: swiss-minimal
- visual_style_behavior: 严谨网格、左对齐与大留白；页眉为章节标签加粗体标题与短色条；信息容器以浅灰底块与细分隔线为主；安全阈值与关键数字用琥珀或主色加粗；无阴影、无发光、无装饰纹理。

## colors
- background: #FFFFFF
- secondary_bg: #F2F5F8
- primary: #1F4E79
- accent: #E0A030
- secondary_accent: #1C9C8C
- body_text: #1D2430
- secondary_text: #5B6878
- divider: #D5DCE4

## typography
- font_family: "Microsoft YaHei", Arial, sans-serif
- title_family: "Microsoft YaHei", Arial, sans-serif
- body_family: "Microsoft YaHei", Arial, sans-serif
- body: 24
- title: 32
- subtitle: 26
- annotation: 16
- display: 52

## icons
- library: tabler-filled
- inventory: lungs, pill, user, calendar, clock, alert-triangle, shield-check, flask, microscope, database, file-text, clipboard, list-check, eye, lock, heart, scale, droplet, calendar-event, bulb, circle-check, flag, search

## page_rhythm
- P01: anchor
- P02: anchor
- P03: dense
- P04: dense
- P05: dense
- P06: dense
- P07: dense
- P08: dense
- P09: dense
- P10: dense
- P11: dense
- P12: dense
- P13: dense
- P14: dense
- P15: dense
- P16: dense
- P17: anchor

## pptx_structure
- mode: flat

## forbidden
- `mask`, `<style>`, `class`, external CSS, `<foreignObject>`, `textPath`, `@font-face`, `<animate*>`, `<set>`, `<script>` / event attributes, `<iframe>`
- HTML named entities in text; write typography as raw Unicode and escape XML reserved characters
