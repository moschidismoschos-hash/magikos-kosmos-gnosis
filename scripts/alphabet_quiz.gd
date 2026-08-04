extends Control

var greek := ["Α","Β","Γ","Δ","Ε","Ζ","Η","Θ","Ι","Κ","Λ","Μ","Ν","Ξ","Ο","Π","Ρ","Σ","Τ","Υ","Φ","Χ","Ψ","Ω"]
var english := ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

var current = greek
var language := "el"
var correct_letter := ""
var options_box: GridContainer
var feedback_label: Label
var stars_label: Label
var prompt_label: Label
var stars := 0
var answered := false

func _ready() -> void:
    randomize()
    stars = int(_load_value("stars", 0))
    _build()
    _new_question()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#eaf7ff")
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
    title.text = "Κουίζ Γραμμάτων"
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
    panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.97), 28))
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 18)
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

    prompt_label = Label.new()
    prompt_label.text = "Άκουσε και βρες το σωστό γράμμα."
    prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    prompt_label.add_theme_font_size_override("font_size", 28)
    column.add_child(prompt_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε το γράμμα"
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

    var next := Button.new()
    next.name = "NextButton"
    next.text = "Επόμενη ερώτηση"
    next.custom_minimum_size = Vector2(0, 58)
    next.visible = false
    next.pressed.connect(_new_question)
    column.add_child(next)

func _set_language(value: String) -> void:
    language = value
    current = greek if value == "el" else english
    _new_question()

func _new_question() -> void:
    answered = false
    feedback_label.text = ""
    get_node("PanelContainer/VBoxContainer/NextButton").visible = false

    correct_letter = current[randi_range(0, current.size() - 1)]

    for child in options_box.get_children():
        child.queue_free()

    var choices := [correct_letter]

    while choices.size() < 4:
        var candidate = current[randi_range(0, current.size() - 1)]
        if candidate not in choices:
            choices.append(candidate)

    choices.shuffle()

    for choice in choices:
        var button := Button.new()
        button.text = choice
        button.custom_minimum_size = Vector2(300, 120)
        button.add_theme_font_size_override("font_size", 58)
        button.pressed.connect(func(selected=choice): _answer(selected))
        options_box.add_child(button)

    await get_tree().create_timer(0.3).timeout
    _speak_current()

func _answer(selected: String) -> void:
    if answered:
        return

    if selected == correct_letter:
        answered = true
        feedback_label.text = "Μπράβο! Σωστό γράμμα! ⭐"
        stars += 1
        stars_label.text = "⭐ %d" % stars
        _save_value("stars", stars)

        for child in options_box.get_children():
            child.disabled = true

        get_node("PanelContainer/VBoxContainer/NextButton").visible = true
        _speak("Μπράβο! Σωστό γράμμα!")
    else:
        feedback_label.text = "Δοκίμασε ξανά."
        _speak("Δοκίμασε ξανά.")

func _speak_current() -> void:
    _speak(correct_letter)

func _speak(text: String) -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var voices := DisplayServer.tts_get_voices_for_language(language)
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
