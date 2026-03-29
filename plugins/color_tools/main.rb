# frozen_string_literal: true
module ColorTools
  # 随机彩虹色：给选中的面随机上色
  def self.random_rainbow
    model = Sketchup.active_model
    sel = model.selection.grep(Sketchup::Face)
    if sel.empty?
      # 没有选中面就给所有面上色
      sel = model.active_entities.grep(Sketchup::Face)
    end
    if sel.empty?
      UI.messagebox('场景中没有面可以上色')
      return
    end

    model.start_operation('Rainbow Colors', true)
    sel.each do |face|
      mat = model.materials.add("rainbow_#{rand(99999)}")
      mat.color = Sketchup::Color.new(rand(256), rand(256), rand(256))
      face.material = mat
    end
    model.commit_operation
    UI.messagebox("已为 #{sel.length} 个面上色")
  end

  # 渐变色：从红到蓝
  def self.gradient_red_blue
    model = Sketchup.active_model
    sel = model.selection.grep(Sketchup::Face)
    sel = model.active_entities.grep(Sketchup::Face) if sel.empty?
    if sel.empty?
      UI.messagebox('场景中没有面')
      return
    end

    model.start_operation('Gradient Colors', true)
    sorted = sel.sort_by { |f| f.bounds.center.z }
    sorted.each_with_index do |face, i|
      t = sorted.length > 1 ? i.to_f / (sorted.length - 1) : 0
      r = ((1.0 - t) * 255).to_i
      b = (t * 255).to_i
      mat = model.materials.add("gradient_#{i}")
      mat.color = Sketchup::Color.new(r, 50, b)
      face.material = mat
    end
    model.commit_operation
    UI.messagebox("已为 #{sorted.length} 个面应用渐变")
  end

  # 透明度设置
  def self.set_opacity
    model = Sketchup.active_model
    sel = model.selection.grep(Sketchup::Face)
    if sel.empty?
      UI.messagebox('请先选中要设置透明度的面')
      return
    end

    result = UI.inputbox(['透明度 (0-100)'], ['50'], '设置透明度')
    return unless result

    opacity = result[0].to_f / 100.0
    model.start_operation('Set Opacity', true)
    sel.each do |face|
      mat = face.material || model.materials.add("opacity_#{rand(99999)}")
      mat.alpha = opacity
      face.material = mat
    end
    model.commit_operation
  end

  unless @loaded
    menu = UI.menu('Plugins')
    sub = menu.add_submenu('颜色工具')
    sub.add_item('随机彩虹色') { random_rainbow }
    sub.add_item('渐变色(红→蓝)') { gradient_red_blue }
    sub.add_item('设置透明度...') { set_opacity }
    @loaded = true
  end
end
