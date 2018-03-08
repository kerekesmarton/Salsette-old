source 'https://github.com/CocoaPods/Specs.git'

workspace 'Salsette'

platform :ios, '10.0'

inhibit_all_warnings!

use_frameworks!

target 'Salsette' do
    project 'Salsette.xcodeproj'
    
    pod 'DZNEmptyDataSet'
    pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
    pod 'TextFieldEffects'
    pod 'FSCalendar'
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
    pod 'Auth0'
    pod 'SimpleKeychain', '~> 0.7'
    pod 'Apollo'
end

target 'Crawler' do
    project 'Salsette.xcodeproj'

    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
    pod 'Apollo'
    pod 'SimpleKeychain', '~> 0.7'
    pod 'DZNEmptyDataSet'
    pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
end
