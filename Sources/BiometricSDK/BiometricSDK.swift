import Foundation
import LocalAuthentication


public class BiometricAuthSDK {
    public enum BiometricAuthError: Error {
            case unavailable
            case failed(String)
        }

        public init() {}

        public func authenticateUser(completion: @escaping (Result<String, BiometricAuthError>) -> Void) {
            let context = LAContext()
            var error: NSError?

            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                completion(.failure(.unavailable))
                return
            }

            let reason = "Authenticate to continue"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                    if success {
                        let token = self.generateSecureToken()
                        completion(.success(token))
                    } else {
                        completion(.failure(.failed(authError?.localizedDescription ?? "Authentication failed")))
                    }
            }
        }

        private func generateSecureToken() -> String {
            let timestamp = "\(Int(Date().timeIntervalSince1970))"
            let deviceID = UUID().uuidString
            let rawToken = "\(timestamp)-\(deviceID)"
            
            return rawToken.data(using: .utf8)?.base64EncodedString() ?? ""
        }
}

