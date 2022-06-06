import AWSLambdaRuntime
import GlucoseAppHelper

struct Input: Codable {
    let username: String
    let password: String
}

struct Output: Codable {
    let message: String
}

Lambda.run { (context, input: Input, completion: @escaping (Result<Output, Error>) -> Void) in
    let carelink = LoginUseCase.singleton
    
    Task.init {
//        let loggedIn = try? await carelink.validateCredentials(username: input.username, password: input.password)
//        completion(.success(Output(message: "Result: \(loggedIn ?? false)")))
    }
}
