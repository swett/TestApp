//
//  PreloaderView.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import SwiftUI

struct PreloaderView: View {
    @ObservedObject var viewModel: PreloaderViewModel
    var body: some View {
        ZStack {
            Color.theme.colorF4E041
                .ignoresSafeArea(.all)
            
            Image("Logo")
        }
        .onAppear {
            viewModel.setupBindings()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                //            viewModel.showMain()
//            }
        }
    }
}

#Preview {
    PreloaderView(viewModel: PreloaderViewModel())
}
