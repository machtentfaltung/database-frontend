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
//  LoginView.swift
//  DatabaseFrontend
//
//  Created by Matei Pralea on 22/04/2024.
//

import SwiftUI
import SQLite

struct LoginView: SwiftUI.View {
    let connection: Connection
    @State var name = String()
    @State var password = String()

    @State var showNameError = true
    @State var showPasswordError = true
    @State var hasVerifiedOnce = false

    @State var showPassword = false

    @State var foundUser = User(mail: String(), name: String(), hash: String(), salt: String())

    @State var accountInvalid = false
    @State var passwordIncorrect = false

    var body: some SwiftUI.View {
        VStack {
            VStack(alignment: .leading) {
#if os(macOS)
                Text("Authenticate").font(.title).bold()
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

                Text("Password").font(.title3)
                if showPasswordError {
                    Text("The TextField for the password is empty.").bold().foregroundStyle(.red)
#if !os(macOS)
                        .font(.caption)
#endif
                }

                if !showPassword {
                    SecureField("Password", text: $password).onChange(of: password, {
                        if password.isEmpty {
                            showPasswordError = true
                        }
                        else {
                            showPasswordError = false
                        }
                    }).textContentType(.password)
                }
                else {
                    TextField("Password", text: $password).onChange(of: password, {
                        if password.isEmpty {
                            showPasswordError = true
                        }
                        else {
                            showPasswordError = false
                        }
                    }).textContentType(.password)

                }

                HStack {
                    Spacer()

                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill").font(.system(size: 16, weight: .regular)).frame(width: 20, height: 20)
                    }
                }

                Spacer()

            }

            if passwordIncorrect && !accountInvalid {
                Text("The password is incorrect.").bold().foregroundStyle(.red)
#if !os(macOS)
                    .font(.caption)
#endif
            }

            if accountInvalid {
                Text("This account does not exist.").bold().foregroundStyle(.red)
#if !os(macOS)
                    .font(.caption)
#endif
            }

            Button("Verify") {
                hasVerifiedOnce = true
                if !userExists(connection, name: name) {
                    accountInvalid = true
                }
                else {
                    accountInvalid = false
                }

                if !accountInvalid {
                    let d = getDatabaseUsers(connection)
                    let t = d.first(where: { $0.name == name })!

                    foundUser = t

                    let computedHash = computeHash(for: password, salt: t.salt)

                    if computedHash == t.hash {
                        passwordIncorrect = false
                    }
                    else {
                        passwordIncorrect = true
                    }
                }
            }.controlSize(.small).disabled(password.isEmpty || name.isEmpty)

            NavigationLink(destination: AccountView(connection: connection, user: User(mail: foundUser.mail, name: foundUser.name, hash: foundUser.hash, salt: foundUser.salt), created: false), label: {
                Text("Authenticate")
            }).disabled(passwordIncorrect || accountInvalid || showNameError || showPasswordError || !hasVerifiedOnce)
#if os(macOS)
                .controlSize(.large)
#else
                .controlSize(.regular)
#endif

        }.padding()
            .textFieldStyle(.roundedBorder)
            .buttonStyle(.bordered)
            .ignoresSafeArea(.keyboard)
#if !os(macOS)
            .navigationTitle("Authenticate")
#endif
#if os(macOS)
            .frame(minWidth: 500, minHeight: 500)
#endif
    }
}

#Preview {
    LoginView(connection: openSQLDatabaseConnection(at: getDatabasePath()))
}
