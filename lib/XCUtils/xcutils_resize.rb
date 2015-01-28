require "thor"
require 'fileutils'
require 'debugger'
require 'json'
require 'parseconfig'
require 'RMagick'
require "XCUtils/xcutils_image"

module XCUtils
  class XCUtilsResize < Thor::Group
    include Thor::Actions

    @options_merge = {}

    argument :source, desc: "source directory or file"
    argument :target, desc: "target directory or file"

    class_options :scale_iphone_1x        => 0.25,   desc: "Iphone 3 scale"
    class_options :scale_iphone_2x        => 0.5,    desc: "Iphone @2x scale"
    class_options :scale_iphone_3x        => 1.0,    desc: "Iphone @3x scale"
    class_options :scale_ipad_1x          => 0.5,    desc: "IPad scale"
    class_options :scale_ipad_2x          => 1.0,    desc: "IPad @2x scale - source scale"

    class_options :create_image_assets    => false,  desc: "create xcassets folder per image including json, default: false"
    class_options :create_xcatlas         => false,  desc: "create xcatlas for folder, default: false"
    class_options :dry_run                => false,  desc: "print only logs - no files are created, default: false"

    def check_configuration_file

      # check for configuration file
      config_path = File.join(source,".xcutils-config")

      @options_merge = options

      if File.exists?(config_path)
        original_options = options
        say "found configuration file", nil
        defaults = ParseConfig.new(config_path).params || {}
        defaults = defaults.map{ |key,value| {key => value.to_f} }.reduce(:merge)
        @options_merge = original_options.merge( defaults )
      end

      # print current configuration
      say_status "iphone 1x scale",       @options_merge[:scale_iphone_1x],       :blue
      say_status "iphone 2x scale",       @options_merge[:scale_iphone_2x],       :blue
      say_status "iphone 3x scale",       @options_merge[:scale_iphone_3x],       :blue
      say_status "ipad 1x scale",         @options_merge[:scale_ipad_1x],         :blue
      say_status "ipad 2x scale",         @options_merge[:scale_ipad_2x],         :blue
      say_status "create image assets:",  @options_merge[:create_image_assets],   :blue
      say_status "create xcatlas:",       @options_merge[:create_xcatlas],        :blue

      say_status "DRY RUN - no files will be created!", nil, :red if @options_merge[:dry_run]

    end

    def create_output_directory
      say_status "create output directory", nil, :yellow
      name = File.basename target
      Dir.mkdir(target) unless Dir.exists?(target)
    end

    def xcassets_directory

      # support single file or directory source
      source_elements = File.directory?(source) ? Dir.entries(source) : [ File.basename(source) ]

      # each source file
      source_elements.each do |f|

        next if f == "." || f == ".." || f == ".DS_Store" || f == ".xcutils-config"

        fn = f.gsub("@3x","").gsub("~ipad","").gsub("@2x","") # remove extensions
        fn = File.basename(fn,File.extname(fn))               # remove file extension

        say_status "# #{fn}", nil, :magenta

        # create folder
        base_name = File.basename(target)
        imageset_folder = @options_merge[:create_image_assets] ? File.join(target,"#{fn}.imageset") : target
        imageset_folder = File.join(target,"#{base_name}.atlas") if @options_merge[:create_xcatlas]
        Dir.mkdir(imageset_folder) unless Dir.exists?(imageset_folder)

        say_status "packing into xcasset:", imageset_folder, :blue if @options_merge[:create_image_assets]
        say_status "packing into xcatlas:", imageset_folder, :blue if @options_merge[:create_xcatlas]

        # load image
        img = Magick::Image.read(File.join(source,f)).first

        # create @3x version
        say_status "create @3x version", "#{fn}@3x", :yellow
        unless @options_merge[:dry_run]
          img_3x = XCUtilsImage.scale_image(img,@options_merge[:scale_iphone_3x])
          img_3x.write(File.join(imageset_folder,"#{fn}@3x.png"))
        end
        content_iphone_3x = {"idiom" => "iphone", "scale" => "3x", "filename" => "#{fn}@3x.png"}

        # create ipad retina version
        say_status "create ipad retina version", "#{fn}@2x~ipad", :yellow
        unless @options_merge[:dry_run]
          img_ipad_2x = XCUtilsImage.scale_image(img,@options_merge[:scale_ipad_2x])
          img_ipad_2x.write(File.join(imageset_folder,"#{fn}@2x~ipad.png"))
        end
        content_ipad_2x = {"idiom" => "ipad", "scale" => "2x", "filename" => "#{fn}@2x~ipad.png"}

        # create ipad non retina version
        say_status "create ipad non retina version", "#{fn}~ipad", :yellow
        unless @options_merge[:dry_run]
          img_ipad_1x = XCUtilsImage.scale_image(img,@options_merge[:scale_ipad_1x])
          img_ipad_1x.write(File.join(imageset_folder,"#{fn}~ipad.png"))
        end
        content_ipad = {"idiom" => "ipad", "scale" => "1x", "filename" => "#{fn}~ipad.png"}

        # create iphone retina version
        say_status "create iphone retina version", "#{fn}@2x", :yellow
        unless @options_merge[:dry_run]
          img_iphone_2x = XCUtilsImage.scale_image(img,@options_merge[:scale_iphone_2x])
          img_iphone_2x.write(File.join(imageset_folder,"#{fn}@2x.png"))
        end
        content_iphone_2x = {"idiom" => "iphone", "scale" => "2x", "filename" => "#{fn}@2x.png"}

        # create iphone non retina version
        say_status "create iphone non retina version", "#{fn}", :yellow
        unless @options_merge[:dry_run]
          img_iphone_1x = XCUtilsImage.scale_image(img,@options_merge[:scale_iphone_1x])
          img_iphone_1x.write(File.join(imageset_folder,"#{fn}.png"))
        end
        content_iphone = {"idiom" => "iphone", "scale" => "1x", "filename" => "#{fn}.png"}

        # for imageassets create json
        if @options_merge[:create_image_assets] && !@options_merge[:dry_run]
          contents_json = JSON.pretty_generate( {"images" => [content_iphone, content_iphone_2x, content_iphone_3x, content_ipad, content_ipad_2x], "info" => {"version" => 1, "author" => "xcode"} } )

          File.open(File.join(imageset_folder,"Contents.json"),"w") do |f|
            f.write(contents_json)
          end
        end

      end
    end

  end
end