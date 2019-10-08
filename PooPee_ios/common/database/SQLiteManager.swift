//
//  CarSQLiteManager.swift
//  cardealerpro
//
//  Created by Jung ho Seo on 2018. 6. 22..
//  Copyright © 2018년 EMEYE. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteManager {
    static let instance = SQLiteManager()
    var db: OpaquePointer?
    
    /**
     * db open
     */
    func getReadableDatabase() -> OpaquePointer! {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("toilets_v\(String(SharedManager.instance.getDbVer())).sqlite")
        
        var db: OpaquePointer?
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        } else {
            print("opening database")
        }
        
        return db
    }
    
    /**
     * db close
     */
    func closeCursorAndDb(db: OpaquePointer, cursor: OpaquePointer) {
        if sqlite3_finalize(cursor) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(cursor)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
    }
    
    
    /**
     * Toilet 가져오기
     */
    func getToilet(id: Int) -> Toilet {
        let db = getReadableDatabase()
        let queryString = "SELECT * FROM toilets WHERE id='\(id)'";
        var cursor: OpaquePointer?
        
        if (sqlite3_prepare(db, queryString, -1, &cursor, nil) != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing: \(errmsg)")
            return Toilet()
        }
        
        var count = false
        let toilet = Toilet()
        while(sqlite3_step(cursor) == SQLITE_ROW){
            count = true
            toilet.toilet_id = Int(sqlite3_column_int(cursor, 0))
            toilet.type = String(cString: sqlite3_column_text(cursor, 1))
            toilet.name = String(cString: sqlite3_column_text(cursor, 2))
            toilet.address_new = String(cString: sqlite3_column_text(cursor, 3))
            toilet.address_old = String(cString: sqlite3_column_text(cursor, 4))
            toilet.unisex = String(cString: sqlite3_column_text(cursor, 5))
            toilet.m_poo = String(cString: sqlite3_column_text(cursor, 6))
            toilet.m_pee = String(cString: sqlite3_column_text(cursor, 7))
            toilet.m_d_poo = String(cString: sqlite3_column_text(cursor, 8))
            toilet.m_d_pee = String(cString: sqlite3_column_text(cursor, 9))
            toilet.m_c_poo = String(cString: sqlite3_column_text(cursor, 10))
            toilet.m_c_pee = String(cString: sqlite3_column_text(cursor, 11))
            toilet.w_poo = String(cString: sqlite3_column_text(cursor, 12))
            toilet.w_d_poo = String(cString: sqlite3_column_text(cursor, 13))
            toilet.w_c_poo = String(cString: sqlite3_column_text(cursor, 14))
            toilet.manager_name = String(cString: sqlite3_column_text(cursor, 15))
            toilet.manager_tel = String(cString: sqlite3_column_text(cursor, 16))
            toilet.open_time = String(cString: sqlite3_column_text(cursor, 17))
            toilet.latitude = sqlite3_column_double(cursor, 19)
            toilet.longitude = sqlite3_column_double(cursor, 20)
        }
        
        closeCursorAndDb(db: db!, cursor: cursor!)
        
        if (count) {
            return toilet
        } else {
            return Toilet()
        }
    }
    
    /**
     * Toilet 목록 가져오기
     */
    func getToiletList(latitude: Double, longitude: Double) -> [Toilet] {
        let startLat = String(latitude - ObserverManager.DISTANCE)
        let endLat = String(latitude + ObserverManager.DISTANCE)
        let startLong = String(longitude - ObserverManager.DISTANCE)
        let endLong = String(longitude + ObserverManager.DISTANCE)
        
        let db = getReadableDatabase()
        let queryString = "SELECT * FROM toilets WHERE (latitude * 1.0 BETWEEN \(startLat) AND \(endLat)) AND (longitude * 1.0 BETWEEN \(startLong) AND \(endLong))"
        var cursor: OpaquePointer?
        
        if (sqlite3_prepare(db, queryString, -1, &cursor, nil) != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing: \(errmsg)")
            return []
        }
        
        var toiletList: [Toilet] = []
        while(sqlite3_step(cursor) == SQLITE_ROW){
            let toilet = Toilet()
            toilet.toilet_id = Int(sqlite3_column_int(cursor, 0))
            toilet.type = String(cString: sqlite3_column_text(cursor, 1))
            toilet.name = String(cString: sqlite3_column_text(cursor, 2))
            toilet.address_new = String(cString: sqlite3_column_text(cursor, 3))
            toilet.address_old = String(cString: sqlite3_column_text(cursor, 4))
            toilet.unisex = String(cString: sqlite3_column_text(cursor, 5))
            toilet.m_poo = String(cString: sqlite3_column_text(cursor, 6))
            toilet.m_pee = String(cString: sqlite3_column_text(cursor, 7))
            toilet.m_d_poo = String(cString: sqlite3_column_text(cursor, 8))
            toilet.m_d_pee = String(cString: sqlite3_column_text(cursor, 9))
            toilet.m_c_poo = String(cString: sqlite3_column_text(cursor, 10))
            toilet.m_c_pee = String(cString: sqlite3_column_text(cursor, 11))
            toilet.w_poo = String(cString: sqlite3_column_text(cursor, 12))
            toilet.w_d_poo = String(cString: sqlite3_column_text(cursor, 13))
            toilet.w_c_poo = String(cString: sqlite3_column_text(cursor, 14))
            toilet.manager_name = String(cString: sqlite3_column_text(cursor, 15))
            toilet.manager_tel = String(cString: sqlite3_column_text(cursor, 16))
            toilet.open_time = String(cString: sqlite3_column_text(cursor, 17))
            toilet.latitude = sqlite3_column_double(cursor, 19)
            toilet.longitude = sqlite3_column_double(cursor, 20)
            toiletList.append(toilet)
        }
        
        closeCursorAndDb(db: db!, cursor: cursor!)
        
        return toiletList
    }
    
}
