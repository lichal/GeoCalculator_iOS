//
//  SettingViewController.swift
//  GeoCalculator
//
//  Created by Cheng Li, Ryan Basso on 9/22/17.
//  Copyright © 2017 Cheng Li, Ryan Basso. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func settingsChanged(distanceUnits: String, bearingUnits: String)
}

class SettingViewController: UIViewController {
    
    @IBOutlet weak var distanceChees: UILabel!
    
    @IBOutlet weak var bearingChees: UILabel!
    
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = [String]()
    var selection1: String = "Kilometers"
    var selection2: String = "Degrees"
    
    var delegate: SettingsViewControllerDelegate?
    
    var isDataDistance: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.dataSource = self
        self.picker.delegate = self
        
        picker.isHidden = true
        
        view.addSubview(picker)
        
        distanceChees.text = selection1
        bearingChees.text = selection2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector((distanceTapped(_:))))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector((unitsTapped(_:))))
        
        distanceChees.addGestureRecognizer(tap)
        distanceChees.isUserInteractionEnabled = true
        
        bearingChees.addGestureRecognizer(tap2)
        bearingChees.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.picker.isHidden = true
    }
    
    @IBAction func distanceTapped(_ sender: UITapGestureRecognizer) {
        isDataDistance = true
        self.pickerData = ["Kilometers", "Miles"]
        self.picker.selectRow(position(select: selection1), inComponent: 0, animated: true)
        self.picker.delegate = self
        picker.isHidden = false
    }
    
    @IBAction func unitsTapped(_ sender: UITapGestureRecognizer) {
        isDataDistance = false
        self.pickerData = ["Degrees", "Mils"]
        self.picker.selectRow(position(select: selection2), inComponent: 0, animated: true)
        self.picker.delegate = self
        picker.isHidden = false
    }

    func position(select: String) -> Int {
        if(select == "Kilometers" || select == "Degrees") {
            return 0
        }
        else {
            return 1
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        if let d = self.delegate {
            d.settingsChanged(distanceUnits: selection1, bearingUnits: selection2)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SettingViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (isDataDistance) {
            self.selection1 = self.pickerData[row]
            distanceChees.text = selection1
        }
        else {
            self.selection2 = self.pickerData[row]
            bearingChees.text = selection2
        }
    }
}


