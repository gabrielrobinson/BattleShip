//
// Created by Gabriel Robinson on 2019-03-25.
// Copyright (c) 2019 CS4530. All rights reserved.
//


import Foundation


struct LobbyItem: Codable {
    var id: String
    var name: String
    var status: GameStatus
}

struct NewGameItem: Codable {
    var playerId: String
    var gameId: String
}

struct GameDetailsItem: Codable {
    var id: String
    var name : String
    var player1: String
    var player2: String
    var winner: String
    var status: GameStatus
    var missilesLaunched: Int
}

struct Cell: Codable {
    var xPos: Int
    var yPos: Int
    var status: CellStatus
}

struct Board: Codable {
    var playerBoard: [Cell]
    var opponentBoard: [Cell]
}

enum CellStatus: String, Codable {
    case HIT = "HIT"
    case MISS = "MISS"
    case NONE = "NONE"
}

struct QueryHIt: Codable {
    var hit: Bool
    var shipSunk: Int
}

struct QueryTurn: Codable {
    var isYourTurn: Bool
    var winner: String
}