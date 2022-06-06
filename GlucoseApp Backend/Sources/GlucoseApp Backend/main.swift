import AWSLambdaRuntime
import GlucoseApp_Core

Lambda.run { (context, input: CredentialsState, completion: @escaping (Result<DataResponse, Error>) -> Void) in
    let carelink = CareLinkController.singleton

    Task.init {
        var loggedIn = false

        do {
            loggedIn = try await carelink.validateCredentials(username: input.username, password: input.password)
        } catch {
            completion(.failure(error))
            return
        }
        
        guard loggedIn == true else {
            completion(.failure(HttpErrors.CredentialsError))
            return
        }
        
        do {
            let data = try await carelink.getLastSensorGlucose()
            completion(.success(data))
        } catch {
            completion(.failure(error))
            return
        }
    }
}
