require 'RMagick'
require 'debugger'

module XCUtils

  class XCUtilsImage

    # resize image by scale utilizing Mitchell filter and slightly blurrying
    def self.scale_image(image, scale)
      w = image.columns
      h = image.rows
      scale != 1.0 ? image.resize(w * scale, h * scale, Magick::HammingFilter,0.9) : image
      # image.scale(scale)
      # image.resize(w * scale, h * scale, Magick::BoxFilter)
      #.unsharp_mask(1.5, 1.0, 0.5, 0.02)
    end

  end
end