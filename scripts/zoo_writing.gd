extends Control

var lessons := [
    {"letter":"Λ","word":"Λιοντάρι","voice":"Λ. Λιοντάρι."},
    {"letter":"Ε","word":"Ελέφαντας","voice":"Ε. Ελέφαντας."},
    {"letter":"Κ","word":"Καμηλοπάρδαλη","voice":"Κ. Καμηλοπάρδαλη."},
    {"letter":"Ζ","word":"Ζέβρα","voice":"Ζ. Ζέβρα."}
]

var lesson_index := 0
var drawing_area: Control
var guide_label: Label
var word_label: Label
var stars_label: Label
var strokes: Array[Line2D] = []
var current_line: Line2D
var drawing := false
var stars := 0

func _ready() -> void:
    stars = int(_load_value("stars", 0))
    _build_interface()
    _show_lesson()

func _build_interface() -> void:
    var background := TextureRect.new()
    background.texture = load("res://assets/zoo_background.svg")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    add_child(background)

    var shade := ColorRect.new()
    shade.color = Color(0.02, 0.05, 0.08, 0.30)
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
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://zoo.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Γράψε το Γράμμα"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top_row.add_child(title)

    stars_label = Label.new()
    stars_label.text = "⭐ %d" % stars
    stars_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    stars_label.add_theme_font_size_override("font_size", 24)
    top_row.add_child(stars_label)

    var panel := PanelContainer.new()
    panel.position = Vector2(175, 105)
    panel.size = Vector2(930, 585)
    panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.97), 28))
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 12)
    panel.add_child(column)

    word_label = Label.new()
    word_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    word_label.add_theme_font_size_override("font_size", 30)
    column.add_child(word_label)

    var controls := HBoxContainer.new()
    controls.alignment = BoxContainer.ALIGNMENT_CENTER
    controls.add_theme_constant_override("separation", 12)
    column.add_child(controls)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε"
    hear.custom_minimum_size = Vector2(180, 50)
    hear.pressed.connect(_speak_current)
    controls.add_child(hear)

    var clear := Button.new()
    clear.text = "🧽 Καθάρισμα"
    clear.custom_minimum_size = Vector2(180, 50)
    clear.pressed.connect(_clear_canvas)
    controls.add_child(clear)

    var next := Button.new()
    next.text = "➡ Επόμενο"
    next.custom_minimum_size = Vector2(180, 50)
    next.pressed.connect(_next_lesson)
    controls.add_child(next)

    var canvas_panel := PanelContainer.new()
    canvas_panel.custom_minimum_size = Vector2(0, 400)
    canvas_panel.add_theme_stylebox_override("panel", _panel_style(Color.WHITE, 22))
    column.add_child(canvas_panel)

    drawing_area = Control.new()
    drawing_area.mouse_filter = Control.MOUSE_FILTER_STOP
    canvas_panel.add_child(drawing_area)

    guide_label = Label.new()
    guide_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    guide_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    guide_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    guide_label.add_theme_font_size_override("font_size", 280)
    guide_label.add_theme_color_override("font_color", Color(0.55, 0.55, 0.55, 0.22))
    guide_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    drawing_area.add_child(guide_label)

    drawing_area.gui_input.connect(_on_draw_input)

    var done := Button.new()
    done.text = "⭐ Το έγραψα!"
    done.custom_minimum_size = Vector2(0, 56)
    done.pressed.connect(_complete_lesson)
    column.add_child(done)

func _show_lesson() -> void:
    var lesson = lessons[lesson_index]
    guide_label.text = lesson["letter"]
    word_label.text = lesson["letter"] + " — " + lesson["word"]
    _clear_canvas()

func _next_lesson() -> void:
    lesson_index = (lesson_index + 1) % lessons.size()
    _show_lesson()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var voices := DisplayServer.tts_get_voices_for_language("el")
    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(lessons[lesson_index]["voice"], voices[0])

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
    current_line.default_color = Color("#3867d6")
    current_line.width = 18.0
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

func _complete_lesson() -> void:
    if strokes.size() == 0:
        word_label.text = "Σχεδίασε πρώτα το γράμμα."
        return

    stars += 1
    stars_label.text = "⭐ %d" % stars
    _save_value("stars", stars)
    word_label.text = "Μπράβο! Έγραψες το " + lessons[lesson_index]["letter"] + " ⭐"

func _panel_style(color: Color, radius: int) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = color
    style.corner_radius_top_left = radius
    style.corner_radius_top_right = radius
    style.corner_radius_bottom_left = radius
    style.corner_radius_bottom_right = radius
    style.content_margin_left = 18
    style.content_margin_right = 18
    style.content_margin_top = 14
    style.content_margin_bottom = 14
    return style

func _save_value(key: String, value) -> void:
    var data := {}

    if FileAccess.file_exists("user://save.json"):
        var file := FileAccess.open("user://save.json", FileAccess.READ)
        var parsed = JSON.parse_string(file.get_as_text())
        if typeof(parsed) == TYPE_DICTIONARY:
            data = parsed

    data[key] = value
    var output := FileAccess.open("user://save.json", FileAccess.WRITE)
    output.store_string(JSON.stringify(data))

func _load_value(key: String, fallback):
    if not FileAccess.file_exists("user://save.json"):
        return fallback

    var file := FileAccess.open("user://save.json", FileAccess.READ)
    var parsed = JSON.parse_string(file.get_as_text())

    if typeof(parsed) != TYPE_DICTIONARY:
        return fallback

    return parsed.get(key, fallback)
