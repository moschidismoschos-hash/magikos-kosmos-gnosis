extends Control

var correct_order := [0, 1, 2, 3]
var current_order := [2, 0, 3, 1]
var selected_index := -1
var buttons: Array[TextureButton] = []
var message_label: Label
var stars_label: Label
var stars := 0
var completed := false

func _ready() -> void:
    stars = int(_load_value("stars", 0))
    _build_interface()
    _draw_puzzle()

func _build_interface() -> void:
    var background := TextureRect.new()
    background.texture = load("res://assets/zoo_background.svg")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    add_child(background)

    var shade := ColorRect.new()
    shade.color = Color(0.02, 0.05, 0.08, 0.34)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(shade)

    var top := PanelContainer.new()
    top.position = Vector2(20, 16)
    top.size = Vector2(1240, 72)
    top.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.95), 22))
    add_child(top)

    var top_row := HBoxContainer.new()
    top.add_child(top_row)

    var back := Button.new()
    back.text = "← Ζωολογικός Κήπος"
    back.custom_minimum_size = Vector2(250, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://zoo.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Παζλ Λιονταριού"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top_row.add_child(title)

    stars_label = Label.new()
    stars_label.text = "⭐ %d" % stars
    stars_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    stars_label.add_theme_font_size_override("font_size", 24)
    top_row.add_child(stars_label)

    var puzzle_panel := PanelContainer.new()
    puzzle_panel.position = Vector2(250, 112)
    puzzle_panel.size = Vector2(780, 500)
    puzzle_panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.96), 28))
    add_child(puzzle_panel)

    var content := VBoxContainer.new()
    puzzle_panel.add_child(content)

    var instruction := Label.new()
    instruction.text = "Πάτησε δύο κομμάτια για να αλλάξουν θέση."
    instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    instruction.add_theme_font_size_override("font_size", 22)
    content.add_child(instruction)

    var board := GridContainer.new()
    board.name = "Board"
    board.columns = 2
    board.custom_minimum_size = Vector2(560, 330)
    board.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    content.add_child(board)

    for i in range(4):
        var button := TextureButton.new()
        button.custom_minimum_size = Vector2(275, 160)
        button.ignore_texture_size = true
        button.stretch_mode = TextureButton.STRETCH_SCALE
        button.pressed.connect(func(index=i): _select_piece(index))
        board.add_child(button)
        buttons.append(button)

    message_label = Label.new()
    message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    message_label.add_theme_font_size_override("font_size", 24)
    content.add_child(message_label)

    var controls := HBoxContainer.new()
    controls.alignment = BoxContainer.ALIGNMENT_CENTER
    content.add_child(controls)

    var shuffle := Button.new()
    shuffle.text = "🔀 Ανακάτεμα"
    shuffle.custom_minimum_size = Vector2(210, 54)
    shuffle.pressed.connect(_shuffle)
    controls.add_child(shuffle)

    var show_image := Button.new()
    show_image.text = "👁 Δείξε εικόνα"
    show_image.custom_minimum_size = Vector2(210, 54)
    show_image.pressed.connect(_show_solution)
    controls.add_child(show_image)

func _draw_puzzle() -> void:
    var source_texture: Texture2D = load("res://assets/animals/lion.svg")
    var piece_width := 350.0
    var piece_height := 210.0

    for board_index in range(4):
        var source_index := current_order[board_index]
        var column := source_index % 2
        var row := source_index / 2

        var atlas := AtlasTexture.new()
        atlas.atlas = source_texture
        atlas.region = Rect2(column * piece_width, row * piece_height, piece_width, piece_height)
        buttons[board_index].texture_normal = atlas
        buttons[board_index].modulate = Color.WHITE

    if selected_index >= 0:
        buttons[selected_index].modulate = Color(1.0, 0.86, 0.35)

func _select_piece(index: int) -> void:
    if completed:
        return

    if selected_index == -1:
        selected_index = index
        _draw_puzzle()
        return

    if selected_index == index:
        selected_index = -1
        _draw_puzzle()
        return

    var temporary := current_order[selected_index]
    current_order[selected_index] = current_order[index]
    current_order[index] = temporary
    selected_index = -1
    _draw_puzzle()
    _check_completion()

func _check_completion() -> void:
    if current_order == correct_order:
        completed = true
        message_label.text = "Μπράβο! Το παζλ ολοκληρώθηκε! ⭐"
        stars += 1
        stars_label.text = "⭐ %d" % stars
        _save_value("stars", stars)

func _shuffle() -> void:
    current_order.shuffle()
    if current_order == correct_order:
        current_order = [1, 3, 0, 2]
    selected_index = -1
    completed = false
    message_label.text = ""
    _draw_puzzle()

func _show_solution() -> void:
    current_order = correct_order.duplicate()
    selected_index = -1
    completed = false
    message_label.text = "Αυτή είναι η σωστή εικόνα."
    _draw_puzzle()

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
