source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

def common_pods
  pod 'AMWaveTransition', '~> 0.5'
  pod 'AHKActionSheet', '~> 0.5'
  pod 'pop', '~> 1.0'
  pod 'AMPopTip', '~> 0.7'
  pod 'UICountingLabel', '~> 1.2'
  pod 'JTCalendar', git: 'https://github.com/andreamazz/JTCalendar', branch: 'develop'
  pod 'BAFluidView', '~> 0.1.6'
  pod 'BubbleTransition', '~> 1.0.0'
end

target 'Gulps' do
  common_pods
end

target 'GulpsTests' do
  common_pods
  pod 'Nimble', '~> 2.0.0-rc.3'
  pod 'Quick', '~> 0.6.0'
  pod 'Nimble-Snapshots'
end

inhibit_all_warnings!
use_frameworks!

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
