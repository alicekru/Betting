
import Foundation

enum Role {
    case admin
    case regular
}
enum State {
    case logined
    case logout
    case banned
    case undefined
}
class User {
    let username: String
    let password: String
    let role: Role
    var state: State = .logout
    init(username: String, password: String, role: Role) {
        self.username = username
        self.password = password
        self.role = role
    }
   
}

protocol Identifiable {
    associatedtype ID: Hashable
    var id: ID {get}
}

struct DataBaseUser{
    var allUsers: [User] = []
    var bets: [String: [String]] = [:]
    
    
    func checkUserNameAlreadyExist(newUserName: String) -> Bool {

        let isUnique = allUsers.contains { (user) -> Bool in
            user.username == newUserName
        }
        return isUnique
    }
    func stateUser(username: String) -> State {
        
        var userState: State = .undefined
        allUsers.forEach { (user) in
            if user.username == username {
                userState = user.state
            }
        }
        return userState
    }
    
    func changeState(username: String, state: State) {
        for user in allUsers {
            if user.username == username {
                user.state = state
            }
        }
    }
    func checkData(username: String, password: String) -> Bool {
        for user in allUsers {
            if user.username == username && user.password == password {
                return true
            }
        }
        return false
    }
    func showBets(username: String) -> [String] {
        var betsUser = [""]
        bets.forEach {
            if $0 == username {
                betsUser = $1
            }
        }
        return betsUser
    }
    
    
}

class SimpleBetting {
    var storage = DataBaseUser()

    func registrate(username: String, password: String, role: Role) {
        if storage.checkUserNameAlreadyExist(newUserName: username) {
            print("AlreadyExist")
        }
        else {
            let newUser = User(username: username, password: password, role: role)
            storage.allUsers.append(newUser)
            print("AddNew \(username)")
        }
    }
    func login(username: String, password: String) {
        let userState = storage.stateUser(username: username)
            switch userState {
            case .undefined: print("I don't understand")
            case .logined: print("You have already logined")
            case .banned: print("You have already banned")
            case .logout:
                let dataValid = storage.checkData(username: username, password: password)
                if dataValid {
                    storage.changeState(username: username, state: .logined)
                    print("Successful logined \(username)")
                }
            }
        
    }
    func logout(username: String) {
        let userState = storage.stateUser(username: username)
            switch userState {
            case .undefined: print("I don't understand")
            case .logout: print("You have already logout")
            case .banned: print("You have already banned")
            case .logined:
                    storage.changeState(username: username, state: .logout)
                    print("Successful logout")
            }
        }
    func take(bet: String, from username: String) {
        for user in storage.allUsers {
            if user.username == username && user.state == .logined  && user.role == .regular {
                let newBet = bet
                if storage.bets[username] == nil {
                    storage.bets[username]? = [bet]
                }
                else {
                    storage.bets[username]?.append(newBet)
                    print("Bet Taking")
                }
            }
            else {
                print("You can't place bet")
            }
            
        }
    }
    func showAllUsers(to adminUserName: String) {

        for user in storage.allUsers {
            if user.role == .admin && user.username == adminUserName && user.state == .logined {
                storage.allUsers.forEach { (user) in
                    if user.role == .regular {
                        print("Regular user \(user.username)")
                    }
                }
            }
        }
    }
    func banUser(username: String, adminUserName: String ) {
        for user in storage.allUsers {
            if user.role == .admin && user.username == adminUserName && user.state == .logined {
                if storage.allUsers.contains(where: {$0.username == username}) {
                    storage.changeState(username: username, state: .banned)
                    print("Baaaaan")
                    
                }
            }
        }
}
    func showBets(to username: String) {
        for user in storage.allUsers {
            if user.username == username && user.state == .logined  && user.role == .regular {
                storage.showBets(username: username).forEach {
                    print($0)
                }
            }
        }
    }
}




let dataBase = DataBaseUser()
let system = SimpleBetting()
let user = User(username: "Alice", password: "123445", role: .admin)
let user1 = User(username: "Alice", password: "123445", role: .admin)

dataBase.checkUserNameAlreadyExist(newUserName: user.username)
dataBase.checkUserNameAlreadyExist(newUserName: user1.username)

system.registrate(username: "Alice", password: "12", role: .regular)
system.registrate(username: "Alice", password: "12", role: .regular)

system.login(username: "Alice", password: "12")
system.logout(username: "Alice")
system.logout(username: "Alice")

system.take(bet: "neeeew", from: "Alice")


system.registrate(username: "Ali", password: "1290", role: .regular)
system.registrate(username: "ce", password: "120987", role: .regular)
system.login(username: "Alice", password: "12")


system.registrate(username: "Den", password: "987", role: .admin)

system.login(username: "Den", password: "987")

system.showAllUsers(to: "Den")

system.registrate(username: "poiu", password: "120-9", role: .regular)
system.login(username: "poiu", password: "120-9")

//system.banUser(username: "poiu", adminUserName: "Den")
//system.login(username: "poiu", password: "120-9")
system.take(bet: "neeeew", from: "poiu")

system.showBets(to: "poiu")
system.storage.bets["poiu"]





























