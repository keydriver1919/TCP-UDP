//
//  UDPViewController.swift
//  TCPUDP
//
//  Created by change on 2021/12/28.
//

import UIKit
import CocoaAsyncSocket

class UDPViewController: UIViewController,GCDAsyncUdpSocketDelegate {

    let IP = "255.255.255.255"
    var udpSocket: GCDAsyncUdpSocket!
    
    
    @IBOutlet weak var portTextField: UITextField!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var udpMessageTextView: UITextView!
    
    func showMessage(_ string: String) {
        udpMessageTextView.text = udpMessageTextView.text.appendingFormat("%@\n", string)
    }
    
    func dateString() -> String{
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: currentTime)
        
        return date
    }
    
//MARK: - socket
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        
        print("didReceiveData")
        var host: NSString?
        var port: UInt16 = 0
        
        //取得Host端資訊
        GCDAsyncUdpSocket.getHost(&host, port: &port, fromAddress: address)
        
        //顯示Host IP
        showMessage("From IP: \(host! as String) ")
        
        //顯示資料
        showMessage(": \(String(data: data, encoding: String.Encoding.utf8)!)")
        
        print("From \(host!)")
        print("incoming message: \(String(data: data, encoding: String.Encoding.utf8)!)")
    }
    
    //UDP socket未連線成功
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        print("socket未連線成功： \(error!)")
    }
    
    //斷掉連結
    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        print("斷開連結錯誤:\(error!)")
    }
    
    //訊息發送失敗
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print("訊息發送失敗")
    }
   
    //訊息發送成功
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        print("訊息發送成功")
    }
    
    
//MARK: - IBAaction
    
    @IBAction func udpBindButton(_ sender: Any) {
        
        do {
            try udpSocket.bind(toPort: UInt16(portTextField.text!)!)
            showMessage(dateString())
            showMessage("已經綁定窗口： \(UInt16(portTextField.text!)!)")
            showMessage("-------------------------------------")
        }catch {
            showMessage("窗口綁定失敗")
        }
        
        do {
            //開始廣播
            try udpSocket.enableBroadcast(true)
            print("開始廣播")
        }catch {
            print("廣播失敗")
        }
        
        do {
            //開始接收
            try udpSocket.beginReceiving()
            print("開始接收")
        }catch {
            print("接收失敗")
        }
        
        view.endEditing(true)
    }

    //timeout = 一直等待
    @IBAction func udpSearchButton(_ sender: Any) {
        let data = messageTextField.text?.data(using: .utf8)
        udpSocket.send(data!, toHost: IP, port: UInt16(portTextField.text!)!, withTimeout: -1, tag: 0)
        
        view.endEditing(true)
    }
    
        
    @IBAction func clearMessageButton(_ sender: Any) {
        udpMessageTextView.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
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
