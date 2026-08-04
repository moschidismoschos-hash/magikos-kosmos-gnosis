extends Control

var greek := [
    {"l":"Α","w":"Αεροπλάνο","e":"✈️"},{"l":"Β","w":"Βάρκα","e":"⛵"},{"l":"Γ","w":"Γάτα","e":"🐱"},
    {"l":"Δ","w":"Δέντρο","e":"🌳"},{"l":"Ε","w":"Ελέφαντας","e":"🐘"},{"l":"Ζ","w":"Ζέβρα","e":"🦓"},
    {"l":"Η","w":"Ήλιος","e":"☀️"},{"l":"Θ","w":"Θάλασσα","e":"🌊"},{"l":"Ι","w":"Ιπποπόταμος","e":"🦛"},
    {"l":"Κ","w":"Καμηλοπάρδαλη","e":"🦒"},{"l":"Λ","w":"Λιοντάρι","e":"🦁"},{"l":"Μ","w":"Μήλο","e":"🍎"}
]

var english := [
    {"l":"A","w":"Apple","e":"🍎"},{"l":"B","w":"Ball","e":"⚽"},{"l":"C","w":"Cat","e":"🐱"},
    {"l":"D","w":"Dog","e":"🐶"},{"l":"E","w":"Elephant","e":"🐘"},{"l":"F","w":"Fish","e":"🐟"},
    {"l":"G","w":"Giraffe","e":"🦒"},{"l":"H","w":"House","e":"🏠"},{"l":"I","w":"Ice cream","e":"🍦"},
    {"l":"J","w":"Juice","e":"🧃"},{"l":"K","w":"Kite","e":"🪁"},{"l":"L","w":"Lion","e":"🦁"}
]

var current = greek
var language := "el"
var correct_index := 0
var letter_label: Label
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
    background.color = Color("#f1f9ff")
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

    var title := Label.new()
    title.text = "Ταίριαξε το Γράμμα"
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
    panel.position = Vector2(200, 105)
    panel.size = Vector2(880, 585)
    panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.98), 28))
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 16)
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

    var instruction := Label.new()
    instruction.text = "Βρες την εικόνα και τη λέξη που αρχίζουν από το γράμμα."
    instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    instruction.add_theme_font_size_override("font_size", 24)
    column.add_child(instruction)

    letter_label = Label.new()
    letter_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    letter_label.add_theme_font_size_override("font_size", 130)
    column.add_child(letter_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε το γράμμα"
    hear.custom_minimum_size = Vector2(0, 56)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

    options_box = GridContainer.new()
    options_box.columns = 2
    options_box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    options_box.add_theme_constant_override("h_separation", 14)
    options_box.add_theme_constant_override("v_separation", 14)
    column.add_child(options_box)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", 25)
    column.add_child(feedback_label)

    next_button = Button.new()
    next_button.text = "Επόμενος γύρος"
    next_button.custom_minimum_size = Vector2(0, 56)
    next_button.visible = false
    next_button.pressed.connect(_new_round)
    column.add_child(next_button)

func _set_language(value: String) -> void:
    language = value
    current = greek if value == "el" else english
    _new_round()

func _new_round() -> void:
    answered = false
    feedback_label.text = ""
    next_button.visible = false
    correct_index = randi_range(0, current.size() - 1)
    letter_label.text = current[correct_index]["l"]

    for child in options_box.get_children():
        child.queue_free()

    var choices := [correct_index]

    while choices.size() < 4:
        var candidate := randi_range(0, current.size() - 1)
        if candidate not in choices:
            choices.append(candidate)

    choices.shuffle()

    for index in choices:
        var button := Button.new()
        button.text = current[index]["e"] + "\n" + current[index]["w"]
        button.custom_minimum_size = Vector2(350, 120)
        button.add_theme_font_size_override("font_size", 26)
        button.pressed.connect(func(chosen=index): _answer(chosen))
        options_box.add_child(button)

func _answer(chosen: int) -> void:
    if answered:
        return

    if chosen == correct_index:
        answered = true
        feedback_label.text = "Μπράβο! Σωστή αντιστοίχιση! ⭐"
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

    var voices := DisplayServer.tts_get_voices_for_language(language)
    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(current[correct_index]["l"], voices[0])

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
