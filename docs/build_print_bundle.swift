import AppKit
import CoreGraphics

struct PrintItem {
    let path: String
    let copies: Int
    let title: String
}

let outputPath = "docs/print_bundle.pdf"

let items: [PrintItem] = [
    PrintItem(path: "docs/map_gravity.png", copies: 10, title: "карта"),

    PrintItem(path: "docs/portal_1.png", copies: 2, title: "портал Билла, вариант 1"),
    PrintItem(path: "docs/portal_2.png", copies: 2, title: "портал Билла, вариант 2"),
    PrintItem(path: "docs/portal_3.png", copies: 2, title: "портал Билла, вариант 3"),
    PrintItem(path: "docs/portal_4.png", copies: 2, title: "портал Билла, вариант 4"),
    PrintItem(path: "docs/portal_5.png", copies: 2, title: "портал Билла, вариант 5"),

    PrintItem(path: "docs/secret_sheet.png", copies: 3, title: "зашифрованное сообщение"),
    PrintItem(path: "docs/key_sheet.png", copies: 3, title: "ключ к шифру"),

    PrintItem(path: "docs/answers_1_a4.png", copies: 2, title: "карточки ответов 1"),
    PrintItem(path: "docs/answers_2_a4.png", copies: 2, title: "карточки ответов 2"),
    PrintItem(path: "docs/answers_3_a4.png", copies: 2, title: "карточки ответов 3"),

    PrintItem(path: "docs/host_memo_a4.png", copies: 2, title: "памятка ведущего"),
    PrintItem(path: "docs/inventory_a4.png", copies: 2, title: "список инвентаря"),
    PrintItem(path: "docs/parents_a4.png", copies: 10, title: "задание для родителей"),
    PrintItem(path: "docs/assistant_memo_a4.png", copies: 2, title: "памятка помощнику"),
]

let pageWidth: CGFloat = 595.276
let pageHeight: CGFloat = 841.890
var mediaBox = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

guard let context = CGContext(URL(fileURLWithPath: outputPath) as CFURL, mediaBox: &mediaBox, nil) else {
    fatalError("Cannot create PDF: \(outputPath)")
}

var pageNumber = 0

for item in items {
    guard FileManager.default.fileExists(atPath: item.path) else {
        fatalError("Missing image: \(item.path)")
    }
    guard
        let image = NSImage(contentsOfFile: item.path),
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
    else {
        fatalError("Cannot load image: \(item.path)")
    }

    for _ in 0..<item.copies {
        pageNumber += 1
        context.beginPDFPage([
            kCGPDFContextMediaBox as String: NSData(bytes: &mediaBox, length: MemoryLayout<CGRect>.size)
        ] as CFDictionary)
        context.saveGState()
        context.draw(cgImage, in: mediaBox)
        context.restoreGState()
        context.endPDFPage()
    }
}

context.closePDF()

print("Created \(outputPath)")
print("Pages: \(pageNumber)")
for item in items {
    print("\(item.copies)x \(item.path) - \(item.title)")
}
