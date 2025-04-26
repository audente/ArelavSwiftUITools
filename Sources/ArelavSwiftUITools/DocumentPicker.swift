import SwiftUI

import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

public struct DocumentPicker: UIViewControllerRepresentable {
    public typealias UIViewControllerType = UIDocumentPickerViewController
    
    let allowedContentTypes: [UTType]
    let onPicked: ([URL]) -> Void
    
    public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: allowedContentTypes)
        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = context.coordinator
        return documentPicker
    }
    
    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(onPicked: onPicked)
    }
    
    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPicked: ([URL]) -> Void
        
        public init(onPicked: @escaping ([URL]) -> Void) {
            self.onPicked = onPicked
        }
        
        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onPicked(urls)
        }
        
        public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}
    }
}


public struct TestDocumentPicker: View {
    @State private var fileURL: [URL]?
    @State private var isDocumentPickerPresented = false
    
    public var body: some View {
        VStack {
            if let fileURL = fileURL {
                Text("Selected: \(fileURL.count) files")
            } else {
                Button("Select PDF file") {
                    isDocumentPickerPresented.toggle()
                }
                .sheet(isPresented: $isDocumentPickerPresented, onDismiss: loadSelectedFile) {
                    DocumentPicker(allowedContentTypes: [UTType.pdf], onPicked: handlePickedDocuments)
                }
            }
        }
    }
    
    public func handlePickedDocuments(urls: [URL]) {
        fileURL = urls
        loadSelectedFile()
    }
    
    public func loadSelectedFile() {
        let fileManager = FileManager.default
        
        guard let fileURL = fileURL else { return }
        // Here you can handle the selected file URL, for example, by displaying it in a label or loading it in a web view.
        let _ = fileURL.map { url in
            print("\(url.absoluteString)")
            if fileManager.fileExists(atPath: url.path) {
                print("FILE exists")
                print("TEXT: \(String(describing: url.textFromPDF))")

            } else {
                print("FILE does not exist")
            }
        }
    }
}

struct DocumentPicker_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            TestDocumentPicker().preferredColorScheme(.dark)    
            TestDocumentPicker().preferredColorScheme(.light)    
        }
        
    }
}
