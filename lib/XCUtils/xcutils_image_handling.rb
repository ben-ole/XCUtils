require 'RMagick'
require 'debugger'

module XCUtils

  class XCUtilsImageHandling

    # resize image by scale utilizing Mitchell filter and slightly blurrying
    def self.scale_image(image, scale)
      w = image.columns
      h = image.rows
      image.resize(w * scale, h * scale, Magick::MitchellFilter, 1.04)
    end

  end
end