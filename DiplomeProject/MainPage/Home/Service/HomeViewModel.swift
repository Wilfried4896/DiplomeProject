
import Foundation
import Combine

class HomeViewModel {
    
    enum State {
        case loading
        case success(articles: [Articles])
        case failed(error: Error)
        case none
    }
    
    enum StateImag {
        case loading
        case success
        case failed(error: Error)
        case none
    }
    
    init() {
        getPostFromServer()
    }
    
    let urlString = "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=55c8624285d94dcf975066f96611753a"
    var cancelled = Set<AnyCancellable>()

    @Published var state: State = .none
    @Published var stateImag: StateImag = .none
    
    func getPostFromServer() {
        
        self.state = .loading
        guard let url = URL(string: urlString) else { return }
    
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, resp) -> Data in
                guard let resp = resp as? HTTPURLResponse, resp.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Article.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] artcleAnswer in
                self?.state = .success(articles: artcleAnswer.articles)
            }
            .store(in: &cancelled)
    }
    
    func getUrlImage(_ urlImage: String, _ completionHandler: @escaping (_ imgaeData: Data) -> Void) {
        self.stateImag = .loading
        guard let url = URL(string: urlImage) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, resp) -> Data in
                guard let resp = resp as? HTTPURLResponse, resp.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.stateImag = .failed(error: error)
                default: break
                }
            } receiveValue: { image in
                self.stateImag = .success
                completionHandler(image)
            }
            .store(in: &cancelled)
    }
}
