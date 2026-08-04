extends Control

var animals := [
    {"name_gr":"Λιοντάρι","name_en":"Lion","letter":"Λ","image":"res://assets/animals/lion.svg","fact":"Το λιοντάρι ζει σε αγέλες και το βρυχηθμό του μπορείς να τον ακούσεις από πολύ μακριά."},
    {"name_gr":"Ελέφαντας","name_en":"Elephant","letter":"Ε","image":"res://assets/animals/elephant.svg","fact":"Ο ελέφαντας είναι το μεγαλύτερο ζώο της στεριάς και χρησιμοποιεί την προβοσκίδα του για τροφή και νερό."},
    {"name_gr":"Καμηλοπάρδαλη","name_en":"Giraffe","letter":"Κ","image":"res://assets/animals/giraffe.svg","fact":"Η καμηλοπάρδαλη έχει πολύ μακρύ λαιμό και τρώει φύλλα από ψηλά δέντρα."},
    {"name_gr":"Ζέβρα","name_en":"Zebra","letter":"Ζ","image":"res://assets/animals/zebra.svg","fact":"Κάθε ζέβρα έχει διαφορετικές ρίγες, όπως κάθε άνθρωπος έχει διαφορετικά δακτυλικά αποτυπώματα."}
]

var selected_index := 0
var animal_image: TextureRect
var name_gr: Label
var name_en: Label
var letter_label: Label
var fact_label: Label
var star_label: Label
var stars := 0

func _ready() -> void:
    stars = int(_load_value("stars", 0))
    _build()
    _show_animal(0)

func _build() -> void:
    var background := TextureRect.new()
    background.texture = load("res://assets/zoo_background.svg")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    add_child(background)

    var shade := ColorRect.new()
    shade.color = Color(0.03, 0.08, 0.05, 0.18)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(shade)

    var top := PanelContainer.new()
    top.position = Vector2(18, 16)
    top.size = Vector2(1244, 74)
    top.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.94), 24))
    add_child(top)

    var top_row := HBoxContainer.new()
    top_row.add_theme_constant_override("separation", 16)
    top.add_child(top_row)

    var back := Button.new()
    back.text = "← Χάρτης"
    back.custom_minimum_size = Vector2(160, 52)
    back.add_theme_font_size_override("font_size", 22)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://main.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Ζωολογικός Κήπος"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top_row.add_child(title)

    star_label = Label.new()
    star_label.text = "⭐ %d" % stars
    star_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    star_label.add_theme_font_size_override("font_size", 25)
    top_row.add_child(star_label)

    var content := HBoxContainer.new()
    content.position = Vector2(34, 112)
    content.size = Vector2(1212, 530)
    content.add_theme_constant_override("separation", 18)
    add_child(content)

    var list_panel := PanelContainer.new()
    list_panel.custom_minimum_size = Vector2(245, 0)
    list_panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.91), 24))
    content.add_child(list_panel)

    var list_box := VBoxContainer.new()
    list_box.add_theme_constant_override("separation", 9)
    list_panel.add_child(list_box)

    var list_title := Label.new()
    list_title.text = "Διάλεξε ζώο"
    list_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    list_title.add_theme_font_size_override("font_size", 24)
    list_box.add_child(list_title)

    for i in animals.size():
        var button := Button.new()
        button.text = animals[i]["name_gr"]
        button.custom_minimum_size = Vector2(0, 72)
        button.add_theme_font_size_override("font_size", 22)
        button.pressed.connect(func(index=i): _show_animal(index))
        list_box.add_child(button)

    var main_panel := PanelContainer.new()
    main_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    main_panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.95), 28))
    content.add_child(main_panel)

    var main_column := VBoxContainer.new()
    main_column.add_theme_constant_override("separation", 12)
    main_panel.add_child(main_column)

    var heading_row := HBoxContainer.new()
    main_column.add_child(heading_row)

    letter_label = Label.new()
    letter_label.custom_minimum_size = Vector2(110, 85)
    letter_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    letter_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    letter_label.add_theme_font_size_override("font_size", 58)
    heading_row.add_child(letter_label)

    var names := VBoxContainer.new()
    names.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    heading_row.add_child(names)

    name_gr = Label.new()
    name_gr.add_theme_font_size_override("font_size", 34)
    names.add_child(name_gr)

    name_en = Label.new()
    name_en.add_theme_font_size_override("font_size", 22)
    names.add_child(name_en)

    animal_image = TextureRect.new()
    animal_image.custom_minimum_size = Vector2(0, 270)
    animal_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    animal_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    main_column.add_child(animal_image)

    fact_label = Label.new()
    fact_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    fact_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    fact_label.add_theme_font_size_override("font_size", 21)
    fact_label.custom_minimum_size = Vector2(0, 80)
    main_column.add_child(fact_label)

    var actions := HBoxContainer.new()
    actions.alignment = BoxContainer.ALIGNMENT_CENTER
    actions.add_theme_constant_override("separation", 14)
    main_column.add_child(actions)

    var hear_gr := Button.new()
    hear_gr.text = "🔊 Ελληνικά"
    hear_gr.custom_minimum_size = Vector2(210, 58)
    hear_gr.pressed.connect(_speak_greek)
    actions.add_child(hear_gr)

    var hear_en := Button.new()
    hear_en.text = "🔊 Αγγλικά"
    hear_en.custom_minimum_size = Vector2(210, 58)
    hear_en.pressed.connect(_speak_english)
    actions.add_child(hear_en)

    var learn := Button.new()
    learn.text = "⭐ Το έμαθα!"
    learn.custom_minimum_size = Vector2(190, 58)
    learn.pressed.connect(_reward)
    actions.add_child(learn)

    var puzzle := Button.new()
    puzzle.text = "🧩 Παζλ"
    puzzle.custom_minimum_size = Vector2(170, 58)
    puzzle.pressed.connect(func(): get_tree().change_scene_to_file("res://zoo_puzzle.tscn"))
    actions.add_child(puzzle)

    var coloring := Button.new()
    coloring.text = "🎨 Χρωμάτισμα"
    coloring.custom_minimum_size = Vector2(190, 58)
    coloring.pressed.connect(func(): get_tree().change_scene_to_file("res://zoo_coloring.tscn"))
    actions.add_child(coloring)

    var quiz := Button.new()
    quiz.text = "❓ Κουίζ"
    quiz.custom_minimum_size = Vector2(160, 58)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://zoo_quiz.tscn"))
    actions.add_child(quiz)

    var memory := Button.new()
    memory.text = "🧠 Μνήμη"
    memory.custom_minimum_size = Vector2(160, 58)
    memory.pressed.connect(func(): get_tree().change_scene_to_file("res://zoo_memory.tscn"))
    actions.add_child(memory)

func _show_animal(index: int) -> void:
    selected_index = index
    var animal = animals[index]
    letter_label.text = animal["letter"]
    name_gr.text = animal["name_gr"]
    name_en.text = animal["name_en"]
    fact_label.text = animal["fact"]
    animal_image.texture = load(animal["image"])

func _speak_greek() -> void:
    var animal = animals[selected_index]
    _speak(animal["name_gr"] + ". " + animal["fact"], "el")

func _speak_english() -> void:
    var animal = animals[selected_index]
    _speak(animal["name_en"], "en")

func _speak(text: String, language: String) -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return
    DisplayServer.tts_stop()
    var voices := DisplayServer.tts_get_voices_for_language(language)
    if voices.size() > 0:
        DisplayServer.tts_speak(text, voices[0])

func _reward() -> void:
    stars += 1
    star_label.text = "⭐ %d" % stars
    _save_value("stars", stars)

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
