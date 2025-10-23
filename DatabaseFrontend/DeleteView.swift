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
//  DeleteView.swift
//  DatabaseFrontend
//
//  Created by Matei Pralea on 22/04/2024.
//

import SwiftUI
import SQLite

struct DeleteView: SwiftUI.View {
    let connection: Connection

    @State var name = String()
    @State var password = String()

    @State var showNameError = true

    @State var foundUser = User(mail: String(), name: String(), hash: String(), salt: String())

    @State var accountInvalid = false
    @State var hasVerifiedOnce = false
    @State var deleteSuccessful = false

    var body: some SwiftUI.View {
        VStack {
            VStack(alignment: .leading) {
#if os(macOS)
                Text("Delete user").font(.title).bold()
#endif

                Spacer().frame(height: 25)

                Text("Username").font(.title3)
                if showNameError {
                    Text("The TextField for the username is empty.").bold().foregroundStyle(.red)
#if !os(macOS)
                        .font(.caption)
#endif
                }


                TextField("Username", text: $name).onChange(of: name, {
                    if name.isEmpty {
                        showNameError = true
                    }
                    else {
                        showNameError = false
                    }
                }).textContentType(.username)
            }

            Spacer()

            if accountInvalid {
                Text("This user does not exist.").bold().foregroundStyle(.red)
#if !os(macOS)
                    .font(.caption)
#endif
            }

            if deleteSuccessful {
                Text("The user has been successfully deleted.").bold().foregroundStyle(.green)
#if !os(macOS)
                    .font(.caption)
#endif
            }

            Button("Verify") {
                if deleteSuccessful {
                    deleteSuccessful = false
                }

                hasVerifiedOnce = true

                if !userExists(connection, name: name) {
                    accountInvalid = true
                }
                else {
                    accountInvalid = false
                }
            }.disabled(name.isEmpty).controlSize(.small)

            Button("Delete user") {
                deleteUser(connection, name: name)
                deleteSuccessful = true
                name = String()
                hasVerifiedOnce = false
            }.disabled(accountInvalid || showNameError || !hasVerifiedOnce)
#if os(macOS)
                .controlSize(.large)
#else
                .controlSize(.regular)
#endif
        }.padding()
#if os(macOS)
            .frame(minWidth: 700, minHeight: 500)
#endif
            .textFieldStyle(.roundedBorder)
            .buttonStyle(.bordered)
            .ignoresSafeArea(.keyboard)
#if !os(macOS)
            .navigationTitle("Delete user")
#endif
    }
}

#Preview {
    DeleteView(connection: openSQLDatabaseConnection(at: getDatabasePath()))
}

