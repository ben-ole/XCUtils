require 'RMagick'
require 'debugger'

module XCUtils

  class XCUtilsImageHandling

    # resize image by scale utilizing Mitchell filter and slightly blurrying
    def self.scale_image(image, scale)
      img.resize(scale_factor:scale,filter:"Mitchell",support:1.1)
    end

  end
end