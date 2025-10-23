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
//  SwiftUI.View.swift
//  DatabaseFrontend
//
//  Created by Matei Pralea on 22/04/2024.
//

import SwiftUI
import SQLite

struct CreateView: SwiftUI.View {
    let connection: Connection

    @State var name = String()
    @State var password = String()
    @State var mail = String()

    @State var canContinue = false

    @State var passwordState = PasswordStrength.empty
    @State var nameState = UsernameCreationStatus.empty
    @State var mailState = MailCreationStatus.empty

    @State var showPassword = false

    @State var userSalt = salt()

    var body: some SwiftUI.View {
        VStack {
            VStack(alignment: .leading) {
#if os(macOS)
                Text("Create user").font(.title).bold()
#endif
                Spacer().frame(height: 25)
                Text("E-mail address").font(.title3)
                switch mailState {
                case .empty:
                    Text("The TextField for the e-mail address is empty.").bold().foregroundStyle(.red)
#if !os(macOS)
                        .font(.caption)
#endif
                case .noAt:
                    Text("The e-mail address does not contain '@'").bold().foregroundStyle(.red)
#if !os(macOS)
                        .font(.caption)
#endif
                case .noDot:
                    Text("The e-mail address does not contain a dot.").bold().foregroundStyle(.red)
#if !os(macOS)
                        .font(.caption)
#endif
                case .good:
                    EmptyView()
                }

                TextField("E-mail", text: $mail).onChange(of: mail, {
                    if mail.isEmpty {
                        mailState = .empty
                    }
                    else if !mail.contains(try! Regex("@")){
                        mailState = .noAt
                    }
                    else if !mail.contains(try! Regex(#"\."#)){
                        mailState = .noDot
                    } else {
                        mailState = .good
                    }

                    if passwordState == .good && mailState == .good && nameState == .good {
                        canContinue = true;
                    } else {
                        canContinue = false;
                    }
                }).textContentType(.emailAddress)


                Text("Username").font(.title3)
                Text("- must have at least 6 characters").font(.caption)

                switch nameState {
                case .empty:
                    Text("The TextField for the username is empty.").bold().foregroundStyle(.red)
#if !os(macOS)
                        .font(.caption)
#endif
                case .short:
                    Text("The username is too short.").bold().foregroundStyle(.red)
#if !os(macOS)
                        .font(.caption)
#endif
                case .good:
                    EmptyView()
                }

                TextField("Username", text: $name).onChange(of: name, {
                    if name.isEmpty {
                        nameState = .empty
                    }
                    else if name.count < 6 {
                        nameState = .short
                    } else {
                        nameState = .good
                    }

                    if passwordState == .good && mailState == .good && nameState == .good {
                        canContinue = true;
                    } else {
                        canContinue = false;
                    }
                }).textContentType(.username)

                Text("Password").font(.title3)
                Text("- must contain at least 12 characters").font(.caption)
                Text("- must contain alphanumeric characters").font(.caption)
                Text("- must contain special characters ($, !, @, etc)").font(.caption)

                switch passwordState {
                case .empty:
                    Text("The TextField for the password is empty.").foregroundStyle(.red).bold()
#if !os(macOS)
                        .font(.caption)
#endif
                case .invalid:
                    Text("The password is invalid.").foregroundStyle(.red).bold()
#if !os(macOS)
                        .font(.caption)
#endif
                case .tooShort:
                    Text("The password is too short.").foregroundStyle(.red).bold()
#if !os(macOS)
                        .font(.caption)
#endif
                case .noCapitals:
                    Text("The password does not contain capital letters.").foregroundStyle(.red).bold()
#if !os(macOS)
                        .font(.caption)
#endif
                case .noSmall:
                    Text("The password does not contain short letters.").foregroundStyle(.red).bold()
#if !os(macOS)
                        .font(.caption)
#endif
                case .noNumbers:
                    Text("The password does not contain numbers.").foregroundStyle(.red).bold()
#if !os(macOS)
                        .font(.caption)
#endif
                case .noSpecialCharacters:
                    Text("The password does not contain special characters.").foregroundStyle(.red).bold()
#if !os(macOS)
                        .font(.caption)
#endif
                case .good:
                    EmptyView()
                }


                if !showPassword {
                    SecureField("Password", text: $password).onChange(of: password, {
                        passwordState = checkPassword(for: password)

                        if passwordState == .good && mailState == .good && nameState == .good {
                            canContinue = true;
                        } else {
                            canContinue = false;
                        }
                    }).textContentType(.password)
                }
                else {
                    TextField("Password", text: $password).onChange(of: password, {
                        passwordState = checkPassword(for: password)

                        if passwordState == .good && mailState == .good && nameState == .good {
                            canContinue = true;
                        } else {
                            canContinue = false;
                        }
                    }).textContentType(.password)

                }

                HStack {
                    Spacer()

                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill").font(.system(size: 16, weight: .regular)).frame(width: 20, height: 20)
                    }
                }
            }

            Spacer()

            Text("\(userSalt)").font(.caption)

            Button("Regenerate salt") {
                userSalt = salt()
            }.controlSize(.small)

            NavigationLink(destination: AccountView(connection: connection, user: User(mail: mail, name: name, hash: computeHash(for: "\(password)\(userSalt)"), salt: userSalt), created: true), label: {
                Text("Continue")
            }).disabled(!canContinue)
#if os(macOS)
                .controlSize(.large)
#else
                .controlSize(.regular)
#endif

        }.textFieldStyle(.roundedBorder)
            .buttonStyle(.bordered)
            .padding()
            .ignoresSafeArea(.keyboard)
#if !os(macOS)
            .navigationTitle("Create user")
#endif
#if os(macOS)
            .frame(minWidth: 500, minHeight: 500)
#endif
    }
}


#Preview {
    CreateView(connection: openSQLDatabaseConnection(at: getDatabasePath()))
}
