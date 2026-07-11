from pathlib import Path
import textwrap

from PIL import Image, ImageDraw, ImageFont


OUT_DIR = Path(__file__).resolve().parent
W, H = 2560, 1440

FONT_REG = "/System/Library/Fonts/Supplemental/Arial.ttf"
FONT_BOLD = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
FONT_BLACK = "/System/Library/Fonts/Supplemental/Arial Black.ttf"


def font(path, size):
    return ImageFont.truetype(path, size)


F = {
    "title": font(FONT_BLACK, 72),
    "subtitle": font(FONT_REG, 34),
    "section": font(FONT_BOLD, 34),
    "card_title": font(FONT_BOLD, 29),
    "body": font(FONT_REG, 24),
    "small": font(FONT_REG, 21),
    "small_bold": font(FONT_BOLD, 21),
    "metric": font(FONT_BLACK, 44),
    "label": font(FONT_BOLD, 20),
    "footer": font(FONT_REG, 18),
}


COL = {
    "bg": (248, 250, 252),
    "ink": (18, 28, 45),
    "muted": (82, 97, 122),
    "soft": (230, 236, 245),
    "blue": (30, 91, 168),
    "teal": (0, 134, 145),
    "green": (36, 137, 89),
    "amber": (207, 132, 32),
    "red": (181, 65, 62),
    "purple": (95, 88, 170),
    "white": (255, 255, 255),
    "line": (207, 216, 229),
    "dark": (26, 43, 69),
}


def rounded(draw, box, radius=24, fill=COL["white"], outline=None, width=1):
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def text(draw, xy, value, fnt, fill=COL["ink"], anchor=None, spacing=7, max_width=None, line_gap=1.18):
    x, y = xy
    if max_width is None:
        draw.text((x, y), value, font=fnt, fill=fill, anchor=anchor, spacing=spacing)
        return draw.textbbox((x, y), value, font=fnt, spacing=spacing, anchor=anchor)

    lines = []
    for para in value.split("\n"):
        if not para:
            lines.append("")
            continue
        words = para.split()
        current = ""
        for word in words:
            trial = (current + " " + word).strip()
            if draw.textlength(trial, font=fnt) <= max_width:
                current = trial
            else:
                if current:
                    lines.append(current)
                current = word
        if current:
            lines.append(current)

    line_h = int(fnt.size * line_gap)
    yy = y
    for line in lines:
        draw.text((x, yy), line, font=fnt, fill=fill)
        yy += line_h
    return (x, y, x + max_width, yy)


def pill(draw, x, y, w, h, label, fill, color=COL["white"]):
    rounded(draw, (x, y, x + w, y + h), radius=h // 2, fill=fill)
    draw.text((x + w / 2, y + h / 2 - 1), label, font=F["label"], fill=color, anchor="mm")


def bullet_list(draw, x, y, items, max_width, fnt=F["small"], fill=COL["ink"], bullet_fill=COL["blue"], gap=17):
    yy = y
    for item in items:
        draw.ellipse((x, yy + 9, x + 9, yy + 18), fill=bullet_fill)
        bbox = text(draw, (x + 24, yy), item, fnt, fill=fill, max_width=max_width - 24, line_gap=1.2)
        yy = bbox[3] + gap
    return yy


def draw_header(draw, page_no, subtitle):
    draw.rectangle((0, 0, W, 16), fill=COL["blue"])
    pill(draw, 96, 52, 160, 40, "NeatLogic", COL["dark"])
    draw.text((278, 72), "Customer Solution Draft", font=F["small_bold"], fill=COL["muted"], anchor="lm")
    draw.text((W - 96, 72), f"Page {page_no} / 2", font=F["footer"], fill=COL["muted"], anchor="rm")
    draw.text((96, 126), subtitle, font=F["title"], fill=COL["ink"])


def draw_footer(draw):
    draw.line((96, H - 76, W - 96, H - 76), fill=COL["line"], width=2)
    footer = "Draft for Huawei Thailand customer discussion | Metrics are PoC validation targets, not committed production results"
    draw.text((96, H - 43), footer, font=F["footer"], fill=COL["muted"])


def page1():
    im = Image.new("RGB", (W, H), COL["bg"])
    draw = ImageDraw.Draw(im)
    draw_header(draw, 1, "NeatLogic for Financial IT Operations")
    text(draw, (96, 214), "From fragmented operations to AI-assisted service resilience", F["subtitle"], COL["muted"])

    pain_x, pain_y, pain_w, pain_h = 96, 295, 520, 845
    rounded(draw, (pain_x, pain_y, pain_x + pain_w, pain_y + pain_h), fill=(255, 255, 255), outline=COL["line"])
    draw.text((pain_x + 32, pain_y + 34), "Customer Pain Points", font=F["section"], fill=COL["red"])
    pains = [
        "Slow response: manual dispatch and unclear ownership",
        "High operating cost: repetitive checks, releases and recovery",
        "Fragmented data: assets, tickets, alerts and changes are disconnected",
        "Late risk detection: noisy alerts without business context",
        "Compliance pressure: evidence is hard to trace end to end",
    ]
    bullet_list(draw, pain_x + 36, pain_y + 96, pains, pain_w - 72, F["body"], gap=28, bullet_fill=COL["red"])

    chain_x, chain_y = 668, 295
    draw.text((chain_x, chain_y), "Business Pain -> Platform Capability -> Huawei Foundation -> Outcome", font=F["section"], fill=COL["ink"])

    rows = [
        ("Service response is slow", "ITSM service catalog, workflow, SLA, smart assignment, mobile handling", "Cloud, network, compute, storage and AI service foundation", "Faster routing, visible SLA control, better user experience", COL["blue"]),
        ("Asset and application data are incomplete", "CMDB, auto discovery, topology, transaction records, audit trail", "Trusted ICT resource data and integration capability", "Faster impact analysis and stronger change risk control", COL["teal"]),
        ("Alerts are noisy and risk is late", "Alert center, event plugins, suppression, subscription, topology, AI analysis", "AI platform/model services plus monitoring data", "Lower alert noise and earlier risk recognition", COL["purple"]),
        ("Operations and releases are manual", "Automation orchestration, runner execution, gray/batch release, super pipeline", "Compute, network, storage, security and cloud resources", "Shorter cycles, fewer manual errors, repeatable execution", COL["green"]),
    ]
    y = chain_y + 66
    col_w = [326, 420, 390, 430]
    headers = ["Pain Point", "NeatLogic Capability", "Huawei ICT / AI", "Business Effect"]
    x = chain_x
    for i, h in enumerate(headers):
        rounded(draw, (x, y, x + col_w[i] - 14, y + 48), radius=12, fill=COL["dark"])
        draw.text((x + 18, y + 24), h, font=F["small_bold"], fill=COL["white"], anchor="lm")
        x += col_w[i]
    y += 64
    for row in rows:
        x = chain_x
        row_h = 132
        for i, val in enumerate(row[:4]):
            fill = (255, 255, 255) if i else (253, 248, 247)
            rounded(draw, (x, y, x + col_w[i] - 14, y + row_h), radius=16, fill=fill, outline=COL["line"])
            if i == 0:
                draw.rectangle((x, y, x + 7, y + row_h), fill=row[4])
            text(draw, (x + 20, y + 20), val, F["small"], COL["ink"], max_width=col_w[i] - 54, line_gap=1.18)
            x += col_w[i]
        y += row_h + 16

    draw.text((668, 1010), "Customer Value to Validate in PoC", font=F["section"], fill=COL["ink"])
    metrics = [
        ("30-50%", "less manual incident triage effort"),
        ("20-40%", "shorter incident or change lead time"),
        ("40-60%", "automation coverage for selected repetitive tasks"),
        ("60-80%", "faster asset and impact analysis"),
        ("100%", "traceable approval, execution and audit evidence"),
    ]
    mx, my = 668, 1066
    box_w, box_h = 330, 154
    for i, (num, lab) in enumerate(metrics):
        x = mx + i * (box_w + 22)
        rounded(draw, (x, my, x + box_w, my + box_h), radius=20, fill=COL["white"], outline=COL["line"])
        draw.text((x + 24, my + 40), num, font=F["metric"], fill=[COL["blue"], COL["teal"], COL["green"], COL["amber"], COL["purple"]][i])
        text(draw, (x + 24, my + 92), lab, F["small"], COL["muted"], max_width=box_w - 48, line_gap=1.12)

    draw_footer(draw)
    im.save(OUT_DIR / "neatlogic-solution-page-1.png", quality=95)


def capability_card(draw, x, y, w, h, title, body, color):
    rounded(draw, (x, y, x + w, y + h), radius=20, fill=COL["white"], outline=COL["line"])
    draw.rectangle((x, y, x + 9, y + h), fill=color)
    draw.text((x + 26, y + 28), title, font=F["card_title"], fill=color)
    text(draw, (x + 26, y + 74), body, F["small"], COL["muted"], max_width=w - 52, line_gap=1.16)


def poc_card(draw, x, y, w, h, title, scenario, steps, metrics, color):
    rounded(draw, (x, y, x + w, y + h), radius=24, fill=COL["white"], outline=COL["line"])
    title_box = text(draw, (x + 30, y + 32), title, F["card_title"], color, max_width=w - 60, line_gap=1.05)
    scenario_box = text(draw, (x + 30, title_box[3] + 16), scenario, F["small"], COL["ink"], max_width=w - 60, line_gap=1.15)
    impl_y = scenario_box[3] + 20
    draw.text((x + 30, impl_y), "Implementation path", font=F["small_bold"], fill=COL["ink"])
    yy = bullet_list(draw, x + 34, impl_y + 36, steps, w - 68, F["small"], COL["muted"], color, gap=7)
    draw.text((x + 30, yy + 8), "Suggested validation metrics", font=F["small_bold"], fill=COL["ink"])
    bullet_list(draw, x + 34, yy + 42, metrics, w - 68, F["small"], COL["muted"], color, gap=7)


def page2():
    im = Image.new("RGB", (W, H), COL["bg"])
    draw = ImageDraw.Draw(im)
    draw_header(draw, 2, "Capability Map & PoC Proof Path")
    text(draw, (96, 214), "One platform for service, operations, change, knowledge and AI-assisted decisioning", F["subtitle"], COL["muted"])

    draw.text((96, 292), "NeatLogic Capability Coverage", font=F["section"], fill=COL["ink"])
    cards = [
        ("Customer & Employee Service", "Service catalog, work order center, workflow, SLA, satisfaction, notification, mobile access", COL["blue"]),
        ("CMDB & Resource Center", "Dynamic CI model, topology, transaction, discovery, collection, authorization, APIs and messages", COL["teal"]),
        ("Monitoring & Risk Detection", "Inspection, latest problem list, config comparison, alert lifecycle, suppression and subscription", COL["red"]),
        ("Automation & Release", "Custom tools, orchestration, runner execution, batch/parallel/gray execution, one-click release, super pipeline", COL["green"]),
        ("Delivery Governance", "Requirements, tasks, defects, iterations, test plans/cases, code and release association, state transitions", COL["amber"]),
        ("Knowledge & Visibility", "Knowledge approval and versioning, ITSM-to-knowledge conversion, reports, dashboard and large screen", COL["purple"]),
        ("AI-assisted Operations", "AI agents, tool/workflow invocation, RAG knowledge retrieval, alert analysis, structured outputs", COL["dark"]),
    ]
    x0, y0 = 96, 350
    cw, ch = 520, 150
    for i, card in enumerate(cards):
        x = x0 + (i % 2) * (cw + 24)
        y = y0 + (i // 2) * (ch + 22)
        capability_card(draw, x, y, cw, ch, *card)

    draw.text((1230, 292), "Financial Customer PoC Proof Path", font=F["section"], fill=COL["ink"])
    poc_card(
        draw,
        1230,
        350,
        592,
        680,
        "PoC 1: Incident-to-Resolution Intelligence",
        "Connect monitoring alerts, CMDB context, ITSM workflow, knowledge base and approved automation for one high-value banking application.",
        [
            "Ingest alerts into Alert Center",
            "Correlate application, owner and topology through CMDB",
            "Use AI to classify severity, probable cause and action",
            "Create/update ticket, assign team and attach runbook",
            "Report SLA, MTTA/MTTR and closure evidence",
        ],
        [
            "Alert noise reduction ratio",
            "Correct assignment ratio",
            "MTTA and MTTR improvement",
            "Evidence completeness per incident",
        ],
        COL["blue"],
    )
    poc_card(
        draw,
        1872,
        350,
        592,
        680,
        "PoC 2: Controlled Change and Release",
        "Standardize a core banking or channel-system change flow from request, approval, risk assessment, release, verification and rollback evidence.",
        [
            "Submit change through ITSM service catalog",
            "Use CMDB topology to show impacted services",
            "Run automated pre-check, release, post-check and rollback steps",
            "Show status, logs, failure reason and compliance evidence",
        ],
        [
            "Lead time from request to verified completion",
            "Manual steps replaced by automation",
            "Release success and rollback readiness",
            "Audit evidence completeness",
        ],
        COL["green"],
    )

    rounded(draw, (1230, 1076, 2464, 1225), radius=24, fill=(235, 244, 255), outline=(183, 205, 235))
    draw.text((1262, 1112), "Recommended customer-facing message", font=F["card_title"], fill=COL["blue"])
    msg = (
        "NeatLogic does not replace existing banking systems. It connects requests, assets, alerts, changes, "
        "automation and knowledge into one operational loop, then uses Huawei ICT/AI foundation to make the loop "
        "faster, more traceable and easier to scale."
    )
    text(draw, (1262, 1156), msg, F["body"], COL["ink"], max_width=1168, line_gap=1.18)

    draw_footer(draw)
    im.save(OUT_DIR / "neatlogic-solution-page-2.png", quality=95)


if __name__ == "__main__":
    page1()
    page2()
    print(OUT_DIR / "neatlogic-solution-page-1.png")
    print(OUT_DIR / "neatlogic-solution-page-2.png")
