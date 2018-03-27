
import UIKit
import SystemConfiguration

class WebServiceHelper: NSObject
{
    typealias SuccessHandler = (Data) -> Void
    typealias FailureHandler = (Error) -> Void
    
    let NO_NETWORK               = "Please check the internet connectivity."
    
    // MARK: - Helper Methods
    
    class func webServiceCall(_ strURL : String, params : [String : AnyObject]?, httpMethod : String, isShowLoader : Bool, success : @escaping SuccessHandler, failure : @escaping FailureHandler)
    {
        if self.isConnectedToNetwork()
        {
            if !strURL.isEmpty
            {
                //                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                //                SVProgressHUD.show()
                
                let url = NSURL(string:strURL)!
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = httpMethod
                if let para = params
                {
                    let jsonRequestData = try? JSONSerialization.data(withJSONObject: para, options: .prettyPrinted)
                    request.httpBody = jsonRequestData
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                    //              SVProgressHUD.dismiss()
                    guard let data = data else {failure(error!); return}
                    success(data)
                }
                task.resume()
            }
        }
        else{
            if !((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.isKind(of: UIAlertController.self))!
            {
                self.alertForOK(msg:"Please check the internet connectivity.")
            }
        }
    }
    
      class func webServiceCallUploadImages(_ params:[String:Any], imageData:[UIImage], strURL:String, isMultiplaeImageUpload:Bool, imagePara:String ,success : @escaping SuccessHandler, failure : @escaping FailureHandler)
        {
            if self.isConnectedToNetwork()
            {
                if !strURL.isEmpty
                {
                    //                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    //                SVProgressHUD.show()
    
                    var request = URLRequest(url: URL(string: strURL)!)
                    request.httpMethod = "POST"
                    let boundary = "Boundary-\(UUID().uuidString)"
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
                    var body: Data = Data()
                    // parameters to send i.e. text
                    for (key, value) in params
                    {
                        body.append(string: "--\(boundary)\r\n")
                        body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                        body.append(string: "\(value)\r\n")
                    }
    
                    // you can also send multiple images
                    if isMultiplaeImageUpload
                    {
                        for i in (0..<imageData.count)
                        {
                            let filename = "photo\(i+1).jpg"
                            let mimetype = "image/jpg"
                            let imagePara = "\(imagePara)\(i+1)"
                            let imageDataKey = UIImageJPEGRepresentation(imageData.first!, 0.6)
                            body.append(string: "--\(boundary)\r\n")
                            body.append(string: "Content-Disposition: form-data; name=\"\(imagePara)\"; filename=\"\(filename)\"\r\n")
                            body.append(string: "Content-Type: \(mimetype)\r\n\r\n")
                            body.append(imageDataKey!)
                            body.append(string: "\r\n")
                        }
                    }
                    else if imageData.count > 0 {
                        let filename = "user-profile.jpg"
                        let mimetype = "image/jpg"
                        let imageDataKey = UIImageJPEGRepresentation(imageData.first!, 0.6)
                        body.append(string: "--\(boundary)\r\n")
                        body.append(string: "Content-Disposition: form-data; name=\"\(imagePara)\"; filename=\"\(filename)\"\r\n")
                        body.append(string: "Content-Type: \(mimetype)\r\n\r\n")
                        body.append(imageDataKey!)
                        body.append(string: "\r\n")
                    }
                    body.append(string: "--\(boundary)--\r\n")
                    request.httpBody = body
                    //To handel Response
                    let task = URLSession.shared.dataTask(with: request){ data,response,error in
                        //              SVProgressHUD.dismiss()
                        guard let data = data else {failure(error!); return}
                        success(data)
                    }
                    task.resume()
                }
                
            }
            else
            {
                if !((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.isKind(of: UIAlertController.self))!
                {
                    self.alertForOK(msg:"Please check the internet connectivity.")
                }
            }
        }
    // MARK: - Internet Connectivity
    
   class func isConnectedToNetwork() -> Bool
   {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
   class func alertForOK(msg:String)
    {
        if !((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.isKind(of: UIAlertController.self))!
        {
            let avc = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                
            }
            avc.addAction(okAction)
            DispatchQueue.main.async {
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(avc, animated: true, completion: nil)
            }
            
        }
    }
}

extension Data {
    mutating func append(string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
}
