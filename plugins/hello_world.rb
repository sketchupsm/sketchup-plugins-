# frozen_string_literal: true
require 'sketchup'
require 'extensions'

module HelloWorld
  PLUGIN_NAME = 'Hello World 示例插件'.freeze
  PLUGIN_VERSION = '1.0.0'.freeze
  PLUGIN_DIR = File.join(File.dirname(__FILE__), 'hello_world')

  extension = SketchupExtension.new(PLUGIN_NAME, File.join(PLUGIN_DIR, 'main'))
  extension.version = PLUGIN_VERSION
  extension.creator = 'Demo'
  extension.description = '一个简单的示例插件'
  Sketchup.register_extension(extension, true)
end
