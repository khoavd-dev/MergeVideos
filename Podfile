# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'


post_install do |installer|
 installer.pods_project.targets.each do |target|
   target.build_configurations.each do |config|
     config.build_settings['SWIFT_VERSION'] = '3.0'
   end
 end
end

target 'MergeVideos' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MergeVideos

  pod 'DKImagePickerController’, ‘~>3.5.7’

end
