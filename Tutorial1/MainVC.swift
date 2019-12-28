//
//  MainVC.swift
//  Tutorial1
//
//  Created by wi on 2019/12/18.
//  Copyright © 2019 튜토리얼. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    enum ButtonTag:Int {
        case start = 10
        case check = 20
        case stop = 30
        case reset = 40
    }
    
    @IBOutlet weak var lapTableView: UITableView!
    var lapTableviewData = [String]()
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var decimalLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var mainTimer:Timer?
    var timeCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lapTableView.delegate = self
        lapTableView.dataSource = self
        setButton(button: startButton, tag: .start)
        setButton(button: checkButton, tag: .check)
        setButton(button: stopButton, tag: .stop)
        setButton(button: resetButton, tag: .reset)
        checkButton.isEnabled = false
    }
    
    func setButton(button:UIButton, tag:ButtonTag){
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button.tag = tag.rawValue
    }
    
    @objc func buttonAction(_ button:UIButton) {
        if let select = ButtonTag(rawValue: button.tag) {
            switch select {
            case .start: startAction()
            case .check: checkAction()
            case .reset: resetAction()
            case .stop : stopAction()
            }
        } else {
            print("존재하지않는 태그를 가진 버튼의 입력이 들어왔습니다.")
        }
    }
    
    func startAction() {
        print("start")
        startButton.isEnabled = false
        checkButton.isEnabled = true
        stopButton.isEnabled = true
        mainTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (_) in
            self.timeCount += 1
            DispatchQueue.main.async {
                let timeString = self.makeTimeLabel(count: self.timeCount)
                self.timeLabel.text = timeString.0
                self.decimalLabel.text = ".\(timeString.1)"
            }
        })
    }
    
    func checkAction() {
        print("check")
        let timeString = self.makeTimeLabel(count: self.timeCount)
        self.lapTableviewData.append("\(timeString.0).\(timeString.1)")
        let indexPath = IndexPath(row: self.lapTableviewData.count - 1, section: 0)
        self.lapTableView.insertRows(at: [indexPath], with: .automatic)
        self.lapTableView.scrollToRow(at: indexPath, at: .none, animated: true)
    }
    
    func stopAction() {
        print("stop")
        mainTimer?.invalidate()
        mainTimer = nil
        startButton.isEnabled = true
        checkButton.isEnabled = false
        stopButton.isEnabled = false
    }
    
    func resetAction() {
        mainTimer?.invalidate()
        mainTimer = nil
        timeCount = 0
        timeLabel.text = "00:00"
        decimalLabel.text = ".0"
        self.lapTableviewData.removeAll()
        self.lapTableView.reloadData()
        stopButton.isEnabled = false
        checkButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    func makeTimeLabel(count:Int) -> (String,String) {
        //return - (TimeLabel, decimalLabel)
        let decimalSec  = count % 10
        let sec = (count / 10) % 60
        let min = (count / 10) / 60
        
        let sec_string = "\(sec)".count == 1 ? "0\(sec)" : "\(sec)"
        let min_string = "\(min)".count == 1 ? "0\(min)" : "\(min)"
        return ("\(min_string):\(sec_string)","\(decimalSec)")
    }
}
extension MainVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapTableviewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableviewCell.cell_id, for: indexPath) as! MainTableviewCell
        let item = self.lapTableviewData[indexPath.row]
        cell.timeLabel.text = item
        return cell
    }
    
}
