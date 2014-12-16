require "thor"
require 'RMagick'
require 'fileutils'
require 'debugger'

module XCUtils
  class XCUtilsResizer < Thor::Group
    include Thor::Actions

    argument :source
    argument :target

    def create_output_directory
      say_status "create_output_directory", nil
      name = File.basename target
      Dir.mkdir(target) unless Dir.exists?(target)
      Dir.mkdir(File.join(target,"#{name}.atlas")) unless Dir.exists?(File.join(target,"#{name}.atlas"))
    end

    def write_rename_images_to_dir
      name = File.basename target
      Dir.foreach(source) do |f|
        next if f == "." || f == ".." || f == ".DS_Store"

        if f.include?("@3x")

          fn = f.gsub("@3x","")
          fn = File.basename(fn,File.extname(fn))

          # load image
          img = Magick::Image.read(File.join(source,f)).first
          img.background_color = "none"

          # adjust image size so it's devitable by 4
          width = img.columns
          height = img.rows

          nWidth = width%4 == 0 ? width : (width + 4 - width%4)
          nHeight = height%4 == 0 ? height : (height + 4 - height%4)

          img = img.extent(nWidth, nHeight)

          # create @3x version
          say_status "create @3x version", "#{fn}@3x", :yellow
          img.write(File.join(target,"#{name}.atlas","#{fn}@3x.png"))

          # create ipad retina version
          say_status "create ipad retina version", "#{fn}@2x~ipad", :yellow
          img.write(File.join(target,"#{name}.atlas","#{fn}@2x~ipad.png"))

          # create ipad non retina version
          say_status "create ipad non retina version", "#{fn}~ipad", :yellow
          img.minify!
          img.write(File.join(target,"#{name}.atlas","#{fn}~ipad.png"))

          # create iphone retina version - identical to ipad non retina version
          say_status "create iphone retina version - identical to ipad non retina version", "#{fn}@2x", :yellow
          img.write(File.join(target,"#{name}.atlas","#{fn}@2x.png"))

          # create iphone non retina version
          say_status "create iphone non retina version", "#{fn}", :yellow
          img.minify!
          img.write(File.join(target,"#{name}.atlas","#{fn}.png"))
        end
      end
    end

  end
end
