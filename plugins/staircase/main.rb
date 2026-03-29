# frozen_string_literal: true
module Staircase
  # 直跑楼梯
  def self.straight(steps = 12, width = 1000, tread = 280, riser = 170)
    model = Sketchup.active_model
    model.start_operation('Straight Staircase', true)
    group = model.active_entities.add_group

    steps.times do |i|
      x0 = 0
      y0 = i * tread
      z0 = i * riser
      pts = [
        Geom::Point3d.new(x0, y0, z0),
        Geom::Point3d.new(x0 + width, y0, z0),
        Geom::Point3d.new(x0 + width, y0 + tread, z0),
        Geom::Point3d.new(x0, y0 + tread, z0)
      ]
      face = group.entities.add_face(pts)
      face.pushpull(-riser)
    end

    model.commit_operation
  end

  # 旋转楼梯
  def self.spiral(steps = 16, radius = 800, tread_width = 800, riser = 170, rotation = 360)
    model = Sketchup.active_model
    model.start_operation('Spiral Staircase', true)
    group = model.active_entities.add_group

    angle_step = rotation.degrees / steps
    center = Geom::Point3d.new(0, 0, 0)

    steps.times do |i|
      a1 = i * angle_step
      a2 = (i + 1) * angle_step
      z = i * riser
      inner_r = 100

      pts = [
        Geom::Point3d.new(Math.cos(a1) * inner_r, Math.sin(a1) * inner_r, z),
        Geom::Point3d.new(Math.cos(a1) * (inner_r + tread_width), Math.sin(a1) * (inner_r + tread_width), z),
        Geom::Point3d.new(Math.cos(a2) * (inner_r + tread_width), Math.sin(a2) * (inner_r + tread_width), z),
        Geom::Point3d.new(Math.cos(a2) * inner_r, Math.sin(a2) * inner_r, z)
      ]
      face = group.entities.add_face(pts)
      face.pushpull(-riser) if face
    end

    # 中心柱
    circle = group.entities.add_circle(center, Z_AXIS, inner_r = 100, 24)
    col_face = group.entities.add_face(circle)
    col_face.pushpull(-(steps * riser)) if col_face

    model.commit_operation
  end

  def self.straight_dialog
    result = UI.inputbox(['踏步数', '宽度mm', '踏面mm', '踢面mm'], ['12', '1000', '280', '170'], '直跑楼梯')
    straight(result[0].to_i, result[1].to_f, result[2].to_f, result[3].to_f) if result
  end

  def self.spiral_dialog
    result = UI.inputbox(['踏步数', '半径mm', '踏面宽mm', '踢面mm', '总旋转角度'], ['16', '800', '800', '170', '360'], '旋转楼梯')
    spiral(result[0].to_i, result[1].to_f, result[2].to_f, result[3].to_f, result[4].to_f) if result
  end

  unless @loaded
    menu = UI.menu('Plugins')
    sub = menu.add_submenu('楼梯生成器')
    sub.add_item('直跑楼梯...') { straight_dialog }
    sub.add_item('旋转楼梯...') { spiral_dialog }
    @loaded = true
  end
end
