//
//  ClassListView.swift
//  DungeonsAndDragons
//
//  Created by Khateeb H. on 7/22/22.
//

import SwiftUI

struct ClassListView: View {
    @ObservedObject var viewModel:ClassListViewModel = ClassListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.dragonClasses, id: \.index) { dragonClass in
                    NavigationLink {
                        SpellsView(viewModel: SpellsViewModel(dragonClass: dragonClass))
                    } label: {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(dragonClass.name)
                                .font(.system(size: 14, weight: .semibold, design: .default))
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitle("Dragon Classes")
            .onAppear(perform: {
                viewModel.fetchDragonClasses()
            })
            .alert(isPresented: viewModel.isPresentingAlert, content: {
                Alert(title: Text("Error"),
                      message: Text(viewModel.activeError!.localizedDescription),
                      dismissButton: .cancel())
            })
        }
    }
}
