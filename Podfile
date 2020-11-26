platform :ios, '11.0'

inhibit_all_warnings!

target 'MobileTest' do
  use_frameworks!

  pod 'CryptoSwift'
  pod 'SwiftLint'
  pod 'Kingfisher'

  target 'MobileTestTests' do
      inherit! :search_paths
  end
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
