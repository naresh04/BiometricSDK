import Foundation
import LocalAuthentication



@MainActor  // Ensures all methods are executed on the main thread
public class BiometricAuth {
    
    public init() {} // Required for external instantiation

    public func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate using biometrics"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                completion(success, authError?.localizedDescription)
            }
        } else {
            completion(false, "Biometric authentication is not available.")
        }
    }
}
