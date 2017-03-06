//
//  Contacts
//  example
//
//  Created by 2017 Patrícia Gabriele Neri on 05/03/17.
//  Copyright © 2017 Patrícia Gabriele Neri. All rights reserved.
//

import UIKit
import Contacts

struct Contacts {

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

    mutating func searchForContactUsingPhoneNumber(phoneNumber: String) -> String {
    
        var result: String = phoneNumber
        
        for contact in self.contacts {
            if !contact.phoneNumbers.isEmpty {
                let phoneNumberToCompareAgainst = phoneNumber.onlyDigits()
                for phoneNumber in contact.phoneNumbers {
                    if let phoneNumberStruct: CNPhoneNumber = phoneNumber.value {
                        let phoneNumberString = phoneNumberStruct.stringValue
                        let phoneNumberToCompare = phoneNumberString.onlyDigits()
                        if phoneNumberToCompare.substringPhoneNumber() == phoneNumberToCompareAgainst.substringPhoneNumber() {
                            result = contact.givenName+" "+contact.familyName
                        }
                    }
                }
            }
        }
        return result
    }
}

extension String {
    func onlyDigits() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }

    func substringPhoneNumber() -> String {
        return String(self.characters.suffix(10))
    }
}
