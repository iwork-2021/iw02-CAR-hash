//
//  ItemViewController.swift
//  ToDoApp
//
//  Created by nju on 2021/10/26.
//

import UIKit

protocol AddItemDelegate{
    func addItem(item:ToDoItem)
}

protocol EditItemDelegate{
    func editItem(newItem:ToDoItem,itemIndex:Int)
}

class ItemViewController: UIViewController {
    
    @IBOutlet weak var type: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var isCheckedSwitch: UISwitch!
    @IBOutlet weak var doneButton: UIButton!
    
    var addItemDelegate:AddItemDelegate?
    var editItemDelegate:EditItemDelegate?
    var itemToEdit:ToDoItem?
    var itemIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if itemToEdit==nil{
            doneButton.isEnabled=false
            isCheckedSwitch.isOn=false
        }else{
            doneButton.isEnabled = !itemToEdit!.title.isEmpty
            isCheckedSwitch.isOn=itemToEdit!.isChecked
            textField.text=itemToEdit!.title
        }
    }
    

    @IBAction func done(_ sender: Any) {
        if itemToEdit==nil{
            addItemDelegate?.addItem(item: ToDoItem(title: textField.text!, isChecked: isCheckedSwitch.isOn))
        }else{
            self.editItemDelegate?.editItem(newItem: ToDoItem(title: textField.text!, isChecked: isCheckedSwitch.isOn), itemIndex: self.itemIndex)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ItemViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldtext=textField.text!
        let stringRange=Range(range, in: oldtext)!
        let newtext=oldtext.replacingCharacters(in: stringRange, with: string)
        doneButton.isEnabled = !newtext.isEmpty
        return true
    }
}
