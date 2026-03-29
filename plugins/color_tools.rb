# frozen_string_literal: true
require 'sketchup'
require 'extensions'

module ColorTools
  extension = SketchupExtension.new('颜色工具', File.join(File.dirname(__FILE__), 'color_tools/main'))
  extension.version = '1.0.0'
  extension.creator = 'OnlinePlugins'
  extension.description = '批量上色、随机彩虹色、渐变色工具'
  Sketchup.register_extension(extension, true)
end
