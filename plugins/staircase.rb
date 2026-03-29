# frozen_string_literal: true
require 'sketchup'
require 'extensions'

module Staircase
  extension = SketchupExtension.new('楼梯生成器', File.join(File.dirname(__FILE__), 'staircase/main'))
  extension.version = '1.0.0'
  extension.creator = 'OnlinePlugins'
  extension.description = '快速生成直跑楼梯和旋转楼梯'
  Sketchup.register_extension(extension, true)
end
