extends Control

var left_number := 0
var right_number := 0
var correct_symbol := "="

var left_label: Label
var right_label: Label
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
    title.text = "Μεγαλύτερος, Μικρότερος ή Ίσος;"
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
    panel.position = Vector2(180, 110)
    panel.size = Vector2(920, 565)
    panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.98), 28))
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 24)
    panel.add_child(column)

    var instruction := Label.new()
    instruction.text = "Διάλεξε το σωστό σύμβολο ανάμεσα στους δύο αριθμούς."
    instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    instruction.add_theme_font_size_override("font_size", 27)
    column.add_child(instruction)

    var numbers_row := HBoxContainer.new()
    numbers_row.alignment = BoxContainer.ALIGNMENT_CENTER
    numbers_row.add_theme_constant_override("separation", 45)
    column.add_child(numbers_row)

    left_label = Label.new()
    left_label.custom_minimum_size = Vector2(220, 180)
    left_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    left_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    left_label.add_theme_font_size_override("font_size", 110)
    numbers_row.add_child(left_label)

    var question := Label.new()
    question.text = "?"
    question.custom_minimum_size = Vector2(140, 180)
    question.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    question.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    question.add_theme_font_size_override("font_size", 95)
    numbers_row.add_child(question)

    right_label = Label.new()
    right_label.custom_minimum_size = Vector2(220, 180)
    right_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    right_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    right_label.add_theme_font_size_override("font_size", 110)
    numbers_row.add_child(right_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε την ερώτηση"
    hear.custom_minimum_size = Vector2(0, 58)
    hear.add_theme_font_size_override("font_size", 22)
    hear.pressed.connect(_speak_question)
    column.add_child(hear)

    var choices := HBoxContainer.new()
    choices.alignment = BoxContainer.ALIGNMENT_CENTER
    choices.add_theme_constant_override("separation", 20)
    column.add_child(choices)

    for symbol in [">", "=", "<"]:
        var button := Button.new()
        button.text = symbol
        button.custom_minimum_size = Vector2(190, 130)
        button.add_theme_font_size_override("font_size", 72)
        button.pressed.connect(func(selected=symbol): _answer(selected))
        choices.add_child(button)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", 27)
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

    left_number = randi_range(0, 100)
    right_number = randi_range(0, 100)

    if randi_range(0, 4) == 0:
        right_number = left_number

    left_label.text = str(left_number)
    right_label.text = str(right_number)

    if left_number > right_number:
        correct_symbol = ">"
    elif left_number < right_number:
        correct_symbol = "<"
    else:
        correct_symbol = "="

func _answer(selected: String) -> void:
    if answered:
        return

    if selected == correct_symbol:
        answered = true
        feedback_label.text = "Μπράβο! Σωστή σύγκριση! ⭐"
        stars += 1
        stars_label.text = "⭐ %d" % stars
        _save_value("stars", stars)
        next_button.visible = true
        _speak("Μπράβο! Σωστή απάντηση.")
    else:
        feedback_label.text = "Δοκίμασε ξανά."
        _speak("Δοκίμασε ξανά.")

func _speak_question() -> void:
    var phrase := ""

    if correct_symbol == ">":
        phrase = str(left_number) + " είναι μεγαλύτερο από " + str(right_number)
    elif correct_symbol == "<":
        phrase = str(left_number) + " είναι μικρότερο από " + str(right_number)
    else:
        phrase = str(left_number) + " είναι ίσο με " + str(right_number)

    _speak(phrase)

func _speak(text: String) -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var voices := DisplayServer.tts_get_voices_for_language("el")

    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(text, voices[0])

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
