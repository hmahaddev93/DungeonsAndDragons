//
//  DragonService.swift
//  DungeonsAndDragons
//
//  Created by Khateeb H. on 7/22/22.
//

import Foundation
import Combine

protocol DragonService_Protocol {
    func getClasses() async throws -> [DragonClass]
}

final class DragonService: DragonService_Protocol {
    
    static let shared: DragonService = DragonService()
    private let jsonDecoder: JSONDecoder
    
    init() {
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    enum DragonServiceError: Error {
        case invalidURL
    }
    
    struct DragonClassResponseBody: Codable {
        let results: [DragonClass]
    }
    
    struct DragonSpellResponseBody: Codable {
        let results: [DragonSpell]
    }
    
    func getClasses() async throws -> [DragonClass] {
        guard let url = URL(string: AppConstants.DragonsAPI.base +
                            AppConstants.DragonsAPI.EndPoints.classes) else {
            throw DragonServiceError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let responseBody = try self.jsonDecoder.decode(DragonClassResponseBody.self, from: data)
        return responseBody.results
    }
    
    func getSpells(by classIndex: String) async throws -> [DragonSpellDetail] {
        guard let url = URL(string: String(format: AppConstants.DragonsAPI.base + AppConstants.DragonsAPI.EndPoints.spellsByClassIndex, classIndex)) else {
            throw DragonServiceError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let responseBody = try self.jsonDecoder.decode(DragonSpellResponseBody.self, from: data)
        
        var spellsDetails: [DragonSpellDetail] = []
        for spell in responseBody.results {
            async let spellDetail = getSpellDetails(by: spell.index)
            spellsDetails += [try await spellDetail]
        }
        
        print(spellsDetails)
        
        return spellsDetails
    }
    
    func getSpellDetails(by spellIndex: String) async throws -> DragonSpellDetail {
        guard let url = URL(string: String(format: AppConstants.DragonsAPI.base + AppConstants.DragonsAPI.EndPoints.spellDetailByIndex, spellIndex)) else {
            throw DragonServiceError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let spellDetail = try self.jsonDecoder.decode(DragonSpellDetail.self, from: data)
        return spellDetail
    }
    
    
    
}
