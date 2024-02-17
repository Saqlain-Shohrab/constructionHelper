#Required higher iOS versin for using latest versins of the pods
platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            # some older pods don't support some architectures, anything over iOS 11 resolves that
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
    end
end

#Add only shared pods here
def shared_pods
  #pod 'AlamofireObjectMapper', '~> 5'
  pod 'PromiseKit'
  pod 'RealmSwift'
  pod 'Charts'
  pod 'Signals', '~> 6.0'
  pod 'Kingfisher', '7.6.1'
  pod 'lottie-ios'
end

target 'Construction Helper' do
  shared_pods
  
  target 'Construction HelperTests' do
  end

  target 'Construction HelperUITests' do
    # UI Testig pods
  end

end
