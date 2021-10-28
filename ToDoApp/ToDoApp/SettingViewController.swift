//
//  SettingViewController.swift
//  ToDoApp
//
//  Created by nju on 2021/10/26.
//

import UIKit

protocol SettingAgent{
    func changeHideFinishedTasks()
    func setColor(r:CGFloat,g:CGFloat,b:CGFloat)
}

class SettingViewController: UIViewController {

    @IBOutlet weak var redSlider: UISlider!
    
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setSlider(s: redSlider, v: redColor)
        setSlider(s: greenSlider, v: greenColor)
        setSlider(s: blueSlider, v: blueColor)
    }
    
    var settingAgent:SettingAgent?
    var redColor:CGFloat=0
    var greenColor:CGFloat=0
    var blueColor:CGFloat=0
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func InitScene(bColor:UIColor){
        redColor=bColor.cgColor.components![0]
        greenColor=bColor.cgColor.components![1]
        blueColor=bColor.cgColor.components![2]
        self.view.backgroundColor=UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1)
    }
    func setSlider(s:UISlider,v:CGFloat){
        s.value=Float(v)
    }
    
    @IBAction func onSwitch(_ sender: Any) {
        settingAgent?.changeHideFinishedTasks()
    }
    @IBAction func onSliderChange(){
        redColor=CGFloat(redSlider.value)
        greenColor=CGFloat(greenSlider.value)
        blueColor=CGFloat(blueSlider.value)
        settingAgent?.setColor(r: redColor, g: greenColor, b: blueColor)
        self.view.backgroundColor=UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1)
    }
}
