# frozen_string_literal: true
module HelloWorld
  def self.say_hello
    model = Sketchup.active_model
    UI.messagebox("Hello World!\n当前模型: #{model.title.empty? ? '未命名' : model.title}")
  end

  def self.add_greeting_text
    model = Sketchup.active_model
    model.start_operation('Add Greeting', true)
    group = model.active_entities.add_group
    group.entities.add_3d_text('Hello SketchUp!', TextAlignLeft, 'Arial', false, false, 12.0, 0.0, 0.5, true, 5.0)
    model.commit_operation
    UI.messagebox('已添加 3D 文字: Hello SketchUp!')
  end

  unless @loaded
    menu = UI.menu('Plugins')
    submenu = menu.add_submenu('Hello World')
    submenu.add_item('Say Hello') { say_hello }
    submenu.add_item('添加 3D 文字') { add_greeting_text }
    @loaded = true
  end
end
