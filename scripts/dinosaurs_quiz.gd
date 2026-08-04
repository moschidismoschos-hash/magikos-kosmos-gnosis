extends Control

var dinosaurs := [
    {"name":"Τυραννόσαυρος Ρεξ","symbol":"🦖"},
    {"name":"Τρικεράτοπας","symbol":"🦕"},
    {"name":"Βραχιόσαυρος","symbol":"🦕"},
    {"name":"Στεγόσαυρος","symbol":"🦕"},
    {"name":"Βελοσιράπτορας","symbol":"🦖"},
    {"name":"Σπινόσαυρος","symbol":"🦖"},
    {"name":"Αγκυλόσαυρος","symbol":"🦕"},
    {"name":"Παρασαυρόλοφος","symbol":"🦕"},
    {"name":"Απατόσαυρος","symbol":"🦕"},
    {"name":"Διπλόδοκος","symbol":"🦕"},
    {"name":"Καρνόταυρος","symbol":"🦖"},
    {"name":"Ιγκουανόδοντας","symbol":"🦕"},
    {"name":"Αλλόσαυρος","symbol":"🦖"},
    {"name":"Παχυκεφαλόσαυρος","symbol":"🦕"},
    {"name":"Πτεροδάκτυλος","symbol":"🦅"}
]

var correct_index := 0
var target_label: Label
var options_box: VBoxContainer
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
    background.color = Color("#eef8e8")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var top := HBoxContainer.new()
    top.position = Vector2(20, 18)
    top.size = Vector2(1240, 58)
    add_child(top)

    var back := Button.new()
    back.text = "← Δεινόσαυροι"
    back.custom_minimum_size = Vector2(190, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://dinosaurs.tscn"))
    top.add_child(back)

    var title := Label.new()
    title.text = "Κουίζ Δεινοσαύρων"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top.add_child(title)

    stars_label = Label.new()
    stars_label.text = "⭐ %d" % stars
    stars_label.add_theme_font_size_override("font_size", 24)
    top.add_child(stars_label)

    var panel := PanelContainer.new()
    panel.position = Vector2(230, 110)
    panel.size = Vector2(820, 560)
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 16)
    panel.add_child(column)

    target_label = Label.new()
    target_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    target_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    target_label.custom_minimum_size = Vector2(0, 90)
    target_label.add_theme_font_size_override("font_size", 31)
    column.add_child(target_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε"
    hear.custom_minimum_size = Vector2(0, 56)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

    options_box = VBoxContainer.new()
    options_box.add_theme_constant_override("separation", 10)
    column.add_child(options_box)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", 26)
    column.add_child(feedback_label)

    next_button = Button.new()
    next_button.text = "Επόμενος γύρος"
    next_button.custom_minimum_size = Vector2(0, 56)
    next_button.visible = false
    next_button.pressed.connect(_new_round)
    column.add_child(next_button)

func _new_round() -> void:
    answered = false
    feedback_label.text = ""
    next_button.visible = false
    correct_index = randi_range(0, dinosaurs.size() - 1)
    target_label.text = "Βρες τον δεινόσαυρο: " + dinosaurs[correct_index]["name"]

    for child in options_box.get_children():
        child.queue_free()

    var choices := [correct_index]

    while choices.size() < 4:
        var candidate := randi_range(0, dinosaurs.size() - 1)
        if candidate not in choices:
            choices.append(candidate)

    choices.shuffle()

    for value in choices:
        var button := Button.new()
        button.text = dinosaurs[value]["symbol"] + "  " + dinosaurs[value]["name"]
        button.custom_minimum_size = Vector2(0, 68)
        button.add_theme_font_size_override("font_size", 22)
        button.pressed.connect(func(chosen=value): _answer(chosen))
        options_box.add_child(button)

func _answer(chosen: int) -> void:
    if answered:
        return

    if chosen == correct_index:
        answered = true
        feedback_label.text = "Μπράβο! Σωστός δεινόσαυρος! ⭐"
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
        DisplayServer.tts_speak("Βρες τον δεινόσαυρο " + dinosaurs[correct_index]["name"], voices[0])

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
