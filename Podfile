platform :ios, '13.0'

use_frameworks!
inhibit_all_warnings!

target 'Pass' do
  # Architecture
  pod 'ReactorKit'
  
  # UI
  pod 'SnapKit', '~> 5.0.0'
  
  # Rx
  pod 'RxSwift', '5.1.1'
  pod 'RxCocoa', '5.1.1'
  pod 'RxDataSources', '~> 4.0'
  
  # DB
  pod 'RealmSwift'
  
  # Network
  pod 'Moya/RxSwift', '~> 14.0'
  pod 'MoyaSugar/RxSwift'
  pod 'Kingfisher', '~> 6.0'
  
  # Tool
  pod 'SwiftLint'
  pod 'R.swift'
  pod 'Then'
#  pod 'Swinject', '~> 1.1.4'
  
  # Security
  pod 'KeychainAccess'
  
  target 'PassTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
    pod 'RxTest'
  end
end

target 'PassUITests' do
  inherit! :search_paths
  # Pods for testing
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
  end
 end
end
