extends Control

var colors := [
    {"name":"Κόκκινο","hex":"#e53935"},{"name":"Μπλε","hex":"#1e88e5"},{"name":"Κίτρινο","hex":"#fdd835"},
    {"name":"Πράσινο","hex":"#43a047"},{"name":"Πορτοκαλί","hex":"#fb8c00"},{"name":"Μωβ","hex":"#8e24aa"},
    {"name":"Ροζ","hex":"#ec407a"},{"name":"Καφέ","hex":"#6d4c41"},{"name":"Μαύρο","hex":"#212121"},
    {"name":"Λευκό","hex":"#f5f5f5"},{"name":"Γκρι","hex":"#757575"}
]

var correct_index := 0
var target_label: Label
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
    _new_round()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#f4fbff")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var top := HBoxContainer.new()
    top.position = Vector2(20, 18)
    top.size = Vector2(1240, 58)
    add_child(top)

    var back := Button.new()
    back.text = "← Χρώματα"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://colors.tscn"))
    top.add_child(back)

    var title := Label.new()
    title.text = "Κουίζ Χρωμάτων"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top.add_child(title)

    stars_label = Label.new()
    stars_label.text = "⭐ %d" % stars
    stars_label.add_theme_font_size_override("font_size", 24)
    top.add_child(stars_label)

    var panel := PanelContainer.new()
    panel.position = Vector2(220, 110)
    panel.size = Vector2(840, 560)
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 18)
    panel.add_child(column)

    target_label = Label.new()
    target_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    target_label.add_theme_font_size_override("font_size", 32)
    column.add_child(target_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε το χρώμα"
    hear.custom_minimum_size = Vector2(0, 58)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

    options_box = GridContainer.new()
    options_box.columns = 2
    options_box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    column.add_child(options_box)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", 26)
    column.add_child(feedback_label)

    next_button = Button.new()
    next_button.text = "Επόμενος γύρος"
    next_button.custom_minimum_size = Vector2(0, 58)
    next_button.visible = false
    next_button.pressed.connect(_new_round)
    column.add_child(next_button)

func _new_round() -> void:
    answered = false
    feedback_label.text = ""
    next_button.visible = false
    correct_index = randi_range(0, colors.size() - 1)
    target_label.text = "Βρες το: " + colors[correct_index]["name"]

    for child in options_box.get_children():
        child.queue_free()

    var choices := [correct_index]

    while choices.size() < 4:
        var candidate := randi_range(0, colors.size() - 1)
        if candidate not in choices:
            choices.append(candidate)

    choices.shuffle()

    for index in choices:
        var button := Button.new()
        button.custom_minimum_size = Vector2(300, 140)
        button.text = colors[index]["name"]
        button.add_theme_font_size_override("font_size", 22)

        var style := StyleBoxFlat.new()
        style.bg_color = Color(colors[index]["hex"])
        style.corner_radius_top_left = 18
        style.corner_radius_top_right = 18
        style.corner_radius_bottom_left = 18
        style.corner_radius_bottom_right = 18
        button.add_theme_stylebox_override("normal", style)

        button.pressed.connect(func(chosen=index): _answer(chosen))
        options_box.add_child(button)

func _answer(chosen: int) -> void:
    if answered:
        return

    if chosen == correct_index:
        answered = true
        feedback_label.text = "Μπράβο! Σωστό χρώμα! ⭐"
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
        DisplayServer.tts_speak(colors[correct_index]["name"], voices[0])

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
