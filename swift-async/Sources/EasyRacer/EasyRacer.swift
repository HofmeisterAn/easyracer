import Foundation

enum EasyRacerError : Error {
    case error(String)
}

@main
public struct EasyRacer {
    let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func scenario1() async throws -> String {
        print("Scenario 1")
        let result: String = await withTaskGroup(of: String?.self) { group in
            defer { group.cancelAll() }
            
            let url: URL = baseURL.appendingPathComponent("1")
            let urlSession: URLSession = URLSession(configuration: .ephemeral)
            @Sendable func doHTTPGet() async throws -> String {
                let (data, response) = try await urlSession.data(from: url)
                guard
                    let response = response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode),
                    let dataUTF8: String = String(data: data, encoding: .utf8)
                else {
                    throw EasyRacerError.error("invalid HTTP response")
                }
                
                return dataUTF8
            }
            group.addTask(operation: { try? await doHTTPGet() })
            group.addTask(operation: { try? await doHTTPGet() })
            
            return await group.first { $0 != nil }.flatMap { $0 } ?? "wrong"
        }
        
        return result
    }
    
    func scenario2() async throws -> String {
        print("Scenario 2")
        let result: String = try await withThrowingTaskGroup(of: String.self) { group in
            defer { group.cancelAll() }
            
            let url: URL = baseURL.appendingPathComponent("2")
            let urlSession: URLSession = URLSession(configuration: .ephemeral)
            @Sendable func doHTTPGet() async throws -> String {
                let (data, response) = try await urlSession.data(from: url)
                guard
                    let response = response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode),
                    let dataUTF8: String = String(data: data, encoding: .utf8)
                else {
                    throw EasyRacerError.error("invalid HTTP response")
                }
                
                return dataUTF8
            }
            group.addTask(operation: doHTTPGet)
            group.addTask(operation: doHTTPGet)
            
            while let next: Result<String, Error> = await group.nextResult() {
                switch(next) {
                case let .success(first):
                    return first
                case .failure:
                    continue
                }
            }
            throw EasyRacerError.error("all requests failed")
        }
        
        return result
    }
    
    func scenario3() async throws -> String {
        print("Scenario 3")
        let result: String = try await withThrowingTaskGroup(of: String.self) { group in
            defer { group.cancelAll() }
            
            let url: URL = baseURL.appendingPathComponent("3")
            let urlSessionConf = URLSessionConfiguration.ephemeral
            urlSessionConf.timeoutIntervalForRequest = 900 // Ridiculous 15-minute time out
            for _ in 1...10_000 {
                group.addTask {
                    let urlSession: URLSession = URLSession(configuration: urlSessionConf)
                    let (data, response) = try await urlSession.data(from: url)
                    guard
                        let response = response as? HTTPURLResponse,
                        (200..<300).contains(response.statusCode),
                        let dataUTF8: String = String(data: data, encoding: .utf8)
                    else {
                        throw EasyRacerError.error("invalid HTTP response")
                    }
                    
                    return dataUTF8
                }
            }
            
            while let next: Result<String, Error> = await group.nextResult() {
                switch(next) {
                case let .success(first):
                    return first
                case .failure:
                    continue
                }
            }
            throw EasyRacerError.error("all requests failed")
        }
        
        return result
    }
    
    func scenario4() async throws -> String {
        print("Scenario 4")
        let url: URL = baseURL.appendingPathComponent("4")
        let urlSession: URLSession = URLSession(configuration: .ephemeral)
        async let result: String = {
            let (data, response) = try await urlSession.data(from: url)
            guard
                let response = response as? HTTPURLResponse,
                (200..<300).contains(response.statusCode),
                let dataUTF8: String = String(data: data, encoding: .utf8)
            else {
                throw EasyRacerError.error("invalid HTTP response")
            }
            
            return dataUTF8
        }()
        try await Task.sleep(nanoseconds: 100_000_000) // TODO new API?
        let secondConnectionCancellable = urlSession.dataTask(with: URLRequest(url: url))
        secondConnectionCancellable.resume()
        try await Task.sleep(nanoseconds: 1_000_000_000) // TODO new API?
        secondConnectionCancellable.cancel()
        
        return try await result
    }
    
    func scenario5() async throws -> String {
        print("Scenario 5")
        let result: String = try await withThrowingTaskGroup(of: String.self) { group in
            defer { group.cancelAll() }
            
            let url: URL = baseURL.appendingPathComponent("5")
            let urlSession: URLSession = URLSession(configuration: .ephemeral)
            @Sendable func doHTTPGet() async throws -> String {
                let (data, response) = try await urlSession.data(from: url)
                guard
                    let response = response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode),
                    let dataUTF8: String = String(data: data, encoding: .utf8)
                else {
                    throw EasyRacerError.error("invalid HTTP response")
                }
                
                return dataUTF8
            }
            group.addTask(operation: doHTTPGet)
            group.addTask(operation: doHTTPGet)
            
            while let next: Result<String, Error> = await group.nextResult() {
                switch(next) {
                case let .success(first):
                    return first
                case .failure:
                    continue
                }
            }
            throw EasyRacerError.error("all requests failed")
        }
        
        return result
    }
    
    func scenario6() async throws -> String {
        print("Scenario 6")
        let result: String = try await withThrowingTaskGroup(of: String.self) { group in
            defer { group.cancelAll() }
            
            let url: URL = baseURL.appendingPathComponent("6")
            let urlSession: URLSession = URLSession(configuration: .ephemeral)
            @Sendable func doHTTPGet() async throws -> String {
                let (data, response) = try await urlSession.data(from: url)
                guard
                    let response = response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode),
                    let dataUTF8: String = String(data: data, encoding: .utf8)
                else {
                    throw EasyRacerError.error("invalid HTTP response")
                }
                
                return dataUTF8
            }
            group.addTask(operation: doHTTPGet)
            group.addTask(operation: doHTTPGet)
            group.addTask(operation: doHTTPGet)
            
            while let next: Result<String, Error> = await group.nextResult() {
                switch(next) {
                case let .success(first):
                    return first
                case .failure:
                    continue
                }
            }
            throw EasyRacerError.error("all requests failed")
        }
        
        return result
    }
    
    func scenario7() async throws -> String {
        print("Scenario 7")
        let result: String = try await withThrowingTaskGroup(of: String.self) { group in
            defer { group.cancelAll() }
            
            let url: URL = baseURL.appendingPathComponent("7")
            let urlSession: URLSession = URLSession(configuration: .ephemeral)
            @Sendable func doHTTPGet() async throws -> String {
                let (data, response) = try await urlSession.data(from: url)
                guard
                    let response = response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode),
                    let dataUTF8: String = String(data: data, encoding: .utf8)
                else {
                    throw EasyRacerError.error("invalid HTTP response")
                }
                
                return dataUTF8
            }
            group.addTask(operation: doHTTPGet)
            try await Task.sleep(nanoseconds: 3_000_000_000) // TODO new API?
            group.addTask(operation: doHTTPGet)
            
            while let next: Result<String, Error> = await group.nextResult() {
                switch(next) {
                case let .success(first):
                    return first
                case .failure:
                    continue
                }
            }
            throw EasyRacerError.error("all requests failed")
        }
        
        return result
    }
    
    func scenario8() async throws -> String {
        print("Scenario 8")
        let result: String = try await withThrowingTaskGroup(of: String.self) { group in
            defer { group.cancelAll() }
            
            let url: URL = baseURL.appendingPathComponent("8")
            let urlSession: URLSession = URLSession(configuration: .ephemeral)
            @Sendable func openUseAndClose() async throws -> String {
                guard
                    let urlComps: URLComponents = URLComponents(
                        url: url, resolvingAgainstBaseURL: false
                    )
                else {
                    throw EasyRacerError.error("invalid HTTP response")
                }
                
                // Open
                var openURLComps = urlComps
                openURLComps.queryItems = [URLQueryItem(name: "open", value: nil)]
                
                guard
                    let openURL: URL = openURLComps.url
                else {
                    throw EasyRacerError.error("bad open URL")
                }
                let (openData, openResponse) = try await urlSession.data(from: openURL)
                
                guard
                    let response = openResponse as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode),
                    let id: String = String(data: openData, encoding: .utf8)
                else {
                    throw EasyRacerError.error("invalid HTTP response")
                }
                
                // Use
                var useURLComps = urlComps
                useURLComps.queryItems = [URLQueryItem(name: "use", value: id)]
                
                guard
                    let useURL: URL = useURLComps.url
                else {
                    throw EasyRacerError.error("bad use URL")
                }
                let (useData, useResponse) = try await urlSession.data(from: useURL)
                
                let dataUTF8: String?
                if
                    let response = useResponse as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode)
                {
                    dataUTF8 = String(data: useData, encoding: .utf8)
                } else {
                    dataUTF8 = nil
                }
                
                // Close
                var closeURLComps = urlComps
                closeURLComps.queryItems = [URLQueryItem(name: "close", value: id)]
                
                guard
                    let closeURL: URL = closeURLComps.url
                else {
                    throw EasyRacerError.error("bad close URL")
                }
                let _ = try await urlSession.data(from: closeURL)
                
                guard let dataUTF8: String = dataUTF8 else {
                    throw EasyRacerError.error("invalid HTTP response")
                }
                return dataUTF8
            }
            group.addTask(operation: openUseAndClose)
            group.addTask(operation: openUseAndClose)
            
            while let next: Result<String, Error> = await group.nextResult() {
                switch(next) {
                case let .success(first):
                    return first
                case .failure:
                    continue
                }
            }
            throw EasyRacerError.error("all requests failed")
        }
        
        return result
    }
    
    func scenario9() async -> String {
        print("Scenario 9")
        let result: String = await withThrowingTaskGroup(of: String.self) { group in
            defer { group.cancelAll() }
            
            let url: URL = baseURL.appendingPathComponent("9")
            let urlSessionConfiguration: URLSessionConfiguration = .ephemeral
            urlSessionConfiguration.httpMaximumConnectionsPerHost = 10
            let urlSession: URLSession = URLSession(
                configuration: urlSessionConfiguration
            )
            for _ in 1...10 {
                group.addTask {
                    let (data, response) = try await urlSession.data(from: url)
                    guard
                        let response = response as? HTTPURLResponse,
                        (200..<300).contains(response.statusCode),
                        let dataUTF8: String = String(data: data, encoding: .utf8)
                    else {
                        throw EasyRacerError.error("invalid HTTP response")
                    }
                    
                    return dataUTF8
                }
            }
            
            var result: String = ""
            while let next: Result<String, Error> = await group.nextResult() {
                switch(next) {
                case let .success(next):
                    result += next
                case .failure:
                    continue
                }
            }
            return result
        }
        
        return result
    }
    
    public func scenarios() async throws -> [(Int, String)] {
        [
//            (1, try await scenario1()),
//            (2, try await scenario2()),
//            (4, try await scenario4()), // TODO look into why 4 has to come before 3
            (3, try await scenario3()),
//            (5, try await scenario5()),
//            (6, try await scenario6()),
//            (7, try await scenario7()),
//            (8, try await scenario8()),
//            (9, await scenario9())
        ]
    }
    
    public static func main() async throws {
        guard
            let baseURL = URL(string: "http://localhost:8080")
        else { return }
        
        let easyRacer = EasyRacer(baseURL: baseURL)
        print(try await easyRacer.scenario1())
        print(try await easyRacer.scenario2())
        print(try await easyRacer.scenario4())
        print(try await easyRacer.scenario3())
        print(try await easyRacer.scenario5())
        print(try await easyRacer.scenario6())
        print(try await easyRacer.scenario7())
        print(try await easyRacer.scenario8())
        print(await easyRacer.scenario9())
    }
}
