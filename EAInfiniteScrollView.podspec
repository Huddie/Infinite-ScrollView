Pod::Spec.new do |s|
s.name             = 'EAInfiniteScrollView'
s.version          = '0.1.5'
s.summary          = 'A simple scrollview that scrolls forever'

s.description      = <<-DESC
This scrollview has the ability to scroll forever in a smooth fashion.
DESC

s.homepage         = 'https://github.com/Huddie/Infinite-ScrollView'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Ehud Adler' => 'adlerehud@gmail.com' }
s.source           = { :git => 'https://github.com/Huddie/Infinite-ScrollView.git', :tag => s.version.to_s }

s.ios.deployment_target = '10.0'
s.source_files = 'InfiniteScrollView/InfiniteScrollView.swift'

end

