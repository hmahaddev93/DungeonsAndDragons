//
//  ClassListViewModel.swift
//  DungeonsAndDragons
//
//  Created by Khateeb H. on 7/22/22.
//

import SwiftUI
import Combine

@MainActor
final class ClassListViewModel: ObservableObject {
    @Published var dragonClasses:[DragonClass] = []
    @Published var activeError: Error?
    
    var isPresentingAlert: Binding<Bool> {
        return Binding<Bool>(
            get: {
            return self.activeError != nil
        }, set: { newValue in
            guard !newValue else { return }
            self.activeError = nil
        })
    }
        
    func fetchDragonClasses() {
        Task {
            do {
                self.dragonClasses = try await DragonService.shared.getClasses()
            } catch {
                self.activeError = error
                self.dragonClasses = []
            }
        }
    }
}
