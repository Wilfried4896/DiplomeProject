
import Foundation
import Combine
import FirebaseAuth

protocol LoginService: AnyObject {
    func loginIn(with currentUser: CurrentLogin) -> AnyPublisher<Void, Error>
}

struct CurrentLogin {
    var email: String
    var password: String
}

class LoginServiceImp: LoginService {

    func loginIn(with currentUser: CurrentLogin) -> AnyPublisher<Void, Error> {
        
        Deferred {
            Future { promise in
                Auth.auth()
                    .signIn(withEmail: currentUser.email, password: currentUser.password) { resp, error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
