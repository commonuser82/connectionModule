//
//  JsonEncodedViewController.swift
//  ConnectionModule
//
//  Created by SYS005 on 12/26/17.
//  Copyright © 2017 SYS005. All rights reserved.
//

import UIKit

class JsonEncodedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        jsonDecoding()
        // Do any additional setup after loading the view.
    }
    func jsonDecoding() {
        
        let jsonUrlString = "http://104.130.26.84:1337/countries"
        WebServiceHelper.webServiceCall(jsonUrlString, params: [:], httpMethod: "get", isShowLoader: true, success: { (data) in
            do {
                
                let animeJsonStuff =  try JSONDecoder().decode(ModelClass.self, from: data)
                for anime in animeJsonStuff.data {
                    
                    print(anime.id!)
                    print(anime.countries_name!)
                    
                }
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
        }) { (error) in
           
            print(error.localizedDescription)
        }
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
