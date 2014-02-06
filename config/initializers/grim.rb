if %w(staging production).include?(Rails.env)
  Grim.processor = Grim::MultiProcessor.new([
    Grim::ImageMagickProcessor.new({ ghostscript_path: "/app/vendor/gs/gs/bin/gs" }),
    Grim::ImageMagickProcessor.new({ ghostscript_path: "/usr/bin/gs"})
  ])
end
