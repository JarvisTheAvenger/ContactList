//
//  contactModel.swift
//  ContactList
//
//  Created by Rahul Umap on 30/08/17.
//  Copyright © 2017 Rahul Umap. All rights reserved.
//
import Foundation
import RealmSwift

class ContactModel: Object {

    dynamic var name : String? = nil
    dynamic var address : String? = nil
    dynamic var contactNumber : String? = nil
    dynamic var image : Data? = nil

    override class func primaryKey() -> String?  {
        return "contactNumber"
    }

}
