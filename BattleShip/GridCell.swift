//
//  BattleShipCell.swift
//  BattleShip
//
//  Created by Gabriel Robinson on 2/24/19.
//  Copyright © 2019 CS4530. All rights reserved.
//
import UIKit

enum CellStatus: Int, Codable {
    case NOTFIREDAT = 0
    case HIT = 1
    case MISS = 2
    case ERROR = 3
}

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
