//
//  CreateListTitleView.swift
//  Reminders
//
//  Created by Imen Ksouri on 12/05/2023.
//

import SwiftUI

struct CreateListTitleView: View {
    @Binding var listTitle: String
    @Binding var selectedColor: Color

    var body: some View {
        VStack {
            Image(systemName: "list.bullet")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
                .padding(25)
                .background(selectedColor)
                .clipShape(Circle())

            ListTextFieldView(listTitle: $listTitle, selectedColor: $selectedColor)
        }
    }
}

struct CreateListTitleView_Previews: PreviewProvider {
    @State static var selectedColor: Color = .blue
    static var previews: some View {
        Form {
            CreateListTitleView(listTitle: .constant(""), selectedColor: $selectedColor)
        }
    }
}
