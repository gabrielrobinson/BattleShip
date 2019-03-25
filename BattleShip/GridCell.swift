//
//  BattleShipCell.swift
//  BattleShip
//
//  Created by Gabriel Robinson on 2/24/19.
//  Copyright © 2019 CS4530. All rights reserved.
//
import UIKit

class GridCell: Codable {
    private var cellStatus: CellStatus

    init() {
        self.cellStatus = CellStatus.NOTFIREDAT
    }

    init(status: CellStatus) {
        self.cellStatus = status
    }

    func getStatus()->CellStatus {
        return self.cellStatus
    }

    func setCellStatus(status: CellStatus) {
        self.cellStatus = status
    }
}