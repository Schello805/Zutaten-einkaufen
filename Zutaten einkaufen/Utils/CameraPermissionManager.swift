import AVFoundation
import SwiftUI

class CameraPermissionManager: ObservableObject {
    static let shared = CameraPermissionManager()
    @Published var isCameraAuthorized = false
    
    private init() {
        checkCameraAuthorization()
    }
    
    func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isCameraAuthorized = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isCameraAuthorized = granted
                }
            }
        case .denied, .restricted:
            isCameraAuthorized = false
        @unknown default:
            isCameraAuthorized = false
        }
    }
    
    func requestCameraAccess() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        // Bereits autorisiert
        guard status != .authorized else { return true }
        
        // Berechtigung anfragen wenn noch nicht entschieden
        if status == .notDetermined {
            return await AVCaptureDevice.requestAccess(for: .video)
        }
        
        return false
    }
    
    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl) else {
            return
        }
        UIApplication.shared.open(settingsUrl)
    }
}
