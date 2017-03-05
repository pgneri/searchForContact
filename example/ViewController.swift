//
//  ViewController.swift
//  example
//
//  Created by 2017 Patrícia Gabriele Neri on 05/03/17.
//  Copyright © 2017 Patrícia Gabriele Neri. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {

    lazy var contacts: [CNContact] = {
        let contactStore = CNContactStore()
        let keysToFetch: [CNKeyDescriptor] = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor]

        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [CNContact] = []

        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }

        return results
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let contact: CNContact = searchForContactUsingPhoneNumber(phoneNumber: "888-555-5512")
        print(contact.givenName+" "+contact.familyName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchForContactUsingPhoneNumber(phoneNumber: String) -> CNContact {

        var result: CNContact = CNContact()

        for contact in self.contacts {
            if (!contact.phoneNumbers.isEmpty) {
                let phoneNumberToCompareAgainst = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                for phoneNumber in contact.phoneNumbers {
                    if let phoneNumberStruct = phoneNumber.value as? CNPhoneNumber {
                        let phoneNumberString = phoneNumberStruct.stringValue
                        let phoneNumberToCompare = phoneNumberString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                        if phoneNumberToCompare == phoneNumberToCompareAgainst {
                            result = contact
                        }
                    }
                }
            }
        }

        return result
    }
}
