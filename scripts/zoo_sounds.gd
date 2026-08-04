extends Control

var animals := [
    {"name_gr":"Λιοντάρι","name_en":"Lion","image":"res://assets/animals/lion.svg"},
    {"name_gr":"Ελέφαντας","name_en":"Elephant","image":"res://assets/animals/elephant.svg"},
    {"name_gr":"Καμηλοπάρδαλη","name_en":"Giraffe","image":"res://assets/animals/giraffe.svg"},
    {"name_gr":"Ζέβρα","name_en":"Zebra","image":"res://assets/animals/zebra.svg"}
]

var correct_index := 0
var cards: Array[TextureButton] = []
var feedback_label: Label
var stars_label: Label
var stars := 0
var answered := false

func _ready() -> void:
    randomize()
    stars = int(_load_value("stars", 0))
    _build_interface()
    _new_round()

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
    title.text = "Ποιο ζώο ακούς;"
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
    panel.position = Vector2(170, 105)
    panel.size = Vector2(940, 585)
    panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.97), 28))
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 15)
    panel.add_child(column)

    var instruction := Label.new()
    instruction.text = "Άκουσε το όνομα και πάτησε τη σωστή εικόνα."
    instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    instruction.add_theme_font_size_override("font_size", 25)
    column.add_child(instruction)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε ξανά"
    hear.custom_minimum_size = Vector2(0, 58)
    hear.add_theme_font_size_override("font_size", 22)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

    var grid := GridContainer.new()
    grid.columns = 2
    grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    grid.add_theme_constant_override("h_separation", 18)
    grid.add_theme_constant_override("v_separation", 18)
    column.add_child(grid)

    for i in range(4):
        var card := TextureButton.new()
        card.custom_minimum_size = Vector2(360, 200)
        card.ignore_texture_size = true
        card.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
        card.pressed.connect(func(index=i): _choose(index))
        grid.add_child(card)
        cards.append(card)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", 25)
    column.add_child(feedback_label)

    var next := Button.new()
    next.name = "NextButton"
    next.text = "Επόμενος γύρος"
    next.custom_minimum_size = Vector2(0, 56)
    next.visible = false
    next.pressed.connect(_new_round)
    column.add_child(next)

func _new_round() -> void:
    answered = false
    feedback_label.text = ""
    get_node("PanelContainer/VBoxContainer/NextButton").visible = false
    correct_index = randi_range(0, animals.size() - 1)

    var order := [0, 1, 2, 3]
    order.shuffle()

    for i in range(cards.size()):
        cards[i].texture_normal = load(animals[order[i]]["image"])
        cards[i].set_meta("animal_index", order[i])
        cards[i].disabled = false
        cards[i].modulate = Color.WHITE

    await get_tree().create_timer(0.35).timeout
    _speak_current()

func _speak_current() -> void:
    var text := animals[correct_index]["name_gr"]

    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        feedback_label.text = "Η συσκευή δεν υποστηρίζει φωνητική εκφώνηση."
        return

    DisplayServer.tts_stop()
    var voices := DisplayServer.tts_get_voices_for_language("el")

    if voices.size() > 0:
        DisplayServer.tts_speak(text, voices[0])

func _choose(card_index: int) -> void:
    if answered:
        return

    var chosen := int(cards[card_index].get_meta("animal_index"))

    if chosen == correct_index:
        answered = true
        feedback_label.text = "Μπράβο! Σωστή εικόνα! ⭐"
        cards[card_index].modulate = Color(0.75, 1.0, 0.75)
        stars += 1
        stars_label.text = "⭐ %d" % stars
        _save_value("stars", stars)

        for card in cards:
            card.disabled = true

        get_node("PanelContainer/VBoxContainer/NextButton").visible = true
    else:
        cards[card_index].modulate = Color(1.0, 0.72, 0.72)
        feedback_label.text = "Δοκίμασε ξανά."

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
