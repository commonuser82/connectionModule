//
//  ConnectionFile.swift
//  ConnectionModule
//
//  Created by SYS005 on 3/29/17.
//  Copyright © 2017 SYS005. All rights reserved.
//

import Foundation
import UIKit
protocol ResponseProtocol
{
    func ToHandelReponse(response:AnyObject,apiName:String)
    func ToHandelReponseError(errorMessage:String)
    
}

class Connection
{
    var del:ResponseProtocol?
    
    
    func TosendRequest(httpMethod:String,para:[String:Any],stringUrl:String)
    {
        if !stringUrl.isEmpty
        {
          
           // let jsonData : NSData = NSKeyedArchiver.archivedData(withRootObject: para) as NSData
            
            
            let url = NSURL(string:stringUrl)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = httpMethod
            
            do
            {
                let jsonRequestData = try JSONSerialization.data(withJSONObject: para, options: .prettyPrinted)
                request.httpBody=jsonRequestData
            }
            catch
            {
                
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
               
                if error == nil
                {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                        
                        print("Result",result!)
                        
                        self.del?.ToHandelReponse(response: result as AnyObject, apiName: url.lastPathComponent!)
                        
                        
                    } catch {
                        print("Error -> \(error)")
                        self.del?.ToHandelReponseError(errorMessage: error.localizedDescription)
                    }

                }
                else
                {
                     self.del?.ToHandelReponseError(errorMessage: (error?.localizedDescription)!)
                }
               
            }
            
            task.resume()
        }
    }
    func TosendRequestForUploadImage(para:[String:Any],imageData:[UIImage],stringUrl:String)
    {
        
        
        if !stringUrl.isEmpty
        {
            
            let _ : NSData = NSKeyedArchiver.archivedData(withRootObject: para) as NSData
            
            
            let url = NSURL(string:stringUrl)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
           
            let body: NSMutableData = NSMutableData()
            let boundary = "Boundary-\(UUID().uuidString)"
          
            
            // parameters to send i.e. text
            let paramsArray = para.keys
            for item in paramsArray {
                body.append(("--\(boundary)\r\n" as String).data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                body.append("Content-Disposition: form-data; name=\"\(item)\"\r\n\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                body.append("\(para[item]!)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            }
            
            // you can also send multiple images
            
                for i in (0..<imageData.count) {
                    body.append(("--\(boundary)\r\n" as String).data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                    body.append("Content-Disposition: form-data; name=\"Image\(i+1)\"; filename=\"photo\(i+1).jpeg\"\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                    
                    // change quality of image here
                    body.append(UIImageJPEGRepresentation(imageData[i], 0.5)!)
                    body.append("\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                }
           
            
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            
            
            
            
            let task = URLSession.shared.uploadTask(with: request as URLRequest, from: request.httpBody){ data,response,error in
                
                if error != nil
                {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                        
                        print("Result",result!)
                        
                        self.del?.ToHandelReponse(response: result as AnyObject, apiName: url.lastPathComponent!)
                        
                        
                    } catch {
                        print("Error -> \(error)")
                        self.del?.ToHandelReponseError(errorMessage: error.localizedDescription)
                    }
                    
                }
                else
                {
                    self.del?.ToHandelReponseError(errorMessage: (error?.localizedDescription)!)
                }
                
            }
            
            task.resume()
        }
    }
}

