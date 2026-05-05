import AppKit

let width = 2480
let height = 3508
let dark = NSColor(red: 0.227, green: 0.141, blue: 0.075, alpha: 1)
let mid = NSColor(red: 0.478, green: 0.337, blue: 0.188, alpha: 1)
let paper = NSColor(red: 0.941, green: 0.859, blue: 0.659, alpha: 1)
let panel = NSColor(red: 0.906, green: 0.765, blue: 0.478, alpha: 0.92)
let gold = NSColor(red: 0.792, green: 0.553, blue: 0.169, alpha: 1)
let ink = NSColor(red: 0.149, green: 0.090, blue: 0.043, alpha: 1)

enum BlockKind {
    case heading2
    case heading3
    case bullet
    case paragraph
}

struct Block {
    let kind: BlockKind
    let text: String
}

struct TextSpec {
    let heading2: CGFloat
    let heading3: CGFloat
    let body: CGFloat
    let bullet: CGFloat
    let lineSpacing: CGFloat
    let afterHeading: CGFloat
    let afterBody: CGFloat
    let bulletIndent: CGFloat
}

func bitmap() -> NSBitmapImageRep {
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: width,
        pixelsHigh: height,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )!
    rep.size = NSSize(width: width, height: height)
    return rep
}

func save(_ rep: NSBitmapImageRep, _ path: String) {
    let data = rep.representation(using: .png, properties: [.compressionFactor: 0.9])!
    try! data.write(to: URL(fileURLWithPath: path))
}

func font(_ size: CGFloat, bold: Bool = false) -> NSFont {
    NSFont(name: bold ? "Georgia-Bold" : "Georgia", size: size)
        ?? NSFont.systemFont(ofSize: size, weight: bold ? .bold : .regular)
}

func paragraphStyle(
    alignment: NSTextAlignment = .left,
    lineSpacing: CGFloat = 5,
    firstLineHeadIndent: CGFloat = 0,
    headIndent: CGFloat = 0
) -> NSMutableParagraphStyle {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = alignment
    paragraph.lineBreakMode = .byWordWrapping
    paragraph.lineSpacing = lineSpacing
    paragraph.firstLineHeadIndent = firstLineHeadIndent
    paragraph.headIndent = headIndent
    return paragraph
}

func attrs(size: CGFloat, bold: Bool = false, color: NSColor = ink, style: NSMutableParagraphStyle) -> [NSAttributedString.Key: Any] {
    [
        .font: font(size, bold: bold),
        .foregroundColor: color,
        .paragraphStyle: style,
    ]
}

func attributed(_ text: String, size: CGFloat, bold: Bool = false, style: NSMutableParagraphStyle) -> NSAttributedString {
    NSAttributedString(string: text, attributes: attrs(size: size, bold: bold, style: style))
}

func textHeight(_ text: String, width: CGFloat, size: CGFloat, bold: Bool = false, style: NSMutableParagraphStyle) -> CGFloat {
    let attr = attributed(text, size: size, bold: bold, style: style)
    let rect = attr.boundingRect(
        with: NSSize(width: width, height: CGFloat.greatestFiniteMagnitude),
        options: [.usesLineFragmentOrigin, .usesFontLeading]
    )
    return ceil(rect.height)
}

func drawText(_ text: String, in rect: NSRect, size: CGFloat, bold: Bool = false, align: NSTextAlignment = .left, color: NSColor = ink) {
    let style = paragraphStyle(alignment: align, lineSpacing: 4)
    NSAttributedString(
        string: text,
        attributes: attrs(size: size, bold: bold, color: color, style: style)
    ).draw(in: rect)
}

func rounded(_ rect: NSRect, radius: CGFloat, fill: NSColor, stroke: NSColor = dark, line: CGFloat = 8) {
    let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
    fill.setFill()
    path.fill()
    stroke.setStroke()
    path.lineWidth = line
    path.stroke()
}

func line(_ points: [NSPoint], width: CGFloat, alpha: CGFloat = 0.45) {
    let path = NSBezierPath()
    path.move(to: points[0])
    for point in points.dropFirst() {
        path.line(to: point)
    }
    mid.withAlphaComponent(alpha).setStroke()
    path.lineWidth = width
    path.lineCapStyle = .round
    path.stroke()
}

func triangle(_ center: NSPoint, size: CGFloat, fill: NSColor = gold, stroke: NSColor = dark, lineWidth: CGFloat = 18) {
    let path = NSBezierPath()
    path.move(to: NSPoint(x: center.x, y: center.y + size * 0.62))
    path.line(to: NSPoint(x: center.x - size * 0.56, y: center.y - size * 0.44))
    path.line(to: NSPoint(x: center.x + size * 0.56, y: center.y - size * 0.44))
    path.close()
    fill.setFill()
    path.fill()
    stroke.setStroke()
    path.lineWidth = lineWidth
    path.lineJoinStyle = .round
    path.stroke()
}

func drawBackground(title: String, subtitle: String) {
    paper.setFill()
    NSRect(x: 0, y: 0, width: width, height: height).fill()

    rounded(
        NSRect(x: 116, y: 126, width: 2248, height: 3256),
        radius: 28,
        fill: NSColor(red: 0.851, green: 0.741, blue: 0.490, alpha: 1),
        line: 12
    )
    rounded(
        NSRect(x: 156, y: 166, width: 2168, height: 3176),
        radius: 18,
        fill: paper,
        stroke: NSColor(red: 0.541, green: 0.357, blue: 0.176, alpha: 1),
        line: 4
    )

    for x in stride(from: 204, through: 2276, by: 96) {
        let p = NSBezierPath()
        p.move(to: NSPoint(x: x, y: 214))
        p.line(to: NSPoint(x: x, y: 3294))
        NSColor(red: 0.545, green: 0.416, blue: 0.243, alpha: 0.08).setStroke()
        p.lineWidth = 2
        p.stroke()
    }
    for y in stride(from: 214, through: 3294, by: 96) {
        let p = NSBezierPath()
        p.move(to: NSPoint(x: 204, y: y))
        p.line(to: NSPoint(x: 2276, y: y))
        NSColor(red: 0.545, green: 0.416, blue: 0.243, alpha: 0.08).setStroke()
        p.lineWidth = 2
        p.stroke()
    }

    line([NSPoint(x: 200, y: 3150), NSPoint(x: 420, y: 3210), NSPoint(x: 610, y: 3178), NSPoint(x: 760, y: 3220)], width: 7, alpha: 0.34)
    line([NSPoint(x: 1720, y: 3220), NSPoint(x: 1880, y: 3188), NSPoint(x: 2070, y: 3218), NSPoint(x: 2250, y: 3182)], width: 7, alpha: 0.34)
    line([NSPoint(x: 260, y: 410), NSPoint(x: 430, y: 470), NSPoint(x: 610, y: 435), NSPoint(x: 770, y: 475)], width: 7, alpha: 0.26)
    line([NSPoint(x: 1710, y: 475), NSPoint(x: 1885, y: 435), NSPoint(x: 2060, y: 470), NSPoint(x: 2230, y: 425)], width: 7, alpha: 0.26)

    triangle(NSPoint(x: 280, y: 3188), size: 88, lineWidth: 8)
    triangle(NSPoint(x: 2200, y: 3188), size: 88, lineWidth: 8)

    let titleText = title.uppercased()
    if titleText.count > 32 {
        drawText(titleText, in: NSRect(x: 330, y: 3130, width: 1820, height: 150), size: 50, bold: true, align: .center, color: dark)
        drawText(subtitle, in: NSRect(x: 330, y: 3078, width: 1820, height: 52), size: 32, bold: false, align: .center, color: mid)
    } else {
        drawText(titleText, in: NSRect(x: 330, y: 3154, width: 1820, height: 105), size: 68, bold: true, align: .center, color: dark)
        drawText(subtitle, in: NSRect(x: 330, y: 3094, width: 1820, height: 58), size: 34, bold: false, align: .center, color: mid)
    }
}

func parseMarkdown(_ path: String) -> (title: String, blocks: [Block]) {
    let text = try! String(contentsOfFile: path, encoding: .utf8)
    var title = ""
    var blocks: [Block] = []

    for rawLine in text.components(separatedBy: .newlines) {
        let line = rawLine.trimmingCharacters(in: .whitespaces)
        if line.isEmpty {
            continue
        }
        if line.hasPrefix("# ") {
            title = String(line.dropFirst(2))
        } else if line.hasPrefix("## ") {
            blocks.append(Block(kind: .heading2, text: String(line.dropFirst(3))))
        } else if line.hasPrefix("### ") {
            blocks.append(Block(kind: .heading3, text: String(line.dropFirst(4))))
        } else if line.hasPrefix("- ") {
            blocks.append(Block(kind: .bullet, text: String(line.dropFirst(2))))
        } else {
            blocks.append(Block(kind: .paragraph, text: line))
        }
    }

    return (title.isEmpty ? path : title, blocks)
}

func blockText(_ block: Block) -> String {
    switch block.kind {
    case .bullet:
        return "• \(block.text)"
    default:
        return block.text
    }
}

func blockSpec(_ block: Block, spec: TextSpec) -> (size: CGFloat, bold: Bool, style: NSMutableParagraphStyle, after: CGFloat, widthInset: CGFloat) {
    switch block.kind {
    case .heading2:
        return (spec.heading2, true, paragraphStyle(lineSpacing: spec.lineSpacing), spec.afterHeading, 0)
    case .heading3:
        return (spec.heading3, true, paragraphStyle(lineSpacing: spec.lineSpacing), spec.afterHeading * 0.7, 18)
    case .bullet:
        return (
            spec.bullet,
            false,
            paragraphStyle(
                lineSpacing: spec.lineSpacing,
                firstLineHeadIndent: 0,
                headIndent: spec.bulletIndent
            ),
            spec.afterBody,
            28
        )
    case .paragraph:
        return (spec.body, false, paragraphStyle(lineSpacing: spec.lineSpacing), spec.afterBody * 1.4, 18)
    }
}

func fittedSpec(base: TextSpec, blocks: [Block], contentRect: NSRect, columns: Int) -> TextSpec {
    let scales: [CGFloat] = [1.0, 0.96, 0.92, 0.88, 0.84, 0.80, 0.76, 0.72]
    for scale in scales {
        let candidate = TextSpec(
            heading2: base.heading2 * scale,
            heading3: base.heading3 * scale,
            body: base.body * scale,
            bullet: base.bullet * scale,
            lineSpacing: max(2, base.lineSpacing * scale),
            afterHeading: max(8, base.afterHeading * scale),
            afterBody: max(5, base.afterBody * scale),
            bulletIndent: base.bulletIndent * scale
        )
        if layout(blocks, in: contentRect, columns: columns, spec: candidate, draw: false) {
            return candidate
        }
    }
    return TextSpec(
        heading2: base.heading2 * 0.68,
        heading3: base.heading3 * 0.68,
        body: base.body * 0.68,
        bullet: base.bullet * 0.68,
        lineSpacing: 2,
        afterHeading: 7,
        afterBody: 4,
        bulletIndent: base.bulletIndent * 0.68
    )
}

@discardableResult
func layout(_ blocks: [Block], in contentRect: NSRect, columns: Int, spec: TextSpec, draw: Bool) -> Bool {
    let columnGap: CGFloat = columns == 1 ? 0 : 72
    let columnWidth = (contentRect.width - columnGap * CGFloat(columns - 1)) / CGFloat(columns)
    var columnIndex = 0
    let columnTop = contentRect.maxY - 44
    var top = columnTop
    let bottom = contentRect.minY + 38

    func measured(_ index: Int) -> CGFloat {
        let block = blocks[index]
        let cfg = blockSpec(block, spec: spec)
        let effectiveWidth = columnWidth - cfg.widthInset
        let text = blockText(block)
        let height = textHeight(text, width: effectiveWidth, size: cfg.size, bold: cfg.bold, style: cfg.style)
        return height + cfg.after
    }

    func keepWithNextHeight(from index: Int) -> CGFloat {
        var total = measured(index)
        if blocks[index].kind == .heading2 {
            if index + 1 < blocks.count {
                total += measured(index + 1)
            }
            if index + 2 < blocks.count && blocks[index + 1].kind == .heading3 {
                total += measured(index + 2)
            }
        } else if blocks[index].kind == .heading3 && index + 1 < blocks.count {
            total += measured(index + 1)
        }
        return total
    }

    func moveToNextColumn() -> Bool {
        columnIndex += 1
        if columnIndex >= columns {
            return false
        }
        top = columnTop
        return true
    }

    for index in blocks.indices {
        let block = blocks[index]
        let cfg = blockSpec(block, spec: spec)
        let effectiveWidth = columnWidth - cfg.widthInset
        let text = blockText(block)
        let height = textHeight(text, width: effectiveWidth, size: cfg.size, bold: cfg.bold, style: cfg.style)
        let needed = height + cfg.after

        if top < columnTop && top - keepWithNextHeight(from: index) < bottom {
            if !moveToNextColumn() {
                return false
            }
        }

        if top - needed < bottom {
            if !moveToNextColumn() {
                return false
            }
        }

        let columnX = contentRect.minX + CGFloat(columnIndex) * (columnWidth + columnGap)
        let x = columnX + cfg.widthInset

        if draw {
            if block.kind == .heading2 {
                let band = NSRect(x: columnX, y: top - height - 12, width: columnWidth, height: height + 24)
                rounded(band, radius: 12, fill: panel.withAlphaComponent(0.55), stroke: mid.withAlphaComponent(0.65), line: 3)
            }
            let rect = NSRect(x: x, y: top - height, width: effectiveWidth, height: height)
            let attr = attributed(text, size: cfg.size, bold: cfg.bold, style: cfg.style)
            attr.draw(with: rect, options: [.usesLineFragmentOrigin, .usesFontLeading])
        }
        top -= needed
    }

    return true
}

func renderNote(markdownPath: String, outputPath: String, subtitle: String, columns: Int, baseSpec: TextSpec) {
    let parsed = parseMarkdown(markdownPath)
    let rep = bitmap()

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

    drawBackground(title: parsed.title, subtitle: subtitle)
    let contentRect = NSRect(x: 230, y: 260, width: 2020, height: 2790)
    rounded(contentRect, radius: 22, fill: NSColor(red: 0.960, green: 0.885, blue: 0.704, alpha: 0.80), stroke: mid, line: 5)
    let innerRect = contentRect.insetBy(dx: 42, dy: 34)

    let spec = fittedSpec(base: baseSpec, blocks: parsed.blocks, contentRect: innerRect, columns: columns)
    _ = layout(parsed.blocks, in: innerRect, columns: columns, spec: spec, draw: true)

    drawText("Gravity Falls quest", in: NSRect(x: 360, y: 222, width: 1760, height: 44), size: 26, align: .center, color: mid)

    NSGraphicsContext.restoreGraphicsState()
    save(rep, outputPath)
}

let dense = TextSpec(
    heading2: 34,
    heading3: 29,
    body: 28,
    bullet: 26,
    lineSpacing: 4,
    afterHeading: 18,
    afterBody: 10,
    bulletIndent: 36
)

let regular = TextSpec(
    heading2: 46,
    heading3: 38,
    body: 34,
    bullet: 33,
    lineSpacing: 6,
    afterHeading: 22,
    afterBody: 15,
    bulletIndent: 44
)

renderNote(
    markdownPath: "main_actions.md",
    outputPath: "docs/host_memo_a4.png",
    subtitle: "памятка ведущего",
    columns: 2,
    baseSpec: dense
)

renderNote(
    markdownPath: "inventory.md",
    outputPath: "docs/inventory_a4.png",
    subtitle: "список вещей",
    columns: 1,
    baseSpec: regular
)

renderNote(
    markdownPath: "other_adults_actions.md",
    outputPath: "docs/parents_a4.png",
    subtitle: "задание для родителей",
    columns: 1,
    baseSpec: regular
)

renderNote(
    markdownPath: "assistant_actions.md",
    outputPath: "docs/assistant_memo_a4.png",
    subtitle: "памятка помощнику",
    columns: 1,
    baseSpec: regular
)
