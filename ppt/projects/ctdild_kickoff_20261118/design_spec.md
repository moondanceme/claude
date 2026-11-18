<!-- ppt-master-schema: design-spec/v1 -->
# 替尔泊肽 CTD-ILD 探索性RCT 项目启动会 - Design Spec

## I. Project Information

| Item | Value |
| --- | --- |
| Project Name | ctdild_kickoff |
| Canvas Format | ppt169 (1280×720) |
| Page Count | 17 |
| Primary Language | zh-Hans-CN |
| Target Audience | 项目组全体参研人员、呼吸科纤支镜老师 |
| Communication Intent | 主要讲方案要点（入排、分组、剂量递增、访视、终点、BALF、安全与数据质控、分工）；“为什么做”仅一页，说明替尔泊肽的潜能 |
| Desired Audience Outcome | 会后每位成员能说清主要终点，知道自己的职责与时限，掌握胰腺炎、低血糖、ILD 急性加重等处置与上报规则，纤支镜老师掌握 BALF 采集条件与时点 |
| Core Message / Ask / Action | 单中心、开放标签、1:1 随机的探索性先导 RCT（n=20，26 周），主要终点第 26 周 FVC 变化；成败取决于入排、剂量递增、盲态评估与安全上报的规范执行 |
| Delivery Context | 主要为 PI 主讲的启动会现场投影（约 30–40 分钟含答疑）；次要为会后自查的培训材料 |
| Artifact Afterlife | 作为 GCP 启动培训记录存档，供入组执行与质控核查时查阅 |
| Reading Mode | balanced |
| Content Strategy | balanced default：保留方案全部要点，重组为启动会叙事 |
| Design Style | 临床规范风：白底、严谨网格、克制留白，深医疗蓝为主色、青绿辅色、琥珀仅用于安全阈值 |
| AI Image Acquisition Path | not applicable |
| Generation Mode | continuous |
| Spec Refinement | disabled |
| Speaker Notes | enabled — final Stage-2 proactive policy |
| Custom Animations | disabled — final Stage-2 proactive policy |
| Narration Audio | disabled — final Stage-2 proactive policy |
| Created Date | 2026-11-18 |

## II. Canvas Specification

| Property | Value |
| --- | --- |
| Format | PPT 16:9 |
| Dimensions | 1280 × 720 |
| viewBox | `0 0 1280 720` |
| Margins | 左右 64，上 48，下 40 |
| Content Area | x 64–1216，y 48–680 |

## III. Visual Theme

### Theme Style

- **Mode**: custom
- **Mode References**: instructional, briefing
- **Mode Behavior**: 以 instructional 的分解与步骤讲解为主线，把方案拆成“设计→人群→干预→访视→终点→安全→执行”的可操作模块；briefing 负责每页信息完整、可速查，标题用“主题：要点”式短判断句，P03 背景页一页收束后不再回到论证。
- **Visual style**: custom
- **Visual Style References**: swiss-minimal
- **Visual Style Behavior**: swiss-minimal 负责严谨网格、左对齐与大留白；页眉为左上小号章节标签加粗体标题，标题下一条短色条；信息容器以浅灰底块与细分隔线为主，少用描边卡片；安全阈值与关键数字用琥珀或主色加粗凸显；无阴影、无发光、无装饰纹理。
- **Theme**: 临床研究方案培训
- **Tone**: 严谨、清晰、可执行

### Color Scheme

| Role | HEX | Purpose |
| --- | --- | --- |
| Background | #FFFFFF | 页面底色 |
| Secondary background | #F2F5F8 | 信息分区底块 |
| Primary | #1F4E79 | 标题、主结构、治疗组 |
| Accent | #E0A030 | 安全阈值、警示、关键强调 |
| Secondary accent | #1C9C8C | 次级结构、对照/流程节点、正向标记 |
| Body text | #1D2430 | 正文 |
| Secondary text | #5B6878 | 注释、脚注、来源 |
| Divider | #D5DCE4 | 分隔线、表格线 |

## IV. Typography System

### Font Plan

| Role | Character (Reference) | Primary | English if non-English | Fallback tail |
| --- | --- | --- | --- | --- |
| Title | 无衬线粗体 | Microsoft YaHei | Arial | sans-serif |
| Body | 无衬线常规 | Microsoft YaHei | Arial | sans-serif |

- **Title stack**: "Microsoft YaHei", Arial, sans-serif
- **Body stack**: "Microsoft YaHei", Arial, sans-serif

### Font Size Hierarchy

| Purpose | Anchor Size (px) |
| --- | ---: |
| Body | 24 |
| Title | 32 |
| Subtitle | 26 |
| Annotation | 16 |
| Display | 52 |

## V. Layout Principles

### Deck-wide Direction

- **Hierarchy direction**: 左上章节标签→标题→主体证据→底部要点/来源
- **Composition tendency**: 网格分栏为主，流程类页面横向推进，表格类页面满宽
- **Cross-page continuity**: 统一页眉（章节标签+标题+短色条）与页脚（研究简称+页码）；治疗组恒用主色、对照组恒用辅色
- **Spacing posture**: 内容页偏紧凑，封面与收尾页开阔
- **Spacing anchors**: 页边距 64，块间距 24，栏间距 32，圆角 6，正文行距 1.45

## VI. Icon Usage Specification

- **Primary bundled library**: tabler-filled

| Icon Path | Suitable Scenarios |
| --- | --- |
| icons/tabler-filled/lungs.svg | |
| icons/tabler-filled/pill.svg | |
| icons/tabler-filled/user.svg | |
| icons/tabler-filled/calendar.svg | |
| icons/tabler-filled/clock.svg | |
| icons/tabler-filled/alert-triangle.svg | |
| icons/tabler-filled/shield-check.svg | |
| icons/tabler-filled/flask.svg | |
| icons/tabler-filled/microscope.svg | |
| icons/tabler-filled/database.svg | |
| icons/tabler-filled/file-text.svg | |
| icons/tabler-filled/clipboard.svg | |
| icons/tabler-filled/list-check.svg | |
| icons/tabler-filled/eye.svg | |
| icons/tabler-filled/lock.svg | |
| icons/tabler-filled/heart.svg | |
| icons/tabler-filled/scale.svg | |
| icons/tabler-filled/droplet.svg | |
| icons/tabler-filled/calendar-event.svg | |
| icons/tabler-filled/bulb.svg | |
| icons/tabler-filled/circle-check.svg | |
| icons/tabler-filled/flag.svg | |
| icons/tabler-filled/search.svg | |

## VIII. Image Resource List

| Filename | Dimensions | Ratio | Purpose | Type | Image pattern | Crop Policy | Acquire Via | Status | Reference | text_policy | page_role |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

## IX. Content Outline

### Part 1: 开场

#### Slide 01 - 封面

- **Audience move**: 不了解本项目 → 明确这是哪项试验、规模与主要终点
- **Relationships**: none
- **Composition**: 左侧大标题与副标题，右侧或下方以三个关键数字（n=20 / 26 周 / FVC）构成钩子
- **Title**: 替尔泊肽联合标准疗法治疗合并肥胖/超重或T2DM的CTD-ILD
- **Core message**: 探索性随机对照临床试验 · 项目启动会
- **Content**: 副题：探索性随机对照临床试验（Pilot RCT）项目启动会 · 关键数字：20例 / 26周 / 第26周FVC变化 · 陆军军医大学第一附属医院 中医与风湿免疫科 · 方案 V4.0（2026-07-23）· PI：邹庆华
- **Cover impact**: 三个关键数字“20 例 · 26 周 · FVC”作为钩子

#### Slide 02 - 议程

- **Audience move**: 不清楚会议结构 → 知道五部分顺序
- **Relationships**: order: 为什么做 → 方案设计 → 评估与BALF → 安全性 → 数据质控与执行
- **Title**: 议程
- **Core message**: 五部分，重点在方案执行
- **Content**: 01 为什么做（1页）· 02 方案设计：总体设计/流程/入排/干预/访视 · 03 终点评估与BALF采集 · 04 安全性监测与上报 · 05 数据质控、分工与时间表

### Part 2: 为什么做

#### Slide 03 - 替尔泊肽的潜能

- **Audience move**: 不知为何选此药 → 理解“降糖减重 + 潜在抗纤维化”双重目标
- **Relationships**: link: 未满足需求 + 代谢—纤维化交互 → 替尔泊肽多器官抗纤维化证据 + 临床线索 + 本组前期数据 → 本研究假设
- **Composition**: 左侧窄栏陈述需求与假设，右侧四个证据块
- **Title**: 为什么做：替尔泊肽的潜能
- **Core message**: 替尔泊肽满足患者降糖/减重刚需，同时可能带来抗纤维化附加获益
- **Content**: 需求：CTD-ILD现有药物仅能延缓、不能逆转纤维化；肥胖、胰岛素抵抗、高血糖通过炎症、氧化应激、成纤维细胞活化推动纤维化 · 证据1 多器官抗纤维化：GLP-1类药物抑制TGF-β/Smad、激活AMPK；替尔泊肽2期试验对F2–F3期MASH有效，2026年1月获NMPA突破性治疗认定 · 证据2 肺部临床线索：IPF倾向评分匹配队列（各1166例）3年死亡风险降低约38%；pSS-ILD个案联合司美格鲁肽约1年FVC 68%→99% pred · 证据3 本组前期：博来霉素小鼠模型中替尔泊肽显著减轻肺纤维化，并调控促纤维化巨噬细胞亚群（未发表）· 定位：探索性研究，为确证性试验提供效应量

### Part 3: 方案设计

#### Slide 04 - 研究设计总览

- **Audience move**: 零散印象 → 掌握设计骨架与关键参数
- **Relationships**: membership: 设计属性（单中心/随机/开放标签/平行对照/探索性）；contrast: 治疗组 vs 对照组
- **Title**: 研究设计：单中心、随机、开放标签、平行对照
- **Core message**: 20例按1:1随机，治疗26周，主要终点第26周FVC绝对变化（mL）
- **Content**: 设计：单中心 · 随机（简单随机，1:1）· 开放标签（终点评估盲态）· 平行对照 · Pilot RCT · 治疗组 n=10：标准治疗 + 替尔泊肽皮下注射每周1次，2.5 mg起每4周+2.5 mg，最高15 mg，26周 · 对照组 n=10：维持入组前稳定的CTD-ILD标准治疗 · 时间：筛选≤4周 + 治疗26周 + 安全随访2周 = 28周 · 主要终点：第26周FVC较基线绝对变化（mL）· 研究周期 2026.09–2028.09

#### Slide 05 - 研究流程

- **Audience move**: 不清楚受试者路径 → 能按阶段走完一位受试者
- **Relationships**: order: 筛选V1(W-4~0) → 基线V2(W0, 随机) → 分组两臂 → 中期V3(W13) → 主要终点V4(W26) → 安全随访V5(W28, 电话)
- **Composition**: 横向时间轴，随机后分为两条并行泳道
- **Title**: 研究流程：一位受试者的28周
- **Core message**: 5次访视，随机在V2，主要终点评估在V4
- **Content**: V1 筛选（W-4~0）：知情同意、病史、CTD确认与抗体谱、HRCT（纤维化≥10%）、实验室检查 · V2 基线（W0）：肺功能、确认入组→随机；治疗组首针2.5 mg并培训自行注射；6MWD、K-BILD、生物标志物、可选BALF · V3 中期（W13）：肺功能、6MWD、K-BILD、安全性与代谢指标、耐受性评估 · V4 主要终点（W26）：全套疗效与安全评估、HRCT、BALF（可选）· V5 安全随访（W28）：电话随访AE/SAE；治疗组V4后停药

#### Slide 06 - 纳入标准

- **Audience move**: 记不住8条标准 → 按4类快速判断
- **Relationships**: membership: 8条纳入标准归为4类
- **Title**: 纳入标准：四类条件同时满足
- **Core message**: CTD诊断 + 纤维化ILD + 代谢异常 + 病情/治疗稳定
- **Content**: ① CTD诊断：风湿免疫专科确诊RA、SSc、DM/PM、pSS或MCTD之一；年龄>18岁 · ② ILD影像：HRCT纤维化累及>10%肺实质，UIP/NSIP/混合型均可，以纤维化为主，无替代诊断 · ③ 代谢异常（至少一项）：T2DM（FPG≥7.0、OGTT 2h≥11.1、HbA1c≥6.5%或已治疗）；BMI≥28；BMI≥24且伴≥1种体重相关合并症 · ④ 稳定性：FVC%pred≥45%，DLCO%pred≥30%；背景治疗稳定≥3个月（激素调整≤5 mg/d泼尼松当量）；降糖方案稳定≥3个月；签署知情同意

#### Slide 07 - 排除标准

- **Audience move**: 不清楚易漏排除项 → 记住三条高风险排除项
- **Relationships**: membership: 14条排除标准按类别分组；contrast: 三条重点项与其余
- **Title**: 排除标准：三条最易漏的重点
- **Core message**: 胰腺炎史、近3个月用过GLP-1/GIP类药物、近3个月ILD急性加重须重点核查
- **Content**: 重点：既往或目前胰腺炎 · 正在或3个月内使用其他GLP-1R/GIPR激动剂 · 近3个月ILD急性加重 · ILD相关：药物/感染等非CTD原因ILD；HRCT以磨玻璃影为主；临床显著COPD/哮喘；近3个月针对肺部调整激素（>10 mg/d）、免疫抑制剂或细胞因子调节剂 · 代谢/药物：1型糖尿病；对替尔泊肽过敏 · 合并症：NYHA III–IV级心衰、活动性恶性肿瘤、eGFR<30、严重肝损；活动性感染、HIV、病毒性肝炎 · 其他：妊娠/哺乳/计划妊娠；正参加其他干预性研究；研究者判断不适宜

#### Slide 08 - 干预：剂量递增

- **Audience move**: 不清楚给药节奏 → 能按周确定剂量并知道何时暂缓/回退
- **Relationships**: order: 2.5 → 5 → 7.5 → 10 → 12.5 → 15 mg/周，每4周一档，第21–26周维持MTD；link: 不耐受条件 → 延缓或回退
- **Composition**: 左侧阶梯图，右侧调整规则
- **Title**: 干预：每4周递增2.5 mg，20周达个体最大耐受剂量
- **Core message**: 允许以10 mg/周为MTD，不强求15 mg
- **Visualization**: dose-steps：周次W1–4/5–8/9–12/13–16/17–20/21–26对应2.5/5/7.5/10/12.5/15(MTD) mg 的阶梯
- **Native-ready**: dose-steps=no
- **Content**: 阶梯：W1–4 2.5 · W5–8 5.0 · W9–12 7.5 · W13–16 10.0 · W17–20 12.5（或10为MTD）· W21–26 15.0或个体MTD维持 · 暂缓递增：≥2级恶心/呕吐>72h且对症无效；≥2级腹泻>48h；低血糖（FPG<3.9）；体重降≥5%伴营养不良征象 · 回退一档：其他相关≥3级不良反应 · 连续2次递增失败→以当前剂量为MTD · 降糖药：磺脲类减量≥50%；基础胰岛素（HbA1c≤8.5%）减量≥20%；二甲双胍/SGLT2i/α-糖苷酶抑制剂通常无需调整 · 对照组：标准治疗不更换药物种类、不调整剂量

#### Slide 09 - 访视评估节点

- **Audience move**: 不知道每次访视做什么 → 有一张速查表
- **Relationships**: none
- **Title**: 访视评估节点：V1–V5
- **Core message**: 肺功能在V2/V3/V4，HRCT在V1/V4，BALF在V2/V4（可选）
- **Visualization**: visit-matrix：表格，行=评估项，列=V1(W-4~0)/V2(W0)/V3(W13)/V4(W26)/V5(W28)/早期终止
- **Native-ready**: visit-matrix=yes
- **Content**: 知情同意 V1 · 随机化/药物发放 V2 · AE与合并用药 全部 · 依从性 V3、V4 · 体格检查/体重BMI腰围/SpO2 V1–V4、早终 · CTD确认与抗体谱 V1 · FVC/DLCO V2–V4、早终 · HRCT V1、V4、早终 · 6MWD/K-BILD V2–V4、早终 · 血常规肝肾功血脂/FPG HbA1c V1–V4、早终 · 淀粉酶/脂肪酶 V2基础值，腹痛时即测 · 血清生物标志物 V2、V4 · BALF V2、V4（可选）

### Part 4: 终点评估与BALF

#### Slide 10 - 终点指标

- **Audience move**: 不清楚哪个数据最重要 → 知道主要/次要/探索性终点层级
- **Relationships**: parent: 主要终点 > 次要终点 > 探索性终点
- **Title**: 终点指标：FVC绝对变化是唯一主要终点
- **Core message**: 第26周FVC较基线绝对变化（mL）
- **Content**: 主要：第26周FVC较基线绝对变化（mL）· 次要：FVC%pred、DLCO%pred、6MWD、K-BILD总分、体重及BMI、HbA1c 较基线变化 · 探索性：HRCT纤维化范围变化、血清纤维化生物标志物、26周疾病进展事件发生率、BALF细胞学及促纤维化巨噬细胞标志物 · 分析：ITT为主，ANCOVA（协变量基线FVC、HRCT纹型），报告调整均值差与95%CI，P值按描述性解读

#### Slide 11 - BALF采集要点

- **Audience move**: 纤支镜老师不清楚要求 → 掌握时点、条件、检测内容与流转
- **Relationships**: order: 评估条件 → 基线采集V2 → 第26周采集V4 → 匿名流转检测
- **Composition**: 左侧采集条件三项，中间两个时点，右侧检测内容
- **Title**: BALF采集：基线与第26周各一次（可选项目）
- **Core message**: 仅在SpO2≥90%、FVC%pred≥45%且受试者自愿时采集
- **Content**: 条件（同时满足）：静息SpO2≥90% · FVC%pred≥45% · 受试者自愿 · 时点：V2基线（随机后）· V4第26周 · 检测：细胞分类计数 · 流式细胞术分析促纤维化巨噬细胞标志物 · 质控：专人负责，方法与试剂批次全程一致；标本以匿名编码流转，检测人员不知分组 · 意义：为动物实验发现的巨噬细胞机制提供人体线索

#### Slide 12 - 随机化与盲态评估

- **Audience move**: 担心开放标签偏倚 → 理解各环节如何保持盲态
- **Relationships**: membership: 独立随机人员、肺功能技师、影像核心实验室、独立统计师各自不知分组
- **Title**: 随机化与盲态评估：开放标签下的四道隔离
- **Core message**: 研究者与受试者知情，关键终点评估者不知情
- **Content**: 随机：独立人员用R预生成1:1序列（20个分配号），密封保存，按入组顺序揭开并记入随机化日志 · 肺功能：肺功能室技师不知分组，按ATS/ERS标准化流程 · 影像：影像核心实验室3位专家，2人独立阅片、第3人仲裁 · 统计：独立统计师在数据库锁定后分析 · 提醒：参研人员不得向评估人员透露分组

### Part 5: 安全性

#### Slide 13 - 特别关注不良事件与处置

- **Audience move**: 不清楚阈值 → 能按阈值处置
- **Relationships**: membership: 7类AESI；link: 每类事件 → 处置阈值与动作
- **Title**: 特别关注不良事件：阈值即动作
- **Core message**: 胰腺炎立即永久停药，其余按阈值暂缓、回退或暂停
- **Content**: 胰腺炎：腹痛伴淀粉酶/脂肪酶≥3×ULN → 永久停药，按SAE上报 · 胃肠道：1–2级对症继续；≥3级持续>72h → 暂停并回退一档 · 低血糖（<3.9 mmol/L）：先减/停磺脲类或胰岛素；反复≥2次 → 暂停 · 体重/营养：降≥5%伴营养不良 → 暂缓递增；降≥10%伴营养不良/肌少症 → 暂停 · 胆囊疾病：右上腹痛→超声；确诊暂停 · ILD急性加重：暂停替尔泊肽，激素不受限 · 肝功能：ALT/AST≥5×ULN，或≥3×ULN且TBil≥2×ULN → 停药 · 联合用药：与抗纤维化药/MMF合用出现≥2级胃肠道反应，先调背景药、后调替尔泊肽，间隔≥1周

#### Slide 14 - 上报时限与暂停入组

- **Audience move**: 不清楚时限与触发条件 → 记住24小时与4个触发条件
- **Relationships**: order: 获知SAE → 24h上报伦理与DSMB → 7个工作日书面报告；link: 触发条件 → 暂停入组 → 72h内DSMB再评估
- **Title**: 上报时限与暂停入组：24小时是红线
- **Core message**: SAE 24小时内上报，满足任一触发条件立即暂停入组
- **Content**: SAE：获知后24h内报伦理委员会与DSMB，7个工作日内书面报告；AESI 24h内记录并评估相关性 · 期中安全分析：第10例完成随机化时启动，提交DSMB · 暂停入组触发（任一）：累计≥2例ILD急性加重 · 累计≥2例≥3级胃肠道反应且处理无效 · 1例与研究药物明确相关的SAE（如急性胰腺炎、严重过敏）· DSMB判断风险不可接受 · 触发后：24h内通知DSMB主席与伦理，72h内DSMB再评估；经伦理批准方可恢复

### Part 6: 数据质控与执行

#### Slide 15 - 数据管理与质控

- **Audience move**: 不清楚数据要求 → 知道录入时限、核查比例与偏离上报
- **Relationships**: order: 录入 → 校验 → 核查 → 锁库；membership: 质控措施
- **Title**: 数据管理与质控：72小时录入，关键数据100% SDV
- **Core message**: 按时录入、按比例核查、偏离及时上报
- **Content**: EDC/eCRF：访视后72h内录入；SAE 24h内录入；保留审计轨迹 · 校验：范围、一致性、完整性、时间顺序；肺功能与影像评分与原始报告核对 · 核查：每周查及时性，每月查完整性；每季度稽查 · SDV：知情同意、入排标准、主要终点100%，其余≥20%抽查 · 方案偏离：重大偏离24h内报PI与伦理；每季度汇总 · 依从性：注射笔使用记录与剩余药量核对；V3–V4间增加电话随访

#### Slide 16 - 分工与时间表

- **Audience move**: 不清楚谁负责什么、何时 → 明确职责与节点
- **Relationships**: membership: 4名成员与角色；order: 2026.07–12 启动 → 2027.01–08 入组 → 2027.08–2028.09 完成与总结
- **Composition**: 上部分工，下部时间线
- **Title**: 分工与时间表
- **Core message**: 2027年8月前完成20例入组
- **Content**: 分工：邹庆华（主任医师）方案设计/PI · 刘秋平（主治医师）安全监督 · 郭翠（住院医师）数据管理 · 蒋桓宇（住院医师）统计分析（需补GCP培训证书）· 协作：呼吸科纤支镜（BALF）、肺功能室、影像核心实验室、内分泌科/呼吸科转介 · 时间线：2026.07–12 科学性审查、伦理、注册、团队培训、eCRF搭建、DSMB组建 · 2027.01–08 完成20例筛选与入组 · 2027.08–2028.09 完成试验与数据收集、统计分析、总结报告、论文投稿

#### Slide 17 - 启动后第一批行动

- **Audience move**: 听完会议 → 知道下周起做什么
- **Relationships**: order: 三项行动并行启动
- **Title**: 启动后第一批行动
- **Core message**: 规范执行入排、剂量递增、盲态评估与安全上报，是这项先导研究成败的关键
- **Content**: 行动1 预筛查：检索本中心CTD-ILD患者数据库，评估潜在合格人数 · 行动2 转介机制：与内分泌科、呼吸科建立患者转介 · 行动3 就绪检查：eCRF上线、随机序列就位、全员完成方案与GCP培训、纤支镜与肺功能流程对接
- **Closing impact**: 一句关键要点 + 三项行动

## X. Speaker Notes Requirements

- **Generation**: enabled
- **Filename**: match each SVG filename under `notes/`
- **Content**: 基于页面内容与方案原文补充解释和过渡，不引入方案外事实
- **Total duration**: 约30–40分钟（含答疑）
- **Notes style**: 正式、口语化讲解
- **Presentation purpose**: 主要讲方案要点；“为什么做”仅一页说明替尔泊肽的潜能
