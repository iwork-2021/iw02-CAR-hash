//
//  ToDoTableViewController.swift
//  ToDoApp
//
//  Created by nju on 2021/10/26.
//

import UIKit

class ToDoTableViewController: UITableViewController {

    var items:[ToDoItem]=[
    ]
    var hidefinishedTasks:Bool=false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.prefersLargeTitles=true
        self.tableView.backgroundColor=UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        load()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if hidefinishedTasks==false{
            return items.count
        }
        else{
            var count:Int=0
            for item in items {
                if item.isChecked==false{
                    count=count+1
                }
            }
            return count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoTableViewCell
        let item=items[indexPath.row]

        // Configure the cell...
        if item.isChecked{
            cell.status.text="finished"
            cell.status.textColor = UIColor.green
        }else{
            cell.status.text="pending"
            cell.status.textColor = UIColor.red
        }
        cell.title.text=item.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier=="addItem"{
            let addItemViewController=segue.destination as! ItemViewController
            addItemViewController.addItemDelegate = self
            addItemViewController.view.backgroundColor=self.tableView.backgroundColor
        }else if segue.identifier=="editItem"{
            let editItemViewController=segue.destination as! ItemViewController
            let cell=sender as! ToDoTableViewCell
            
            editItemViewController.editItemDelegate=self
            
            var isChecked:Bool
            
            if cell.status.text=="finished"{
                isChecked=true
            }else{
                isChecked=false
            }
            let item=ToDoItem(title: cell.title.text!, isChecked: isChecked)
            editItemViewController.itemIndex=tableView.indexPath(for: cell)!.row
            editItemViewController.itemToEdit=item
            editItemViewController.view.backgroundColor=self.tableView.backgroundColor
        }else if segue.identifier=="setting"{
            let settingViewController=segue.destination as! SettingViewController
            
            settingViewController.settingAgent=self
            settingViewController.InitScene(bColor: self.tableView.backgroundColor!)
        }
    }
    

}
extension ToDoTableViewController:AddItemDelegate{
    func addItem(item:ToDoItem){
        if item.isChecked==true{
            items.append(item)
        }else{
            var i:Int = 0
            while i<items.count && items[i].isChecked==false{
                i=i+1
            }
            if i==items.count{
                items.append(item)
            }else{
                items.insert(item, at: i)
            }
        }
        self.tableView.reloadData()
    }
}
extension ToDoTableViewController:EditItemDelegate{
    func editItem(newItem:ToDoItem,itemIndex:Int){
        items.remove(at: itemIndex)
        self.addItem(item: newItem)
        self.tableView.reloadData()
    }
}
extension ToDoTableViewController{
    func save(){
        saveAllItems()
        saveSettings()
    }
    func load(){
        loadItems()
        loadSettings()
    }
    
    func dataFilePath()->URL{
        let path=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return path!.appendingPathComponent("todoItems.json")
    }
    func configFilePath()->URL{
        let path=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return path!.appendingPathComponent("config1.json")
    }
    func configcolorFilePath()->URL{
        let path=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return path!.appendingPathComponent("config2.json")
    }
    func saveAllItems(){
        do{
            let data=try JSONEncoder().encode(items)
            try data.write(to: dataFilePath(),options: .atomic)
        }catch{
            print("Cannot save: \(error.localizedDescription)")
        }
    }
    func loadItems(){
        let path=dataFilePath()
        if let data=try?Data(contentsOf: path){
            do{
                items=try JSONDecoder().decode([ToDoItem].self, from: data)
            }catch{
                print("Error decoding list:\(error.localizedDescription)")
            }
        }
    }
    func saveSettings(){
        do{
            let data=try JSONEncoder().encode(hidefinishedTasks)
            try data.write(to: configFilePath(),options: .atomic)
            
            var color:[Float]=[]
            let r=self.tableView.backgroundColor?.cgColor.components![0]
            let g=self.tableView.backgroundColor?.cgColor.components![1]
            let b=self.tableView.backgroundColor?.cgColor.components![2]
            color.append(Float(r!))
            color.append(Float(g!))
            color.append(Float(b!))
            let data2=try JSONEncoder().encode(color)
            try data2.write(to: configcolorFilePath(),options: .atomic)
        }catch{
            print("Cannot save: \(error.localizedDescription)")
        }
    }
    func loadSettings(){
        let path=configFilePath()
        if let data=try?Data(contentsOf: path){
            do{
                hidefinishedTasks=try JSONDecoder().decode(Bool.self, from: data)
            }catch{
                print("Error decoding list:\(error.localizedDescription)")
            }
        }
        let path2=configcolorFilePath()
        if let data2=try?Data(contentsOf: path2){
            do{
                let color=try JSONDecoder().decode([Float].self, from: data2)
                let r=CGFloat(color[0])
                let g=CGFloat(color[1])
                let b=CGFloat(color[2])
                self.tableView.backgroundColor=UIColor(red: r, green: g, blue: b, alpha: 1)
            }catch{
                print("Error decoding list:\(error.localizedDescription)")
            }
        }
    }
}
extension ToDoTableViewController:SettingAgent{
    func changeHideFinishedTasks() {
        hidefinishedTasks = !hidefinishedTasks
        self.tableView.reloadData()
    }
    func setColor(r:CGFloat,g:CGFloat,b:CGFloat){
        self.tableView.backgroundColor=UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
