Pod::Spec.new do |s|

  s.name        = "AutoReview"
  s.version     = "0.1.0"
  s.summary     = "AutoReview for app review."

  s.description = <<-DESC
                   AutoReview has a nice logic for show prompt of app review.
                   DESC

  s.homepage    = "https://github.com/nixzhu/AutoReview"

  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.authors           = { "nixzhu" => "zhuhongxu@gmail.com" }
  s.social_media_url  = "https://twitter.com/nixzhu"

  s.ios.deployment_target   = "8.0"

  s.source          = { :git => "https://github.com/nixzhu/AutoReview.git", :tag => s.version }
  s.source_files    = "AutoReview/*.swift"
  s.requires_arc    = true

end
