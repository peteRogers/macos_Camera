//
//  Arduino_Connector.swift
//  macos_Camera
//
//  Created by Peter Rogers on 15/05/2023.
//

import Foundation
import ORSSerial

class ArduinoConnector: NSObject, ObservableObject, ORSSerialPortDelegate{
    
    @Published var receivedData: String = ""
    var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            oldValue?.delegate = nil
            serialPort?.delegate = self
        }
    }
    weak var delegate: SerialPortDelegate?
    
    override init(){
        super.init()
        openOrClosePort()
    }
    
    
    
    func openOrClosePort() {
       
        let availablePorts = ORSSerialPortManager.shared().availablePorts
        print(availablePorts)
        self.serialPort = ORSSerialPort(path: availablePorts[0].path)
        // self.serialPort = availablePorts[0]
        self.serialPort?.baudRate = 9600
        self.serialPort?.open()
        
        
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceivePacket packetData: Data, matching descriptor: ORSSerialPacketDescriptor) {
        if let dataAsString = NSString(data: packetData, encoding: String.Encoding.ascii.rawValue) {
            let valueString = dataAsString.substring(with: NSRange(location: 1, length: dataAsString.length-2))
            
            let inArray = valueString.components(separatedBy: ",")
           
            
            if(inArray[1] == "A"){
                Task {
                        await delegate?.didReceiveData("A")
                    }
               
            }
            if(inArray[1] == "B"){
                //etc etc
            }
            
            
        }
        
    }
    

    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        //self.openCloseButton.title = "Close"
        let descriptor = ORSSerialPacketDescriptor(prefixString: "<", suffixString: ">", maximumPacketLength: 8, userInfo: nil)
        serialPort.startListeningForPackets(matching: descriptor)
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        //self.openCloseButton.title = "Open"
    }
    
    
    
    
    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
        self.serialPort = nil
        // self.openCloseButton.title = "Open"
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("SerialPort \(serialPort) encountered an error: \(error)")
    }
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        // ah well
    }
    
    
}

protocol SerialPortDelegate: AnyObject {
    func didReceiveData(_ data: String) async
}
