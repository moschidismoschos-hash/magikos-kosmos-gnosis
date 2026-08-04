extends Control

var lessons := [
    {"title":"Αλφαβήτα","icon":"🔤","scene":"res://alphabet.tscn"},
    {"title":"Αριθμοί","icon":"🔢","scene":"res://numbers.tscn"},
    {"title":"Χρώματα","icon":"🎨","scene":"res://colors.tscn"},
    {"title":"Σχήματα","icon":"🔷","scene":"res://shapes.tscn"},
    {"title":"Το Σώμα μου","icon":"🧍","scene":"res://body_parts.tscn"},
    {"title":"Μουσικά Όργανα","icon":"🎵","scene":"res://instruments.tscn"},
    {"title":"Οχήματα","icon":"🚗","scene":"res://vehicles.tscn"},
    {"title":"Ζώα από Α έως Ω","icon":"🐾","scene":"res://animals_alphabet.tscn"},
    {"title":"Φρούτα","icon":"🍎","scene":"res://fruits.tscn"},
    {"title":"Λαχανικά","icon":"🥕","scene":"res://vegetables.tscn"},
    {"title":"Τρόφιμα","icon":"🍞","scene":"res://foods.tscn"},
    {"title":"Ρούχα","icon":"👕","scene":"res://clothes.tscn"},
    {"title":"Το Σπίτι","icon":"🏠","scene":"res://house.tscn"},
    {"title":"Έπιπλα","icon":"🪑","scene":"res://furniture.tscn"},
    {"title":"Χώρες και Σημαίες","icon":"🌍","scene":"res://countries.tscn"},
    {"title":"Εποχές","icon":"🌸","scene":"res://seasons.tscn"},
    {"title":"Καιρός","icon":"🌦️","scene":"res://weather.tscn"},
    {"title":"Ώρα και Ημερολόγιο","icon":"🕒","scene":"res://time_calendar.tscn"},
    {"title":"Δεινόσαυροι","icon":"🦖","scene":"res://dinosaurs.tscn"},
    {"title":"Διάστημα","icon":"🚀","scene":"res://space.tscn"}
]

var stars_label: Label

func _ready() -> void:
    _build_menu()

func _build_menu() -> void:
    var background := ColorRect.new()
    background.color = Color("#eaf4ff")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    # Διακοσμητικές φωτεινές περιοχές.
    var glow_left := ColorRect.new()
    glow_left.color = Color(0.65, 0.86, 1.0, 0.28)
    glow_left.position = Vector2(0, 0)
    glow_left.size = Vector2(340, 720)
    add_child(glow_left)

    var glow_right := ColorRect.new()
    glow_right.color = Color(1.0, 0.84, 0.62, 0.24)
    glow_right.position = Vector2(940, 0)
    glow_right.size = Vector2(340, 720)
    add_child(glow_right)

    var header := PanelContainer.new()
    header.position = Vector2(28, 20)
    header.size = Vector2(1224, 105)
    header.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.96), 28))
    add_child(header)

    var header_row := HBoxContainer.new()
    header_row.add_theme_constant_override("separation", 18)
    header.add_child(header_row)

    var logo := Label.new()
    logo.text = "✨📚"
    logo.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    logo.add_theme_font_size_override("font_size", 48)
    header_row.add_child(logo)

    var title_box := VBoxContainer.new()
    title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    header_row.add_child(title_box)

    var title := Label.new()
    title.text = "Μαγικός Κόσμος Γνώσης"
    title.add_theme_font_size_override("font_size", 38)
    title_box.add_child(title)

    var subtitle := Label.new()
    subtitle.text = "Διάλεξε μια ενότητα και ξεκίνα το ταξίδι της μάθησης!"
    subtitle.add_theme_font_size_override("font_size", 21)
    title_box.add_child(subtitle)

    stars_label = Label.new()
    stars_label.text = "⭐ %d" % int(_load_value("stars", 0))
    stars_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    stars_label.add_theme_font_size_override("font_size", 30)
    header_row.add_child(stars_label)

    var main_panel := PanelContainer.new()
    main_panel.position = Vector2(28, 142)
    main_panel.size = Vector2(1224, 545)
    main_panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.93), 30))
    add_child(main_panel)

    var scroll := ScrollContainer.new()
    scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    main_panel.add_child(scroll)

    var grid := GridContainer.new()
    grid.columns = 4
    grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    grid.add_theme_constant_override("h_separation", 14)
    grid.add_theme_constant_override("v_separation", 14)
    scroll.add_child(grid)

    for lesson in lessons:
        var button := Button.new()
        button.text = lesson["icon"] + "\n" + lesson["title"]
        button.custom_minimum_size = Vector2(275, 118)
        button.add_theme_font_size_override("font_size", 22)
        button.tooltip_text = lesson["title"]

        var scene_path: String = lesson["scene"]
        var exists := ResourceLoader.exists(scene_path)

        if exists:
            button.pressed.connect(func(path=scene_path): _open_scene(path))
        else:
            button.disabled = true
            button.text += "\n(δεν εγκαταστάθηκε)"

        grid.add_child(button)

func _open_scene(path: String) -> void:
    if ResourceLoader.exists(path):
        get_tree().change_scene_to_file(path)

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
    style.content_margin_left = 18
    style.content_margin_right = 18
    style.content_margin_top = 16
    style.content_margin_bottom = 16
    return style
