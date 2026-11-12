# -*- coding: utf-8 -*-
from pathlib import Path
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN, MSO_ANCHOR
from pptx.enum.shapes import MSO_SHAPE
from pptx.oxml.ns import qn
from PIL import Image

OUT = Path("/home/user/claude/slides_mmf_aza/output")
FIG = OUT / "assets" / "figures"
CN, EN = "Microsoft YaHei", "Arial"
NAVY, INK, GREY, RED, TEAL, LINE = (RGBColor(0x14, 0x2B, 0x4D), RGBColor(0x22, 0x26, 0x2E), RGBColor(0x6B, 0x72, 0x80),
                                    RGBColor(0xB4, 0x2B, 0x2B), RGBColor(0x1F, 0x6F, 0x78), RGBColor(0xD5, 0xDA, 0xE1))
CITE = "Pugashetti JV, et al. Am J Respir Crit Care Med 2026;212(10):2493–2503"
L, R, W = 0.6, 12.733, 12.133   # left guide, right guide, content width (in)

prs = Presentation()
prs.slide_width, prs.slide_height = Inches(13.333), Inches(7.5)
BLANK = prs.slide_layouts[6]
state = {"n": 0}


def font(run, size, bold=False, color=INK, italic=False):
    run.font.size, run.font.bold, run.font.italic = Pt(size), bold, italic
    run.font.color.rgb = color
    run.font.name = EN
    rpr = run._r.get_or_add_rPr()
    for tag in ("a:ea", "a:cs"):
        el = rpr.find(qn(tag))
        if el is None:
            el = rpr.makeelement(qn(tag), {})
            rpr.append(el)
        el.set("typeface", CN)


def text(slide, x, y, w, h, paras, size=16, color=INK, bold=False, align=PP_ALIGN.LEFT, anchor=MSO_ANCHOR.TOP, space=6, line=1.15):
    """paras: list of str or (str, dict) or list of (str, dict) runs."""
    tb = slide.shapes.add_textbox(Inches(x), Inches(y), Inches(w), Inches(h))
    tf = tb.text_frame
    tf.word_wrap = True
    tf.vertical_anchor = anchor
    for m in ("margin_left", "margin_right", "margin_top", "margin_bottom"):
        setattr(tf, m, Inches(0.02))
    for i, p in enumerate(paras):
        para = tf.paragraphs[0] if i == 0 else tf.add_paragraph()
        para.alignment = align
        para.space_after = Pt(space)
        para.line_spacing = line
        runs = p if isinstance(p, list) else [p]
        for r in runs:
            s, kw = (r, {}) if isinstance(r, str) else r
            run = para.add_run()
            run.text = s
            font(run, kw.get("size", size), kw.get("bold", bold), kw.get("color", color), kw.get("italic", False))
    return tb


def rule(slide, x, y, w, color=LINE, weight=1.0):
    ln = slide.shapes.add_connector(1, Inches(x), Inches(y), Inches(x + w), Inches(y))
    ln.line.color.rgb = color
    ln.line.width = Pt(weight)


def bar(slide, x, y, h, color=TEAL, w=0.06):
    s = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, Inches(x), Inches(y), Inches(w), Inches(h))
    s.fill.solid(); s.fill.fore_color.rgb = color; s.line.fill.background()


def new(title, notes, kicker=None):
    s = prs.slides.add_slide(BLANK)
    state["n"] += 1
    if kicker:
        text(s, L, 0.38, W, 0.3, [kicker], size=11, color=TEAL, bold=True)
    text(s, L, 0.66, W, 0.62, [title], size=26, color=NAVY, bold=True, anchor=MSO_ANCHOR.MIDDLE)
    rule(s, L, 1.36, W, NAVY, 1.25)
    rule(s, L, 7.0, W)
    text(s, L, 7.06, 9.5, 0.26, [CITE], size=8, color=GREY)
    text(s, R - 1.0, 7.06, 1.0, 0.26, [str(state["n"])], size=8, color=GREY, align=PP_ALIGN.RIGHT)
    s.notes_slide.notes_text_frame.text = notes
    return s


def picture(slide, name, x, y, w=None, h=None, src=None):
    """Insert the original figure unchanged, scaled by one dimension. Returns (w, h) in inches."""
    iw, ih = Image.open(FIG / name).size
    if w is None:
        w = h * iw / ih
    else:
        h = w * ih / iw
    slide.shapes.add_picture(str(FIG / name), Inches(x), Inches(y), Inches(w), Inches(h))
    if src:
        text(slide, x, y + h + 0.05, w, 0.24, [src], size=8, color=GREY)
    return w, h


def bullets(slide, x, y, w, h, items, size=15, gap=10):
    paras = []
    for it in items:
        head, body = it if isinstance(it, tuple) else (None, it)
        runs = []
        if head:
            runs.append((head, {"bold": True, "color": NAVY}))
        runs.append(body)
        paras.append(runs)
    return text(slide, x, y, w, h, paras, size=size, space=gap, line=1.2)


# ---------------------------------------------------------------- 1 cover
s = prs.slides.add_slide(BLANK); state["n"] += 1
bar(s, L, 2.05, 2.05, NAVY, 0.09)
text(s, 0.95, 1.2, 11.5, 0.35, ["组会文献汇报"], size=13, color=TEAL, bold=True)
text(s, 0.95, 2.0, 11.6, 1.1, ["MMF / 硫唑嘌呤能否改善纤维化型 ILD 的长期结局？"], size=34, color=NAVY, bold=True, anchor=MSO_ANCHOR.MIDDLE)
text(s, 0.95, 3.15, 11.6, 0.9, ["Mycophenolate and Azathioprine in Fibrotic Interstitial Lung Disease"], size=20, color=INK, anchor=MSO_ANCHOR.TOP)
text(s, 0.95, 4.65, 11.6, 1.0, [
    "Pugashetti JV†, Jee AS†, Yu AR, … Oldham JM, Molyneaux PL, Newton CA",
    "Am J Respir Crit Care Med 2026; 212(10): 2493–2503 · doi: 10.1093/ajrccm/aamag362",
    "多中心回顾性队列 · 目标试验模拟（clone-censor-weighting）· n = 2270"], size=13, color=GREY, space=5)
rule(s, L, 7.0, W)
text(s, L, 7.06, 9.5, 0.26, ["汇报人：        日期："], size=9, color=GREY)
s.notes_slide.notes_text_frame.text = ("【约 30 秒】今天汇报的是 2026 年 10 月发表在 AJRCCM 上的一项多中心回顾性研究。"
    "问题很直接：在非 IPF 的纤维化型间质性肺病里，我们常规使用的吗替麦考酚酯（MMF）和硫唑嘌呤，到底能不能改善三年生存和肺功能。"
    "作者没有做 RCT，而是用目标试验模拟的方法，在 2270 例患者的登记数据上尽量逼近一个 RCT。")

# ---------------------------------------------------------------- 2 background
s = new("非 IPF 纤维化型 ILD：免疫抑制用得多，证据却很少", kicker="背景",
    notes="【约 1 分钟】背景有三点。第一，IPF 有多项 RCT 明确了哪些药有效、哪些有害，PANTHER-IPF 证明泼尼松+硫唑嘌呤+NAC 增加死亡和住院。"
    "第二，非 IPF 的纤维化型 ILD，包括非 IPF 特发性间质性肺炎、纤维化型过敏性肺炎和大多数 CTD-ILD，没有同等质量的证据；"
    "抗纤维化药（尼达尼布、nerandomilast）一般要等到疾病进展后才能获批或报销，所以临床上为了“防进展”常先上免疫抑制。"
    "第三，支持这种做法的数据主要是回顾性观察研究，提示肺功能稳定；只有部分 CTD-ILD 有试验数据，而且对生存的影响并不清楚。")
bullets(s, L, 1.7, 7.4, 4.9, [
    ("IPF 有 RCT 定论  ", "免疫抑制有害（PANTHER-IPF），抗纤维化药有效"),
    ("非 IPF IIP、fHP、多数 CTD-ILD 没有  ", "同等质量的试验证据缺失"),
    ("抗纤维化药要等“进展”  ", "获批与报销通常以疾病进展为前提"),
    ("于是先上 MMF / 硫唑嘌呤  ", "依据主要是回顾性研究中的肺功能稳定"),
], size=19, gap=26)
bar(s, 8.55, 1.75, 4.3, TEAL)
text(s, 8.8, 1.7, 3.9, 0.4, ["尚未回答的问题"], size=12, color=TEAL, bold=True)
text(s, 8.8, 2.15, 3.9, 3.9, [
    "免疫抑制能否改善",
    [("三年无移植生存", {"bold": True, "color": NAVY, "size": 22})],
    "和",
    [("肺功能变化轨迹", {"bold": True, "color": NAVY, "size": 22})],
    "？",
    [("除部分 CTD-ILD 的肺功能数据外，生存获益始终不确定。", {"size": 12, "color": GREY})],
], size=16, space=8)

# ---------------------------------------------------------------- 3 question / approach
s = new("用观察性数据模拟一项 RCT：目标试验模拟", kicker="研究问题与思路",
    notes="【约 1 分钟】直接用观察数据比较“用药 vs 不用药”有三个经典问题：适应证混杂——医生会给看上去更活动的病人用药；"
    "不朽时间偏倚——用药者必须先活到用药那天；选择偏倚。"
    "目标试验模拟的思路是先写下理想 RCT 的方案：纳入谁、比较哪两种策略、从何时起算、终点是什么，然后让观察数据去套这个方案。"
    "本研究比较的两种策略是：入组 6 个月内启动 MMF 或硫唑嘌呤，对比 6 个月内不启动；估计的是符合方案效应。"
    "同时用同样的方法构建了一个 IPF 队列当阳性对照——如果方法可靠，应该能重现 PANTHER-IPF 的有害方向。")
text(s, L, 1.65, 5.6, 0.35, ["传统观察性比较的三类偏倚"], size=12, color=TEAL, bold=True)
bullets(s, L, 2.1, 5.6, 3.6, [
    ("适应证混杂  ", "病情看上去更活动者更易被用药"),
    ("不朽时间偏倚  ", "用药者必须先存活到启动用药"),
    ("选择偏倚  ", "偏离策略者被不当剔除或归组"),
], size=18, gap=24)
bar(s, 6.75, 1.7, 4.75, NAVY)
text(s, 7.0, 1.65, 5.7, 0.35, ["本研究模拟的“目标试验”"], size=12, color=TEAL, bold=True)
bullets(s, 7.0, 2.1, 5.7, 4.4, [
    ("人群  ", "非 IPF IIP、fHP、CTD-ILD；既往未用 IS 或抗纤维化药"),
    ("策略  ", "入组 6 个月内启动 MMF / 硫唑嘌呤 vs 不启动"),
    ("起点  ", "登记入组日；随访 3 年"),
    ("主要终点  ", "死亡或肺移植；次要为 FVC、DLCO 轨迹"),
    ("阳性对照  ", "同法构建的 IPF 队列（预期有害）"),
], size=16, gap=17)

# ---------------------------------------------------------------- 4 Fig 1 (process-wide)
s = new("克隆–删失–加权：每位患者同时进入两种策略", kicker="研究设计 · Fig. 1",
    notes="【约 1.5 分钟】这张是原文图 1。从左往右看：纳入人群先做逆概率处理加权（IPTW），平衡基线。"
    "然后每个患者被复制成两个克隆体，一个分到“6 个月内启动 IS”，一个分到“不启动”。"
    "接着看时间轴：如果克隆体的实际治疗与所分配的策略不符，就在那个时间点被删失（圆圈 C）；"
    "例如分到“不启动”的克隆体，患者一旦真的开始用药（方块 T）就被删失；分到“启动”的克隆体到 6 个月还没用药也被删失。"
    "因为删失不是随机的，所以用随时间更新的逆概率删失加权（IPCW）把留下来的克隆体放大——图里人形变大、线变粗就是这个意思。"
    "三角形 O 是结局（死亡或移植）。最终得到一个加权后的伪人群，其中每个人都“遵循”了所分配的策略。"
    "加权在每个中心、每个亚型内部分别做；MMF 和硫唑嘌呤互换不算偏离；启动抗纤维化药按管理性删失处理。")
picture(s, "fig1.jpg", L + 0.75, 1.5, w=10.6, src="Source: Fig. 1（原文图，未改动）。IS = immunosuppression；T = 启动治疗，C = 删失，O = 死亡或移植")
text(s, L, 6.52, W, 0.4, [[("① 克隆", {"bold": True, "color": NAVY}), "  保留基线、分入两策略      ",
                          ("② 删失", {"bold": True, "color": NAVY}), "  6 个月窗内偏离策略即删失      ",
                          ("③ 加权", {"bold": True, "color": NAVY}), "  IPTW × 随时间更新的 IPCW"]], size=14)

# ---------------------------------------------------------------- 5 Fig 2 (tall figure + rail)
s = new("5 个中心筛查 3398 例，2270 例进入分析", kicker="研究人群 · Fig. 2",
    notes="【约 1 分钟】这是原文图 2 的 STROBE 流程图。数据来自美国四个登记库（UCSF/UC Davis、UTSW、密歇根、芝加哥）和英国 Royal Brompton，入组时间 2006–2020。"
    "非 IPF 纤维化型 ILD 筛查 3398 例，排除 1128 例，最主要的排除原因是入组前已用过免疫抑制（469 例）、DLCO 过低（397 例）和首个免疫抑制剂不是 MMF 或硫唑嘌呤（280 例）。"
    "最终 2270 例：非 IPF IIP 1022 例（其中不可分类 ILD 813 例）、fHP 544 例、CTD-ILD 704 例。右侧是 IPF 对照队列 1063 例。"
    "提醒一个细节：流程图里 FVC 的排除阈值写的是 <45%，而正文方法部分写的是 FVC ≥40% 预计值，原文前后不一致。")
w_, h_ = picture(s, "fig2.jpg", L, 1.5, h=5.1, src="Source: Fig. 2（原文图，未改动）")
rx = L + w_ + 0.55
bar(s, rx - 0.2, 1.5, 4.6, TEAL)
bullets(s, rx, 1.5, R - rx, 4.9, [
    ("2270 例  ", "非 IPF IIP 1022 · fHP 544 · CTD-ILD 704"),
    ("IPF 对照  ", "1063 例，同一套纳排标准"),
    ("主要排除  ", "入组前已用 IS（469）、DLCO <25%（397）、首药非 MMF/AZA（280）"),
    ("注意  ", "图中 FVC 阈值为 <45%，正文为 ≥40% 预计值，原文不一致"),
], size=14, gap=14)

# ---------------------------------------------------------------- 6 Table 1 part 1
s = new("加权后两组基线可测因素达到平衡（SMD <0.1）", kicker="基线特征 · Table 1（上半）",
    notes="【约 1 分钟】原文表 1 的上半部分。每个亚型有两大栏：左边是未加权的原始数据，右边是 6 个月治疗窗结束后的加权数据集。"
    "先看未加权：以非 IPF IIP 为例，启动组更年轻（62.4 vs 67.4 岁）、男性更少（37% vs 51%）、FVC 更低（64.6% vs 74.4%）、UIP 更少（16% vs 22%）——也就是医生倾向于给年轻、肺功能差、非 UIP 的人用药。"
    "加权之后这些差异基本消失，SMD 几乎都小于 0.01，达到作者预设的 <0.1 平衡标准。加权后的 n 是小数，因为是伪人群。"
    "但要记住：能平衡的只有进了模型的变量——年龄、性别、族裔、吸烟、FVC、DLCO、UIP、入组年份。")
w_, h_ = picture(s, "table1_part1.png", L, 1.5, h=5.15, src="Source: Table 1（原文表格截取，上半；PDF 第 21 页）")
rx = L + w_ + 0.45
bar(s, rx - 0.2, 1.5, 4.3, TEAL)
bullets(s, rx, 1.5, R - rx, 4.8, [
    ("未加权  ", "启动组更年轻、女性多、FVC/DLCO 更低、UIP 更少"),
    ("加权后  ", "各变量 SMD 几乎均 <0.01"),
    ("加权范围  ", "按中心、按亚型分别估计权重"),
    ("仅限已测变量  ", "未含影像炎症程度、血清学、激素"),
], size=14, gap=14)

# ---------------------------------------------------------------- 7 Table 1 part 2
s = new("约七成用 MMF；fHP 与非 IPF IIP 用药组粗死亡率更高", kicker="用药与三年结局 · Table 1（下半）",
    notes="【约 45 秒】表 1 的下半部分。药物构成：三个亚型里 MMF 都占约三分之二到七成，硫唑嘌呤约三成；中位暴露时间 1.9 到 2.5 年。"
    "看最下面的三年结局，这是描述性的粗数字：非 IPF IIP 中死亡 20% 对 17%，移植 4% 对 0%；fHP 中死亡 22% 对 14%，移植 5% 对 2%；CTD-ILD 两组都在 10% 左右。"
    "加权后这个差距依然存在（非 IPF IIP 22% vs 16%，fHP 21% vs 13%），提示后面的 HR 方向。各组中位随访都是 3.0 年。")
w_, h_ = picture(s, "table1_part2.png", L, 1.5, w=8.7, src="Source: Table 1（原文表格截取，下半；PDF 第 22 页）")
rx = L + w_ + 0.45
bar(s, rx - 0.2, 1.5, 4.3, TEAL)
bullets(s, rx, 1.5, R - rx, 4.9, [
    ("药物  ", "MMF 67–70%，硫唑嘌呤 29–31%"),
    ("暴露时间  ", "中位 1.9–2.5 年"),
    ("三年死亡（未加权）  ", "非 IPF IIP 20% vs 17%；fHP 22% vs 14%；CTD-ILD 11% vs 10%"),
    ("随访  ", "各组中位 3.0 年"),
], size=14, gap=14)

# ---------------------------------------------------------------- 8 Fig 3 (hero, top/bottom)
s = new("主要结果：无一亚型生存获益，fHP 与非 IPF IIP 风险更高", kicker="三年死亡或肺移植 · Fig. 3",
    notes="【约 2 分钟，全场重点】原文图 3 的森林图，横轴是 6 个月内启动免疫抑制相对于不启动的 HR，终点是三年内死亡或肺移植。"
    "第一行是 IPF 阳性对照：HR 1.45，95% CI 1.02–2.05，P=0.039，重现了 PANTHER-IPF 的有害方向，说明这套方法能检出已知的危害。"
    "非 IPF IIP：HR 1.38（1.04–1.84），P=0.028。fHP：HR 1.62（1.09–2.40），P=0.016。两者点估计与 IPF 相近，置信区间都不跨 1。"
    "CTD-ILD：HR 0.86（0.53–1.41），P=0.55，点估计小于 1 但区间很宽，既没有显示获益也没有显示危害；事件数只有 75 个，是三个亚型中最少的。"
    "注意 Cloned N 是克隆后的样本量，是实际人数的两倍。"
    "正文补充：非 IPF IIP 内部，危害主要来自不可分类 ILD（uILD，HR 1.40，1.01–1.94）；MMF 和硫唑嘌呤分开看效应大体相似（补充表 E10）。")
w_, h_ = picture(s, "fig3.jpg", L + 0.6, 1.5, w=10.9, src="Source: Fig. 3（原文图，未改动）。HR >1 表示启动免疫抑制者风险更高；符合方案效应")
text(s, L, 6.4, W, 0.5, [[("fHP ", {"bold": True, "color": RED}), "HR 1.62      ",
                          ("非 IPF IIP ", {"bold": True, "color": RED}), "HR 1.38      ",
                          ("IPF 阳性对照 ", {"bold": True, "color": NAVY}), "HR 1.45      ",
                          ("CTD-ILD ", {"bold": True, "color": GREY}), "HR 0.86，区间跨 1"]], size=15)

# ---------------------------------------------------------------- 9 Fig 4
s = new("危害信号集中在基线低风险患者", kicker="按预测死亡风险分层 · Fig. 4",
    notes="【约 1.5 分钟】原文图 4。作者想回答：免疫抑制的危害是不是只是因为用药的人本来就重？"
    "他们在未用药的患者里用年龄、性别、FVC、DLCO 和中心建了一个预后模型（c 指数 0.75），再把合并的非 IPF 队列按预测风险三分位分层。"
    "结果有些反直觉：高风险组 HR 1.05（0.82–1.33），没有差异；中风险组 HR 1.36（0.93–1.98）；低风险组 HR 2.77（1.43–5.37），P=0.003。"
    "解读要谨慎：低风险组只有 41 个事件，置信区间很宽。一种可能是低风险患者本来预后好，药物的不良作用更容易显现；"
    "另一种可能是残余混杂——低风险却被用药的人，往往有模型没测到的理由。这个结果适合作为假设，不宜直接用于个体决策。")
w_, h_ = picture(s, "fig4.jpg", L, 1.5, w=9.0, src="Source: Fig. 4（原文图，未改动）。风险由年龄、性别、FVC%、DLCO%、中心预测，按三分位分层")
rx = L + w_ + 0.45
bar(s, rx - 0.2, 1.5, 3.6, RED)
text(s, rx, 1.5, R - rx, 3.8, [
    [("低风险组", {"size": 12, "color": GREY})],
    [("HR 2.77", {"size": 30, "bold": True, "color": RED})],
    [("95% CI 1.43–5.37", {"size": 12, "color": GREY})],
    [("高风险组", {"size": 12, "color": GREY})],
    [("HR 1.05", {"size": 30, "bold": True, "color": NAVY})],
    [("95% CI 0.82–1.33", {"size": 12, "color": GREY})],
], space=4)
text(s, L, 5.75, W, 0.9, [
    [("读图提醒  ", {"bold": True, "color": NAVY}), "低风险组仅 41 个事件，区间宽；预后模型 c 指数 0.75（0.72–0.78）。"],
    "低风险却被用药者可能带有未测量的用药理由，此结果宜作为假设。"], size=14, space=6)

# ---------------------------------------------------------------- 10 Fig 5
s = new("肺功能轨迹：FVC 与 DLCO 的变化两组无差异", kicker="次要终点 · Fig. 5",
    notes="【约 1.5 分钟】原文图 5。上排是 FVC 相对基线的变化，下排是 DLCO；三列分别是非 IPF IIP、fHP、CTD-ILD。"
    "蓝线是 6 个月内启动免疫抑制，橙线是不启动，阴影是置信带。每个小图上方给出了两组差值和 P 值。"
    "FVC：非 IPF IIP 差 24 mL（−16 到 64，p=0.23）；fHP −10 mL（−59 到 39，p=0.70）；CTD-ILD 24 mL（−28 到 77，p=0.36）。"
    "DLCO 三个亚型 p 值分别是 0.23、0.54、0.90。六个小图的置信带都大量重叠，没有一个达到统计学差异。"
    "两个细节：一是图的横轴画的是 0 到 1.00 年；二是有纵向数据的比例 FVC 为 80%、DLCO 为 68%，作者用随时间更新的 IPCW 处理信息性缺失。"
    "这与既往回顾性研究“免疫抑制稳定肺功能”的印象不同，作者认为是 CCW 减少了适应证混杂所致。")
w_, h_ = picture(s, "fig5.jpg", L, 1.5, h=5.15, src="Source: Fig. 5（原文图，未改动）。蓝 = 6 个月内启动；橙 = 不启动")
rx = L + w_ + 0.45
bar(s, rx - 0.2, 1.5, 4.4, TEAL)
bullets(s, rx, 1.5, R - rx, 4.9, [
    ("FVC 差值（IS − 不用）  ", "24、−10、24 mL，p = 0.23 / 0.70 / 0.36"),
    ("DLCO 差值  ", "p = 0.23 / 0.54 / 0.90"),
    ("数据可得性  ", "FVC 80%（1811 例），DLCO 68%（1535 例）"),
    ("与既往不同  ", "此前回顾性研究报告肺功能稳定或改善"),
], size=14, gap=14)

# ---------------------------------------------------------------- 11 robustness (text, no supplement figures)
s = new("稳健性：多种设定下方向一致，但 E 值有边界", kicker="敏感性分析（正文数据）",
    notes="【约 1 分钟】这一页没有图，因为相关图表都在补充材料里（表 E9、E10，图 E3、E4），我们手上的 PDF 不含补充材料，所以只列正文给出的数字。"
    "第一，改变 IPCW 模型设定、把治疗窗改成 3 个月或 12 个月，各亚型的效应方向一致。"
    "第二，MMF 与硫唑嘌呤分开分析，效应大体相似。"
    "第三，E 值：非 IPF IIP 为 2.10，fHP 为 2.62。意思是需要一个与用药和死亡都有 2 倍以上关联的未测混杂因素才能把结果完全解释掉；"
    "作为参照，已知预后因素的校正 HR 是年龄>65 岁 1.47、男性 1.83、FVC<70% 1.57、DLCO<50% 1.93、影像 UIP 1.37，都小于 E 值。"
    "但作者自己也承认，E 值只针对单一混杂因素，不能排除多个相关因素叠加。"
    "第四，6 个月窗内两组的肺功能下降速度没有实质差异（表 E7），不支持“用药者是因为早期快速进展才被用药”。")
bullets(s, L, 1.7, 6.9, 4.9, [
    ("治疗窗 3 / 12 个月  ", "各亚型效应方向一致"),
    ("IPCW 模型换设定  ", "方向一致"),
    ("MMF 与硫唑嘌呤分开  ", "效应大体相似"),
    ("用药前肺功能下降速度  ", "两组无实质差异"),
    ("亚组  ", "uILD HR 1.40（1.01–1.94）；其余亚组无差异"),
], size=17, gap=22)
bar(s, 8.0, 1.75, 4.5, NAVY)
text(s, 8.25, 1.7, 4.45, 0.35, ["E 值与已知预后因素的对照"], size=12, color=TEAL, bold=True)
text(s, 8.25, 2.15, 4.45, 1.5, [
    [("2.10", {"size": 30, "bold": True, "color": NAVY}), ("   非 IPF IIP", {"size": 13, "color": GREY})],
    [("2.62", {"size": 30, "bold": True, "color": NAVY}), ("   fHP", {"size": 13, "color": GREY})]], space=2)
text(s, 8.25, 3.95, 4.45, 2.4, [
    "已知因素的校正 HR 均更小：",
    "年龄 >65 岁 1.47 · 男性 1.83",
    "FVC <70% 1.57 · DLCO <50% 1.93 · UIP 1.37",
    [("E 值按单一混杂因素计算，不涵盖多因素联合作用。", {"color": RED})]], size=13, space=7)
text(s, L, 6.62, W, 0.3, ["对应图表在补充材料（Table E7、E9、E10；Figure E3、E4），本次所用 PDF 未包含，故此页无原图。"], size=9, color=GREY)

# ---------------------------------------------------------------- 12 limitations
s = new("解读边界：残余混杂与人群选择", kicker="局限性",
    notes="【约 1.5 分钟】局限性分四类讲。"
    "一，残余混杂是最大的问题：权重模型里没有影像上的炎症/磨玻璃程度、血清学、症状进展速度、糖皮质激素用量。"
    "医生给“看起来更活动”的患者用药，而这些患者本身预后可能就差，方向上会使用药组显得更差。"
    "作者引用既往工作说激素使用与这些药同步，且不造成结局差异，但这并不是本研究内的校正。"
    "二，选择：都是学术转诊中心；排除了入组前已用药者、用利妥昔单抗或环磷酰胺者、肺功能很差者，以及三年结局未知者。"
    "三，暴露定义：MMF 和硫唑嘌呤合并，剂量、疗程、依从性没有建模。"
    "四，终点：全因死亡或移植，无法区分非 ILD 的竞争死因；也没有报告感染、肿瘤等具体不良事件，所以“为什么更差”没有机制证据。"
    "另外 CTD-ILD 的阴性结果要和 SLS II 等 RCT 区别看：本研究人群更杂、启动时机不一，作者明确说要谨慎解读。")
col_w = 5.75
text(s, L, 1.65, col_w, 0.35, ["内部真实性"], size=12, color=TEAL, bold=True)
bullets(s, L, 2.1, col_w, 4.3, [
    ("未测量混杂  ", "影像炎症程度、血清学、激素用量未入模"),
    ("基线后进展  ", "启动用药可能由入组后恶化触发"),
    ("信息性缺失  ", "肺功能随访不全，IPCW 未必完全纠正"),
    ("死因不明  ", "无法区分非 ILD 竞争死因；无不良事件数据"),
], size=16, gap=22)
bar(s, 6.75, 1.7, 4.6, TEAL)
text(s, 7.0, 1.65, col_w, 0.35, ["外推性与暴露定义"], size=12, color=TEAL, bold=True)
bullets(s, 7.0, 2.1, col_w, 4.3, [
    ("学术转诊中心  ", "病例更重、更难治或诊断更复杂"),
    ("排除人群  ", "既往用药者、利妥昔单抗/环磷酰胺、FVC 或 DLCO 过低者"),
    ("两药合并  ", "剂量、疗程、依从性未建模"),
    ("CTD-ILD  ", "人群异质、启动时机不一，与 SLS II 不可直接比较"),
], size=16, gap=22)

# ---------------------------------------------------------------- 13 conclusion / discussion
s = new("结论：按诊断常规启动 MMF / 硫唑嘌呤缺乏获益证据", kicker="结论与讨论",
    notes="【约 1.5 分钟】总结。在这项多中心目标试验模拟里，入组 6 个月内启动 MMF 或硫唑嘌呤，在任何一个纤维化型 ILD 亚型都没有改善三年无移植生存或肺功能轨迹；"
    "在 fHP 和非 IPF IIP（尤其是不可分类 ILD）中反而与更差的结局相关，量级接近 IPF。CTD-ILD 中既无获益也无危害的信号。"
    "作者的落点是：这不等于所有患者都不该用免疫抑制，而是“仅凭诊断就经验性启动”需要重新审视，要靠生物标志物——比如端粒长度、蛋白质组内型——来分层，并且需要前瞻性 RCT。"
    "留给大家讨论的三个问题在右侧：第一，我们科里 fHP 和 uILD 患者启动 MMF 的指征是什么，是否有影像上 UIP 样表现者也在用；"
    "第二，适应证混杂能在多大程度上解释 HR 1.4–1.6；第三，低风险组 HR 2.77 这个发现我们信多少。")
bullets(s, L, 1.7, 6.9, 4.9, [
    ("生存  ", "任一亚型均无获益；fHP HR 1.62、非 IPF IIP HR 1.38"),
    ("肺功能  ", "FVC、DLCO 轨迹两组无差异"),
    ("CTD-ILD  ", "HR 0.86（0.53–1.41），未见获益亦未见危害"),
    ("方法可信度  ", "IPF 阳性对照重现有害方向（HR 1.45）"),
    ("作者主张  ", "以生物标志物分层，并开展前瞻性 RCT"),
], size=17, gap=22)
bar(s, 8.0, 1.75, 4.5, RED)
text(s, 8.25, 1.7, 4.45, 0.35, ["组会讨论"], size=12, color=RED, bold=True)
bullets(s, 8.25, 2.15, 4.45, 4.4, [
    "我们对 fHP、uILD 启动 MMF 的指征是什么？UIP 样表现者是否也在用？",
    "适应证混杂能解释多少 HR 1.4–1.6？",
    "低风险组 HR 2.77（41 个事件）可信度如何？",
], size=17, gap=24)

prs.save(OUT / "final_presentation_cn.pptx")
print("slides:", len(prs.slides))
