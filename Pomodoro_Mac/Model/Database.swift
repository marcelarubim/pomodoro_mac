//
//  VIewController.SQlLite.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 09.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation
import SQLite

class Database
{
    var db : OpaquePointer?
    
    func open()
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("PomodoroDatabase.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
    }
    
    func createTable() {
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Pomodoro (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, start DATETIME, end DATETIME)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
//    var errorMessage: String { return String(cString: sqlite3_errmsg(db)) }
    
    func insertPomodoro(pomodoro : Pomodoro) {
        
        let queryString = "INSERT INTO Pomodoro (name, start, end) VALUES (?,?,?)"

        var stmt: OpaquePointer?

        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        guard sqlite3_bind_text(stmt, 1, pomodoro.name, -1, nil) == SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        guard sqlite3_bind_text(stmt, 2, dateFormatter.string(from: pomodoro.start), -1, nil) == SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding start: \(errmsg)")
            return
        }
        
        guard sqlite3_bind_text(stmt, 3, dateFormatter.string(from: pomodoro.stop), -1, nil) == SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding end: \(errmsg)")
            return
        }

        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }

        print("Successfully inserted row.")
        sqlite3_finalize(stmt)
    }
    
    func queryPomodoro() {
        let queryStatementString = "SELECT * FROM Pomodoro;"
        var queryStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                // 3
                let id = sqlite3_column_int(queryStatement, 0)
                
                // 4
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                
                // 5
                print("Query Result:")
                print("\(id) | \(name)")
                
            } else {
                print("Query returned no results")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
    }


}
