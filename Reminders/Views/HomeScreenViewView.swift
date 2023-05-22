//
//  HomeScreenView.swift
//  Reminders
//
//  Created by Imen Ksouri on 11/05/2023.
//

import SwiftUI

struct HomeScreenView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.isSearching) private var isSearching
    @State private var sortDescriptor: SortDescriptor = .dateCreated
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            Section {
                SearchView(searchText: $searchText)
                    .searchable(text: $searchText)
                if searchText.isEmpty {
                    SummaryView()
                    ReminderListView(sortDescriptor: $sortDescriptor)
                        .offset(x: 0, y: -20)
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

extension View {
    func navigationBarTitleTextColor(_ color: UIColor) -> some View {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: color ]
        return self
    }
}
