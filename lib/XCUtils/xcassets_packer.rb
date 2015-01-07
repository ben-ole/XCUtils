require "thor"
require 'fileutils'
require 'debugger'
require 'json'

module XCUtils
  class XCAssetsPacker < Thor::Group
    include Thor::Actions

    argument :source
    argument :target

    def create_output_directory
      say_status "create_output_directory", nil
      name = File.basename target
      Dir.mkdir(target) unless Dir.exists?(target)
    end

    def xcassets_directory

      # each source file
      Dir.foreach(source) do |f|
        next if f == "." || f == ".." || f == ".DS_Store"

        fn = f.gsub("@3x","").gsub("~ipad","").gsub("@2x","") # remove extensions
        fn = File.basename(fn,File.extname(fn))

        say_status "Notice", "packing xcasset: #{fn}", :blue

        # create folder
        imageset_folder = File.join(target,"#{fn}.imageset")
        Dir.mkdir(imageset_folder) unless Dir.exists?(imageset_folder)

        # load image
        img = Magick::Image.read(File.join(source,f)).first

        # create @3x version
        say_status "create @3x version", "#{fn}@3x", :yellow
        img.write(File.join(imageset_folder,"#{fn}@3x.png"))
        content_iphone_3x = {"idiom" => "iphone", "scale" => "3x", "filename" => "#{fn}@3x.png"}

        # create ipad retina version
        say_status "create ipad retina version", "#{fn}@2x~ipad", :yellow
        img.write(File.join(imageset_folder,"#{fn}@2x~ipad.png"))
        content_ipad_2x = {"idiom" => "ipad", "scale" => "2x", "filename" => "#{fn}@2x~ipad.png"}

        # create ipad non retina version
        say_status "create ipad non retina version", "#{fn}~ipad", :yellow
        img = XCUtilsImageHandling.scale_image(img,0.5)
        img.write(File.join(imageset_folder,"#{fn}~ipad.png"))
        content_ipad = {"idiom" => "ipad", "scale" => "1x", "filename" => "#{fn}~ipad.png"}

        # create iphone retina version - identical to ipad non retina version
        say_status "create iphone retina version - identical to ipad non retina version", "#{fn}@2x", :yellow
        img.write(File.join(imageset_folder,"#{fn}@2x.png"))
        content_iphone_2x = {"idiom" => "iphone", "scale" => "2x", "filename" => "#{fn}@2x.png"}

        # create iphone non retina version
        say_status "create iphone non retina version", "#{fn}", :yellow
        img = XCUtilsImageHandling.scale_image(img,0.5)
        img.write(File.join(imageset_folder,"#{fn}.png"))
        content_iphone = {"idiom" => "iphone", "scale" => "1x", "filename" => "#{fn}.png"}

        # create json
        contents_json = JSON.pretty_generate( {"images" => [content_iphone, content_iphone_2x, content_iphone_3x, content_ipad, content_ipad_2x], "info" => {"version" => 1, "author" => "xcode"} } )

        File.open(File.join(imageset_folder,"Contents.json"),"w") do |f|
          f.write(contents_json)
        end

      end
    end
  end
end