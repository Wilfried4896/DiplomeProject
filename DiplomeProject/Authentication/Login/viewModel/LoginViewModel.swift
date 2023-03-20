
import Foundation
import Combine


class LoginViewModel {
    
    enum State {
        case loading
        case success
        case failed(error: Error)
        case none
    }
    
    var cancelled = Set<AnyCancellable>()
    
    @Published var emailPush = ""
    @Published var passwordPush = ""
    @Published var state: State = .none
    
    var isEmailValidedPublisher: AnyPublisher<Bool, Never> {
         $emailPush
            .map { _email in
                _email.isValidEmail
            }
            .eraseToAnyPublisher()
    }
    
    var isPasswordValidedPublisher: AnyPublisher<Bool, Never> {
         $passwordPush
            .map { _password in
                _password.count >= 6
            }
            .eraseToAnyPublisher()
    }
    
    var isSubmit: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isEmailValidedPublisher, isPasswordValidedPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    func loginIn() {
        let current = CurrentLogin(email: emailPush, password: passwordPush)
        
        LoginServiceImp()
            .loginIn(with: current)
            .sink { resp in
                switch resp {
                case .failure(let error):
                    self.state = .failed(error: error)
                default:
                    break
                }
            } receiveValue: { _ in
                self.state = .success
            }
            .store(in: &cancelled)
    }
}
