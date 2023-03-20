
import Foundation
import Combine


class RegisterViewModel {
    
    enum State {
        case loading
        case success
        case failed
        case none
    }
    
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var occupation = ""
    @Published var state: State = .none
    
    var isEmail: AnyPublisher<Bool, Never> {
        $email
            .map { $0.isValidEmail }
            .eraseToAnyPublisher()
    }
    
    var isPassword: AnyPublisher<Bool, Never> {
        $password
            .map { $0.count >= 8}
            .eraseToAnyPublisher()
    }
    
    var isName: AnyPublisher<Bool, Never> {
        $name
            .map { !$0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    var isOccupation: AnyPublisher<Bool, Never> {
        $occupation
        .map { !$0.isEmpty}
        .eraseToAnyPublisher()
    }
    
    var isSubmit: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(isEmail, isPassword, isName, isOccupation)
            .map { $0 && $1 && $2 && $3 }
            .eraseToAnyPublisher()
    }
    
    func register() {
        
    }

}
