extends Control

var age := ""
var stars := 0
var coins := 0
var map_layer: Control
var age_layer: Control
var dialog: PanelContainer
var dialog_title: Label
var dialog_text: Label
var cloud_one: Label
var cloud_two: Label

func _ready() -> void:
    age = str(_load_value("age", ""))
    stars = int(_load_value("stars", 0))
    coins = int(_load_value("coins", 0))
    _build_interface()
    if age.is_empty():
        _show_age_screen()
    else:
        _show_map()

func _build_interface() -> void:
    var background := TextureRect.new()
    background.texture = load("res://assets/map.svg")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    add_child(background)

    map_layer = Control.new()
    map_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(map_layer)

    _add_top_bar()
    _add_hotspots()
    _add_clouds()
    _add_dialog()

    age_layer = Control.new()
    age_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(age_layer)
    _build_age_screen()

func _add_top_bar() -> void:
    var panel := PanelContainer.new()
    panel.position = Vector2(20, 18)
    panel.size = Vector2(1240, 72)
    map_layer.add_child(panel)

    var style := StyleBoxFlat.new()
    style.bg_color = Color(1, 1, 1, 0.92)
    style.corner_radius_top_left = 24
    style.corner_radius_top_right = 24
    style.corner_radius_bottom_left = 24
    style.corner_radius_bottom_right = 24
    panel.add_theme_stylebox_override("panel", style)

    var row := HBoxContainer.new()
    row.add_theme_constant_override("separation", 18)
    panel.add_child(row)

    var age_button := Button.new()
    age_button.text = "Ηλικία: " + (age if not age.is_empty() else "—")
    age_button.custom_minimum_size = Vector2(185, 50)
    age_button.pressed.connect(_show_age_screen)
    row.add_child(age_button)

    var title := Label.new()
    title.text = "Ο Μαγικός Κόσμος της Γνώσης"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 28)
    row.add_child(title)

    var rewards := Label.new()
    rewards.name = "Rewards"
    rewards.text = "⭐ %d     🪙 %d" % [stars, coins]
    rewards.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    rewards.add_theme_font_size_override("font_size", 24)
    row.add_child(rewards)

func _make_hotspot(text: String, position_value: Vector2, size_value: Vector2, action: String) -> void:
    var button := Button.new()
    button.text = text
    button.position = position_value
    button.size = size_value
    button.add_theme_font_size_override("font_size", 22)

    var normal := StyleBoxFlat.new()
    normal.bg_color = Color(1, 1, 1, 0.86)
    normal.border_width_left = 3
    normal.border_width_top = 3
    normal.border_width_right = 3
    normal.border_width_bottom = 3
    normal.border_color = Color(1, 0.84, 0.36, 0.95)
    normal.corner_radius_top_left = 20
    normal.corner_radius_top_right = 20
    normal.corner_radius_bottom_left = 20
    normal.corner_radius_bottom_right = 20
    button.add_theme_stylebox_override("normal", normal)

    var hover := normal.duplicate()
    hover.bg_color = Color(1, 0.95, 0.72, 0.98)
    button.add_theme_stylebox_override("hover", hover)
    button.add_theme_stylebox_override("pressed", hover)
    button.pressed.connect(func(): _open_place(action))
    map_layer.add_child(button)

func _add_hotspots() -> void:
    _make_hotspot("🎨 Ζωγραφική", Vector2(55, 245), Vector2(190, 58), "art")
    _make_hotspot("🔤 Σχολείο", Vector2(145, 475), Vector2(190, 58), "school")
    _make_hotspot("📖 Βιβλιοθήκη", Vector2(365, 420), Vector2(210, 58), "library")
    _make_hotspot("🧩 Παζλ", Vector2(610, 335), Vector2(170, 58), "puzzle")
    _make_hotspot("🎵 Μουσική", Vector2(975, 300), Vector2(180, 58), "music")
    _make_hotspot("🦁 Ζωολογικός", Vector2(850, 560), Vector2(220, 58), "zoo")

func _add_clouds() -> void:
    cloud_one = Label.new()
    cloud_one.text = "☁"
    cloud_one.position = Vector2(130, 95)
    cloud_one.add_theme_font_size_override("font_size", 74)
    cloud_one.modulate = Color(1, 1, 1, 0.8)
    map_layer.add_child(cloud_one)

    cloud_two = Label.new()
    cloud_two.text = "☁"
    cloud_two.position = Vector2(790, 120)
    cloud_two.add_theme_font_size_override("font_size", 62)
    cloud_two.modulate = Color(1, 1, 1, 0.75)
    map_layer.add_child(cloud_two)

    _animate_cloud(cloud_one, 900.0, 28.0)
    _animate_cloud(cloud_two, 530.0, 22.0)

func _animate_cloud(cloud: Control, distance: float, duration: float) -> void:
    var start_x := cloud.position.x
    var tween := create_tween().set_loops()
    tween.tween_property(cloud, "position:x", start_x + distance, duration)
    tween.tween_callback(func(): cloud.position.x = -130.0)

func _add_dialog() -> void:
    dialog = PanelContainer.new()
    dialog.position = Vector2(355, 190)
    dialog.size = Vector2(570, 300)
    dialog.visible = false
    map_layer.add_child(dialog)

    var style := StyleBoxFlat.new()
    style.bg_color = Color(1, 1, 1, 0.97)
    style.corner_radius_top_left = 28
    style.corner_radius_top_right = 28
    style.corner_radius_bottom_left = 28
    style.corner_radius_bottom_right = 28
    dialog.add_theme_stylebox_override("panel", style)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 18)
    dialog.add_child(column)

    dialog_title = Label.new()
    dialog_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    dialog_title.add_theme_font_size_override("font_size", 32)
    column.add_child(dialog_title)

    dialog_text = Label.new()
    dialog_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    dialog_text.add_theme_font_size_override("font_size", 22)
    dialog_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
    column.add_child(dialog_text)

    var close := Button.new()
    close.text = "Επιστροφή στον χάρτη"
    close.custom_minimum_size = Vector2(0, 54)
    close.pressed.connect(func(): dialog.visible = false)
    column.add_child(close)

func _build_age_screen() -> void:
    var shade := ColorRect.new()
    shade.color = Color(0.05, 0.1, 0.18, 0.76)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    age_layer.add_child(shade)

    var card := PanelContainer.new()
    card.position = Vector2(250, 115)
    card.size = Vector2(780, 490)
    age_layer.add_child(card)

    var style := StyleBoxFlat.new()
    style.bg_color = Color(1, 1, 1, 0.98)
    style.corner_radius_top_left = 30
    style.corner_radius_top_right = 30
    style.corner_radius_bottom_left = 30
    style.corner_radius_bottom_right = 30
    card.add_theme_stylebox_override("panel", style)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 20)
    card.add_child(column)

    var heading := Label.new()
    heading.text = "Διάλεξε ηλικία"
    heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    heading.add_theme_font_size_override("font_size", 36)
    column.add_child(heading)

    var helper := Label.new()
    helper.text = "Το παιχνίδι θα προσαρμόζει τη δυσκολία και τις δραστηριότητες."
    helper.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    helper.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    helper.add_theme_font_size_override("font_size", 20)
    column.add_child(helper)

    for value in ["2–3", "4–6", "6–8"]:
        var button := Button.new()
        button.text = value + " ετών"
        button.custom_minimum_size = Vector2(0, 82)
        button.add_theme_font_size_override("font_size", 28)
        button.pressed.connect(func(v=value): _choose_age(v))
        column.add_child(button)

func _choose_age(value: String) -> void:
    age = value
    _save_value("age", age)
    _show_map()
    get_tree().reload_current_scene()

func _show_age_screen() -> void:
    age_layer.visible = true
    map_layer.visible = false

func _show_map() -> void:
    age_layer.visible = false
    map_layer.visible = true

func _open_place(action: String) -> void:
    var data := {
        "art": ["Εργαστήριο Ζωγραφικής", "Εδώ θα μπουν έτοιμα σχέδια για χρωμάτισμα, πινέλα και αποθήκευση ζωγραφιών."],
        "school": ["Σχολείο Γραμμάτων", "Ελληνικά και αγγλικά γράμματα, καθοδήγηση γραφής και παιχνίδια λέξεων."],
        "library": ["Μαγική Βιβλιοθήκη", "Διαδραστικές ιστορίες με εικόνες, αφήγηση και μικρές επιλογές."],
        "puzzle": ["Πάρκο Παζλ", "Κανονικά παζλ εικόνων με 4, 9, 16 και 25 κομμάτια."],
        "music": ["Μουσικό Σπίτι", "Πρωτότυπα τραγούδια, ρυθμοί, ήχοι ζώων και μουσικά παιχνίδια."],
        "zoo": ["Ζωολογικός Κήπος", "Πιο φυσικά ζώα, ονόματα στα ελληνικά και αγγλικά, ήχοι, κουίζ και παζλ."]
    }
    dialog_title.text = data[action][0]
    dialog_text.text = data[action][1]
    dialog.visible = true

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
