//  Copyright © 2019 la-labs. All rights reserved.

import UIKit
import Vision

/// Data model for a given face in a photo.
public struct Face: Equatable {
  
  /// PHAsset local Identifier or pre defined id for local UIImage.
  public let localIdentifier: String
  
  /// Cropped and align image of a given face in a photo.
  ///
  /// The default value is empty image.
  public let faceCroppedImage: UIImage
  
  /// Face observation. contain info as requested
  public let faceObservation: VNFaceObservation
  
  /// Finds facial features (such as the eyes and mouth) in an image.
  public var landmarks: VNFaceLandmarks2D? {
    faceObservation.landmarks
  }
  
  /// Floating-point number representing the capture quality of a given face in a photo.
  ///
  /// The default value is 0.
  public let quality: Float
  
  /// Floating-point number representing the roll angle in radian of a given face in a photo.
  ///
  /// The default value is 0.
  public let roll: Double
  
  /// Floating array numbers representing the capture of a given face in a photo.
  ///
  /// The default value is empty array.
  public let faceEncoding: [Double]
  
  /// Facial emotion (such as happy and angry) in an image.
  ///
  /// The default value is none.
  public let faceEmotion: FaceEmotion 

  init(
    localIdentifier: String = UUID().uuidString,
    faceCroppedImage: UIImage = UIImage(),
    faceObservation: VNFaceObservation = VNFaceObservation(boundingBox: .zero),
    quality: Float = 0,
    roll: Double = 0,
    faceEncoding: [Double] = [],
    faceEmotion: FaceEmotion = .none
  ) {
    self.localIdentifier = localIdentifier
    self.faceCroppedImage = faceCroppedImage
    self.faceObservation = faceObservation
    self.quality = quality
    self.roll = roll
    self.faceEncoding = faceEncoding
    self.faceEmotion = faceEmotion
  }

  public enum FaceEmotion: CaseIterable, CustomStringConvertible {
    case angry
    case disgust
    case fear
    case happy
    case sad
    case surprise
    case neutral
    case none
    
    public var description: String {
      switch self {
      case .angry:
        return "angry"
      case .disgust:
        return "disgust"
      case .fear:
        return "fear"
      case .happy:
        return "happy"
      case .sad:
        return "sad"
      case .surprise:
        return "surprise"
      case .neutral:
        return "neutral"
      case .none:
        return "none"
      }
    }
  }
}

public extension Face {
    
    /// Distance function between 2 faces
    ///
    /// This function help to decide if 2 faces are belong to the same person.
    /// The function use L2_Norm.
    /// - Parameter rhs: other face.
    /// - Returns: The L2_Norm distance between 2 faces.
    func distance(to rhs: Face) -> Double {
        var sum: Double = 0
        for i in 0...faceEncoding.count-1 {
            sum += (pow(faceEncoding[i] - rhs.faceEncoding[i], 2))
        }
       return sqrt(sum)
    }
}
