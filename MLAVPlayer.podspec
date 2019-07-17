Pod::Spec.new do |spec|

  spec.name         = "MLAVPlayer"
  spec.version      = "1.0.0"
  spec.summary      = "Encapsulate AVPlayer for playing video and audio"

  spec.description  = <<-DESC
  MLAVPlayer for Video &amp; Audio Play Interface
                   DESC
  spec.homepage     = "https://github.com/MichaelLedger/MLAVPlayer"
  spec.license      = "MIT"
  spec.author             = { "MichaelLedger" => "MichaelLedger@163.com" }
  spec.source       = { :git => "https://github.com/MichaelLedger/MLAVPlayer.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"
  spec.ios.framework = "AVFoundation", "MediaPlayer"
end
