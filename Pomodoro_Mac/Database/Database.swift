//
//  Database.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 09.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation
import SQLite

class Database {
    
    var db:Connection!
    let pomodoros = Table("pomodoros")
    let id = Expression<Int64>("id")
    let name = Expression<String?>("name")
    let start = Expression<Date>("start")
    let stop = Expression<Date>("stop")
    let period = Expression<Int>("period")

    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first! + "/" + Bundle.main.bundleIdentifier!
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            db = try Connection("\(path)/db.sqlite3")
            try! createPomodoros()
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("constraint failed: \(message), in \(String(describing: statement))")
        } catch let error {
            print("insertion failed: \(error.localizedDescription)")
        }
    }
    
    func createPomodoros() throws {
        try db.run(pomodoros.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(name)
            t.column(start)
            t.column(stop)
            t.column(period)
        })
    }
    
    func add(pomodoro: Pomodoro) {
        do {
            let insert = pomodoros.insert(name <- pomodoro.name,
                                          start <- pomodoro.start,
                                          stop <- pomodoro.stop,
                                          period <- pomodoro.period)
            let rowid = try db.run(insert)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func allPomodoros() -> [Pomodoro] {
        do {
            var allPomodoros: [Pomodoro] = []
            for pomodoro in try db.prepare(pomodoros) {
                let pomodoro = Pomodoro(name: (try pomodoro.get(name))!,
                                        period: try pomodoro.get(period) as Int,
                                        start: try pomodoro.get(start) as Date,
                                        stop: try pomodoro.get(stop) as Date)
                allPomodoros.append(pomodoro)
            }
            return allPomodoros
        } catch {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }
    
    func allPomodorosNames() -> [String] {
        do {
            var allNames: [String] = []
            let query = pomodoros.select(name).filter(name != nil && name != "").order(name.asc)
            for pomodoro in try db.prepare(query) {
                allNames.append((try pomodoro.get(name))!)
            }
            return allNames
        } catch {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }
}
