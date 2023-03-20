
import Foundation
import Combine
import FirebaseAuth

protocol RegisterService: AnyObject {
    func register(with currentUser: CurrentUser) -> AnyPublisher<Void, Error>
}

struct CurrentUser {
    var name: String
    var occuption: String
    var password: String
    var email: String
    var profileImage = Data()
}

class RegisterServiceImp: RegisterService {
    
    func register(with currentUser: CurrentUser) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth.auth()
                    .createUser(withEmail: currentUser.email, password: currentUser.password){ resp, error in
                        if let error = error {
                            promise(.failure(error))
                        }
                        if let uid = resp?.user.uid {
                            CoreDataManager.shared.createAccount(uid, currentUser.name, currentUser.occuption, currentUser.profileImage)
                            }
                        else {
                            promise(.failure(NSError(domain: "Invalide", code: 0, userInfo: nil)))
                        }

                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}
