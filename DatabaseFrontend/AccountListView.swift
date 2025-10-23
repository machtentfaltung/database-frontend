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
//  AccountListView.swift
//  DatabaseFrontend
//
//  Created by Matei Pralea on 22/04/2024.
//

import SwiftUI
import SQLite

struct AccountListView: SwiftUI.View {
    let connection: Connection

    var body: some SwiftUI.View {
        VStack {
            let db = getDatabaseUsers(connection)


            HStack {
#if os(macOS)
                Text("View users").font(.title).bold()

                Spacer()
#endif

                NavigationLink(destination: ResetView(connection: connection), label: {
                    Text("Reset password")
                }).disabled(db.isEmpty)
#if os(macOS)
                    .controlSize(.large)
#else
                    .controlSize(.regular)
#endif
                NavigationLink(destination: DeleteView(connection: connection), label: {
                    Text("Delete user")
                }).disabled(db.isEmpty)
#if os(macOS)
                    .controlSize(.large)
#else
                    .controlSize(.regular)
#endif


            }



#if os(macOS)
            Spacer().frame(height: 25)
            let alignment = HorizontalAlignment.leading
#else
            Spacer().frame(height: 10)
            let alignment = HorizontalAlignment.center
#endif

            VStack(alignment: alignment) {
                Text("User count: \(userCount(connection))").font(.caption)


#if os(iOS)
                Table(db) {
                    TableColumn("Username", value: \.name)
                    TableColumn("E-mail", value: \.mail)
                    TableColumn("Hash (SHA-512)", value: \.hash)
                    TableColumn("Salt", value: \.salt)
                }
#else
                Table(db) {
                    TableColumn("UUID", value: \.id.uuidString)
#if os(macOS)
                        .width(min: 300)
#endif
                    TableColumn("Username", value: \.name)
#if os(macOS)
                        .width(min: 160)
#endif
                    TableColumn("E-mail", value: \.mail)
#if os(macOS)
                        .width(min: 160)
#endif
                    TableColumn("Hash (SHA-512)", value: \.hash)
#if os(macOS)
                        .width(min: 240, ideal: 420)
#endif
                    TableColumn("Salt", value: \.salt)
#if os(macOS)
                        .width(min: 140)
#endif
                }
#endif
            }


        }.padding()
            .textFieldStyle(.roundedBorder)
            .buttonStyle(.bordered)
            .ignoresSafeArea(.keyboard)
#if !os(macOS)
            .navigationTitle("View users")
#endif
#if os(macOS)
            .frame(minWidth: 700, minHeight: 500)
#endif
    }

}


#Preview {
    AccountListView(connection: openSQLDatabaseConnection(at: getDatabasePath()))
}
