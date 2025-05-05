//
//  UsersView.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import SwiftUI

struct UsersView: View {
    @ObservedObject var viewModel: UsersViewModel
    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.colorFFFFFF
                .ignoresSafeArea(.all)
            VStack {
                header
                cells
            }
        }
        .task {
            await viewModel.loadUsers() // << move .task here, on the WHOLE VStack
        }
    }
}

#Preview {
    UsersView(viewModel: UsersViewModel())
}


extension UsersView {
    private var header: some View {
        Rectangle()
            .foregroundStyle(Color.theme.colorF4E041)
            .frame(height: 56)
            .overlay {
                Text("Working with GET request")
                    .foregroundStyle(Color.theme.color000000)
                    .font(.style(.header1))
            }
        
        
    }
}

extension UsersView {
    private var cells: some View {
        VStack {
            if viewModel.users.isEmpty {
                VStack {
                    Spacer()
                    Image("noUsersImage-image")
                    Text("There are no users yet")
                        .font(.style(.header1))
                        .foregroundStyle(Color.theme.color000000.opacity(0.87))
                    Spacer()
                }
            } else  {
                ScrollView {
                    LazyVStack {
                        
                        ForEach(viewModel.users) { user in
                            UserCell(model: user)
                                .onAppear {
                                    // If this is the last user, load more users
                                    if user == viewModel.users.last {
                                        Task {
                                            await viewModel.loadUsers()
                                        }
                                    }
                                }
                        }
                        
                        // Show a loading spinner while fetching users
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
            
        }
        
    }
}
