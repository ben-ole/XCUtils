require "thor"
require 'fileutils'
require 'debugger'

module XCUtils
  class XCUtilsSorter < Thor::Group
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

    def sort_directory
      say_status "sort directory"
      i = 0
      b = [0,0,0,0]

      # move files
      Dir.foreach(source) do |f|
        next if f == "." || f == ".." || f == ".DS_Store"

        p fn = f

        if (!f.include?("@2x") && !f.include?("~ipad"))
          FileUtils.mv(File.join(source,f),File.join(target,"#{name}.atlas",fn))
          i = i+1
          b[0] = b[0]+1
        elsif (f.include?("@2x") && !f.include?("~ipad"))
          FileUtils.mv(File.join(source,f),File.join(target,"#{name}@2x.atlas",fn.gsub("@2x","")))
          i = i+1
          b[1] = b[1]+1
        elsif (!f.include?("@2x") && f.include?("~ipad"))
          FileUtils.mv(File.join(source,f),File.join(target,"#{name}~ipad.atlas",fn.gsub("~ipad","")))
          i = i+1
          b[2] = b[2]+1
        elsif (f.include?("@2x") && f.include?("~ipad"))
          FileUtils.mv(File.join(source,f),File.join(target,"#{name}@2x~ipad.atlas",fn.gsub("@2x~ipad","")))
          i = i+1
          b[3] = b[3]+1
        end
      end

      # some checking
      p "total number of files moved: #{i}"
      p "! Issue detected: not same amount of files in each atlas (#{b})" unless b[0] == b[1] && b[1] == b[2] && b[2] == b[3]
    end

  end
end