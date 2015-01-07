require 'RMagick'
require 'debugger'

module XCUtils

  class XCUtilsImageHandling

    # resize image by scale utilizing Mitchell filter and slightly blurrying
    def self.scale_image(image, scale)
      w = image.columns
      h = image.rows
      #image.scale(scale)
      image.resize(w * scale, h * scale, Magick::HammingFilter,0.9)
      # image.resize(w * scale, h * scale, Magick::BoxFilter)
      #.unsharp_mask(1.5, 1.0, 0.5, 0.02)
    end

  end
end