//
//  CameraErrors.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/23/18.
//  Copyright © 2018 HD. All rights reserved.
//

import Foundation

enum CameraErrors {
    case videoAuthorizationDenied
    case videoAuthorizationRestricted
    case audioAuthorizationDenied
    case audioAuthorizationRestricted
    case cameraNotFound
    case microphoneNotFound
    case torchUnavailable
    case captureError
    case videoExportFailure
    case couldNotProcessImage
    case couldNotProcessVideo
    case couldNotAccessLibrary
}

extension CameraErrors: AppError {
    var title: String {
        return "Error"
    }
    
    //MARK: - TODO: Update these description to something more ... descriptive
    var description: String {
        switch self {
        case .videoAuthorizationDenied: return String("Authorization denied. If you want to take photos, enable access to the camera.")
        case .videoAuthorizationRestricted: return String("This device is restricted. You are not authorized to grant permission camera access..")
        case .audioAuthorizationDenied: return String("Authorization denied. If you want to capture video with audio, enable access to the microphone.")
        case .audioAuthorizationRestricted: return String("This device is restricted. You are not authorized to grant permission for microphone access.")
        case .cameraNotFound: return String("Camera is not available.")
        case .microphoneNotFound: return String("Microphone is not available.")
        case .torchUnavailable: return String("Torch is not available.")
        case .captureError: return String("Could not take photo.")
        case .videoExportFailure: return String("Export failed.")
        case .couldNotProcessImage: return String("Could not process image.")
        case .couldNotProcessVideo: return String("Could not process video.")
        case .couldNotAccessLibrary: return String("Could not access media library.")
        }
    }
}

extension CameraErrors: hasInstructions {
    var instruction: String? {
        switch self {
        case .videoAuthorizationDenied:
            return String("Go to settings > Privacy > LiveLife > etc to grant LiveLife permission to use the camera.")
        case .videoAuthorizationRestricted:
            return String("Contact the owner / admin of this device that's authorized to grant LiveLife permission to use the camera.")
        case .audioAuthorizationDenied: return String("Go to settings > Privacy > LiveLife > etc to grant LiveLife permission to use the microphone.")
        case .audioAuthorizationRestricted: return String("Contact the owner / admin of this device that's authorized to grant LiveLife permission to use the microphone.")
        default: return nil
        }
    }
}
