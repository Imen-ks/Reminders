//
//  HomeScreenView.swift
//  Reminders
//
//  Created by Imen Ksouri on 11/05/2023.
//

import SwiftUI

struct HomeScreenView: View {
    @Environment(\.isSearching) private var isSearching
    @StateObject var viewModel = SummaryViewModel()

    var body: some View {
        NavigationStack {
            Section {
                SearchView(viewModel: viewModel)
                    .searchable(text: $viewModel.searchText)
                if viewModel.searchText.isEmpty {
                    SummaryView(viewModel: viewModel)
                    ReminderListView()
                        .offset(x: 0, y: -20)
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView(viewModel: SummaryViewModel(dataManager: .preview))
    }
}

extension View {
    func navigationBarTitleTextColor(_ color: UIColor) -> some View {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: color ]
        return self
    }
}
