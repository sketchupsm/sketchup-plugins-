# frozen_string_literal: true
require 'sketchup'
require 'extensions'

module ArrayCopy
  extension = SketchupExtension.new('阵列复制', File.join(File.dirname(__FILE__), 'array_copy/main'))
  extension.version = '1.0.0'
  extension.creator = 'OnlinePlugins'
  extension.description = '线性阵列和环形阵列复制工具'
  Sketchup.register_extension(extension, true)
end
