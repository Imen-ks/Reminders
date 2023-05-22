//
//  FlagView.swift
//  Reminders
//
//  Created by Imen Ksouri on 13/05/2023.
//

import SwiftUI

struct FlagView: View {
    @Binding var isFlagging: Bool

    var body: some View {
        Section {
            HStack {
                Toggle(isOn: $isFlagging) {
                    HStack {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.white)
                            .padding(5)
                            .background {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(.orange)
                            }
                        Text("Flag")
                        .padding(.leading, 8)
                    }
                }
            }
        }
        .padding(.vertical, 5)
        .listRowInsets(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
    }
}

struct FlagView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            FlagView(isFlagging: .constant(true))
        }
    }
}
