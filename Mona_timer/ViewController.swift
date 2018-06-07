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
    private var start_Button: UIButton!
    private var stop_Button: UIButton!
    private var mode_Button: UIButton!
    var myLabel : UILabel!
    var audioPlayer:AVAudioPlayer!
    var h_label : UILabel!
    var m_label : UILabel!
    var s_label : UILabel!
    var mode_label : UILabel!
    var mona_label : UILabel!
    
    // define Timer, counter , mona_label, background_task_identifier, temp
    var timer:Timer = Timer()
    var counter = 0
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0
    var temp = 0
    var button_counter = 0
    var mode_identifier = 0
    var remain_h = 0
    var remain_m = 0
    var remain_s = 0

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
//        myUIPicker.backgroundColor = UIColor.orange
        
        // add to view
        self.view.addSubview(myUIPicker)
        
        // !!!!!--------------------about labels-------------------------!!!!!
        h_label = UILabel()
        h_label.text = "時間"
        h_label.sizeToFit()
        h_label.frame = CGRect(x: self.view.bounds.width*2.6/8, y: self.view.bounds.height/4, width: self.view.bounds.width/4, height: self.view.bounds.height/4)
        self.view.addSubview(h_label)
        
        m_label = UILabel()
        m_label.text = "分"
        m_label.sizeToFit()
        m_label.frame = CGRect(x: self.view.bounds.width*5/8, y: self.view.bounds.height/4, width: self.view.bounds.width/4, height: self.view.bounds.height/4)
        self.view.addSubview(m_label)
        
        s_label = UILabel()
        s_label.text = "秒"
        s_label.sizeToFit()
        s_label.frame = CGRect(x: self.view.bounds.width*7/8, y: self.view.bounds.height/4, width: self.view.bounds.width/4, height: self.view.bounds.height/4)
        self.view.addSubview(s_label)
        
        // mona_label
        mona_label = UILabel()
        
        // !!!!!--------------------about mode label-------------------------!!!!!
        mode_label = UILabel()
        if mode_identifier % 3 == 0 {
            mode_label.text = "モード：の〜まる"
            mode_label.adjustsFontSizeToFitWidth = true
        } else if mode_identifier % 3 == 1 {
            mode_label.text = "モード：カップ麺"
            mode_label.adjustsFontSizeToFitWidth = true
        } else {
            mode_label.text = "モード：筋トレ"
            mode_label.adjustsFontSizeToFitWidth = true
        }
        
        mode_label.frame = CGRect(x: self.view.bounds.width/2 - self.view.bounds.width/4,
                                  y: self.view.bounds.height/1.7,
                                  width: self.view.bounds.width/2,
                                  height: self.view.bounds.height/8)
//        mode_label.sizeToFit()
        mode_label.textAlignment = NSTextAlignment.center
//        mode_label.backgroundColor = UIColor.orange
        self.view.addSubview(mode_label)
        
        
        // !!!!!--------------------about start_Button-----------------------!!!!!
        // make myButton
        start_Button = UIButton()
        
        // size of Button, start_button and stop_button
        let bWidth: CGFloat = self.view.bounds.width / 4
        let bHeight: CGFloat = bWidth
        
        // position of Buttom , X and Y
        let posX: CGFloat = self.view.frame.width * 3/4 - bWidth/2
        let posY: CGFloat = self.view.frame.height/1.35
        
        // put Button and set size, backgroundcolor, shape
        start_Button.frame = CGRect(x: posX, y: posY, width: bWidth, height: bHeight)
        start_Button.backgroundColor = UIColor.red
        start_Button.layer.masksToBounds = true
        start_Button.layer.cornerRadius = 3.0
        start_Button.layer.borderWidth = 3.0
        start_Button.layer.cornerRadius = start_Button.frame.width / 2
        
        // set title and tag
        start_Button.setTitle("Start", for: .normal)
        start_Button.setTitleColor(UIColor.white, for: .normal)
        start_Button.tag = 1
        start_Button.setTitleColor(UIColor.black, for: .highlighted)
        
        // add event
        start_Button.addTarget(self, action: #selector(ViewController.onClick_start_Button(sender:)), for: .touchUpInside)
        
        // add Button to View
        self.view.addSubview(start_Button)
        
        // !!!!!--------------------about stop_Button-----------------------!!!!!
        stop_Button = UIButton()
        stop_Button.frame = CGRect(
            x: self.view.frame.width * 1/4 - bWidth/2,
            y: self.view.frame.height/1.35,
            width: bWidth,
            height: bHeight
        )
        stop_Button.backgroundColor = UIColor.blue
        stop_Button.layer.masksToBounds = true
        stop_Button.layer.cornerRadius = 3.0
        stop_Button.layer.borderWidth = 3.0
        stop_Button.layer.cornerRadius = start_Button.frame.width / 2
        
        // set title and tag
        stop_Button.setTitle("Stop", for: .normal)
        stop_Button.setTitleColor(UIColor.white, for: .normal)
        stop_Button.tag = 2
        stop_Button.setTitleColor(UIColor.black, for: .highlighted)
        
        // add event
        stop_Button.addTarget(self, action: #selector(ViewController.onClick_stop_Button(sender:)), for: .touchUpInside)
        
        self.view.addSubview(stop_Button)
        
        // !!!!!--------------------about mode_Button-----------------------!!!!!
        mode_Button = UIButton()
        mode_Button.frame = CGRect(
            x: self.view.frame.width * 1/2 - bWidth/2,
            y: self.view.frame.height/1.2,
            width: bWidth,
            height: bHeight
        )
        mode_Button.backgroundColor = UIColor.orange
        mode_Button.layer.masksToBounds = true
        mode_Button.layer.cornerRadius = 3.0
        mode_Button.layer.borderWidth = 3.0
        mode_Button.layer.cornerRadius = start_Button.frame.width / 2
        
        // set title and tag
        mode_Button.setTitle("モード", for: .normal)
        mode_Button.setTitleColor(UIColor.white, for: .normal)
        mode_Button.tag = 3
        mode_Button.setTitleColor(UIColor.black, for: .highlighted)
        
        mode_Button.addTarget(self, action: #selector(ViewController.onClick_mode_Button(sender:)), for: .touchUpInside)
        self.view.addSubview(mode_Button)
        
        // !!!!!-------------------about labels---------------------------!!!!!
        
        // make time label
        let Lwidth = self.view.bounds.width
        let Lheight = self.view.bounds.height / 5
        let LposX = self.view.bounds.width / 2 - Lwidth / 2
        let LposY = self.view.bounds.height / 3.5
        myLabel = UILabel(frame: CGRect(x:LposX,y:LposY,width:Lwidth,height:Lheight))
        myLabel.font = UIFont.systemFont(ofSize: CGFloat(40))
        myLabel.textAlignment = NSTextAlignment.center
        
        
        
        // !!!!!--------------------about audio(initial)---------------------------!!!!!
        // ready to audio play
        let audioPath = Bundle.main.path(forResource: "mona_timer_finish_normal", ofType:"wav")!
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
        
        // !!!!!--------------don't allow to side screen -------------!!!!!!
        var shouldAutorotate: Bool {
            get {
                return false
            }
        }
        
        var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            get {
                return .portrait
            }
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
    
    
    
    // !!!!!---------------------when start button is called ----------------!!!!!
    @objc internal func onClick_start_Button(sender: UIButton) {
        print("onClickMyButton:");
        // if already timer is started, stop
        timer.invalidate()
        myUIPicker.removeFromSuperview()
        h_label.removeFromSuperview()
        m_label.removeFromSuperview()
        s_label.removeFromSuperview()
//        mode_label.removeFromSuperview()
        
        self.view.addSubview(myLabel)
        
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
        temp = sum_of_seconds
        print("sum_of_seconds = \(sum_of_seconds)")
        
        if counter != 0 {
            mona_label.removeFromSuperview()
            counter = 0
        }
        
        // make timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update_time(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func update_time(timer: Timer){
        // activate background moving
        if (timer.isValid == true){
            stop_Button.setTitle("Stop", for: .normal)
        } else {
            stop_Button.setTitle("Restart", for: .normal)
        }
        
        self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        sum_of_seconds -= 1
        print("Decreased!")
        remain_h = sum_of_seconds / 3600
        remain_m = (sum_of_seconds - (3600 * remain_h)) / 60
        remain_s = sum_of_seconds - (remain_h * 3600 + remain_m * 60)
        
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
                self.view.addSubview(h_label)
                self.view.addSubview(m_label)
                self.view.addSubview(s_label)
                self.view.addSubview(myUIPicker)
                self.view.addSubview(mode_label)
                mona_label.removeFromSuperview()
            }
        }
        
        
        
        if counter == 0 {
            mona_label = UILabel()
            mona_label.frame = CGRect(x: self.view.bounds.width / 2 - self.view.bounds.width / 1.4 / 2,
                                      y: self.view.bounds.height/6,
                                      width: self.view.bounds.width/1.4,
                                      height: self.view.bounds.height/6)
            
//            mona_label.backgroundColor = UIColor.orange
            self.view.addSubview(mona_label)
            self.view.addSubview(myLabel)
        }
        
        if counter % 2 == 0{
            mona_label.text = "（  ´∀｀）も"
            mona_label.textAlignment = NSTextAlignment.left
            mona_label.font = UIFont.systemFont(ofSize: CGFloat(25))
            mona_label.adjustsFontSizeToFitWidth = true
        }else {
            mona_label.text = "  な (´∀｀ ）"
            mona_label.textAlignment = NSTextAlignment.right
            mona_label.font = UIFont.systemFont(ofSize: CGFloat(25))
            mona_label.adjustsFontSizeToFitWidth = true
        }
        
        myLabel.text = "\(remain_h) : \(remain_m) : \(remain_s) "
        
        counter += 1
        if counter == temp {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
        }
    }
    
    // !!!!!-------------------- when stop button is called --------------------!!!!!
    @objc internal func onClick_stop_Button(sender: UIButton) {
        // stop and ready to start
        if (timer.isValid == true){
            timer.invalidate()
            self.view.addSubview(h_label)
            self.view.addSubview(m_label)
            self.view.addSubview(s_label)
            self.view.addSubview(myUIPicker)
//            self.view.addSubview(mode_label)
            mona_label.removeFromSuperview()
            myLabel.removeFromSuperview()
            stop_Button.setTitle("Restart", for: .normal)
        } else { // after restart
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update_time(timer:)), userInfo: nil, repeats: true)
            myUIPicker.removeFromSuperview()
            h_label.removeFromSuperview()
            m_label.removeFromSuperview()
            s_label.removeFromSuperview()
//            mode_label.removeFromSuperview()
            self.view.addSubview(mona_label)
            self.view.addSubview(myLabel)
            stop_Button.setTitle("Stop", for: .normal)
        }
        
        
        button_counter += 1
        
        if (button_counter == 0){
            stop_Button.setTitle("Stop", for: .normal)
        }
    }
    
    // !!!!!-------------------- when mode button is called --------------------!!!!!
    @objc internal func onClick_mode_Button(sender: UIButton) {
        mode_identifier += 1
        if mode_identifier % 3 == 0 {
            mode_label.text = "モード：の〜まる"
            let audioPath = Bundle.main.path(forResource: "mona_timer_finish_normal", ofType:"wav")!
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
        } else if mode_identifier % 3 == 1 {
            mode_label.text = "モード：カップ麺"
            let audioPath = Bundle.main.path(forResource: "mona_timer_finish_cup_noodle", ofType:"wav")!
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
        } else {
            mode_label.text = "モード：筋トレ"
            let audioPath = Bundle.main.path(forResource: "mona_timer_training_finish", ofType:"wav")!
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
        }
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

