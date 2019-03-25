//
// Created by Gabriel Robinson on 2019-03-25.
// Copyright (c) 2019 CS4530. All rights reserved.
//

import Foundation

protocol LobbyDelegate {
    func setList(lobby: [LobbyItem])
    func setNewGame(newGameInfo: NewGameItem)
    func setGameDetails(gameDetailsInfo: GameDetailsItem)
}