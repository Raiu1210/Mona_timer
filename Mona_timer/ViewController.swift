//
//  ViewController.swift
//  Mona_timer
//
//  Created by 石橋龍 on 2018/05/24.
//  Copyright © 2018 Team snake. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, AVAudioPlayerDelegate {

    // define pickerView , button , time_label, audio player, h-m-s labels
    private var myUIPicker: UIPickerView!
    private var myButton: UIButton!
    var myLabel : UILabel!
    var audioPlayer:AVAudioPlayer!
    var h_label : UILabel!
    var m_label : UILabel!
    var s_label : UILabel!
    
    // define Timer
    var timer:Timer = Timer()
    
    // make components to choose time
    private let myValues1: NSArray = (0...24).map { String ($0) } as NSArray
    private let myValues2: NSArray = (0...59).map { String ($0) } as NSArray
    private let myValues3: NSArray = (0...59).map { String ($0) } as NSArray
    
    // make variables for hour, minuts, seconds
    var s_hour = "0"
    var hour = 0
    var s_minut = "0"
    var minut = 0
    var s_second = "0"
    var second = 0
    var sum_of_seconds = 0
    var test_num = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // !!!!!--------------------about myUIPicker-----------------------!!!!!
        // generate my UIPickerView
        myUIPicker = UIPickerView()

        // set size, Delegate and sourse
        myUIPicker.frame = CGRect(x: 0, y: self.view.bounds.height/4, width: self.view.bounds.width, height: self.view.bounds.height/4)
        myUIPicker.delegate = self
        myUIPicker.dataSource = self
        myUIPicker.backgroundColor = UIColor.orange
        
        // add to view
        self.view.addSubview(myUIPicker)
    
        
        // !!!!!--------------------about myButton-----------------------!!!!!
        // make myButton
        myButton = UIButton()
        
        // size of Button
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        
        // position of Buttom , X and Y
        let posX: CGFloat = self.view.frame.width/2 - bWidth/2
        let posY: CGFloat = self.view.frame.height/1.35
        
        // put Button and set size, backgroundcolor, shape
        myButton.frame = CGRect(x: posX, y: posY, width: bWidth, height: bHeight)
        myButton.backgroundColor = UIColor.red
        myButton.layer.masksToBounds = true
        myButton.layer.cornerRadius = 20.0
        
        // set title and tag
        myButton.setTitle("Start(ready)", for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.tag = 1
        myButton.setTitle("ボタン(押された時)", for: .highlighted)
        myButton.setTitleColor(UIColor.black, for: .highlighted)
        
        // add event
        myButton.addTarget(self, action: #selector(ViewController.onClickMyButton(sender:)), for: .touchUpInside)
        
        // add Button to View
        self.view.addSubview(myButton)
        
        // make time label
        let Lwidth = self.view.bounds.width / 2
        let Lheight = self.view.bounds.height / 5
        let LposX = self.view.bounds.width / 2 - Lwidth / 2
        let LposY = self.view.bounds.height / 1.7 - Lheight / 2
        myLabel = UILabel(frame: CGRect(x:LposX,y:LposY,width:Lwidth,height:Lheight))
        myLabel.text = "Time:\(sum_of_seconds)"
        myLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(myLabel)
        
        // ready to audio play
        let audioPath = Bundle.main.path(forResource: "mona_timer_finish", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        // make audio player
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
    }

    
    // !!!!!---------------------------functions for myPicker-------------------------------!!!!!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0){
            return myValues1.count
        }else if (component == 1){
            return myValues2.count
        }else if (component == 2){
            return myValues3.count
        }
        return 0
    }
    
    // display data
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0){
            return (myValues1[row] as! String)
        }else if (component == 1){
            return (myValues2[row] as! String)
        }else if (component == 2){
            return (myValues3[row] as! String)
        }
        return ""
    }
    
    // when picker was chosen, called
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0){
            print("列: \(component)")
            print("値: \(myValues1[row])")
            s_hour = myValues1[row] as! String
        }else if (component == 1){
            print("列: \(component)")
            print("値: \(myValues2[row])")
            s_minut = myValues2[row] as! String
        }else if (component == 2){
            print("列: \(component)")
            print("値: \(myValues3[row])")
            s_second = myValues3[row] as! String
        }
    }
    
    // change the size of picker
    func pickerView(_ pickerView: UIPickerView, widthForComponent component:Int) -> CGFloat {
        //サンプル
        switch component {
        case 0:
            return self.view.bounds.width/4
        case 1:
            return self.view.bounds.width/4
        default:
            return self.view.bounds.width/4
        }
    }
    
    
    
    
    @objc internal func onClickMyButton(sender: UIButton) {
        print("onClickMyButton:");
        // if already timer is started, stop
        timer.invalidate()
        
        hour = Int(s_hour)!
        minut = Int(s_minut)!
        second = Int(s_second)!
//        print("sender.currentTitle: \(sender.currentTitle)")
//        print("sender.tag: \(sender.tag)")
//        print("!!!!!--------about picker numbers---------!!!!!")
//        print("\(s_hour) is string number")
//        print("\(s_minut) is string number")
//        print("\(s_second) is string number")
//        print("\(hour) is Int number")
//        print("\(minut) is Int number")
//        print("\(second) is Int number")
//        print("!!!!!--------about picker numbers---------!!!!!")
        sum_of_seconds = hour * 60 * 60 + minut * 60 + second
        print("sum_of_seconds = \(sum_of_seconds)")
        
        // make timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update_time(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func update_time(timer: Timer){
            sum_of_seconds -= 1
            print("Decreased!")
        
        if sum_of_seconds > 0{
            let str_sum_of_second = String(sum_of_seconds)
            myLabel.text = str_sum_of_second
        }
        else{
            myLabel.text = "Finish"
            timer.invalidate()
            if ( audioPlayer.isPlaying ){
                audioPlayer.stop()
//                button.setTitle("Stop", for: UIControlState())
            }
            else{
                audioPlayer.play()
//                button.setTitle("Play", for: UIControlState())
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

