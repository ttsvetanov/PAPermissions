//
//  PACameraPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import AVFoundation
import UIKit

public class PACameraPermissionsCheck: PAPermissionsCheck {

	var mediaType = AVMediaTypeVideo
	
	override func checkStatus() {
		let currentStatus = self.status

		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
			let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: mediaType)
			switch authStatus {
			
			case .authorized:
				self.status = .enabled
			case .denied:
				self.status = .disabled
			case .notDetermined:
				self.status = .disabled
			default:
				self.status = .unavailable
			}
		}else{
			self.status = .unavailable
		}
		
		if self.status != currentStatus {
			self.updateStatus()
		}
	}
	
	override func defaultAction() {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
			
			if #available(iOS 8.0, *) {
				let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: mediaType)
				if authStatus == .denied {
					let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
					UIApplication.shared.openURL(settingsURL!)
				}else{
					AVCaptureDevice.requestAccess(forMediaType: mediaType, completionHandler: { (result) in
						if result {
							self.status = .enabled
						}else{
							self.status = .disabled
						}
					})
					self.updateStatus();
				}
			}else{
				//Camera access should be always active on iOS 7
			}
		}
		
		
	}
}
