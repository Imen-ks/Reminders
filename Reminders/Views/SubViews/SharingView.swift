//
//  SharingView.swift
//  Reminders
//
//  Created by Imen Ksouri on 21/05/2023.
//

import SwiftUI

struct SharingView: View {
    var render: URL

    var body: some View {
        ShareLink("", item: render)
    }
}

struct SharingView_Previews: PreviewProvider {
    static var previews: some View {
        SharingView(render: render(view: Text("Hello, World"), path: "output.pdf"))
    }
}

@MainActor
func render(view: any View, path: String) -> URL {
    let renderer = ImageRenderer(content: AnyView(view))
    let url = URL.documentsDirectory.appending(path: path)

    renderer.render { size, context in
        var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
            return
        }
        pdf.beginPDFPage(nil)
        context(pdf)
        pdf.endPDFPage()
        pdf.closePDF()
    }

    return url
}
