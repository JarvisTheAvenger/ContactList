//
//  ContactListViewController.swift
//  ContactList
//
//  Created by Rahul Umap on 30/08/17.
//  Copyright © 2017 Rahul Umap. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ContactListViewController: UIViewController {

    @IBOutlet weak var contactListTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!

    var numberOfContact:Results<ContactModel>?

    let realm = try! Realm()

    var numberOfContactArray : [ContactModel]? = nil



    //   var numberOfContactArray: [Array] = [Array]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup(){
        contactListTableView.register(UINib.init(nibName: "ContactListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ContactListTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        numberOfContact = realm.objects(ContactModel.self)

        numberOfContactArray = numberOfContact?.toArray(ofType: ContactModel.self)
        print(numberOfContactArray ?? "")
        self.contactListTableView.reloadData()
    }

    @IBAction func addButtonAction(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    @IBAction func editButtonAction(_ sender: Any) {
        contactListTableView.setEditing(!contactListTableView.isEditing, animated: true)
        if contactListTableView.isEditing == true{
         editButton.setTitle("Done", for: UIControlState.normal)
        }else{
         editButton.setTitle("Edit", for: UIControlState.normal)
        }
    }
}

extension ContactListViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (numberOfContactArray?.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ContactListTableViewCell", for: indexPath) as! ContactListTableViewCell
        let dict  = numberOfContactArray?[indexPath.row]
        cell.nameLabel.text   = dict?.value(forKey: "name") as? String
        cell.contactNumberLabel.text   = dict?.value(forKey: "contactNumber") as? String
        cell.addressLabel.text   = dict?.value(forKey: "address") as? String
        cell.contactImage.image = (dict?.value(forKey: "image") as? Data)?.uiImage
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           let object = numberOfContactArray?[indexPath.row]
            numberOfContactArray?.remove(at: indexPath.row)

            try! realm.write {
                realm.delete(object!)
            }
           tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let object = numberOfContactArray?[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.contactModelObject = object
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension Data {
    var uiImage: UIImage? {
        return UIImage(data: self)
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
