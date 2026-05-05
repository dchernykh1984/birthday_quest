import AppKit

let width = 2480
let height = 3508
let dark = NSColor(red: 0.227, green: 0.141, blue: 0.075, alpha: 1)
let mid = NSColor(red: 0.478, green: 0.337, blue: 0.188, alpha: 1)
let paper = NSColor(red: 0.941, green: 0.859, blue: 0.659, alpha: 1)
let panel = NSColor(red: 0.906, green: 0.765, blue: 0.478, alpha: 0.92)
let gold = NSColor(red: 0.792, green: 0.553, blue: 0.169, alpha: 1)
let glow = NSColor(red: 0.925, green: 0.686, blue: 0.255, alpha: 0.22)

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

func drawText(_ text: String, in rect: NSRect, size: CGFloat, bold: Bool = false, align: NSTextAlignment = .center, color: NSColor = dark) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = align
    let attrs: [NSAttributedString.Key: Any] = [
        .font: font(size, bold: bold),
        .foregroundColor: color,
        .paragraphStyle: paragraph,
    ]
    NSAttributedString(string: text, attributes: attrs).draw(in: rect)
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

func triangle(_ center: NSPoint, size: CGFloat, fill: NSColor = gold, stroke: NSColor = dark, lineWidth: CGFloat = 18) -> NSBezierPath {
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
    return path
}

func drawBackground(title: String, subtitle: String? = nil) {
    paper.setFill()
    NSRect(x: 0, y: 0, width: width, height: height).fill()
    rounded(NSRect(x: 116, y: 126, width: 2248, height: 3256), radius: 28, fill: NSColor(red: 0.851, green: 0.741, blue: 0.490, alpha: 1), line: 12)
    rounded(NSRect(x: 156, y: 166, width: 2168, height: 3176), radius: 18, fill: paper, stroke: NSColor(red: 0.541, green: 0.357, blue: 0.176, alpha: 1), line: 4)
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
    drawText(title, in: NSRect(x: 250, y: 3150, width: 1980, height: 115), size: 76, bold: true)
    if let subtitle {
        drawText(subtitle, in: NSRect(x: 250, y: 3080, width: 1980, height: 70), size: 38)
    }
}

func drawBill(center: NSPoint, scale: CGFloat, variant: Int) {
    glow.setFill()
    NSBezierPath(ovalIn: NSRect(x: center.x - 830 * scale, y: center.y - 830 * scale, width: 1660 * scale, height: 1660 * scale)).fill()
    for r in [720, 560, 400] {
        let c = NSBezierPath(ovalIn: NSRect(x: center.x - CGFloat(r) * scale, y: center.y - CGFloat(r) * scale, width: CGFloat(r * 2) * scale, height: CGFloat(r * 2) * scale))
        mid.withAlphaComponent(0.36).setStroke()
        c.lineWidth = 10 * scale
        c.stroke()
    }
    let body = triangle(center, size: 1220 * scale, lineWidth: 24 * scale)
    dark.withAlphaComponent(0.25).setStroke()
    for offset in [-245, -70, 105, 280] {
        let y = center.y + CGFloat(offset) * scale
        let p = NSBezierPath()
        p.move(to: NSPoint(x: center.x - 410 * scale, y: y))
        p.line(to: NSPoint(x: center.x + 410 * scale, y: y))
        p.lineWidth = 8 * scale
        p.stroke()
    }
    if variant == 2 {
        let rays = 10
        for i in 0..<rays {
            let angle = CGFloat(i) * CGFloat.pi * 2 / CGFloat(rays)
            let p = NSBezierPath()
            p.move(to: NSPoint(x: center.x + cos(angle) * 680 * scale, y: center.y + sin(angle) * 680 * scale))
            p.line(to: NSPoint(x: center.x + cos(angle) * 850 * scale, y: center.y + sin(angle) * 850 * scale))
            dark.withAlphaComponent(0.55).setStroke()
            p.lineWidth = 12 * scale
            p.stroke()
        }
    }
    if variant == 3 {
        for i in 0..<8 {
            let y = center.y - 600 * scale + CGFloat(i) * 150 * scale
            line([NSPoint(x: center.x - 760 * scale, y: y), NSPoint(x: center.x - 650 * scale, y: y + 35 * scale), NSPoint(x: center.x - 735 * scale, y: y + 75 * scale)], width: 8 * scale, alpha: 0.55)
            line([NSPoint(x: center.x + 760 * scale, y: y), NSPoint(x: center.x + 650 * scale, y: y + 35 * scale), NSPoint(x: center.x + 735 * scale, y: y + 75 * scale)], width: 8 * scale, alpha: 0.55)
        }
    }
    if variant == 4 {
        let ring = NSBezierPath(ovalIn: NSRect(x: center.x - 905 * scale, y: center.y - 905 * scale, width: 1810 * scale, height: 1810 * scale))
        dark.withAlphaComponent(0.35).setStroke()
        ring.lineWidth = 26 * scale
        ring.stroke()
    }
    if variant == 5 {
        for i in 0..<12 {
            let angle = CGFloat(i) * CGFloat.pi * 2 / 12
            let start = NSPoint(x: center.x + cos(angle) * 640 * scale, y: center.y + sin(angle) * 640 * scale)
            let end = NSPoint(x: center.x + cos(angle) * 880 * scale, y: center.y + sin(angle) * 880 * scale)
            let p = NSBezierPath()
            p.move(to: start)
            p.line(to: end)
            dark.withAlphaComponent(0.48).setStroke()
            p.lineWidth = 10 * scale
            p.stroke()
        }
        let ring = NSBezierPath(ovalIn: NSRect(x: center.x - 900 * scale, y: center.y - 900 * scale, width: 1800 * scale, height: 1800 * scale))
        mid.withAlphaComponent(0.35).setStroke()
        ring.lineWidth = 18 * scale
        ring.stroke()
    }
    let eye = NSBezierPath(ovalIn: NSRect(x: center.x - 150 * scale, y: center.y + 105 * scale, width: 300 * scale, height: 220 * scale))
    NSColor(red: 0.965, green: 0.831, blue: 0.478, alpha: 1).setFill()
    eye.fill()
    dark.setStroke()
    eye.lineWidth = 20 * scale
    eye.stroke()
    dark.setFill()
    NSBezierPath(ovalIn: NSRect(x: center.x - 40 * scale, y: center.y + 185 * scale, width: 80 * scale, height: 80 * scale)).fill()
    let smile = NSBezierPath()
    smile.move(to: NSPoint(x: center.x - 145 * scale, y: center.y - 155 * scale))
    smile.curve(to: NSPoint(x: center.x + 145 * scale, y: center.y - 155 * scale), controlPoint1: NSPoint(x: center.x - 65 * scale, y: center.y - 230 * scale), controlPoint2: NSPoint(x: center.x + 65 * scale, y: center.y - 230 * scale))
    dark.setStroke()
    smile.lineWidth = 18 * scale
    smile.stroke()
    let hat = NSBezierPath(roundedRect: NSRect(x: center.x - 95 * scale, y: center.y + 760 * scale, width: 190 * scale, height: 230 * scale), xRadius: 8 * scale, yRadius: 8 * scale)
    dark.setFill()
    hat.fill()
    let brim = NSBezierPath(roundedRect: NSRect(x: center.x - 170 * scale, y: center.y + 720 * scale, width: 340 * scale, height: 60 * scale), xRadius: 12 * scale, yRadius: 12 * scale)
    dark.setFill()
    brim.fill()
    body.addClip()
}

func renderPortal(_ variant: Int, outputPath: String) {
    let rep = bitmap()
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    drawBackground(title: "ПОРТАЛ БИЛЛА ШИФРА", subtitle: "вариант \(variant) · закрыть мячиками, шишками или водой")
    drawBill(center: NSPoint(x: 1240, y: 1725), scale: 1.0, variant: variant)
    rounded(NSRect(x: 300, y: 270, width: 1880, height: 250), radius: 22, fill: panel, stroke: mid, line: 6)
    drawText("Закройте портал", in: NSRect(x: 300, y: 342, width: 1880, height: 70), size: 48, bold: true)
    drawText("мячики, шишки или водяные пистолеты", in: NSRect(x: 300, y: 285, width: 1880, height: 60), size: 34)
    NSGraphicsContext.restoreGraphicsState()
    save(rep, outputPath)
}

func drawCard(_ rect: NSRect, text: String) {
    rounded(rect, radius: 28, fill: panel, stroke: dark, line: 9)
    let inner = rect.insetBy(dx: 34, dy: 34)
    rounded(inner, radius: 16, fill: NSColor(red: 0.941, green: 0.859, blue: 0.659, alpha: 0.55), stroke: mid, line: 4)
    triangle(NSPoint(x: rect.midX, y: rect.maxY - 150), size: 120, lineWidth: 7)
    drawText("СЕКРЕТНЫЙ ПАЗЛ", in: NSRect(x: rect.minX + 40, y: rect.maxY - 270, width: rect.width - 80, height: 70), size: 40, bold: true)
    drawText(text, in: NSRect(x: rect.minX + 70, y: rect.midY - 95, width: rect.width - 140, height: 190), size: 140, bold: true)
}

func renderCards(_ filename: String, _ texts: [String]) {
    let rep = bitmap()
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    paper.setFill()
    NSRect(x: 0, y: 0, width: width, height: height).fill()
    let sectionH = CGFloat(height) / 3
    let cardW: CGFloat = 2120
    let cardH: CGFloat = 930
    let cardX = (CGFloat(width) - cardW) / 2
    let cutLines = [sectionH, sectionH * 2]
    for cutY in cutLines {
        let path = NSBezierPath()
        path.move(to: NSPoint(x: 120, y: cutY))
        path.line(to: NSPoint(x: CGFloat(width) - 120, y: cutY))
        dark.withAlphaComponent(0.28).setStroke()
        path.lineWidth = 4
        path.setLineDash([28, 18], count: 2, phase: 0)
        path.stroke()
    }
    for (i, text) in texts.enumerated() {
        let sectionY = CGFloat(2 - i) * sectionH
        let cardY = sectionY + (sectionH - cardH) / 2
        drawCard(NSRect(x: cardX, y: cardY, width: cardW, height: cardH), text: text)
    }
    NSGraphicsContext.restoreGraphicsState()
    save(rep, filename)
}

for variant in 1...5 {
    let outputPath = "docs/portal_\(variant).png"
    renderPortal(variant, outputPath: outputPath)
}
renderCards("docs/answers_1_a4.png", ["7xxx", "8xxx", "9xxx"])
renderCards("docs/answers_2_a4.png", ["x6xx", "x7xx", "x8xx"])
renderCards("docs/answers_3_a4.png", ["xx3x", "xx4x", "xx5x"])
