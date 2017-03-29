//
//  SettingsTableViewCell.swift
//  HERO
//
//  Created by Amrun on 06/11/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
       let numberFomatter = NumberFormatter()
    
    // outlets for SettingsView Slider
    @IBOutlet weak var RangeLabel: UILabel!
    @IBOutlet weak var slider: MultiStepRangeSlider!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let intervals = [Interval(min: 18, max: 100, stepValue: 1)]
        let preSelectedRange = RangeValue(lower: 18, upper: 35)
        slider.configureSlider(intervals: intervals, preSelectedRange: preSelectedRange)
        
        let lower = abbreviateNumber(NSNumber(value: slider.discreteCurrentValue.lower as Float)) as String
        let upper = abbreviateNumber(NSNumber(value: slider.discreteCurrentValue.upper as Float)) as String
        
        RangeLabel.text = "\(lower)-\(upper)"

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //
    @IBAction func handleSliderChange(_ sender: AnyObject) {
        
        let lower = abbreviateNumber(NSNumber(value: slider.discreteCurrentValue.lower as Float)) as String
        let upper = abbreviateNumber(NSNumber(value: slider.discreteCurrentValue.upper as Float)) as String
        
        RangeLabel.text = "\(lower)-\(upper)"
        
//        print("lower = \(lower) higher = \(upper)")
    }
    
}

func abbreviateNumber(_ num: NSNumber) -> NSString {
    var ret: NSString = ""
    let floatNum = num.floatValue
    ret = NSString(format: "%d", Int(floatNum))
    return ret
}

