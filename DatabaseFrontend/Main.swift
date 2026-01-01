//  SPDX-License-Identifier: MIT OR Apache-2.0
//
//  DatabaseFrontendApp.swift
//  DatabaseFrontend
//
//  Created by Matei Pralea on 22/04/2024.
//  Copyright © 2024-2026 Matei Pralea. All rights reserved.
//

import SwiftUI
import SQLite

@main
struct Main: App {
    var connection: Connection
    init() {
        if !databaseExists() {
            createDatabaseFile()
        }
        let conn = openSQLDatabaseConnection(at: getDatabasePath())
        do {
            _ = try conn.scalar(userTable.exists)
        }
        catch {
            initializeSQLDatabase(conn)
        }
        self.connection = conn
    }

    var body: some Scene {
        WindowGroup {
            WelcomeView(connection: connection)
        }
#if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
#endif


    }
}
