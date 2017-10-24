source 'https://github.com/CocoaPods/Specs.git'

workspace 'Salsette'

platform :ios, '9.0'

use_frameworks!

target 'Salsette' do
    project 'Salsette.xcodeproj'
#    pod 'ColorMatchTabs'
    pod 'DZNEmptyDataSet'
    pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
    pod 'TextFieldEffects'
#    pod 'PermissionScope'
#    pod 'FontAwesomeKit'
    pod 'FSCalendar'
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
#    pod 'FBSDKShareKit'
    pod 'Auth0'
    pod 'SimpleKeychain', '~> 0.7'
    pod 'Apollo', '~> 0.6.0'
    pod 'Hero'

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end




#apollo-codegen introspect-schema https://api.graph.cool/file/v1/cj13ykrpk530j0152qxur34dm/graphql --output schema.json
#apollo-codegen introspect-schema https://eu-west-1.api.scaphold.io/graphql/dance --output schema.json
