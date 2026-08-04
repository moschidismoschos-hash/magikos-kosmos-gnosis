extends Control

var correct_number := 0
var options_box: GridContainer
var feedback_label: Label
var next_button: Button
var stars_label: Label
var stars := 0
var answered := false

func _ready() -> void:
    randomize()
    stars = int(_load_value("stars", 0))
    _build()
    _new_question()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#eef9ff")
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
    back.text = "← Αριθμοί"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://numbers.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Κουίζ Αριθμών"
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
    panel.position = Vector2(210, 105)
    panel.size = Vector2(860, 585)
    panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.98), 28))
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 18)
    panel.add_child(column)

    var instruction := Label.new()
    instruction.text = "Άκουσε και βρες τον σωστό αριθμό."
    instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    instruction.add_theme_font_size_override("font_size", 28)
    column.add_child(instruction)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε τον αριθμό"
    hear.custom_minimum_size = Vector2(0, 62)
    hear.add_theme_font_size_override("font_size", 22)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

    options_box = GridContainer.new()
    options_box.columns = 2
    options_box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    options_box.add_theme_constant_override("h_separation", 18)
    options_box.add_theme_constant_override("v_separation", 18)
    column.add_child(options_box)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", 26)
    column.add_child(feedback_label)

    next_button = Button.new()
    next_button.text = "Επόμενη ερώτηση"
    next_button.custom_minimum_size = Vector2(0, 58)
    next_button.visible = false
    next_button.pressed.connect(_new_question)
    column.add_child(next_button)

func _new_question() -> void:
    answered = false
    feedback_label.text = ""
    next_button.visible = false
    correct_number = randi_range(0, 100)

    for child in options_box.get_children():
        child.queue_free()

    var choices := [correct_number]

    while choices.size() < 4:
        var candidate := clampi(correct_number + randi_range(-15, 15), 0, 100)
        if candidate not in choices:
            choices.append(candidate)

    choices.shuffle()

    for choice in choices:
        var button := Button.new()
        button.text = str(choice)
        button.custom_minimum_size = Vector2(300, 130)
        button.add_theme_font_size_override("font_size", 58)
        button.pressed.connect(func(selected=choice): _answer(selected))
        options_box.add_child(button)

    await get_tree().create_timer(0.3).timeout
    _speak_current()

func _answer(selected: int) -> void:
    if answered:
        return

    if selected == correct_number:
        answered = true
        feedback_label.text = "Μπράβο! Σωστός αριθμός! ⭐"
        stars += 1
        stars_label.text = "⭐ %d" % stars
        _save_value("stars", stars)
        next_button.visible = true

        for child in options_box.get_children():
            child.disabled = true
    else:
        feedback_label.text = "Δοκίμασε ξανά."

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var voices := DisplayServer.tts_get_voices_for_language("el")

    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(str(correct_number), voices[0])

func _panel_style(color: Color, radius: int) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = color
    style.corner_radius_top_left = radius
    style.corner_radius_top_right = radius
    style.corner_radius_bottom_left = radius
    style.corner_radius_bottom_right = radius
    style.content_margin_left = 18
    style.content_margin_right = 18
    style.content_margin_top = 16
    style.content_margin_bottom = 16
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
