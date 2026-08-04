extends Control

var greek := ["Α","Β","Γ","Δ","Ε","Ζ"]
var english := ["A","B","C","D","E","F"]

var current = greek
var language := "el"
var order: Array[String] = []
var selected_index := -1
var buttons: Array[Button] = []
var feedback_label: Label
var stars_label: Label
var stars := 0
var completed := false

func _ready() -> void:
    stars = int(_load_value("stars", 0))
    _build()
    _new_round()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#eef8ff")
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
    title.text = "Βάλε τα Γράμματα στη Σειρά"
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
    panel.position = Vector2(170, 120)
    panel.size = Vector2(940, 540)
    panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.98), 28))
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 22)
    panel.add_child(column)

    var languages := HBoxContainer.new()
    languages.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_child(languages)

    var gr := Button.new()
    gr.text = "Ελληνικά"
    gr.custom_minimum_size = Vector2(160, 52)
    gr.pressed.connect(func(): _set_language("el"))
    languages.add_child(gr)

    var en := Button.new()
    en.text = "Αγγλικά"
    en.custom_minimum_size = Vector2(160, 52)
    en.pressed.connect(func(): _set_language("en"))
    languages.add_child(en)

    var instruction := Label.new()
    instruction.text = "Πάτησε δύο γράμματα για να αλλάξουν θέση."
    instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    instruction.add_theme_font_size_override("font_size", 25)
    column.add_child(instruction)

    var letters_row := HBoxContainer.new()
    letters_row.alignment = BoxContainer.ALIGNMENT_CENTER
    letters_row.add_theme_constant_override("separation", 12)
    column.add_child(letters_row)

    for i in range(6):
        var button := Button.new()
        button.custom_minimum_size = Vector2(120, 140)
        button.add_theme_font_size_override("font_size", 58)
        button.pressed.connect(func(index=i): _select(index))
        letters_row.add_child(button)
        buttons.append(button)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", 27)
    column.add_child(feedback_label)

    var controls := HBoxContainer.new()
    controls.alignment = BoxContainer.ALIGNMENT_CENTER
    controls.add_theme_constant_override("separation", 14)
    column.add_child(controls)

    var shuffle := Button.new()
    shuffle.text = "🔀 Ανακάτεμα"
    shuffle.custom_minimum_size = Vector2(190, 54)
    shuffle.pressed.connect(_new_round)
    controls.add_child(shuffle)

    var help := Button.new()
    help.text = "💡 Βοήθεια"
    help.custom_minimum_size = Vector2(190, 54)
    help.pressed.connect(_show_help)
    controls.add_child(help)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε τη σειρά"
    hear.custom_minimum_size = Vector2(220, 54)
    hear.pressed.connect(_speak_order)
    controls.add_child(hear)

func _set_language(value: String) -> void:
    language = value
    current = greek if value == "el" else english
    _new_round()

func _new_round() -> void:
    order = current.duplicate()
    order.shuffle()

    if order == current:
        order = [current[2], current[0], current[5], current[1], current[4], current[3]]

    selected_index = -1
    completed = false
    feedback_label.text = ""
    _refresh()

func _refresh() -> void:
    for i in range(buttons.size()):
        buttons[i].text = order[i]
        buttons[i].modulate = Color.WHITE

    if selected_index >= 0:
        buttons[selected_index].modulate = Color(1.0, 0.85, 0.35)

func _select(index: int) -> void:
    if completed:
        return

    if selected_index == -1:
        selected_index = index
        _refresh()
        return

    if selected_index == index:
        selected_index = -1
        _refresh()
        return

    var temporary := order[selected_index]
    order[selected_index] = order[index]
    order[index] = temporary
    selected_index = -1
    _refresh()
    _check()

func _check() -> void:
    if order == current:
        completed = true
        feedback_label.text = "Μπράβο! Τα γράμματα μπήκαν στη σωστή σειρά! ⭐"
        stars += 1
        stars_label.text = "⭐ %d" % stars
        _save_value("stars", stars)

func _show_help() -> void:
    feedback_label.text = "Η σωστή σειρά είναι: " + "  ".join(current)

func _speak_order() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var voices := DisplayServer.tts_get_voices_for_language(language)
    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(", ".join(current), voices[0])

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
