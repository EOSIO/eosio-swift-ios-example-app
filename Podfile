using_local_pods = ENV['USE_LOCAL_PODS'] == 'true' || false

platform :ios, '12.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'EosioSwiftiOSExampleApp' do
  use_frameworks!

  if using_local_pods
    pod 'EosioSwift', :path => '../eosio-swift'
    pod 'EosioSwiftAbieosSerializationProvider', :path => '../eosio-swift-abieos-serialization-provider'
    pod 'EosioSwiftSoftkeySignatureProvider', :path => '../eosio-swift-softkey-signature-provider'
    pod 'EosioSwiftEcc', :path => '../eosio-swift-ecc'
  else
    pod 'EosioSwift', '~> 0.1.1'
    pod 'EosioSwiftAbieosSerializationProvider', '~> 0.1.1'
    pod 'EosioSwiftSoftkeySignatureProvider', '~> 0.1.1'
  end




    post_install do |installer|
      installer.pods_project.targets.each do |target|
        installer.pods_project.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.2'
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.2'
       end
       end
       end
      end
    end



