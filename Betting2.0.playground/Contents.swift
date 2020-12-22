import Foundation

enum Role {
    case admin
    case regular
}

struct User {

    let username: String
    let password: String
    let isBanned: Bool
    let role: Role

    init(username: String, password: String, isBanned: Bool, role: Role) {
        self.username = username
        self.password = password
        self.isBanned = isBanned
        self.role = role
    }
}

struct Bet {
    let name: String
    let username: String
}

class DataBaseUser {

    private var users: [User] = []
    private var bets: [Bet] = []
    var currentUser: User?

    func addUser(_ user: User) {
        users.append(user)
    }

    func addBet(_ bet: Bet) {
        bets.append(bet)
    }

    func contains(user: User) -> Bool {
        users.contains(where: { $0.username == user.username })
    }

    func deleteUser(username: String) {
        users.removeAll(where: { $0.username == username })
    }
    
    func getUsers() -> [User] {
        users
    }
    
    func getBets() -> [Bet] {
        bets
    }
}

class AdminBetting {
    
    private let storage: DataBaseUser

    init(storage: DataBaseUser) {
        self.storage = storage
    }
    
    func showUsers() -> [String] {
        return storage.getUsers().map({ $0.username })
    }

    func banUser(username: String) -> Bool {
        if let user = storage.getUsers().first(where: { $0.username == username }) {
            storage.deleteUser(username: username)
            storage.addUser(User(
                                username: user.username,
                                password: user.password,
                                isBanned: true,
                                role: user.role))
            return true
        } else {
            return false
        }
    }
}

class UserBetting {
    
    private let storage: DataBaseUser

    init(storage: DataBaseUser) {
        self.storage = storage
    }
    
    func addBet(_ name: String) {
        guard let username = storage.currentUser?.username else { return }
        let bet = Bet(name: name, username: username)
        storage.addBet(bet)
    }

    func showBets() -> [Bet] {
        if let user = storage.currentUser {
            return storage.getBets().filter({ $0.username == user.username })
        } else {
            return []
        }
    }
}

class SimpleBetting {

    private let storage: DataBaseUser

    init(storage: DataBaseUser) {
        self.storage = storage
    }

    func registrate(user: User) -> Bool {
        guard !storage.contains(user: user) else { return false }
        storage.addUser(user)
        storage.currentUser = user
        return true
    }

    func login(user: User) -> Bool {
        guard
            let user1 = storage.getUsers().first(where: { $0.username == user.username }),
            !user1.isBanned else {
            return false
        }

        storage.currentUser = user
        return true
    }

    func logout() {
        storage.currentUser = nil
    }
}





func testRegularFlow() {
    let dataBase = DataBaseUser()
    let system = SimpleBetting(storage: dataBase)
    let regular = User(username: "Aliceeee", password: "12345", isBanned: false, role: .regular)
    let regular1 = User(username: "Aliceeee", password: "1", isBanned: false, role: .regular)

    system.registrate(user: regular)

    system.logout()
    
    if system.login(user: regular) {
        let userBetting = UserBetting(storage: dataBase)
        userBetting.addBet("Djokovic win")
        userBetting.addBet("Barselona Lose")
        userBetting.showBets()
    }
    
    system.logout()
    system.registrate(user: regular)
    system.registrate(user: regular1)
}

func testAdminFlow() {
    let dataBase = DataBaseUser()
    let system = SimpleBetting(storage: dataBase)
    let admin = User(username: "Alice", password: "123445", isBanned: false, role: .admin)
    let regular = User(username: "Mark", password: "12345", isBanned: false, role: .regular)
    let regular2 = User(username: "Sasha", password: "145", isBanned: false, role: .regular)

    system.registrate(user: admin)
    system.registrate(user: regular)
    system.registrate(user: regular2)
    
    if system.login(user: admin) {
        let adminBetting = AdminBetting(storage: dataBase)
        adminBetting.showUsers()
        adminBetting.banUser(username: regular.username)
        adminBetting.banUser(username: "Andy")
        adminBetting.showUsers()
        system.login(user: regular)
    }
    
}

testRegularFlow()
testAdminFlow()































