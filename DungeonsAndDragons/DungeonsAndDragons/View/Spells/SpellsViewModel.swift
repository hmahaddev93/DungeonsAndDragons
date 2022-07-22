//
//  SpellsViewModel.swift
//  DungeonsAndDragons
//
//  Created by Khateeb H. on 7/22/22.
//

import SwiftUI
import Combine

@MainActor
final class SpellsViewModel: ObservableObject {
    var dragonClass: DragonClass
    @Published var spells:[DragonSpellDetail] = []
    @Published var activeError: Error?
    @Published var isLoadingData: Bool = false
    
    init(dragonClass: DragonClass) {
        self.dragonClass = dragonClass
    }
    
    var isPresentingAlert: Binding<Bool> {
        return Binding<Bool>(
            get: {
            return self.activeError != nil
        }, set: { newValue in
            guard !newValue else { return }
            self.activeError = nil
        })
    }
        
    func fetchSpells() {
        isLoadingData = true
        Task {
            do {
                self.spells = try await DragonService.shared.getSpells(by: dragonClass.index)
                isLoadingData = false
            } catch {
                self.activeError = error
                self.spells = []
                isLoadingData = false
            }
        }
    }
}
