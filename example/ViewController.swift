//
//  ViewController.swift
//  example
//
//  Created by 2017 Patrícia Gabriele Neri on 05/03/17.
//  Copyright © 2017 Patrícia Gabriele Neri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var contacts: Contacts = Contacts()

    override func viewDidLoad() {
        super.viewDidLoad()
        let contact = contacts.searchForContactUsingPhoneNumber(phoneNumber: "8885555512")
        print(contact)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
