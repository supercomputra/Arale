Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "Arale"
  s.version      = "0.0.3"
  s.summary      = "A stretchy big header for UITableView, UICollectionView, or any UIScrollView subclasses."
  s.description  = "Arale is a completely customizeble UI component that can be used in any UIScrollView and UIScrollView subclasses to give a stretchy header effect."
  s.homepage     = "https://github.com/ZulwiyozaPutra"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author             = { "Zulwiyoza Putra" => "zulwiyozaputra@gmail.com" }
  s.social_media_url   = "http://twitter.com/ZulwiyozaPutra"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.platform     = :ios, "10.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :git => "https://github.com/ZulwiyozaPutra/Arale.git", :tag => "#{s.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files  = "Arale", "Arale/**/*.{h,m}"
  s.exclude_files = "Arale/Exclude"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.swift_version = "4.2" 

end
