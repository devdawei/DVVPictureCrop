

Pod::Spec.new do |s|

s.name         = 'DVVPictureCrop'
s.summary      = '图片裁剪功能'
s.version      = '1.0.0'
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.authors      = { 'devdawei' => '2549129899@qq.com' }
s.homepage     = 'https://github.com/devdawei'

s.platform     = :ios
s.ios.deployment_target = '8.0'
s.requires_arc = true

s.source       = { :git => 'https://github.com/devdawei/DVVPictureCrop.git', :tag => s.version.to_s }

s.source_files = 'DVVPictureCrop/DVVPictureCrop/*.{h,m}'

s.frameworks = 'Foundation', 'UIKit'

end
