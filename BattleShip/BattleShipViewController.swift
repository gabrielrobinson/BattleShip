//
//  BattleShipViewController.swift
//  BattleShip
//
//  Created by Gabriel Robinson on 2/25/19.
//  Copyright © 2019 CS4530. All rights reserved.
//
import UIKit

var navigationBarHeight: CGFloat?

//func generateGrid()->[[GridCell]] {
//    var grid = [[GridCell]].init()
//    for _ in 0...9 {
//        var row = [GridCell].init()
//        for _ in 0...9 {
//            row.append(GridCell())
//        }
//        grid.append(row)
//    }
//    return grid
//}
class BattleShipViewController: UIViewController {

    private var firstPlayerView: BattleShipView?

    private var firstPlayerGrid: [[GridCell]]?
    private var secondPlayerGrid: [[GridCell]]?

    private var firstPlayerShipCoords: [String: Int]?
    private var secondPlayerShipCoords: [String: Int]?

    private var currentGameItem: NewGameItem?

    init(gameInfo: NewGameItem) {
        self.currentGameItem = gameInfo
        GameRequests.getNewGameBoards(withId: gameInfo.gameId, playerId: gameInfo.playerId)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Game List ⚓", style: UIBarButtonItem.Style.plain, target: self, action: #selector(BattleShipViewController.popToRoot))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationBarHeight = (self.navigationController?.navigationBar.frame.size.height)!
    }


    /**
        Returns back to the list view controller
    */
    @objc func popToRoot() {
        currentGameItem = nil
        _ = navigationController?.popToRootViewController(animated: true)
    }

}