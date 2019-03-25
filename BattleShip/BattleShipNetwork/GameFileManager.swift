//
// Created by Gabriel Robinson on 2019-03-25.
// Copyright (c) 2019 CS4530. All rights reserved.
//

import Foundation

class GameFileManager {

    static func write(newGameItems: [String: NewGameItem]) {
        let encoder = JSONEncoder()
        let jsonData  = try? encoder.encode(newGameItems)
        writeData(jsonData, Constants.NewGameFile)
    }

    static func write(gameDetailsItems: [String: GameDetailsItem]) {
        let encoder = JSONEncoder()
        let jsonData  = try? encoder.encode(gameDetailsItems)
        writeData(jsonData, Constants.GameDetailsFile)
    }

    private static func writeData(_ jsonData: Data?, _ fileName: String) {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        try! jsonData?.write(to: docDirectory.appendingPathComponent(fileName))
    }

    static func readGameData() {

    }
}