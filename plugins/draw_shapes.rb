# frozen_string_literal: true
require 'sketchup'
require 'extensions'

module DrawShapes
  PLUGIN_NAME = '绘制基本形状'.freeze
  PLUGIN_VERSION = '1.2.0'.freeze
  PLUGIN_DIR = File.join(File.dirname(__FILE__), 'draw_shapes')

  extension = SketchupExtension.new(PLUGIN_NAME, File.join(PLUGIN_DIR, 'main'))
  extension.version = PLUGIN_VERSION
  extension.creator = 'Demo'
  extension.description = '快速绘制立方体、球体、圆柱体'
  Sketchup.register_extension(extension, true)
end
