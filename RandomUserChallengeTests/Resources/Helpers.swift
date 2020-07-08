//
//  Helpers.swift
//  RandomUserChallengeTests
//
//  Created by Juanjo Corbalán on 08/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation

func decodeJSONFile<T: Codable>(named fileName: String) -> T? {
    let bundle = Bundle.init(for: MockCoreDataClient.self)
    let path = bundle.path(forResource: fileName, ofType: "json")!
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
    return try? JSONDecoder().decode(T.self, from: data)
}
