//
//  ViewController.swift
//  SwiftSQLite
//
//  Created by Vasudha Jags on 11/3/17.
//  Copyright © 2017 Vasudha J. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {

    var database: Connection!
    let usersTable :Table = Table("users")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite")
            let dataBase = try Connection(fileURL.path)
            self.database = dataBase
        }catch{
            print("Error")
        }
       // createTable()
        insertUser(name: "Vasudha", email: "vasudha.iosdev@gmail.com")
        insertUser(name: "Vasudha2", email: "vasudha2.iosdev@gmail.com")
          insertUser(name: "Vasudha3", email: "vasudha3.iosdev@gmail.com")
        listUser()

        updateUser(userIdString: "3", email: "vasudha.iosdev3@gmail.com")
        listUser()
        
        deleteUser(userIdString: "2")
        listUser()


    }

    func createTable(){
        let createTable = self.usersTable.create { (table) in
            table.column(self.id, primaryKey : true )
            table.column(self.name)
            table.column(self.email, unique : true)
        }
        do{
            try self.database.run(createTable)
            print("created Table")
            
        }catch{
            print(error)
        }
    }
    func insertUser(name : String, email : String){
       
        let insertUser = self.usersTable.insert(self.name <- name , self.email <- email)
        do{
            try self.database.run(insertUser)
            print("User inserted")
        }catch{
            print(error)
        }
    }
    
    func listUser(){
        do{
            let users = try self.database.prepare(self.usersTable)
            print(users)
            users.forEach { user in
                print("userid: \(user[self.id]) , name : \(user[self.name]), email :\(user[self.email])")
            }
        }catch{
            print(error)
        }
    }
    
    func updateUser(userIdString : String , email : String){
        
        let userID = Int(userIdString)
        let user = self.usersTable.filter(self.id == userID!)
        let updateUser = user.update(self.email <- email)
        do{
            try self.database.run(updateUser)
        }catch{
            
        }
    }
    
    func deleteUser(userIdString : String){
    
        let userId = Int(userIdString)
        let user = self.usersTable.filter(self.id == userId!)
        let deleteUser = user.delete()
        do{
            try self.database.run(deleteUser)
        }catch{
            print(error)
        }
    }
}



