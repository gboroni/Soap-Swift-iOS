//
//  WsClient.swift
//  DireitoMais
//
//  Created by Guilherme Boroni on 19/04/16.
//  Copyright © 2016 Fanese. All rights reserved.
//

import UIKit
import Alamofire


class WsClient: NSObject, NSXMLParserDelegate{
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    
    func request() {
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soapenv:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:ws='http://ws.eventos.com.br/'><soapenv:Header/><soapenv:Body><ws:findParticipanteByNrCPF soapenv:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><String_1 xsi:type='xsd:string'>07103203458</String_1></ws:findParticipanteByNrCPF></soapenv:Body></soapenv:Envelope>"
        
        
        let custom: (URLRequestConvertible, [String: AnyObject]?) -> (NSMutableURLRequest, NSError?) = {
            (convertible, parameters) in
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            let bodyData:NSData = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)!
            mutableRequest.HTTPBody = bodyData
            return (mutableRequest, nil)
        }

        
        let url = "http://10.2.2.81:8080/br.com.eventos.ws/MobilePort?wsdl"
        
        let headers = [
            "Content-Type": "text/xml; charset=utf-8"
        ]
        
        
        Alamofire.request(.POST, url, parameters: [:], encoding: .Custom(custom), headers: headers)
            .responseString { response in
                print("Response String: \(response.result.value)") 
                let xmlParser = NSXMLParser(data:response.data!)
                xmlParser.delegate = self
                xmlParser.parse()
                xmlParser.shouldResolveExternalEntities = true
        }
        
    
        
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {

        
    }
    
    // NSXMLParserDelegate
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName
    }
   
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
//        if currentElementName == "CelsiusToFahrenheitResult" {
            print(currentElementName)
            print(string)
//        }
    }


}
