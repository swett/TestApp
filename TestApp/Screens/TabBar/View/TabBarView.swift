//
//  TabBarView.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 02.05.2025.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var viewModel: TabViewModel
    @State var opacity: Double = 0
    @FocusState var focusedField: Field?
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content area
            Color.theme.colorFFFFFF
                .ignoresSafeArea(.all)
            
            // Custom tab content (replacing TabView)
            VStack {
                // Only display the currently selected tab
                switch viewModel.selectedTab {
                case .users:
                    UsersView(viewModel: viewModel.usersViewModel!)
                case .singUp:
                    SingUpView(viewModel: viewModel.singUpViewModel!)
                }
            }
            
            // Custom tab bar
            ZStack {
                Rectangle()
                    .foregroundStyle(Color.theme.colorF8F8F8)
                    .frame(height: 56)
                    .ignoresSafeArea(.all)
                    .padding(.top,DeviceType.IS_SMALL ? 40 : 90)
                
                HStack(spacing: 20) {
                    ForEach(Tab.allCases) { item in
                        Button {
                            withAnimation {
                                viewModel.selectedTab = item
                                viewModel.previousTab = viewModel.selectedTab
                            }
                            // Clear focus when switching tabs
                            focusedField = nil
                        } label: {
                            CustomTabItem(
                                imageName: item,
                                tag: item.rawValue,
                                isActive: (viewModel.selectedTab.rawValue == item.rawValue)
                            )
                        }
                       
                    }
                }
                .offset(y: DeviceType.IS_SMALL ? 20 : 45)
            }
            .frame(height: 90)
            .ignoresSafeArea(.all)
            .background(.clear)
        }
        .ignoresSafeArea(.keyboard)
        .opacity(opacity)
        .onAppear {
            DispatchQueue.main.async {
                viewModel.selectedTab = viewModel.previousTab
                withAnimation(.easeIn(duration: 1.2)) {
                    opacity = 1
                }
                
            }
        }
    }
}

#Preview {
    TabBarView(viewModel: TabViewModel())
}




extension TabBarView {
    func CustomTabItem(imageName: Tab, tag: Int, isActive: Bool) -> some View{
        HStack{
            Spacer()
            Image(getImageWhenActive(tag: tag, isActive: isActive, tab: imageName))
                .resizable()
                .frame(width: 180, height: 24)
            
            Spacer()
        }
        .frame(width: 180, height: 24)
        .animation(.linear(duration: 0.3))
        
    }
    
    
    func getImageWhenActive(tag: Int, isActive: Bool, tab: Tab) -> String {
        
        switch tag {
        case 0: return "\(isActive ? tab.iconNameActive: tab.iconNamePassive)"
        case 1: return "\(isActive ? tab.iconNameActive: tab.iconNamePassive)"
        default: return ""
        }
    }
}
