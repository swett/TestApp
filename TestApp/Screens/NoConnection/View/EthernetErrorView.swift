//
//  EthernetErrorView.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import SwiftUI

struct EthernetErrorView: View {
    @ObservedObject var viewModel: EthernetErrorViewModel
    var body: some View {
        ZStack {
            Color.theme.colorFFFFFF
                .ignoresSafeArea(.all)
            VStack(spacing: 24) {
                Image("noEthernetConnection-image")
                Text("There is no internet connection")
                    .font(.style(.header1))
                    .foregroundStyle(Color.theme.color000000.opacity(0.87))
                Button {
                    withAnimation(.easeIn) {
                        viewModel.tryAgain()
                    }
                } label: {
                    Text("Try again")
                        .foregroundStyle(Color.theme.color000000.opacity(0.87))
                        .font(.style(.button1))
                        .padding(.horizontal, 31.5)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .foregroundStyle(Color.theme.colorF4E041)
                        )
                }
            }
        }
    }
}

#Preview {
    EthernetErrorView(viewModel: EthernetErrorViewModel())
}
