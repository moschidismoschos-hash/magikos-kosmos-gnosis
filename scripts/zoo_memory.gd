extends Control

var animals := [
    {"name":"Λιοντάρι","image":"res://assets/animals/lion.svg"},
    {"name":"Ελέφαντας","image":"res://assets/animals/elephant.svg"},
    {"name":"Καμηλοπάρδαλη","image":"res://assets/animals/giraffe.svg"},
    {"name":"Ζέβρα","image":"res://assets/animals/zebra.svg"}
]

var deck: Array = []
var cards: Array[TextureButton] = []
var opened: Array[int] = []
var matched: Array[bool] = []
var attempts := 0
var pairs_found := 0
var attempts_label: Label
var message_label: Label
var stars_label: Label
var stars := 0
var locked := false

func _ready() -> void:
    randomize()
    stars = int(_load_value("stars", 0))
    _build_interface()
    _start_game()

func _build_interface() -> void:
    var background := TextureRect.new()
    background.texture = load("res://assets/zoo_background.svg")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    add_child(background)

    var shade := ColorRect.new()
    shade.color = Color(0.02, 0.05, 0.08, 0.32)
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
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://zoo.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Παιχνίδι Μνήμης"
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
    panel.position = Vector2(175, 105)
    panel.size = Vector2(930, 585)
    panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.97), 28))
    add_child(panel)

    var column := VBoxContainer.new()
    panel.add_child(column)

    var info_row := HBoxContainer.new()
    column.add_child(info_row)

    attempts_label = Label.new()
    attempts_label.text = "Προσπάθειες: 0"
    attempts_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    attempts_label.add_theme_font_size_override("font_size", 23)
    info_row.add_child(attempts_label)

    var restart := Button.new()
    restart.text = "🔄 Νέο παιχνίδι"
    restart.custom_minimum_size = Vector2(210, 50)
    restart.pressed.connect(_start_game)
    info_row.add_child(restart)

    var board := GridContainer.new()
    board.columns = 4
    board.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    column.add_child(board)

    for i in range(8):
        var card := TextureButton.new()
        card.custom_minimum_size = Vector2(190, 190)
        card.ignore_texture_size = true
        card.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
        card.texture_normal = _create_back_texture()
        card.pressed.connect(func(index=i): _open_card(index))
        board.add_child(card)
        cards.append(card)

    message_label = Label.new()
    message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    message_label.add_theme_font_size_override("font_size", 25)
    column.add_child(message_label)

func _start_game() -> void:
    deck.clear()
    opened.clear()
    matched.clear()
    attempts = 0
    pairs_found = 0
    locked = false
    attempts_label.text = "Προσπάθειες: 0"
    message_label.text = ""

    for i in range(animals.size()):
        deck.append(i)
        deck.append(i)

    deck.shuffle()

    for i in range(deck.size()):
        matched.append(false)
        cards[i].disabled = false
        cards[i].modulate = Color.WHITE
        cards[i].texture_normal = _create_back_texture()

func _open_card(index: int) -> void:
    if locked or matched[index] or index in opened:
        return

    cards[index].texture_normal = load(animals[deck[index]]["image"])
    opened.append(index)

    if opened.size() == 2:
        attempts += 1
        attempts_label.text = "Προσπάθειες: %d" % attempts
        locked = true
        await get_tree().create_timer(0.8).timeout
        _check_pair()

func _check_pair() -> void:
    var first := opened[0]
    var second := opened[1]

    if deck[first] == deck[second]:
        matched[first] = true
        matched[second] = true
        cards[first].disabled = true
        cards[second].disabled = true
        cards[first].modulate = Color(0.75, 1.0, 0.75)
        cards[second].modulate = Color(0.75, 1.0, 0.75)
        pairs_found += 1
        message_label.text = "Μπράβο! Βρήκες ζευγάρι."

        if pairs_found == animals.size():
            _complete_game()
    else:
        cards[first].texture_normal = _create_back_texture()
        cards[second].texture_normal = _create_back_texture()
        message_label.text = "Δοκίμασε ξανά."

    opened.clear()
    locked = false

func _complete_game() -> void:
    message_label.text = "Τέλεια! Βρήκες όλα τα ζευγάρια! ⭐"
    stars += 1
    stars_label.text = "⭐ %d" % stars
    _save_value("stars", stars)

func _create_back_texture() -> Texture2D:
    var gradient := Gradient.new()
    gradient.colors = PackedColorArray([Color("#5c6bc0"), Color("#3949ab")])
    var texture := GradientTexture2D.new()
    texture.gradient = gradient
    texture.width = 256
    texture.height = 256
    return texture

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
