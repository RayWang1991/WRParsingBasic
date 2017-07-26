# coding: utf-8
#
#  Be sure to run `pod spec lint WRParsingBasic.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
Pod::Spec.new do |s|

  s.name         = "WRParsingBasic"
  s.license      =  "MIT"
  s.version      = "0.1.0"                #版本号
  s.summary      = "Basic Components for CF parsing"        #简短介绍

  s.homepage     =  "https://github.com/RayWang1991/WRParsingBasic"

  s.requires_arc = true                    #是否使用ARC
  
  s.source       = { :git => "https://github.com/RayWang1991/WRParsingBasic.git", :tag => "#{s.version}" }

  s.source_files  = "Classes",
                    "Classes/**/*.{h,m}"
  
  s.frameworks = 'Foundation'    #所需的framework,多个用逗号隔开

  s.author       = { "ray wang" => "wangrui@bongmi.com" }
end

