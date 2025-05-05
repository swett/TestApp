//
//  SingUpView.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 02.05.2025.
//

import SwiftUI

struct SingUpView: View {
    @ObservedObject var viewModel: SingUpViewModel
    @FocusState var focusedField: Field?
    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.colorFFFFFF
                .ignoresSafeArea(.all)
            VStack {
                header
                main
                   
            }
        }
        .onAppear {
            viewModel.getToken()
        }
        .fullScreenCover(isPresented: $viewModel.showFinishView) {
            finishView
        }
    }
}

#Preview {
    SingUpView(viewModel: SingUpViewModel())
}


extension SingUpView {
    private var header: some View {
        Rectangle()
            .foregroundStyle(Color.theme.colorF4E041)
            .frame(height: 56)
            .overlay {
                Text("Working with POST request")
                    .foregroundStyle(Color.theme.color000000)
                    .font(.style(.header1))
            }
        
        
    }
}

extension SingUpView {
    private var main: some View {
        NavigationView {
            ScrollView {
                VStack {
                    CustomTextField(text: $viewModel.name, errorMessage: $viewModel.errorMessageName, showError: $viewModel.showNameError, focusedField: $focusedField, fieldType: .name, placeholder: "Your name",keyboardType: .default, validate: {viewModel.validateName($0); return viewModel.isValidName})
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                HStack {
                                    Spacer()
                                    Button("Done") {
                                        focusedField = nil
                                    }
                                }
                            }
                        }
                    
                    CustomTextField(text: $viewModel.email, errorMessage: $viewModel.errorMessageEmail, showError: $viewModel.showEmailError, focusedField: $focusedField, fieldType: .email, placeholder: "Email",keyboardType: .emailAddress, validate: {viewModel.isValidEmail(email: $0); return viewModel.isValidEmail})
                        .padding(.top, 16)
                    CustomTextField(text: $viewModel.phoneNumber, errorMessage: $viewModel.errorMessagePhoneNumber, showError: $viewModel.showPhoneNumberError, focusedField: $focusedField, fieldType: .phone, placeholder: "Phone",keyboardType: .decimalPad, validate: {viewModel.validatePhoneNumber($0); return viewModel.isValidPhoneNumber})
                        .padding(.top, 16)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select your position")
                            .foregroundStyle(Color.theme.color000000.opacity(0.87))
                            .font(.style(.body2))
                        
                        ForEach(viewModel.positionsArray, id: \.self) { item in
                            Button {
                                withAnimation(.easeIn) {
                                    viewModel.selectedPosition = item
                                    viewModel.checkIsValid()
                                }
                                
                            } label: {
                                HStack {
                                    Circle()
                                        .stroke( viewModel.selectedPosition == item ? Color.theme.color009BBD : Color.theme.colorD0CFCF, lineWidth: viewModel.selectedPosition == item ? 6 : 1)
                                        .frame(width: 14, height: 14)
                                    Text(item.name)
                                        .foregroundStyle(Color.theme.color000000.opacity(0.87))
                                        .font(.style(.body1))
                                    Spacer()
                                }
                                .padding(.leading, 3)
                                .padding(.vertical, 12)
                            }
                        }
                        
                    }
                    .padding(.top, 24)
                    
                    PhotoPicker(selectedImage: $viewModel.pendingImage, isError: $viewModel.showPhotoError, errorMassage: $viewModel.errorMessagePhoto)
                        .onChange(of: viewModel.pendingImage) { newValue in
                            viewModel.checkIsValid()
                        }
                    
                    Button {
                        viewModel.createUser()
                    } label: {
                        Text("Sing Up")
                            .font(.style(.button1))
                            .foregroundStyle(Color.theme.color000000.opacity(0.87))
                            .padding(.horizontal, 38.5)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 100)
                                    .foregroundStyle(viewModel.isAllInputed ? Color.theme.colorF4E041: Color.theme.colorDEDEDE)
                            )
                    }
                    .padding(.top, 20)
                    .allowsHitTesting(viewModel.isAllInputed)
                    Spacer(minLength: 120)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 30)
        }
    }
}

extension SingUpView {
    private var finishView: some View {
        ZStack {
            Color.theme.colorFFFFFF
                .ignoresSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation(.easeIn) {
                            viewModel.showFinishView = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.theme.color000000.opacity(0.48))
                            .font(.system(size: 20))
                    }
                }
                Spacer()
                Image(viewModel.userResponse?.success ?? false ? "success-image" : "error-image")
                
                Text("\(viewModel.userResponse?.message ?? "")")
                
                Button {
                    withAnimation(.easeIn) {
                        viewModel.showFinishView = false
                    }
                    
                } label: {
                    Text(viewModel.userResponse?.success ?? false ? "Got it" : "Try Again")
                        .font(.style(.button1))
                        .foregroundStyle(Color.theme.color000000.opacity(0.87))
                        .padding(.horizontal, 38.5)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .foregroundStyle( Color.theme.colorF4E041)
                        )
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
        }
    }
}
