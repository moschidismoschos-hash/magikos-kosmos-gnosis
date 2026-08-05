extends Control

var lessons := [
    {"title":"Αλφαβήτα","subtitle":"Γράμματα και λέξεις","icon":"🔤","scene":"res://alphabet.tscn","color":"#5068d8"},
    {"title":"Αριθμοί","subtitle":"Μέτρηση και παιχνίδια","icon":"🔢","scene":"res://numbers.tscn","color":"#e36b45"},
    {"title":"Χρώματα","subtitle":"Γνώρισε τα χρώματα","icon":"🎨","scene":"res://colors.tscn","color":"#c04fc8"},
    {"title":"Σχήματα","subtitle":"Κύκλοι και σχήματα","icon":"🔷","scene":"res://shapes.tscn","color":"#2d9cc7"},
    {"title":"Το Σώμα μου","subtitle":"Μέρη του σώματος","icon":"🧍","scene":"res://body_parts.tscn","color":"#dc7b9b"},
    {"title":"Μουσικά Όργανα","subtitle":"Μουσική και ήχοι","icon":"🎵","scene":"res://instruments.tscn","color":"#7453c7"},
    {"title":"Οχήματα","subtitle":"Οχήματα και μεταφορές","icon":"🚗","scene":"res://vehicles.tscn","color":"#e09d35"},
    {"title":"Ζώα","subtitle":"Ζώα από Α έως Ω","icon":"🐾","scene":"res://animals_alphabet.tscn","color":"#43a565"},
    {"title":"Φρούτα","subtitle":"Νόστιμα φρούτα","icon":"🍎","scene":"res://fruits.tscn","color":"#df5a4d"},
    {"title":"Λαχανικά","subtitle":"Υγιεινά λαχανικά","icon":"🥕","scene":"res://vegetables.tscn","color":"#55a348"},
    {"title":"Τρόφιμα","subtitle":"Μαθαίνω τα τρόφιμα","icon":"🍞","scene":"res://foods.tscn","color":"#c88742"},
    {"title":"Ρούχα","subtitle":"Ρούχα και αξεσουάρ","icon":"👕","scene":"res://clothes.tscn","color":"#4786c9"},
    {"title":"Το Σπίτι","subtitle":"Οι χώροι του σπιτιού","icon":"🏠","scene":"res://house.tscn","color":"#bf6b49"},
    {"title":"Έπιπλα","subtitle":"Έπιπλα και αντικείμενα","icon":"🪑","scene":"res://furniture.tscn","color":"#8e6a50"},
    {"title":"Χώρες και Σημαίες","subtitle":"Ταξίδι στον κόσμο","icon":"🌍","scene":"res://countries.tscn","color":"#348bb3"},
    {"title":"Εποχές και Καιρός","subtitle":"Εποχές και φαινόμενα","icon":"🌦️","scene":"res://seasons.tscn","color":"#4b9f68"},
    {"title":"Ώρα και Ημερολόγιο","subtitle":"Ώρες, ημέρες και μήνες","icon":"🕒","scene":"res://time_calendar.tscn","color":"#8b58bb"},
    {"title":"Δεινόσαυροι","subtitle":"Ο κόσμος της προϊστορίας","icon":"🦖","scene":"res://dinosaurs.tscn","color":"#3c8d52"},
    {"title":"Διάστημα","subtitle":"Πλανήτες και αστέρια","icon":"🚀","scene":"res://space.tscn","color":"#394a9c"}
]

func _ready() -> void:
    _build_background()
    _build_header()
    _build_lesson_area()
    _build_footer()

func _build_background() -> void:
    var background := ColorRect.new()
    background.color = Color("#101642")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var top_glow := ColorRect.new()
    top_glow.color = Color(0.24, 0.18, 0.55, 0.55)
    top_glow.position = Vector2(0, 0)
    top_glow.size = Vector2(1280, 180)
    add_child(top_glow)

func _build_header() -> void:
    var header := PanelContainer.new()
    header.position = Vector2(24, 18)
    header.size = Vector2(1232, 102)
    header.add_theme_stylebox_override("panel", _panel_style(Color(0.08, 0.10, 0.28, 0.94), 26, Color(0.46, 0.38, 0.95, 0.7), 2))
    add_child(header)

    var row := HBoxContainer.new()
    row.add_theme_constant_override("separation", 18)
    header.add_child(row)

    var logo := Label.new()
    logo.text = "✨📚"
    logo.custom_minimum_size = Vector2(105, 0)
    logo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    logo.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    logo.add_theme_font_size_override("font_size", 45)
    row.add_child(logo)

    var titles := VBoxContainer.new()
    titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    titles.alignment = BoxContainer.ALIGNMENT_CENTER
    row.add_child(titles)

    var title := Label.new()
    title.text = "ΜΑΓΙΚΟΣ ΚΟΣΜΟΣ ΓΝΩΣΗΣ"
    title.add_theme_font_size_override("font_size", 37)
    title.add_theme_color_override("font_color", Color("#ffd95a"))
    titles.add_child(title)

    var subtitle := Label.new()
    subtitle.text = "ΝΕΑ ΕΚΔΟΣΗ APK 2 • Εξερεύνησε • Μάθε • Διασκέδασε"
    subtitle.add_theme_font_size_override("font_size", 20)
    subtitle.add_theme_color_override("font_color", Color("#e7e5ff"))
    titles.add_child(subtitle)

    var stars := Label.new()
    stars.text = "⭐ %d" % int(_load_value("stars", 0))
    stars.custom_minimum_size = Vector2(150, 0)
    stars.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    stars.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    stars.add_theme_font_size_override("font_size", 29)
    stars.add_theme_color_override("font_color", Color.WHITE)
    row.add_child(stars)

func _build_lesson_area() -> void:
    var panel := PanelContainer.new()
    panel.position = Vector2(24, 135)
    panel.size = Vector2(1232, 500)
    panel.add_theme_stylebox_override("panel", _panel_style(Color(0.06, 0.08, 0.22, 0.94), 28, Color(0.32, 0.37, 0.72, 0.6), 2))
    add_child(panel)

    var scroll := ScrollContainer.new()
    scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    panel.add_child(scroll)

    var grid := GridContainer.new()
    grid.columns = 4
    grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    grid.add_theme_constant_override("h_separation", 14)
    grid.add_theme_constant_override("v_separation", 14)
    scroll.add_child(grid)

    for lesson in lessons:
        var button := Button.new()
        button.text = lesson["icon"] + "\n" + lesson["title"] + "\n" + lesson["subtitle"]
        button.custom_minimum_size = Vector2(282, 142)
        button.add_theme_font_size_override("font_size", 19)
        button.add_theme_color_override("font_color", Color.WHITE)
        button.add_theme_color_override("font_hover_color", Color.WHITE)
        button.add_theme_color_override("font_pressed_color", Color.WHITE)
        button.add_theme_stylebox_override("normal", _card_style(Color(lesson["color"]), 0.92))
        button.add_theme_stylebox_override("hover", _card_style(Color(lesson["color"]).lightened(0.10), 1.0))
        button.add_theme_stylebox_override("pressed", _card_style(Color(lesson["color"]).darkened(0.08), 1.0))

        var scene_path: String = lesson["scene"]
        if ResourceLoader.exists(scene_path):
            button.pressed.connect(func(path=scene_path): get_tree().change_scene_to_file(path))
        else:
            button.disabled = true
            button.text += "\nΔεν εγκαταστάθηκε"

        grid.add_child(button)

func _build_footer() -> void:
    var footer := PanelContainer.new()
    footer.position = Vector2(24, 650)
    footer.size = Vector2(1232, 54)
    footer.add_theme_stylebox_override("panel", _panel_style(Color(0.06, 0.08, 0.20, 0.96), 22, Color(0.32, 0.37, 0.72, 0.5), 1))
    add_child(footer)

    var label := Label.new()
    label.text = "🏠 Αρχική     ⭐ Η πρόοδος αποθηκεύεται αυτόματα     Έκδοση ιστού 2.0"
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 18)
    label.add_theme_color_override("font_color", Color("#dedcff"))
    footer.add_child(label)

func _card_style(color: Color, alpha: float) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = Color(color.r, color.g, color.b, alpha)
    style.border_color = color.lightened(0.28)
    style.set_border_width_all(3)
    style.corner_radius_top_left = 22
    style.corner_radius_top_right = 22
    style.corner_radius_bottom_left = 22
    style.corner_radius_bottom_right = 22
    style.shadow_color = Color(0, 0, 0, 0.35)
    style.shadow_size = 8
    style.content_margin_left = 12
    style.content_margin_right = 12
    style.content_margin_top = 10
    style.content_margin_bottom = 10
    return style

func _panel_style(color: Color, radius: int, border: Color, width: int) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = color
    style.border_color = border
    style.set_border_width_all(width)
    style.corner_radius_top_left = radius
    style.corner_radius_top_right = radius
    style.corner_radius_bottom_left = radius
    style.corner_radius_bottom_right = radius
    style.content_margin_left = 16
    style.content_margin_right = 16
    style.content_margin_top = 12
    style.content_margin_bottom = 12
    return style

func _load_value(key: String, fallback):
    if not FileAccess.file_exists("user://save.json"):
        return fallback
    var file := FileAccess.open("user://save.json", FileAccess.READ)
    var parsed = JSON.parse_string(file.get_as_text())
    if typeof(parsed) != TYPE_DICTIONARY:
        return fallback
    return parsed.get(key, fallback)
