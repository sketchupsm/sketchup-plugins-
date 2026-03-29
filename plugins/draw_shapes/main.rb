# frozen_string_literal: true
module DrawShapes
  def self.draw_cube(size = 100)
    model = Sketchup.active_model
    model.start_operation('Draw Cube', true)
    group = model.active_entities.add_group
    pts = [
      Geom::Point3d.new(0, 0, 0), Geom::Point3d.new(size, 0, 0),
      Geom::Point3d.new(size, size, 0), Geom::Point3d.new(0, size, 0)
    ]
    group.entities.add_face(pts).pushpull(-size)
    model.commit_operation
  end

  def self.draw_cylinder(radius = 50, height = 100, segments = 24)
    model = Sketchup.active_model
    model.start_operation('Draw Cylinder', true)
    group = model.active_entities.add_group
    center = Geom::Point3d.new(0, 0, 0)
    circle = group.entities.add_circle(center, Z_AXIS, radius, segments)
    group.entities.add_face(circle).pushpull(-height)
    model.commit_operation
  end

  def self.draw_sphere(radius = 50, segments = 24)
    model = Sketchup.active_model
    model.start_operation('Draw Sphere', true)
    group = model.active_entities.add_group
    entities = group.entities
    center = Geom::Point3d.new(0, 0, 0)
    path = entities.add_circle(center, Y_AXIS, radius, segments)
    profile_center = Geom::Point3d.new(0, 0, radius)
    profile = entities.add_circle(profile_center, X_AXIS, radius, segments)
    entities.add_face(profile).followme(path)
    model.commit_operation
  end

  def self.draw_cube_dialog
    result = UI.inputbox(['边长 (mm)'], ['100'], '绘制立方体')
    draw_cube(result[0].to_f) if result
  end

  def self.draw_cylinder_dialog
    result = UI.inputbox(['半径', '高度', '分段'], ['50', '100', '24'], '绘制圆柱体')
    draw_cylinder(result[0].to_f, result[1].to_f, result[2].to_i) if result
  end

  def self.draw_sphere_dialog
    result = UI.inputbox(['半径', '分段'], ['50', '24'], '绘制球体')
    draw_sphere(result[0].to_f, result[1].to_i) if result
  end

  unless @loaded
    menu = UI.menu('Plugins')
    submenu = menu.add_submenu('绘制基本形状')
    submenu.add_item('立方体...') { draw_cube_dialog }
    submenu.add_item('圆柱体...') { draw_cylinder_dialog }
    submenu.add_item('球体...') { draw_sphere_dialog }
    @loaded = true
  end
end
