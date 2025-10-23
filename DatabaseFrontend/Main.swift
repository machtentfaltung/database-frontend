// Database Frontend
// Copyright (C) 2024-2025 Matei Pralea <matei.pralea@proton.me>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

//
//  DatabaseFrontendApp.swift
//  DatabaseFrontend
//
//  Created by Matei Pralea on 22/04/2024.
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
