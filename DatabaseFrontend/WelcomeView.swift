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
//  ContentView.swift
//  DatabaseFrontend
//
//  Created by Matei Pralea on 22/04/2024.
//

import SwiftUI
import SQLite

struct WelcomeView: SwiftUI.View {
    var connection: Connection = openSQLDatabaseConnection(at: getDatabasePath())

    var body: some SwiftUI.View {
        NavigationStack {
            VStack {
                Text("Database").font(.title).bold()

                Text("Project")

                Spacer().frame(height: 50)

                HStack {
                    NavigationLink(destination: CreateView(connection: connection), label: {
                        Text("Create user")
                    })
#if os(macOS)
                    .controlSize(.large)
#else
                    .controlSize(.regular)
#endif

                    NavigationLink(destination: LoginView(connection: connection), label: {
                        Text("Authenticate")
                    })
#if os(macOS)
                    .controlSize(.large)
#else
                    .controlSize(.regular)
#endif

                }

                Divider().frame(width: 175)

                NavigationLink(destination: AccountListView(connection: connection), label: {
                    Text("View users")
                })
#if os(macOS)
                .controlSize(.large)
#else
                .controlSize(.regular)
#endif
            }
            .padding()
            .buttonStyle(.bordered)
#if os(macOS)
            .presentedWindowStyle(HiddenTitleBarWindowStyle())
            .frame(minWidth: 400, minHeight: 400, idealHeight: 400)
#endif
        }
    }
}

#Preview {
    WelcomeView()
}
