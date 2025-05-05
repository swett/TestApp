# Configuration options and how to customize them

No config options.

## Dependencies and any external libraries used

Use the package SDWebImage [webImage](https://github.com/SDWebImage/SDWebImageSwiftUI).

## Troubleshooting tips and common issues
Biggest troubles wich i faced this was working with check connection network, because my mac doesn`t see a Iphone, this was the biggest problem. And for test app at simulator without a connection need comment at Preloader view a setupBindings at on Appear and uncomment showMain
```swift
        .onAppear {
            viewModel.setupBindings()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                //            viewModel.showMain()
//            }
        }
```

## Instructions on how to build the application.

So easy, choose destination of simulator or device, start build.
take some info from apple documentation

Before installing your app, perform a few additional steps:

Add your Apple Account to the Accounts settings in Xcode.

Choose a valid team in your project’s Signing & Capabilities pane.

Code sign your macOS app if it includes capabilities that require code signing; see Adding capabilities to your app.

this i think helps start app at device 
