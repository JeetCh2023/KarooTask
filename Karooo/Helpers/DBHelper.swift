//
//  DBHelper.swift
//  Karooo
//
//  Created by Jitender on 22/01/23.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "karooDb.sqlite"
    let tableName: String = "user"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            //print("error opening database")
            sqlite3_close(db)
            return nil
        }
        else
        {
            //print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS \(tableName)(email TEXT PRIMARY KEY,password TEXT,country TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                //print("user table created.")
            } else {
                //print("user table could not be created.")
            }
        } else {
           // print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(email:String, password:String, country:String, _ completion:@escaping (_ status:Bool?) -> Void)
    {
        let users = read()
        for user in users
        {
            if user.email == email
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO \(tableName) (email, password, country) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (country as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                //print("Successfully inserted row.")
                completion(true)
            } else {
                //print("Could not insert row.")
                completion(false)
            }
        } else {
            //print("INSERT statement could not be prepared.")
            completion(false)
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [User] {
        let queryStatementString = "SELECT * FROM \(tableName);"
        var queryStatement: OpaquePointer? = nil
        var users : [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let country = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                users.append(User(email: email, password: password, country: country))
                //print("Query Result:")
                //print("\(email) | \(password) | \(country)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return users
    }
    
}
