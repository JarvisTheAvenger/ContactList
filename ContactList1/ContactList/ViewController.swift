//
//  ViewController.swift
//  ContactList
//
//  Created by Rahul Umap on 30/08/17.
//  Copyright © 2017 Rahul Umap. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ViewController: UIViewController,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var enterPhoneNumber: UITextField!
    @IBOutlet weak var addressTextfield: UITextField!
    @IBOutlet weak var contactImageView: UIImageView!


     var picker:UIImagePickerController?=UIImagePickerController()

    var imageData  : Data? = nil

    @IBOutlet weak var saveButton: UIButton!
    var contactModelObject :  ContactModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
      setup()
    }

    func setup(){
        contactImageView.layer.borderWidth = 1.0
        contactImageView.layer.masksToBounds = false
        contactImageView.layer.borderColor = UIColor.white.cgColor
        contactImageView.layer.cornerRadius = contactImageView.frame.size.height/2
        contactImageView.clipsToBounds = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped))
        contactImageView.isUserInteractionEnabled = true
        contactImageView.addGestureRecognizer(tapGestureRecognizer)

        picker?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        saveButton.setTitle("Save", for: .normal)
        if let object = contactModelObject{
          contactImageView.image = object.image?.uiImage
          nameTextfield.text = object.name
          addressTextfield.text = object.address
          enterPhoneNumber.text = object.contactNumber
          saveButton.setTitle("Update", for: .normal)
        }
    }


    func imageTapped(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker?.sourceType = UIImagePickerControllerSourceType.camera
            picker?.allowsEditing = true
            self.present(picker!, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallary()
    {
        picker?.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker?.allowsEditing = true
        self.present(picker!, animated: true, completion: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            if let data:Data = UIImagePNGRepresentation(image) {
             imageData = data
              contactImageView.image = image
            }
        } else{
            print("Something went wrong")
        }

        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

        let realm = try! Realm()

        let contact = ContactModel()

        contact.address = addressTextfield.text
        contact.contactNumber = enterPhoneNumber.text
        contact.name = nameTextfield.text
        //contact.image = imageData as Data

        print(contact)

        if saveButton.title(for: .normal) == "Save"{
            try! realm.write {
                realm.add(contact)
            }
        }else{
            try! realm.write {
                realm.add(contact, update: true)
            }
        }

    }
}


extension ViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

