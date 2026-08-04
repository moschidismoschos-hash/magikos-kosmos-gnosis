extends Control

var correct_order: Array[int] = []
var current_order: Array[int] = []
var selected_index := -1
var buttons: Array[Button] = []
var feedback_label: Label
var stars_label: Label
var stars := 0
var completed := false

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
    title.text = "Βάλε τους Αριθμούς στη Σειρά"
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
    panel.position = Vector2(150, 115)
    panel.size = Vector2(980, 550)
    panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.98), 28))
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 24)
    panel.add_child(column)

    var instruction := Label.new()
    instruction.text = "Πάτησε δύο αριθμούς για να αλλάξουν θέση."
    instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    instruction.add_theme_font_size_override("font_size", 27)
    column.add_child(instruction)

    var numbers_row := HBoxContainer.new()
    numbers_row.alignment = BoxContainer.ALIGNMENT_CENTER
    numbers_row.add_theme_constant_override("separation", 14)
    column.add_child(numbers_row)

    for i in range(6):
        var button := Button.new()
        button.custom_minimum_size = Vector2(125, 150)
        button.add_theme_font_size_override("font_size", 54)
        button.pressed.connect(func(index=i): _select(index))
        numbers_row.add_child(button)
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
    shuffle.text = "🔀 Νέος γύρος"
    shuffle.custom_minimum_size = Vector2(190, 56)
    shuffle.pressed.connect(_new_round)
    controls.add_child(shuffle)

    var help := Button.new()
    help.text = "💡 Βοήθεια"
    help.custom_minimum_size = Vector2(190, 56)
    help.pressed.connect(_show_help)
    controls.add_child(help)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε τη σειρά"
    hear.custom_minimum_size = Vector2(220, 56)
    hear.pressed.connect(_speak_order)
    controls.add_child(hear)

func _new_round() -> void:
    var start := randi_range(0, 95)

    correct_order.clear()
    current_order.clear()

    for i in range(6):
        correct_order.append(start + i)
        current_order.append(start + i)

    current_order.shuffle()

    if current_order == correct_order:
        current_order = [
            correct_order[2],
            correct_order[0],
            correct_order[5],
            correct_order[1],
            correct_order[4],
            correct_order[3]
        ]

    selected_index = -1
    completed = false
    feedback_label.text = ""
    _refresh()

func _refresh() -> void:
    for i in range(buttons.size()):
        buttons[i].text = str(current_order[i])
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

    var temporary := current_order[selected_index]
    current_order[selected_index] = current_order[index]
    current_order[index] = temporary

    selected_index = -1
    _refresh()
    _check_completion()

func _check_completion() -> void:
    if current_order == correct_order:
        completed = true
        feedback_label.text = "Μπράβο! Οι αριθμοί μπήκαν στη σωστή σειρά! ⭐"
        stars += 1
        stars_label.text = "⭐ %d" % stars
        _save_value("stars", stars)

func _show_help() -> void:
    var text_values: Array[String] = []

    for value in correct_order:
        text_values.append(str(value))

    feedback_label.text = "Η σωστή σειρά είναι: " + "  ".join(text_values)

func _speak_order() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var text_values: Array[String] = []

    for value in correct_order:
        text_values.append(str(value))

    var voices := DisplayServer.tts_get_voices_for_language("el")

    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(", ".join(text_values), voices[0])

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
