//
//  ViewController.swift
//  ConnectionModule
//
//  Created by SYS005 on 3/29/17.
//  Copyright © 2017 SYS005. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let conn = Connection()
        let para = ["ext":"91","phone":"123456789","device_type":"IOS"]
        conn.TosendRequest(httpMethod: "POST", para: para, stringUrl: "http://104.130.26.84/beacon/public/api/auth/login")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

