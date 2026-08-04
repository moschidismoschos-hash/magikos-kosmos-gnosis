extends Control

var shapes := [
    {"gr":"Κύκλος","en":"Circle","symbol":"●","example_gr":"Μπάλα","example_en":"Ball"},
    {"gr":"Τετράγωνο","en":"Square","symbol":"■","example_gr":"Παράθυρο","example_en":"Window"},
    {"gr":"Τρίγωνο","en":"Triangle","symbol":"▲","example_gr":"Στέγη","example_en":"Roof"},
    {"gr":"Ορθογώνιο","en":"Rectangle","symbol":"▭","example_gr":"Πόρτα","example_en":"Door"},
    {"gr":"Αστέρι","en":"Star","symbol":"★","example_gr":"Αστέρι","example_en":"Star"},
    {"gr":"Καρδιά","en":"Heart","symbol":"♥","example_gr":"Καρδιά","example_en":"Heart"},
    {"gr":"Οβάλ","en":"Oval","symbol":"⬭","example_gr":"Αυγό","example_en":"Egg"},
    {"gr":"Ρόμβος","en":"Diamond","symbol":"◆","example_gr":"Χαρταετός","example_en":"Kite"}
]

var index := 0
var language := "el"

var symbol_label: Label
var name_label: Label
var example_label: Label
var grid: GridContainer

func _ready() -> void:
    _build()
    _rebuild_grid()
    _show_shape()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#f5f0ff")
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
    back.text = "← Χρώματα"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://colors.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Ο Κόσμος των Σχημάτων"
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

    symbol_label = Label.new()
    symbol_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    symbol_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    symbol_label.custom_minimum_size = Vector2(0, 280)
    symbol_label.add_theme_font_size_override("font_size", 210)
    symbol_label.add_theme_color_override("font_color", Color("#6c5ce7"))
    column.add_child(symbol_label)

    name_label = Label.new()
    name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    name_label.add_theme_font_size_override("font_size", 42)
    column.add_child(name_label)

    example_label = Label.new()
    example_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    example_label.add_theme_font_size_override("font_size", 28)
    column.add_child(example_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε το σχήμα"
    hear.custom_minimum_size = Vector2(280, 58)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

    var quiz := Button.new()
    quiz.text = "❓ Κουίζ σχημάτων"
    quiz.custom_minimum_size = Vector2(280, 58)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://shapes_quiz.tscn"))
    column.add_child(quiz)

    var nav := HBoxContainer.new()
    nav.alignment = BoxContainer.ALIGNMENT_CENTER
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

    for i in range(shapes.size()):
        var button := Button.new()
        button.text = shapes[i]["symbol"] + "\n" + (shapes[i]["gr"] if language == "el" else shapes[i]["en"])
        button.custom_minimum_size = Vector2(145, 90)
        button.add_theme_font_size_override("font_size", 20)
        button.pressed.connect(func(chosen=i): index = chosen; _show_shape())
        grid.add_child(button)

func _show_shape() -> void:
    var item = shapes[index]
    symbol_label.text = item["symbol"]

    if language == "el":
        name_label.text = item["gr"]
        example_label.text = "Παράδειγμα: " + item["example_gr"]
    else:
        name_label.text = item["en"]
        example_label.text = "Example: " + item["example_en"]

func _set_language(value: String) -> void:
    language = value
    _rebuild_grid()
    _show_shape()

func _previous() -> void:
    index = (index - 1 + shapes.size()) % shapes.size()
    _show_shape()

func _next() -> void:
    index = (index + 1) % shapes.size()
    _show_shape()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = shapes[index]
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
