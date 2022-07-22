//
//  SpellsView.swift
//  DungeonsAndDragons
//
//  Created by Khateeb H. on 7/22/22.
//

import SwiftUI

struct SpellsView: View {
    @StateObject var viewModel:SpellsViewModel
    var body: some View {
        ZStack(alignment: .center){
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.gray)
                .isHidden(!viewModel.isLoadingData)
            List {
                ForEach(viewModel.spells, id: \.index) { spell in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(spell.name)
                            .font(.system(size: 14, weight: .semibold, design: .default))
                        Text(spell.desc?.joined(separator: "\n") ?? "")
                            .font(.system(size: 12, weight: .regular, design: .default))
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationBarTitle(viewModel.dragonClass.name)
        .onAppear(perform: {
            viewModel.fetchSpells()
        })
        .alert(isPresented: viewModel.isPresentingAlert, content: {
            Alert(title: Text("Error"),
                  message: Text(viewModel.activeError!.localizedDescription),
                  dismissButton: .cancel())
        })
    }
}

extension View {
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}

