#
# Overriding save so we can use the sRGB colorspace.
# Makes the jpgs look much more like the results in the PDF
#
module Grim
  class ModProcessor < ImageMagickProcessor
    def save(pdf, index, path, options)
      width   = options.fetch(:width,   Grim::WIDTH)
      density = options.fetch(:density, Grim::DENSITY)
      quality = options.fetch(:quality, Grim::QUALITY)
      command = [@imagemagick_path, "-resize", width.to_s, "-antialias", "-render",
        "-quality", quality.to_s, "-colorspace", "sRGB",
        "-interlace", "none", "-density", density.to_s,
        "-background white -alpha remove",
        "#{Shellwords.shellescape(pdf.path)}[#{index}]", path]
      command.unshift("PATH=#{File.dirname(@ghostscript_path)}:#{ENV['PATH']}") if @ghostscript_path

      result = `#{command.join(' ')}`

      $? == 0 || raise(UnprocessablePage, result)
    end
  end
end
