//
//  ViewController.swift
//  GeoCalculatorApp
//
//  Created by Cheng Li, Ryan Basso on 9/18/17.
//  Copyright © 2017 Cheng Li, Ryan Basso. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase

class ViewController: GeoCalcViewController, SettingsViewControllerDelegate, HistoryTableViewControllerDelegate {
    
    @IBOutlet weak var latitude1Field: UITextField!

    @IBOutlet weak var longitude1Field: UITextField!
    
    @IBOutlet weak var latitude2Field: UITextField!
    
    @IBOutlet weak var longitude2Field: UITextField!
    
    @IBOutlet weak var bearingLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var degreeFrom: UILabel!
    
    @IBOutlet weak var conditionFrom: UILabel!
    
    @IBOutlet weak var weatherFrom: UIImageView!
    
    @IBOutlet weak var degreeTo: UILabel!
    
    @IBOutlet weak var conditionTo: UILabel!
    
    @IBOutlet weak var weatherTo: UIImageView!
    
    fileprivate var ref:DatabaseReference?
    
     let wAPI = DarkSkyWeatherService.getInstance()
    
    var entries : [LocationLookup] = [
        LocationLookup(origLat: 90.0, origLng: 0.0, destLat: -90.0, destLng: 0.0, timestamp: Date.distantPast),
        LocationLookup(origLat: -90.0, origLng: 0.0, destLat: 90.0, destLng: 0.0, timestamp: Date.distantFuture)]
    
    var selection1:String = ""
    var selection2:String = ""
    
    var lat1: Double = 0.0
    var lat2: Double = 0.0
    var long1: Double = 0.0
    var long2: Double = 0.0
    
    var distanceU: String = "Kilometers"
    
    var bearingU: String = "Degrees"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.degreeTo.text = ""
        self.degreeFrom.text = ""
        self.conditionTo.text = ""
        self.conditionFrom.text = ""
        
        self.ref = Database.database().reference()
        self.registerForFireBaseUpdates()
        
    }
    
    // Dismiss keyboard if lose focus
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    // Calculate the distance and bearing when the calculate is pressed
    @IBAction func calculatePressed(_ sender: UIButton) {
        outputString()
        
        
        // save history to firebase
        let entry = LocationLookup(origLat: lat1, origLng: long1, destLat: lat2,
                                   destLng: long2, timestamp: Date())
        let newChild = self.ref?.child("history").childByAutoId()
        newChild?.setValue(self.toDictionary(vals: entry))

    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        self.latitude1Field.text = ""
        self.latitude2Field.text = ""
        self.longitude1Field.text = ""
        self.longitude2Field.text = ""
        self.distanceLabel.text = "Distance: "
        self.bearingLabel.text = "Bearing: "
        self.degreeTo.text = ""
        self.degreeFrom.text = ""
        self.conditionTo.text = ""
        self.conditionFrom.text = ""
        self.weatherFrom.image = nil
        self.weatherTo.image = nil
        self.dismissKeyboard()
    }
    
    func outputString() {
        // String for all points
        let lat1Text: String = self.latitude1Field.text!
        let lat2Text: String = self.latitude2Field.text!
        let long1Text: String = self.longitude1Field.text!
        let long2Text: String = self.longitude2Field.text!
        
        // Procees only if all the field is filled
        if (!lat1Text.isEmpty && !lat2Text.isEmpty && !long1Text.isEmpty && !long2Text.isEmpty) {

            lat1 = Double(lat1Text)!
            lat2 = Double(lat2Text)!
            long1 = Double(long1Text)!
            long2 = Double(long2Text)!
            
            doCalculations(lat1: lat1, long1: long1, lat2: lat2, long2: long2)
            
        }
    }
    
    func doCalculations(lat1: Double, long1: Double, lat2: Double, long2: Double) {
        let p1 = CLLocation(latitude: lat1, longitude: long1)
        let p2 = CLLocation(latitude: lat2, longitude: long2)
        
        var dist = (p1.distance(from: p2))/1000
        
        var bear = p1.bearingToPoint(point: p2)
        
        if(distanceU == "Miles") {
            dist = dist * 1/1.609344
        }
        if(bearingU == "Mils") {
            bear = bear * (160/9)
        }
        
        self.distanceLabel.text = "Distance: \(decimalFormat(d1: dist)) \(distanceU)"
        self.bearingLabel.text = "Bearing: \(decimalFormat(d1: bear)) \(bearingU)"
        self.dismissKeyboard()
        
        wAPI.getWeatherForDate(date: Date(), forLocation: (lat1, long1)) { (weather) in
            if let w = weather {
                DispatchQueue.main.async {
                    self.degreeFrom.text = "\(w.temperature.roundTo(places: 1))°"
                    self.weatherFrom.image = UIImage(named: w.iconName)
                    self.conditionFrom.text = w.summary
                }
            }
        }
        
        wAPI.getWeatherForDate(date: Date(), forLocation: (lat2, long2)) { (weather) in
            if let w = weather {
                DispatchQueue.main.async {
                    self.degreeTo.text = "\(w.temperature.roundTo(places: 1))°"
                    self.weatherTo.image = UIImage(named: w.iconName)
                    self.conditionTo.text = w.summary
                    
                    
                }
            }
        }
    }
    
    func settingsChanged(distanceUnits: String, bearingUnits: String) {
        distanceU = distanceUnits
        bearingU = bearingUnits
        outputString()
    }
    
    func selectEntry(entry: LocationLookup) {
        self.latitude1Field.text = "\(entry.origLat)"
        self.latitude2Field.text = "\(entry.destLat)"
        self.longitude1Field.text = "\(entry.origLng)"
        self.longitude2Field.text = "\(entry.destLng)"
    
        
        lat1 = entry.origLat
        long1 = entry.origLng
        lat2 = entry.destLat
        long2 = entry.destLng
        doCalculations(lat1: entry.origLat, long1: entry.origLng, lat2: entry.destLat, long2: entry.destLng)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "settingsSegue" {
            if let destVC = segue.destination as? SettingViewController{
                destVC.delegate = self
                destVC.selection1 = distanceU
                destVC.selection2 = bearingU
                
            }
        }
        
        else if segue.identifier == "historySegue" {
            if let destVC2 = segue.destination as? HistoryTableViewController{
                destVC2.entries! = self.entries
                destVC2.historyDelegate = self
            }
        }
        
        else if segue.identifier == "searchSegue" {
            if let dest = segue.destination as? LocationSearchViewController {
                dest.delegate = self
            }
        }

    }
    
    // clear the textfield
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func decimalFormat(d1: Double) -> Double {
        let whole = d1 * 100
        let left: Double = round(whole)
        let rounded: Double = left/100
        return rounded
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func registerForFireBaseUpdates()
    {
        self.ref!.child("history").observe(.value, with: { snapshot in
            if let postDict = snapshot.value as? [String : AnyObject] {
                var tmpItems = [LocationLookup]()
                for (_,val) in postDict.enumerated() {
                    let entry = val.1 as! Dictionary<String,AnyObject>
                    let timestamp = entry["timestamp"] as! String?
                    let origLat = entry["origLat"] as! Double?
                    let origLng = entry["origLng"] as! Double?
                    let destLat = entry["destLat"] as! Double?
                    let destLng = entry["destLng"] as! Double?
                    
                    tmpItems.append(LocationLookup(origLat: origLat!,
                                                   origLng: origLng!, destLat: destLat!,
                                                   destLng: destLng!,
                                                   timestamp: (timestamp?.dateFromISO8601)!))
                }
                self.entries = tmpItems
            }
        })
        
    }
    
    func toDictionary(vals: LocationLookup) -> NSDictionary {
        return [
            "timestamp": NSString(string: (vals.timestamp.iso8601)),
            "origLat" : NSNumber(value: vals.origLat),
            "origLng" : NSNumber(value: vals.origLng),
            "destLat" : NSNumber(value: vals.destLat),
            "destLng" : NSNumber(value: vals.destLng),
            
        ]
    }



}

extension ViewController: LocationSearchDelegate {
    func set(calculationData: LocationLookup)
    {
        self.latitude1Field.text = "\(calculationData.origLat)"
        self.longitude1Field.text = "\(calculationData.origLng)"
        self.latitude2Field.text = "\(calculationData.destLat)"
        self.longitude2Field.text = "\(calculationData.destLng)"
        outputString()
        doCalculations(lat1: lat1, long1: long1, lat2: lat2, long2: long2)
    }
}





