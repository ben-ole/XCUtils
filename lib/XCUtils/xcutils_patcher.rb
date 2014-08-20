require "thor"
require 'fileutils'
require 'debugger'

module XCUtils
  class XCUtilsPatcher < Thor::Group
    include Thor::Actions

    argument :version
    argument :base


    def rename_and_move
      say_status "Patching", "version #{version}", :yellow

      unless version.eql? "0.0.1"
        say_status "Warning", "No patch for this version...", :red
        abort
      end

      unless Dir.exists?("#{base}.atlas")
        say_status "Warning", "The base atlas does not exist, make sure you are within the correct directoy", :red
        abort
      end

      checkSuffix = ["~ipad", "@2x~ipad", "@2x"]
      
      checkSuffix.each do |suffix|
        dir_suffix = "#{base}#{suffix}.atlas"

        say_status "Patching", "#{dir_suffix}", :yellow
        Dir["#{dir_suffix}/*.png"].each do |f| 
          filename = File.basename(f, File.extname(f))
          unless filename.eql? ("filename#{suffix}")
            dir = File.dirname(f)
            new_filename = "#{base}.atlas/#{filename}#{suffix}.png"
            say_status "Moving", "#{f} :: #{new_filename}", :green
            File.rename(f, new_filename)
          end
        end
        say_status "Deleting", "#{dir_suffix}", :yellow
        FileUtils.rm_rf(dir_suffix)
      end
      
    end 

  end
end