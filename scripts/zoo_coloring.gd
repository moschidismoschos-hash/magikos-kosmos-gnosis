extends Control

var drawing_area: Control
var strokes: Array[Line2D] = []
var current_line: Line2D
var current_color := Color("#f39c35")
var brush_width := 18.0
var drawing := false

func _ready() -> void:
    _build_interface()

func _build_interface() -> void:
    var background := TextureRect.new()
    background.texture = load("res://assets/zoo_background.svg")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    add_child(background)

    var shade := ColorRect.new()
    shade.color = Color(0.02, 0.05, 0.08, 0.28)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(shade)

    var top := PanelContainer.new()
    top.position = Vector2(18, 16)
    top.size = Vector2(1244, 72)
    top.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.96), 22))
    add_child(top)

    var top_row := HBoxContainer.new()
    top.add_child(top_row)

    var back := Button.new()
    back.text = "← Ζωολογικός Κήπος"
    back.custom_minimum_size = Vector2(250, 50)
    back.add_theme_font_size_override("font_size", 21)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://zoo.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Χρωμάτισε το Λιοντάρι"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top_row.add_child(title)

    var clear := Button.new()
    clear.text = "🧽 Καθάρισμα"
    clear.custom_minimum_size = Vector2(180, 50)
    clear.pressed.connect(_clear_canvas)
    top_row.add_child(clear)

    var body := HBoxContainer.new()
    body.position = Vector2(28, 108)
    body.size = Vector2(1224, 570)
    body.add_theme_constant_override("separation", 18)
    add_child(body)

    var tools := PanelContainer.new()
    tools.custom_minimum_size = Vector2(220, 0)
    tools.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.94), 24))
    body.add_child(tools)

    var tools_box := VBoxContainer.new()
    tools_box.add_theme_constant_override("separation", 12)
    tools.add_child(tools_box)

    var tools_title := Label.new()
    tools_title.text = "Χρώματα"
    tools_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    tools_title.add_theme_font_size_override("font_size", 24)
    tools_box.add_child(tools_title)

    var colors := [
        Color("#f39c35"),
        Color("#ffd84d"),
        Color("#e74c3c"),
        Color("#3498db"),
        Color("#2ecc71"),
        Color("#9b59b6"),
        Color("#7f4f24"),
        Color("#222222")
    ]

    for color in colors:
        var button := Button.new()
        button.custom_minimum_size = Vector2(0, 48)
        button.text = " "
        button.add_theme_stylebox_override("normal", _color_style(color))
        button.add_theme_stylebox_override("hover", _color_style(color.lightened(0.12)))
        button.add_theme_stylebox_override("pressed", _color_style(color.darkened(0.12)))
        button.pressed.connect(func(c=color): current_color = c)
        tools_box.add_child(button)

    var size_title := Label.new()
    size_title.text = "Μέγεθος πινέλου"
    size_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    size_title.add_theme_font_size_override("font_size", 20)
    tools_box.add_child(size_title)

    var small := Button.new()
    small.text = "Μικρό"
    small.pressed.connect(func(): brush_width = 10.0)
    tools_box.add_child(small)

    var medium := Button.new()
    medium.text = "Μεσαίο"
    medium.pressed.connect(func(): brush_width = 18.0)
    tools_box.add_child(medium)

    var large := Button.new()
    large.text = "Μεγάλο"
    large.pressed.connect(func(): brush_width = 30.0)
    tools_box.add_child(large)

    var canvas_panel := PanelContainer.new()
    canvas_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    canvas_panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.98), 24))
    body.add_child(canvas_panel)

    drawing_area = Control.new()
    drawing_area.mouse_filter = Control.MOUSE_FILTER_STOP
    drawing_area.set_process_input(true)
    canvas_panel.add_child(drawing_area)

    var outline := TextureRect.new()
    outline.texture = load("res://assets/coloring/lion_outline.svg")
    outline.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    outline.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    outline.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
    drawing_area.add_child(outline)

    drawing_area.gui_input.connect(_on_draw_input)

func _on_draw_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            _begin_stroke(event.position)
        else:
            drawing = false
            current_line = null

    elif event is InputEventScreenDrag:
        if drawing and current_line != null:
            current_line.add_point(event.position)

    elif event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if event.pressed:
                _begin_stroke(event.position)
            else:
                drawing = false
                current_line = null

    elif event is InputEventMouseMotion:
        if drawing and current_line != null:
            current_line.add_point(event.position)

func _begin_stroke(position: Vector2) -> void:
    drawing = true
    current_line = Line2D.new()
    current_line.default_color = current_color
    current_line.width = brush_width
    current_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
    current_line.end_cap_mode = Line2D.LINE_CAP_ROUND
    current_line.joint_mode = Line2D.LINE_JOINT_ROUND
    current_line.add_point(position)
    drawing_area.add_child(current_line)
    strokes.append(current_line)

func _clear_canvas() -> void:
    for stroke in strokes:
        if is_instance_valid(stroke):
            stroke.queue_free()
    strokes.clear()
    current_line = null
    drawing = false

func _panel_style(color: Color, radius: int) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = color
    style.corner_radius_top_left = radius
    style.corner_radius_top_right = radius
    style.corner_radius_bottom_left = radius
    style.corner_radius_bottom_right = radius
    style.content_margin_left = 16
    style.content_margin_right = 16
    style.content_margin_top = 14
    style.content_margin_bottom = 14
    return style

func _color_style(color: Color) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = color
    style.corner_radius_top_left = 14
    style.corner_radius_top_right = 14
    style.corner_radius_bottom_left = 14
    style.corner_radius_bottom_right = 14
    style.border_width_left = 3
    style.border_width_top = 3
    style.border_width_right = 3
    style.border_width_bottom = 3
    style.border_color = Color.WHITE
    return style
