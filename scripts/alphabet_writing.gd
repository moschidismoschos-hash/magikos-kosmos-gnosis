extends Control

var greek := ["Α","Β","Γ","Δ","Ε","Ζ","Η","Θ","Ι","Κ","Λ","Μ","Ν","Ξ","Ο","Π","Ρ","Σ","Τ","Υ","Φ","Χ","Ψ","Ω"]
var english := ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

var current = greek
var language := "el"
var index := 0

var guide_label: Label
var title_label: Label
var stars_label: Label
var drawing_area: Control
var strokes: Array[Line2D] = []
var current_line: Line2D
var drawing := false
var stars := 0

func _ready() -> void:
    stars = int(_load_value("stars", 0))
    _build()
    _show_letter()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#e8f7ff")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var top := PanelContainer.new()
    top.position = Vector2(18, 16)
    top.size = Vector2(1244, 72)
    top.add_theme_stylebox_override("panel", _panel_style(Color.WHITE, 22))
    add_child(top)

    var top_row := HBoxContainer.new()
    top.add_child(top_row)

    var back := Button.new()
    back.text = "← Αλφαβήτα"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://alphabet.tscn"))
    top_row.add_child(back)

    title_label = Label.new()
    title_label.text = "Γράψε το γράμμα"
    title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 30)
    top_row.add_child(title_label)

    stars_label = Label.new()
    stars_label.text = "⭐ %d" % stars
    stars_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    stars_label.add_theme_font_size_override("font_size", 24)
    top_row.add_child(stars_label)

    var panel := PanelContainer.new()
    panel.position = Vector2(160, 105)
    panel.size = Vector2(960, 585)
    panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.97), 28))
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 12)
    panel.add_child(column)

    var languages := HBoxContainer.new()
    languages.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_child(languages)

    var gr := Button.new()
    gr.text = "Ελληνικά"
    gr.custom_minimum_size = Vector2(160, 50)
    gr.pressed.connect(func(): _set_language("el"))
    languages.add_child(gr)

    var en := Button.new()
    en.text = "Αγγλικά"
    en.custom_minimum_size = Vector2(160, 50)
    en.pressed.connect(func(): _set_language("en"))
    languages.add_child(en)

    var controls := HBoxContainer.new()
    controls.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_child(controls)

    var previous := Button.new()
    previous.text = "← Προηγούμενο"
    previous.custom_minimum_size = Vector2(180, 50)
    previous.pressed.connect(_previous)
    controls.add_child(previous)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε"
    hear.custom_minimum_size = Vector2(180, 50)
    hear.pressed.connect(_speak_current)
    controls.add_child(hear)

    var next := Button.new()
    next.text = "Επόμενο →"
    next.custom_minimum_size = Vector2(180, 50)
    next.pressed.connect(_next)
    controls.add_child(next)

    var clear := Button.new()
    clear.text = "🧽 Καθάρισμα"
    clear.custom_minimum_size = Vector2(180, 50)
    clear.pressed.connect(_clear_canvas)
    controls.add_child(clear)

    var canvas_panel := PanelContainer.new()
    canvas_panel.custom_minimum_size = Vector2(0, 390)
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
    guide_label.add_theme_color_override("font_color", Color(0.35,0.35,0.35,0.18))
    guide_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    drawing_area.add_child(guide_label)

    drawing_area.gui_input.connect(_on_draw_input)

    var done := Button.new()
    done.text = "⭐ Το έγραψα!"
    done.custom_minimum_size = Vector2(0, 56)
    done.pressed.connect(_complete)
    column.add_child(done)

func _set_language(value: String) -> void:
    language = value
    current = greek if value == "el" else english
    index = 0
    _show_letter()

func _show_letter() -> void:
    guide_label.text = current[index]
    title_label.text = "Γράψε το " + current[index]
    _clear_canvas()

func _previous() -> void:
    index = (index - 1 + current.size()) % current.size()
    _show_letter()

func _next() -> void:
    index = (index + 1) % current.size()
    _show_letter()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var voices := DisplayServer.tts_get_voices_for_language(language)
    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(current[index], voices[0])

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
    current_line.default_color = Color("#3367d6")
    current_line.width = 20.0
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

func _complete() -> void:
    if strokes.size() == 0:
        title_label.text = "Σχεδίασε πρώτα το γράμμα."
        return

    stars += 1
    stars_label.text = "⭐ %d" % stars
    _save_value("stars", stars)
    title_label.text = "Μπράβο! Έγραψες το " + current[index] + " ⭐"

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
