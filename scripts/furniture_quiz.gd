extends Control

var furniture := [
    {"name":"Κρεβάτι","symbol":"🛏️"},{"name":"Καναπές","symbol":"🛋️"},
    {"name":"Καρέκλα","symbol":"🪑"},{"name":"Τραπέζι","symbol":"🪵"},
    {"name":"Γραφείο","symbol":"🖥️"},{"name":"Ντουλάπα","symbol":"🚪"},
    {"name":"Συρταριέρα","symbol":"🗄️"},{"name":"Βιβλιοθήκη","symbol":"📚"},
    {"name":"Ράφι","symbol":"📚"},{"name":"Κομοδίνο","symbol":"🛏️"},
    {"name":"Πολυθρόνα","symbol":"🪑"},{"name":"Σκαμπό","symbol":"🪑"},
    {"name":"Τραπεζάκι","symbol":"☕"},{"name":"Καθρέφτης","symbol":"🪞"},
    {"name":"Λάμπα","symbol":"💡"},{"name":"Τηλεόραση","symbol":"📺"},
    {"name":"Ψυγείο","symbol":"🧊"},{"name":"Κουζίνα","symbol":"🍳"},
    {"name":"Πλυντήριο","symbol":"🧺"},{"name":"Μπανιέρα","symbol":"🛁"}
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
    background.color = Color("#f7f3ef")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var top := HBoxContainer.new()
    top.position = Vector2(20, 18)
    top.size = Vector2(1240, 58)
    add_child(top)

    var back := Button.new()
    back.text = "← Έπιπλα"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://furniture.tscn"))
    top.add_child(back)

    var title := Label.new()
    title.text = "Κουίζ Επίπλων"
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
    hear.text = "🔊 Άκουσε"
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
    correct_index = randi_range(0, furniture.size() - 1)
    target_label.text = "Βρες: " + furniture[correct_index]["name"]

    for child in options_box.get_children():
        child.queue_free()

    var choices := [correct_index]

    while choices.size() < 4:
        var candidate := randi_range(0, furniture.size() - 1)
        if candidate not in choices:
            choices.append(candidate)

    choices.shuffle()

    for value in choices:
        var button := Button.new()
        button.text = furniture[value]["symbol"]
        button.custom_minimum_size = Vector2(300, 150)
        button.add_theme_font_size_override("font_size", 92)
        button.pressed.connect(func(chosen=value): _answer(chosen))
        options_box.add_child(button)

func _answer(chosen: int) -> void:
    if answered:
        return

    if chosen == correct_index:
        answered = true
        feedback_label.text = "Μπράβο! Σωστό έπιπλο! ⭐"
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
        DisplayServer.tts_speak(furniture[correct_index]["name"], voices[0])

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
