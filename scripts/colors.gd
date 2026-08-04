extends Control

var colors := [
    {"gr":"Κόκκινο","en":"Red","hex":"#e53935","example_gr":"Μήλο","example_en":"Apple","emoji":"🍎"},
    {"gr":"Μπλε","en":"Blue","hex":"#1e88e5","example_gr":"Θάλασσα","example_en":"Sea","emoji":"🌊"},
    {"gr":"Κίτρινο","en":"Yellow","hex":"#fdd835","example_gr":"Ήλιος","example_en":"Sun","emoji":"☀️"},
    {"gr":"Πράσινο","en":"Green","hex":"#43a047","example_gr":"Φύλλο","example_en":"Leaf","emoji":"🍃"},
    {"gr":"Πορτοκαλί","en":"Orange","hex":"#fb8c00","example_gr":"Πορτοκάλι","example_en":"Orange","emoji":"🍊"},
    {"gr":"Μωβ","en":"Purple","hex":"#8e24aa","example_gr":"Σταφύλι","example_en":"Grape","emoji":"🍇"},
    {"gr":"Ροζ","en":"Pink","hex":"#ec407a","example_gr":"Λουλούδι","example_en":"Flower","emoji":"🌸"},
    {"gr":"Καφέ","en":"Brown","hex":"#6d4c41","example_gr":"Αρκούδα","example_en":"Bear","emoji":"🐻"},
    {"gr":"Μαύρο","en":"Black","hex":"#212121","example_gr":"Πάνθηρας","example_en":"Panther","emoji":"🐈‍⬛"},
    {"gr":"Λευκό","en":"White","hex":"#f5f5f5","example_gr":"Σύννεφο","example_en":"Cloud","emoji":"☁️"},
    {"gr":"Γκρι","en":"Gray","hex":"#757575","example_gr":"Ελέφαντας","example_en":"Elephant","emoji":"🐘"}
]

var index := 0
var language := "el"

var color_panel: ColorRect
var name_label: Label
var example_label: Label
var emoji_label: Label
var grid: GridContainer

func _ready() -> void:
    _build()
    _rebuild_grid()
    _show_color()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#f4fbff")
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
    back.text = "← Αριθμοί"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://numbers.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Ο Κόσμος των Χρωμάτων"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top_row.add_child(title)

    var gr := Button.new()
    gr.text = "Ελληνικά"
    gr.custom_minimum_size = Vector2(140, 50)
    gr.pressed.connect(func(): _set_language("el"))
    top_row.add_child(gr)

    var en := Button.new()
    en.text = "Αγγλικά"
    en.custom_minimum_size = Vector2(140, 50)
    en.pressed.connect(func(): _set_language("en"))
    top_row.add_child(en)

    var body := HBoxContainer.new()
    body.position = Vector2(28, 100)
    body.size = Vector2(1224, 585)
    body.add_theme_constant_override("separation", 18)
    add_child(body)

    var left := PanelContainer.new()
    left.custom_minimum_size = Vector2(330, 0)
    left.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.97), 24))
    body.add_child(left)

    var scroll := ScrollContainer.new()
    left.add_child(scroll)

    grid = GridContainer.new()
    grid.columns = 2
    grid.add_theme_constant_override("h_separation", 10)
    grid.add_theme_constant_override("v_separation", 10)
    scroll.add_child(grid)

    var right := PanelContainer.new()
    right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    right.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.98), 28))
    body.add_child(right)

    var column := VBoxContainer.new()
    column.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_theme_constant_override("separation", 16)
    right.add_child(column)

    color_panel = ColorRect.new()
    color_panel.custom_minimum_size = Vector2(0, 250)
    column.add_child(color_panel)

    emoji_label = Label.new()
    emoji_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    emoji_label.add_theme_font_size_override("font_size", 90)
    column.add_child(emoji_label)

    name_label = Label.new()
    name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    name_label.add_theme_font_size_override("font_size", 42)
    column.add_child(name_label)

    example_label = Label.new()
    example_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    example_label.add_theme_font_size_override("font_size", 28)
    column.add_child(example_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε το χρώμα"
    hear.custom_minimum_size = Vector2(280, 58)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

    var quiz := Button.new()
    quiz.text = "❓ Κουίζ χρωμάτων"
    quiz.custom_minimum_size = Vector2(280, 58)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://colors_quiz.tscn"))
    column.add_child(quiz)

    var nav := HBoxContainer.new()
    nav.alignment = BoxContainer.ALIGNMENT_CENTER
    nav.add_theme_constant_override("separation", 14)
    column.add_child(nav)

    var previous := Button.new()
    previous.text = "← Προηγούμενο"
    previous.custom_minimum_size = Vector2(180, 54)
    previous.pressed.connect(_previous)
    nav.add_child(previous)

    var next := Button.new()
    next.text = "Επόμενο →"
    next.custom_minimum_size = Vector2(180, 54)
    next.pressed.connect(_next)
    nav.add_child(next)

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()

    for i in range(colors.size()):
        var button := Button.new()
        button.text = colors[i]["gr"] if language == "el" else colors[i]["en"]
        button.custom_minimum_size = Vector2(145, 64)
        button.add_theme_font_size_override("font_size", 20)

        var style := StyleBoxFlat.new()
        style.bg_color = Color(colors[i]["hex"])
        style.corner_radius_top_left = 14
        style.corner_radius_top_right = 14
        style.corner_radius_bottom_left = 14
        style.corner_radius_bottom_right = 14
        button.add_theme_stylebox_override("normal", style)

        button.pressed.connect(func(chosen=i): index = chosen; _show_color())
        grid.add_child(button)

func _show_color() -> void:
    var item = colors[index]
    color_panel.color = Color(item["hex"])
    emoji_label.text = item["emoji"]

    if language == "el":
        name_label.text = item["gr"]
        example_label.text = "Παράδειγμα: " + item["example_gr"]
    else:
        name_label.text = item["en"]
        example_label.text = "Example: " + item["example_en"]

func _set_language(value: String) -> void:
    language = value
    _rebuild_grid()
    _show_color()

func _previous() -> void:
    index = (index - 1 + colors.size()) % colors.size()
    _show_color()

func _next() -> void:
    index = (index + 1) % colors.size()
    _show_color()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = colors[index]
    var text := item["gr"] + ". " + item["example_gr"] if language == "el" else item["en"] + ". " + item["example_en"]
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
    style.content_margin_left = 16
    style.content_margin_right = 16
    style.content_margin_top = 14
    style.content_margin_bottom = 14
    return style
