extends Control

var questions := [
    {"question":"Ποιος πλανήτης είναι ο κοντινότερος στον Ήλιο;","answer":"Ερμής","choices":["Ερμής","Γη","Κρόνος","Ποσειδώνας"]},
    {"question":"Σε ποιον πλανήτη ζούμε;","answer":"Γη","choices":["Γη","Άρης","Αφροδίτη","Δίας"]},
    {"question":"Ποιος είναι ο μεγαλύτερος πλανήτης;","answer":"Δίας","choices":["Δίας","Ερμής","Γη","Άρης"]},
    {"question":"Ποιος πλανήτης έχει μεγάλους δακτυλίους;","answer":"Κρόνος","choices":["Κρόνος","Γη","Αφροδίτη","Ερμής"]},
    {"question":"Πώς λέγεται ο φυσικός δορυφόρος της Γης;","answer":"Σελήνη","choices":["Σελήνη","Ήλιος","Άρης","Κομήτης"]},
    {"question":"Ποιος ταξιδεύει και εργάζεται στο διάστημα;","answer":"Αστροναύτης","choices":["Αστροναύτης","Οδηγός","Μάγειρας","Κηπουρός"]},
    {"question":"Τι μεταφέρει ανθρώπους στο διάστημα;","answer":"Πύραυλος","choices":["Πύραυλος","Λεωφορείο","Τρένο","Πλοίο"]},
    {"question":"Ποιος πλανήτης λέγεται Κόκκινος Πλανήτης;","answer":"Άρης","choices":["Άρης","Γη","Ουρανός","Κρόνος"]}
]

var current := 0
var stars := 0
var question_label: Label
var options_box: VBoxContainer
var feedback_label: Label
var next_button: Button
var stars_label: Label
var answered := false

func _ready() -> void:
    randomize()
    questions.shuffle()
    stars = int(_load_value("stars", 0))
    _build()
    _show_question()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#10162f")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var top := HBoxContainer.new()
    top.position = Vector2(20, 18)
    top.size = Vector2(1240, 58)
    add_child(top)

    var back := Button.new()
    back.text = "← Διάστημα"
    back.custom_minimum_size = Vector2(180, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://space.tscn"))
    top.add_child(back)

    var title := Label.new()
    title.text = "Κουίζ Διαστήματος"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    title.add_theme_color_override("font_color", Color.WHITE)
    top.add_child(title)

    stars_label = Label.new()
    stars_label.text = "⭐ %d" % stars
    stars_label.add_theme_font_size_override("font_size", 24)
    stars_label.add_theme_color_override("font_color", Color.WHITE)
    top.add_child(stars_label)

    var panel := PanelContainer.new()
    panel.position = Vector2(230, 110)
    panel.size = Vector2(820, 560)
    panel.add_theme_stylebox_override("panel", _panel_style(Color("#f7f8ff"), 28))
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 16)
    panel.add_child(column)

    question_label = Label.new()
    question_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    question_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    question_label.custom_minimum_size = Vector2(0, 100)
    question_label.add_theme_font_size_override("font_size", 31)
    column.add_child(question_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε την ερώτηση"
    hear.custom_minimum_size = Vector2(0, 56)
    hear.pressed.connect(_speak_question)
    column.add_child(hear)

    options_box = VBoxContainer.new()
    options_box.add_theme_constant_override("separation", 10)
    column.add_child(options_box)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", 26)
    column.add_child(feedback_label)

    next_button = Button.new()
    next_button.text = "Επόμενη ερώτηση"
    next_button.custom_minimum_size = Vector2(0, 56)
    next_button.visible = false
    next_button.pressed.connect(_next_question)
    column.add_child(next_button)

func _show_question() -> void:
    answered = false
    feedback_label.text = ""
    next_button.visible = false

    var item = questions[current]
    question_label.text = item["question"]

    for child in options_box.get_children():
        child.queue_free()

    var choices = item["choices"].duplicate()
    choices.shuffle()

    for choice in choices:
        var button := Button.new()
        button.text = choice
        button.custom_minimum_size = Vector2(0, 62)
        button.add_theme_font_size_override("font_size", 23)
        button.pressed.connect(func(selected=choice): _answer(selected))
        options_box.add_child(button)

func _answer(selected: String) -> void:
    if answered:
        return

    if selected == questions[current]["answer"]:
        answered = true
        feedback_label.text = "Μπράβο! Σωστή απάντηση! ⭐"
        stars += 1
        stars_label.text = "⭐ %d" % stars
        _save_value("stars", stars)
        next_button.visible = true

        for child in options_box.get_children():
            child.disabled = true
    else:
        feedback_label.text = "Δοκίμασε ξανά."

func _next_question() -> void:
    current = (current + 1) % questions.size()
    _show_question()

func _speak_question() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var voices := DisplayServer.tts_get_voices_for_language("el")

    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(questions[current]["question"], voices[0])

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

func _panel_style(color: Color, radius: int) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = color
    style.corner_radius_top_left = radius
    style.corner_radius_top_right = radius
    style.corner_radius_bottom_left = radius
    style.corner_radius_bottom_right = radius
    style.content_margin_left = 16
    style.content_margin_right = 16
    style.content_margin_top = 14
    style.content_margin_bottom = 14
    return style
