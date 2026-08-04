extends Control

var parts := [
    {"gr":"Κεφάλι","en":"Head","symbol":"🙂","fact_gr":"Στο κεφάλι βρίσκονται τα μάτια, τα αυτιά, η μύτη και το στόμα.","fact_en":"The eyes, ears, nose and mouth are on the head."},
    {"gr":"Μάτια","en":"Eyes","symbol":"👀","fact_gr":"Με τα μάτια βλέπουμε.","fact_en":"We see with our eyes."},
    {"gr":"Αυτιά","en":"Ears","symbol":"👂","fact_gr":"Με τα αυτιά ακούμε.","fact_en":"We hear with our ears."},
    {"gr":"Μύτη","en":"Nose","symbol":"👃","fact_gr":"Με τη μύτη μυρίζουμε.","fact_en":"We smell with our nose."},
    {"gr":"Στόμα","en":"Mouth","symbol":"👄","fact_gr":"Με το στόμα μιλάμε και τρώμε.","fact_en":"We speak and eat with our mouth."},
    {"gr":"Χέρι","en":"Hand","symbol":"✋","fact_gr":"Με τα χέρια πιάνουμε αντικείμενα.","fact_en":"We hold things with our hands."},
    {"gr":"Δάχτυλα","en":"Fingers","symbol":"🖐️","fact_gr":"Τα δάχτυλα μας βοηθούν να γράφουμε και να ζωγραφίζουμε.","fact_en":"Fingers help us write and draw."},
    {"gr":"Πόδι","en":"Leg","symbol":"🦵","fact_gr":"Με τα πόδια περπατάμε και τρέχουμε.","fact_en":"We walk and run with our legs."},
    {"gr":"Πατούσα","en":"Foot","symbol":"🦶","fact_gr":"Η πατούσα μας βοηθά να στεκόμαστε.","fact_en":"Our feet help us stand."},
    {"gr":"Καρδιά","en":"Heart","symbol":"❤️","fact_gr":"Η καρδιά χτυπά και στέλνει αίμα σε όλο το σώμα.","fact_en":"The heart pumps blood around the body."}
]

var index := 0
var language := "el"
var symbol_label: Label
var name_label: Label
var fact_label: Label
var grid: GridContainer

func _ready() -> void:
    _build()
    _rebuild_grid()
    _show_part()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#fff4f7")
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
    back.text = "← Σχήματα"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://shapes.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Το Σώμα μου"
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
    left.custom_minimum_size = Vector2(340, 0)
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
    symbol_label.custom_minimum_size = Vector2(0, 250)
    symbol_label.add_theme_font_size_override("font_size", 170)
    column.add_child(symbol_label)

    name_label = Label.new()
    name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    name_label.add_theme_font_size_override("font_size", 42)
    column.add_child(name_label)

    fact_label = Label.new()
    fact_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    fact_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    fact_label.custom_minimum_size = Vector2(0, 100)
    fact_label.add_theme_font_size_override("font_size", 25)
    column.add_child(fact_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε"
    hear.custom_minimum_size = Vector2(280, 58)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

    var quiz := Button.new()
    quiz.text = "❓ Κουίζ σώματος"
    quiz.custom_minimum_size = Vector2(280, 58)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://body_parts_quiz.tscn"))
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

    for i in range(parts.size()):
        var button := Button.new()
        var text := parts[i]["gr"] if language == "el" else parts[i]["en"]
        button.text = parts[i]["symbol"] + "\n" + text
        button.custom_minimum_size = Vector2(150, 90)
        button.add_theme_font_size_override("font_size", 20)
        button.pressed.connect(func(chosen=i): index = chosen; _show_part())
        grid.add_child(button)

func _show_part() -> void:
    var item = parts[index]
    symbol_label.text = item["symbol"]

    if language == "el":
        name_label.text = item["gr"]
        fact_label.text = item["fact_gr"]
    else:
        name_label.text = item["en"]
        fact_label.text = item["fact_en"]

func _set_language(value: String) -> void:
    language = value
    _rebuild_grid()
    _show_part()

func _previous() -> void:
    index = (index - 1 + parts.size()) % parts.size()
    _show_part()

func _next() -> void:
    index = (index + 1) % parts.size()
    _show_part()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = parts[index]
    var text := item["gr"] + ". " + item["fact_gr"] if language == "el" else item["en"] + ". " + item["fact_en"]
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
