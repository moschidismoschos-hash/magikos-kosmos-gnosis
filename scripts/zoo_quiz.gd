extends Control

var animals := [
    {"name_gr":"Λιοντάρι","name_en":"Lion","image":"res://assets/animals/lion.svg"},
    {"name_gr":"Ελέφαντας","name_en":"Elephant","image":"res://assets/animals/elephant.svg"},
    {"name_gr":"Καμηλοπάρδαλη","name_en":"Giraffe","image":"res://assets/animals/giraffe.svg"},
    {"name_gr":"Ζέβρα","name_en":"Zebra","image":"res://assets/animals/zebra.svg"}
]

var correct_index := 0
var image_view: TextureRect
var question_label: Label
var feedback_label: Label
var answers_box: GridContainer
var next_button: Button
var stars_label: Label
var stars := 0
var answered := false

func _ready() -> void:
    randomize()
    stars = int(_load_value("stars", 0))
    _build_interface()
    _new_question()

func _build_interface() -> void:
    var background := TextureRect.new()
    background.texture = load("res://assets/zoo_background.svg")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    add_child(background)

    var shade := ColorRect.new()
    shade.color = Color(0.02, 0.05, 0.08, 0.30)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(shade)

    var top := PanelContainer.new()
    top.position = Vector2(18, 16)
    top.size = Vector2(1244, 72)
    top.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.96), 22))
    add_child(top)

    var top_row := HBoxContainer.new()
    top.add_child(top_row)

    var back := Button.new()
    back.text = "← Ζωολογικός Κήπος"
    back.custom_minimum_size = Vector2(250, 50)
    back.add_theme_font_size_override("font_size", 21)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://zoo.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Κουίζ Ζώων"
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
    panel.position = Vector2(230, 105)
    panel.size = Vector2(820, 570)
    panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.97), 28))
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 12)
    panel.add_child(column)

    question_label = Label.new()
    question_label.text = "Ποιο ζώο βλέπεις;"
    question_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    question_label.add_theme_font_size_override("font_size", 30)
    column.add_child(question_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε την ερώτηση"
    hear.custom_minimum_size = Vector2(0, 50)
    hear.pressed.connect(func(): _speak("Ποιο ζώο βλέπεις;", "el"))
    column.add_child(hear)

    image_view = TextureRect.new()
    image_view.custom_minimum_size = Vector2(0, 260)
    image_view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    image_view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    column.add_child(image_view)

    answers_box = GridContainer.new()
    answers_box.columns = 2
    answers_box.add_theme_constant_override("h_separation", 12)
    answers_box.add_theme_constant_override("v_separation", 12)
    column.add_child(answers_box)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", 24)
    column.add_child(feedback_label)

    next_button = Button.new()
    next_button.text = "Επόμενη ερώτηση"
    next_button.custom_minimum_size = Vector2(0, 56)
    next_button.visible = false
    next_button.pressed.connect(_new_question)
    column.add_child(next_button)

func _new_question() -> void:
    answered = false
    feedback_label.text = ""
    next_button.visible = false
    correct_index = randi_range(0, animals.size() - 1)
    image_view.texture = load(animals[correct_index]["image"])

    for child in answers_box.get_children():
        child.queue_free()

    var order := [0, 1, 2, 3]
    order.shuffle()

    for index in order:
        var button := Button.new()
        button.text = animals[index]["name_gr"]
        button.custom_minimum_size = Vector2(360, 68)
        button.add_theme_font_size_override("font_size", 22)
        button.pressed.connect(func(chosen=index): _answer(chosen))
        answers_box.add_child(button)

func _answer(chosen: int) -> void:
    if answered:
        return

    if chosen == correct_index:
        answered = true
        feedback_label.text = "Μπράβο! Σωστή απάντηση! ⭐"
        stars += 1
        stars_label.text = "⭐ %d" % stars
        _save_value("stars", stars)
        _speak("Μπράβο! Σωστή απάντηση!", "el")
        next_button.visible = true
        for child in answers_box.get_children():
            child.disabled = true
    else:
        feedback_label.text = "Δοκίμασε ξανά."
        _speak("Δοκίμασε ξανά.", "el")

func _speak(text: String, language: String) -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    DisplayServer.tts_stop()
    var voices := DisplayServer.tts_get_voices_for_language(language)

    if voices.size() > 0:
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
