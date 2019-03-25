//
// Created by Gabriel Robinson on 2019-03-25.
// Copyright (c) 2019 CS4530. All rights reserved.
//

import UIKit

protocol NetworkDelegate: class {
    func _getLobby(status: GameStatus, results: Int?, offset: Int?)
}

// HTTP request methods supported
enum RequestMethods: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

// Used for getting the game lobby
enum GameStatus: String, Codable {
    case DONE = "DONE"  // Games that have finished
    case WAITING = "WAITING" // Games needing a second player
    case PLAYING = "PLAYING" // Games that are currently in progress
    case NONE = ""
}

// Used in order to specify the callback
enum RequestType {
    case BOARDS
    case TURN
    case GUESS
    case JOINGAME
    case NEWGAME
    case GAMEDETAIL
    case LOBBY
}

class GameRequests  {
    private static var baseEndpoint = "http://174.23.159.139:2142/api/"

    /**
     Parameters:
     - viewController: GameListViewController,  which allows the use of the lobby delegate protocol
     - status: GameStatus, used for filtering the content returned in the http response
     - results: Int, used for filtering the content returned in the http response
     - offset: Int, used for filtering the content returned in the http response

     Makes async request to the battlship server for the lobby/list of existing games. Sets the lobby for the list view controller
     */
    static func getLobby(viewController: GameListViewController, status: GameStatus = .NONE, results: Int? = nil, offset: Int? = nil) {
        var paramsAppended = false
        var params = "lobby"

        // Create url parameters
        if status != .NONE {
            params += "?status=" + status.rawValue
            paramsAppended = true
        }

        if let results = results {
            if paramsAppended {
                params += "&"
            } else {
                params += "?"
                paramsAppended = true
            }
            params += "results="  + String(results)
        }

        if let offset = offset {
            if paramsAppended {
                params += "&"
            } else {
                params += "?"
                paramsAppended = true
            }
            params += "offset="  + String(offset)
        }

        // Create url and begin request
        let url = URL(string: baseEndpoint + params)!
        let urlRequest = URLRequest(url: url)
        sendRequest(urlRequest, viewController, handleLobby)
    }

    /**
     Parameters:
     - viewController: GameListViewController,  which allows the use of the lobby delegate protocol
     - gameName: String, the name of the game
     - playerName: String, the name of the player

    Makes async request to battleship server for a new game and then calls a delegate to send the new game info to the list view controller.
    */
    static func getNewGame(viewController: GameListViewController, gameName: String, playerName: String) {
        // Create http body and url
        let httpBody =  "{\"gameName\":\"\(gameName)\",\"playerName\":\"\(playerName)\"}"
        let urlStr = baseEndpoint + "lobby"

        // create url and url request objects
        let url = URL(string: urlStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = RequestMethods.POST.rawValue
        urlRequest.httpBody = httpBody.data(using: .utf8)
        sendRequest(urlRequest, viewController, handleNewGame)
    }

    /**
     Parameters:
     - viewController: GameListViewController,  which allows the use of the lobby delegate protocol
     - gameId: String, identifies the game that is being queried

     Makes async request to the battlship server for the details of a game with the specified guid
     */
    static func getGameDetails(viewController: GameListViewController, gameId: String) {
        // Create http body and url
        let urlStr = baseEndpoint + "lobby/\(gameId)"
        // create url and url request objects
        let url = URL(string: urlStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = RequestMethods.GET.rawValue
        sendRequest(urlRequest, viewController, handleGameDetails)

    }

    /**
     Parameters:
     - viewController: GameListViewController,  which allows the use of the lobby delegate protocol
     - withId: String, guid of the game associated with the game board
     - playerId: String, the id of the player making the request. This player must belong to the game otherwise
     the request will fail.

     Makes async request to the battlship server for the lobby/list of existing games. Sets the lobby for the list view controller
     */
    static func getNewGameBoards(viewController: BattleShipViewController, withId: String, playerId: String) {
        // Create http body and url
        let urlStr = baseEndpoint + "lobby/\(withId)/boards?playerId=\(playerId)"
        // create url and url request objects
        let url = URL(string: urlStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = RequestMethods.GET.rawValue
        sendRequest(urlRequest, viewController, handleGameDetails)
    }

    /**
     Parameters:
     - viewController: GameListViewController,  which allows the use of the lobby delegate protocol
     - status: GameStatus, used for filtering the content returned in the http response
     - results: Int, used for filtering the content returned in the http response
     - offset: Int, used for filtering the content returned in the http response

     Makes async request to the battlship server for the lobby/list of existing games. Sets the lobby for the list view controller
     */
    private static func sendRequest(_ urlReq: URLRequest, _ viewController: UIViewController, _ responseHandler: @escaping (Data, UIViewController)->Void) {
        let task = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in

            // Check for error. If an error exists print out the message and return.
            // else continue
            guard let data = data else {

                print(error.debugDescription)
                return

            }

            // Parse json
            responseHandler(data, viewController)
        }
        task.resume()
    }

    /**
     Parameters:
     - viewController: GameListViewController,  which allows the use of the lobby delegate protocol
     - status: GameStatus, used for filtering the content returned in the http response
     - results: Int, used for filtering the content returned in the http response
     - offset: Int, used for filtering the content returned in the http response

     Makes async request to the battlship server for the lobby/list of existing games. Sets the lobby for the list view controller
     */
    private static func handleLobby(data: Data, viewController: UIViewController) {
        do {

            let decoder = JSONDecoder()
            let lobbyInfo = try decoder.decode( [LobbyItem].self, from: data)

            guard let gameListViewController = viewController as? GameListViewController else {
                print("Error while attempting to cast the view controller as GameListViewController")
                return
            }

            DispatchQueue.main.async { gameListViewController.setList(lobby: lobbyInfo) }


        }  catch let error {

            print(error.localizedDescription)

        }
    }

    /**
     Parameters:
     - viewController: GameListViewController,  which allows the use of the lobby delegate protocol
     - status: GameStatus, used for filtering the content returned in the http response
     - results: Int, used for filtering the content returned in the http response
     - offset: Int, used for filtering the content returned in the http response

     Makes async request to the battlship server for the lobby/list of existing games. Sets the lobby for the list view controller
     */
    private static func handleNewGame(data: Data, viewController: UIViewController) {
        do {

            let decoder = JSONDecoder()
            let newGameItem = try decoder.decode( NewGameItem.self, from: data)

            guard let gameListViewController = viewController as? GameListViewController else {
                print("Error while attempting to cast the view controller as GameListViewController")
                return
            }

            DispatchQueue.main.async { gameListViewController.setNewGame(newGameInfo: newGameItem) }

        }  catch let error {

            print(error.localizedDescription)

        }
    }

    /**
     Parameters:
     - viewController: GameListViewController,  which allows the use of the lobby delegate protocol
     - status: GameStatus, used for filtering the content returned in the http response
     - results: Int, used for filtering the content returned in the http response
     - offset: Int, used for filtering the content returned in the http response

     Makes async request to the battlship server for the lobby/list of existing games. Sets the lobby for the list view controller
     */
    private static func handleGameDetails(data: Data, viewController: UIViewController) {
        do {

            let decoder = JSONDecoder()
            let gameDetailsItem = try decoder.decode( GameDetailsItem.self, from: data)

            guard let gameListViewController = viewController as? GameListViewController else {
                print("Error while attempting to cast the view controller as GameListViewController")
                return
            }

            DispatchQueue.main.async { gameListViewController.setGameDetails(gameDetailsInfo: gameDetailsItem) }

        }  catch let error {

            print(error.localizedDescription)

        }
    }

    /**
     Parameters:
     - viewController: GameListViewController,  which allows the use of the lobby delegate protocol
     - status: GameStatus, used for filtering the content returned in the http response
     - results: Int, used for filtering the content returned in the http response
     - offset: Int, used for filtering the content returned in the http response

     Makes async request to the battlship server for the lobby/list of existing games. Sets the lobby for the list view controller
     */
    private static func handleBoard(data: Data, viewController: UIViewController) {
        do {

            let decoder = JSONDecoder()
            let gameDetailsItem = try decoder.decode( GameDetailsItem.self, from: data)

            guard let gameListViewController = viewController as? GameListViewController else {
                print("Error while attempting to cast the view controller as GameListViewController")
                return
            }

            DispatchQueue.main.async { gameListViewController.setGameDetails(gameDetailsInfo: gameDetailsItem) }

        }  catch let error {

            print(error.localizedDescription)

        }
    }
}