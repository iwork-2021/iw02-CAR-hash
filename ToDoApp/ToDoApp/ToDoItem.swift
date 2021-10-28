//
//  ToDoItem.swift
//  ToDoApp
//
//  Created by nju on 2021/10/26.
//

import UIKit

class ToDoItem: NSObject,Encodable,Decodable {
    var title:String
    var isChecked:Bool
    var type:String?

    init(title:String,isChecked:Bool,type:String?=nil){
        self.isChecked=isChecked
        self.title=title
        self.type=type
    }
}
