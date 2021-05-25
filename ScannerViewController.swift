//
//  ScannerViewController.swift
//  YUAS
//
//  Created by Hakan Tunç on 3.12.2020.
//

import AVFoundation
import UIKit
import LocalAuthentication

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            print ("QR Reading session begun..")
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            print ("QR Reading session failed..")
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            GlobalVariables.NfcQrMatchCheck = 0
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            print(stringValue)
            if (GlobalVariables.NFCUID == "047a38b2b22d80" && stringValue == "CSE 499") {
                GlobalVariables.NfcQrMatchCheck = 1
                GlobalVariables.QRCode = "CSE 499"
            }
            if (GlobalVariables.NFCUID == "04826df2f34480" && stringValue == "CSE 466") {
                GlobalVariables.NfcQrMatchCheck = 1
                GlobalVariables.QRCode = "CSE 466"
            }
            if (GlobalVariables.NFCUID == "04847642504380" && stringValue == "CSE 477") {
                GlobalVariables.NfcQrMatchCheck = 1
                GlobalVariables.QRCode = "CSE 477"
            }
            if (GlobalVariables.NfcQrMatchCheck == 1) {
                let context = LAContext()
                var error: NSError?
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Identify yourself!"

                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [unowned self] success, authenticationError in
                        DispatchQueue.main.async {

                            if success {
                                print ("Success!")
                                let date = Date()
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd.MM.yyyy"
                                let result = formatter.string(from: date)
                                if (StudentsData.StudentsNamesandSurnamesText == "Hakan Tunç"){
                                    GlobalVariables.courseArrayForStudent1.append(StudentsData.StudentsNamesandSurnamesText+"          "+GlobalVariables.QRCode+"             " + result)
                                    GlobalVariables.courseArrayForTeacher.append(StudentsData.StudentsNamesandSurnamesText+"          "+GlobalVariables.QRCode+"             " + result)
                                }
                                if (StudentsData.StudentsNamesandSurnamesText == "Bahadır Bağ"){
                                    GlobalVariables.courseArrayForStudent2.append(StudentsData.StudentsNamesandSurnamesText+"          "+GlobalVariables.QRCode+"             " + result)
                                    GlobalVariables.courseArrayForTeacher.append(StudentsData.StudentsNamesandSurnamesText+"          "+GlobalVariables.QRCode+"             " + result)
                                }
                                if (StudentsData.StudentsNamesandSurnamesText == "Özgür Eker"){
                                    GlobalVariables.courseArrayForStudent3.append(StudentsData.StudentsNamesandSurnamesText+"          "+GlobalVariables.QRCode+"             " + result)
                                    GlobalVariables.courseArrayForTeacher.append(StudentsData.StudentsNamesandSurnamesText+"          "+GlobalVariables.QRCode+"             " + result)
                                }
                            } else {
                                let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(ac, animated: true)
                            }
                        }
                    }
                } else {
                    let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        print("QR Input: " + code)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
