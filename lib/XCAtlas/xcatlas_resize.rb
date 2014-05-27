require "thor"
require 'RMagick'
require 'fileutils'
require 'debugger'

module XCAtlas
  class XCAtlasResizer < Thor::Group
    include Thor::Actions

    argument :source
    argument :target

    def create_output_directory
      say_status "create_output_directory", nil
      name = File.basename target
      Dir.mkdir(target) unless Dir.exists?(target)
      Dir.mkdir(File.join(target,"#{name}.atlas")) unless Dir.exists?(File.join(target,"#{name}.atlas"))
      Dir.mkdir(File.join(target,"#{name}@2x.atlas")) unless Dir.exists?(File.join(target,"#{name}@2x.atlas"))
      Dir.mkdir(File.join(target,"#{name}~ipad.atlas")) unless Dir.exists?(File.join(target,"#{name}~ipad.atlas"))
      Dir.mkdir(File.join(target,"#{name}@2x~ipad.atlas")) unless Dir.exists?(File.join(target,"#{name}@2x~ipad.atlas"))
    end

    def write_rename_images_to_dir
      name = File.basename target
      Dir.foreach(source) do |f|
        next if f == "." || f == ".." || f == ".DS_Store"

        if f.include?("@2x") && f.include?("~ipad")

          fn = f.gsub("@2x","").gsub("~ipad","")

          # load image
          img = Magick::Image.read(File.join(source,f)).first
          img.background_color = "none"

          # adjust image size so it's devitable by 4
          width = img.columns
          height = img.rows

          nWidth = width%4 == 0 ? width : (width + 4 - width%4)
          nHeight = height%4 == 0 ? height : (height + 4 - height%4)

          img = img.extent(nWidth, nHeight)

          # create ipad retina version
          say_status "create ipad retina version", "#{name}@2x~ipad.atlas"
          img.write(File.join(target,"#{name}@2x~ipad.atlas",fn))

          # create ipad non retina version
          say_status "create ipad non retina version", "#{name}@~ipad.atlas"
          img.minify!
          img.write(File.join(target,"#{name}~ipad.atlas",fn))

          # create iphone retina version - identical to ipad non retina version
          say_status "create iphone retina version - identical to ipad non retina version", "#{name}@2x.atlas"
          img.write(File.join(target,"#{name}@2x.atlas",fn))

          # create iphone non retina version
          say_status "create iphone non retina version", "#{name}.atlas"
          img.minify!
          img.write(File.join(target,"#{name}.atlas",fn))
        end
      end
    end

  end
end