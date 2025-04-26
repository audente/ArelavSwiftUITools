import PDFKit

public extension URL {
    var textFromPDF: String? {
        guard let pdf = PDFDocument(url: self) else {
            print("!! Can't read text from PDF File: Invalid URL")
            return nil
        }
        
        var text = ""
        for i in 0..<pdf.pageCount {
            guard let page = pdf.page(at: i) else {
                print("!! Couldn't read page #\(i)")
                continue
            }
            guard let pageText = page.string else {
                print("!! Couldn't extract text from page #\(i)")
                continue
            }
            text += pageText
        }
        
        return text
    }

}
