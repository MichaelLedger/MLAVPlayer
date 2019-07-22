Pod::Spec.new do |spec|

  spec.name         = "MLAVPlayer"
  spec.version      = "1.0.2"
  spec.summary      = "Encapsulate AVPlayer"
  spec.platform     = :ios, "7.0"
  spec.description  = <<-DESC
  MLAVPlayer for Video &amp; Audio Play Interface
                   DESC
  spec.homepage     = "https://github.com/MichaelLedger/MLAVPlayer"
  spec.license      = "MIT"
  spec.author   = { "MichaelLedger" => "MichaelLedger@163.com" }
  spec.source       = { :git => "https://github.com/MichaelLedger/MLAVPlayer.git", :tag => "#{spec.version}" }
  spec.source_files  = "MLAVPlayer/**/*.{h,m}"
  spec.resource      = "MLAVPlayer/MLAVPlayer.xib", "MLAVPlayer/MLAVPlayer.bundle"
  spec.ios.framework = "AVFoundation", "MediaPlayer"
  spec.requires_arc   = true
  spec.ios.deployment_target = '7.0'
end
