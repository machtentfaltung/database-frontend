//  SPDX-License-Identifier: MIT OR Apache-2.0
//
//  ContentView.swift
//  DatabaseFrontend
//
//  Created by Matei Pralea on 22/04/2024.
//  Copyright © 2024-2026 Matei Pralea. All rights reserved.
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
