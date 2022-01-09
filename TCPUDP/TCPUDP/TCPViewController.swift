//
//  TCPViewController.swift
//  TCPUDP
//
//  Created by change on 2021/12/28.
//


import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController,GCDAsyncSocketDelegate {

    var socket: GCDAsyncSocket!
    
    @IBOutlet weak var bindButton: UIButton!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
//MARK: - connectButton
    
    @IBAction func connectButtonAction(_ sender: Any) {
        bindButton.isSelected = !bindButton.isSelected
        bindButton.isSelected ? connect() : stopConnect()
        
        if bindButton.isSelected {
            bindButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }else {
            bindButton.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.6784313725, blue: 1, alpha: 1)
        }
    }
    
    func connect() {
        bindButton.setTitle("Unbind", for: .normal)
        
        do {
            try socket.connect(toHost: addressTextField.text!, onPort: UInt16(portTextField.text!)!, withTimeout: -1)
        } catch {
            print("連線狀態： 連線失敗")
        }
        view.endEditing(true)
    }
    
    func stopConnect() {
        bindButton.setTitle("Bind", for: .normal)
        socket.disconnect()
    }
    
//MARK: - sendButton
    
    @IBAction func sendButtonAction(_ sender: Any) {
        let data = messageTextField.text?.data(using: .utf8)
        showMessage(dateString() + "\nClient：" + messageTextField.text! + "\n")
        socket.write(data, withTimeout: -1, tag: 0)
        
        view.endEditing(true)
        messageTextField.text = ""
    }
    
    func dateString() -> String{
        let currentTime = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.string(from: currentTime)
        
        return date
    }
    
    
    func showMessage(_ str: String) {
        messageTextView.text = messageTextView.text.appendingFormat("%@\n", str)
    }
    
    
//MARK: - clearButton
    
    @IBAction func clearButtonAction(_ sender: Any) {
        messageTextView.text = ""
    }
  
//MARK: -  viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        showMessage(dateString())
        showMessage("連線狀態： 連線成功")
        let address = "Server IP: " + "\(host) "
        showMessage(address)
        showMessage("-----------------------------------------")
        socket.readData(withTimeout: -1, tag: 0)
    }
    
    //接收Server端回傳訊息
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let text = String(data: data, encoding: .utf8)
        showMessage(dateString() + "\nServer： " + text! + "\n")
        socket.readData(withTimeout: -1, tag: 0)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        showMessage("切斷連結")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

