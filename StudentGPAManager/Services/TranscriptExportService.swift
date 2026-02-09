import Foundation
import UIKit

final class TranscriptExportService {
    struct ExportResult {
        let url: URL
    }

    func exportTranscript(profile: UserProfile, semesters: [Semester]) throws -> ExportResult {
        let fileName = "Transcript-\(UUID().uuidString).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        try renderer.writePDF(to: url) { context in
            context.beginPage()

            let titleFont = UIFont.boldSystemFont(ofSize: 22)
            let headerFont = UIFont.boldSystemFont(ofSize: 16)
            let bodyFont = UIFont.systemFont(ofSize: 12)

            var cursorY: CGFloat = 36
            let margin: CGFloat = 36
            let lineHeight: CGFloat = 18

            func drawLine(_ text: String, font: UIFont) {
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: UIColor.label
                ]
                let attributed = NSAttributedString(string: text, attributes: attributes)
                let rect = CGRect(x: margin, y: cursorY, width: pageRect.width - margin * 2, height: lineHeight)
                attributed.draw(in: rect)
                cursorY += lineHeight
            }

            func ensureSpace() {
                if cursorY + lineHeight > pageRect.height - margin {
                    context.beginPage()
                    cursorY = margin
                }
            }

            drawLine("Student Transcript", font: titleFont)
            cursorY += 6

            drawLine("Name: \(profile.name)", font: bodyFont)
            drawLine("Age: \(profile.age)", font: bodyFont)
            drawLine("Nationality: \(profile.nationality)", font: bodyFont)
            drawLine("Gender: \(profile.gender)", font: bodyFont)
            drawLine("University: \(profile.university)", font: bodyFont)
            cursorY += 12

            for semester in semesters {
                ensureSpace()
                drawLine("Semester: \(semester.name)", font: headerFont)

                if semester.courses.isEmpty {
                    drawLine("No courses", font: bodyFont)
                    cursorY += 6
                    continue
                }

                for course in semester.courses {
                    ensureSpace()
                    let line = "- \(course.name) | Credits: \(course.credits) | Grade: \(String(format: "%.2f", course.grade))"
                    drawLine(line, font: bodyFont)
                }

                cursorY += 8
            }
        }

        return ExportResult(url: url)
    }
}
