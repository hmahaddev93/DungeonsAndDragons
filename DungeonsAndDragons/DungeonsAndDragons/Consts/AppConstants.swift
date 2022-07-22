//
//  AppConstants.swift
//  DungeonsAndDragons
//
//  Created by Khateeb H. on 7/22/22.
//

import Foundation

enum AppConstants {
    enum DragonsAPI  {
        static let base: String = "https://www.dnd5eapi.co/api"
        enum EndPoints {
            static let classes = "/classes"
            static let spellsByClassIndex = "/classes/%@/spells"
            static let spellDetailByIndex = "/spells/%@"
        }
    }
}
