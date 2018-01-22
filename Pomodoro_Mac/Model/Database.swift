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
    var isOpened: Bool = false
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
        isOpened = true
    }
    
    func createTable() throws {
        guard sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Pomodoro (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, start DATETIME, stop DATETIME, timer INTEGER)", nil, nil, nil) == SQLITE_OK else {
            throw SQLiteError.prepare(message: errorMessage)
        }
    }
    
    func insert(pomodoro : Pomodoro) throws {
        var stmt: OpaquePointer? = nil
        let query = "INSERT INTO Pomodoro (name, start, stop, timer) VALUES (?,?,?,?)"

        //preparing the query
        guard sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK else{
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
        
        guard sqlite3_bind_int64(stmt, 4, Int64(pomodoro.timerSeconds)) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }

        //executing the query to insert values
        guard sqlite3_step(stmt) == SQLITE_DONE else {
            throw SQLiteError.step(message: errorMessage)
        }

        print("Successfully inserted row.")
        pomodoro.id = Int(sqlite3_last_insert_rowid(db))
    }
    
    func update(pomodoro: Pomodoro) throws {
        var statement: OpaquePointer? = nil
        let query = "UPDATE Pomodoro SET name = ?, start = ?, stop = ?, timer = ? WHERE id = ?"
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.prepare(message: errorMessage)
        }
        
        defer { sqlite3_finalize(statement) }
        
        guard sqlite3_bind_text(statement, 1, pomodoro.name, -1, SQLITE_TRANSIENT) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }
        
        guard sqlite3_bind_text(statement, 2, dateFormatter.string(from: pomodoro.start), -1, SQLITE_TRANSIENT) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }
        
        guard sqlite3_bind_text(statement, 3, dateFormatter.string(from: pomodoro.stop), -1, SQLITE_TRANSIENT) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }
        
        guard sqlite3_bind_int64(statement, 4, sqlite3_int64(pomodoro.timerSeconds)) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }
        
        guard sqlite3_bind_int64(statement, 5, Int64(pomodoro.id)) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw SQLiteError.step(message: errorMessage)
        }
        
        guard sqlite3_changes(db) > 0 else {
            throw SQLiteError.noDataChanged
        }
    }
    
    func delete(pomodoro: Pomodoro) throws {
        var statement: OpaquePointer? = nil
        let query = "DELETE FROM Pomodoro WHERE id = ?"
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.prepare(message: errorMessage)
        }
        
        defer { sqlite3_finalize(statement) }
        
        guard sqlite3_bind_int64(statement, 1, Int64(pomodoro.id)) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw SQLiteError.step(message: errorMessage)
        }
        
        guard sqlite3_changes(db) > 0 else {
            throw SQLiteError.noDataChanged
        }
    }
        
    func select(pomodoroId: Int) throws -> Pomodoro {
        var statement: OpaquePointer? = nil
        let query = "SELECT id, name, start, stop, timer FROM Pomodoro WHERE id = ?"
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.prepare(message: errorMessage)
        }
        
        defer { sqlite3_finalize(statement) }
        
        guard sqlite3_bind_int64(statement, 1, Int64(pomodoroId)) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }
        
        guard sqlite3_step(statement) == SQLITE_ROW else {
            throw SQLiteError.step(message: errorMessage)
        }
        
        return try pomodoro(for: statement)
    }
    
    func selectAll() throws -> [Pomodoro] {
        var statement: OpaquePointer? = nil
        let query = "SELECT id, name, start, stop, timer FROM Pomodoro"
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.prepare(message: errorMessage)
        }
        
        defer { sqlite3_finalize(statement) }
        
        var pomodoros = [Pomodoro]()
        
        var rc: Int32
        repeat {
            rc = sqlite3_step(statement)
            guard rc == SQLITE_ROW else { break }
            pomodoros.append(try pomodoro(for: statement))
        } while rc == SQLITE_ROW
        
        guard rc == SQLITE_DONE else {
            throw SQLiteError.step(message: errorMessage)
        }
        
        return pomodoros
    }
    
    func pomodoro(for statement: OpaquePointer?) throws -> Pomodoro {
        let pomodoroId = Int(sqlite3_column_int64(statement, 0))
        
        guard let pomodoroNameCString = sqlite3_column_text(statement, 1) else {
            throw SQLiteError.column(message: errorMessage)
        }
        let pomodoroName = String(cString: pomodoroNameCString)
        
        guard let pomodoroStartCString = sqlite3_column_text(statement, 2) else {
            throw SQLiteError.column(message: errorMessage)
        }
        guard let pomodoroStart = dateFormatter.date(from: String(cString: pomodoroStartCString)) else {
            throw SQLiteError.invalidDate
        }
        
        guard let pomodoroStopCString = sqlite3_column_text(statement, 3) else {
            throw SQLiteError.column(message: errorMessage)
        }
        guard let pomodoroStop = dateFormatter.date(from: String(cString: pomodoroStopCString)) else {
            throw SQLiteError.invalidDate
        }
        
        let pomodoroTimer = Int(sqlite3_column_bytes(statement, 4))
        guard pomodoroTimer > 0 else {
            throw SQLiteError.missingData
        }

        return Pomodoro(id: pomodoroId, name: pomodoroName, start: pomodoroStart, stop: pomodoroStop, timer: pomodoroTimer)
    }

    
//    func queryPomodoro() {
//        let queryStatementString = "SELECT * FROM Pomodoro;"
//        var queryStatement: OpaquePointer? = nil
//        // 1
//        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//            // 2
//            if sqlite3_step(queryStatement) == SQLITE_ROW {
//                // 3
//                let id = sqlite3_column_int(queryStatement, 0)
//
//                // 4
//                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
//                let name = String(cString: queryResultCol1!)
//
//                // 5
//                print("Query Result:")
//                print("\(id) | \(name)")
//
//            } else {
//                print("Query returned no results")
//            }
//        } else {
//            print("SELECT statement could not be prepared")
//        }
//
//        sqlite3_finalize(queryStatement)
//        }
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


