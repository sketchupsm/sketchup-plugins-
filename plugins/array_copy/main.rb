# frozen_string_literal: true
module ArrayCopy
  # 线性阵列
  def self.linear_array
    model = Sketchup.active_model
    sel = model.selection.first
    unless sel.is_a?(Sketchup::Group) || sel.is_a?(Sketchup::ComponentInstance)
      UI.messagebox('请先选中一个组或组件')
      return
    end

    result = UI.inputbox(
      ['X方向数量', 'Y方向数量', 'Z方向数量', 'X间距mm', 'Y间距mm', 'Z间距mm'],
      ['3', '1', '1', '1500', '1500', '1500'],
      '线性阵列'
    )
    return unless result

    nx, ny, nz = result[0].to_i, result[1].to_i, result[2].to_i
    dx, dy, dz = result[3].to_f, result[4].to_f, result[5].to_f

    model.start_operation('Linear Array', true)
    nx.times do |ix|
      ny.times do |iy|
        nz.times do |iz|
          next if ix == 0 && iy == 0 && iz == 0
          vec = Geom::Vector3d.new(ix * dx, iy * dy, iz * dz)
          if sel.is_a?(Sketchup::Group)
            copy = model.active_entities.add_group
            sel.entities.each { |e| e.copy.move!(vec) rescue nil }
            copy = sel.copy
            t = copy.transformation
            copy.transformation = t * Geom::Transformation.translation(vec)
          else
            t = sel.transformation
            copy = model.active_entities.add_instance(sel.definition, t)
            copy.transformation = t * Geom::Transformation.translation(vec)
          end
        end
      end
    end
    model.commit_operation
  end

  # 环形阵列
  def self.radial_array
    model = Sketchup.active_model
    sel = model.selection.first
    unless sel.is_a?(Sketchup::Group) || sel.is_a?(Sketchup::ComponentInstance)
      UI.messagebox('请先选中一个组或组件')
      return
    end

    result = UI.inputbox(
      ['数量', '总角度(度)', '旋转轴 (X/Y/Z)'],
      ['8', '360', 'Z'],
      '环形阵列'
    )
    return unless result

    count = result[0].to_i
    total_angle = result[1].to_f.degrees
    axis = case result[2].upcase
           when 'X' then X_AXIS
           when 'Y' then Y_AXIS
           else Z_AXIS
           end

    center = ORIGIN
    angle_step = total_angle / count

    model.start_operation('Radial Array', true)
    (1...count).each do |i|
      angle = i * angle_step
      rotation = Geom::Transformation.rotation(center, axis, angle)
      if sel.is_a?(Sketchup::ComponentInstance)
        copy = model.active_entities.add_instance(sel.definition, sel.transformation)
      else
        copy = sel.copy
      end
      copy.transformation = rotation * sel.transformation
    end
    model.commit_operation
  end

  unless @loaded
    menu = UI.menu('Plugins')
    sub = menu.add_submenu('阵列复制')
    sub.add_item('线性阵列...') { linear_array }
    sub.add_item('环形阵列...') { radial_array }
    @loaded = true
  end
end
