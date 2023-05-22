//
//  SelectTagView.swift
//  Reminders
//
//  Created by Imen Ksouri on 13/05/2023.
//

import SwiftUI

struct SelectTagView: View {
    @Binding var tags: String

    var body: some View {
        NavigationLink {
            Text("Not implemented")
        } label: {
            HStack {
                Image(systemName: "number")
                    .foregroundColor(.white)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.gray)
                    }
                Text("Tags")
                    .padding(.leading, 8)
            }
        }
        .padding(.vertical, 5)
        .listRowInsets(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
    }
}

struct SelectTagView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Form {
                SelectTagView(tags: .constant(""))
            }
        }
    }
}
