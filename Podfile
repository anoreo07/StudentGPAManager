platform :ios, '16.0'

target 'StudentGPAManager' do
  use_modular_headers!
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end
