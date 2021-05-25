//
//  OperationViewController.swift
//  YUAS
//
//  Created by Hakan Tunç on 3.12.2020.
//

import UIKit
import CoreNFC
import MapKit
import CoreLocation

class OperationViewController: UIViewController, NFCTagReaderSessionDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    var session: NFCTagReaderSession?
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM,yyyy"
        let exactlyCurrentTime: Date = Date()
        dateLabel.text = "\(dateFormatterPrint.string(from: exactlyCurrentTime))"
        nameLabel.text = StudentsData.StudentsNamesandSurnamesText
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()

        }
    }
    @IBAction func CaptureNFC(_ sender:Any) {
        self.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        self.session?.alertMessage = "Hold Your Phone Near the NFC Tag"
        self.session?.begin()
    }
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("NFC Reading session begun..")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        
        if tags.count > 1{
            session.alertMessage = "More Than 1 Tag Detected. Please Try Again"
            session.invalidate()
        }
        let tag = tags.first!
        session.connect(to: tag){ (error) in
            if nil != error{
                session.invalidate(errorMessage: "Connection Failed")
            }
            if case let .miFare(sTag) = tag{
                let UID = sTag.identifier.map{String(format:"%.2hhx",$0)}.joined()
                print("NFC Input UID:",UID)
                //print(sTag.identifier)
                session.invalidate()
                DispatchQueue.main.async {
                    if (UID == "047a38b2b22d80" || UID == "04826df2f34480" || UID == "04847642504380"){
                        GlobalVariables.NFCUID=UID
                        session.alertMessage = "You can scan the QR code next"
                        let scannerVC:ScannerViewController = ScannerViewController()
                        self.present(scannerVC, animated: true, completion: nil)
                    }
                    else {
                        session.invalidate(errorMessage: "Error")
                    }
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.map.setRegion(region, animated: true)
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate
            map.addAnnotation(pin)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
struct GlobalVariables {
    static var courseArrayForStudent1 = [""]
    static var courseArrayForStudent2 = [""]
    static var courseArrayForStudent3 = [""]
    static var courseArrayForTeacher = [""]
    static var NFCUID = ""
    static var QRCode = ""
    static var NfcQrMatchCheck = 0
}

