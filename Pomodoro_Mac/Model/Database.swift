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
    var dateFormatter: DateFormatter = {
        let _formatter = DateFormatter()
        _formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        _formatter.locale = Locale(identifier: "en_US_POSIX")
        _formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return _formatter
    }()
    
    let dbName = "PomodoroDB.sqlite"
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    var db : OpaquePointer?
    var errorMessage: String { return String(cString: sqlite3_errmsg(db)) }

    func open()
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbName)
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        do {
            try self.createTable()
        }
        catch SQLiteError.prepare(let message) {
            print("error creating table: \(message)")
        } catch {
            return
        }            
    }
    
    func createTable() throws {
        guard sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Pomodoro (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, start DATETIME, end DATETIME)", nil, nil, nil) == SQLITE_OK else {
            throw SQLiteError.prepare(message: errorMessage)
        }
    }
    
    func insert(pomodoro : Pomodoro) throws {
        var stmt: OpaquePointer? = nil
        let queryString = "INSERT INTO pomodoro (name, start, end) VALUES (?,?,?)"

        //preparing the query
        guard sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK else{
            throw SQLiteError.prepare(message: errorMessage)
        }
        defer { sqlite3_finalize(stmt) }
        
        //binding the parameters
        guard sqlite3_bind_text(stmt, 1, pomodoro.name, -1, SQLITE_TRANSIENT) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }
        
        guard sqlite3_bind_text(stmt, 2, dateFormatter.string(from: pomodoro.start), -1, SQLITE_TRANSIENT) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }
        
        guard sqlite3_bind_text(stmt, 3, dateFormatter.string(from: pomodoro.stop), -1, SQLITE_TRANSIENT) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }

        //executing the query to insert values
        guard sqlite3_step(stmt) == SQLITE_DONE else {
            throw SQLiteError.step(message: errorMessage)
        }

        print("Successfully inserted row.")
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

        sqlite3_finalize(queryStatement)
    }
}

enum SQLiteError: Error {
    case open(result: Int32)
    case exec(message: String)
    case prepare(message: String)
    case bind(message: String)
    case step(message: String)
    case column(message: String)
    case invalidDate
    case missingData
    case noDataChanged
}


