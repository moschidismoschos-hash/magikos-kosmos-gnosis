extends Control

var vehicles := [
    {"gr":"Αυτοκίνητο","en":"Car","symbol":"🚗","fact_gr":"Το αυτοκίνητο κινείται στον δρόμο.","fact_en":"A car travels on the road."},
    {"gr":"Λεωφορείο","en":"Bus","symbol":"🚌","fact_gr":"Το λεωφορείο μεταφέρει πολλούς ανθρώπους.","fact_en":"A bus carries many people."},
    {"gr":"Τρένο","en":"Train","symbol":"🚆","fact_gr":"Το τρένο κινείται πάνω σε ράγες.","fact_en":"A train travels on rails."},
    {"gr":"Αεροπλάνο","en":"Airplane","symbol":"✈️","fact_gr":"Το αεροπλάνο πετά στον ουρανό.","fact_en":"An airplane flies in the sky."},
    {"gr":"Ελικόπτερο","en":"Helicopter","symbol":"🚁","fact_gr":"Το ελικόπτερο πετά με έλικες.","fact_en":"A helicopter flies with rotors."},
    {"gr":"Πλοίο","en":"Ship","symbol":"🚢","fact_gr":"Το πλοίο ταξιδεύει στη θάλασσα.","fact_en":"A ship travels on the sea."},
    {"gr":"Βάρκα","en":"Boat","symbol":"⛵","fact_gr":"Η βάρκα κινείται στο νερό.","fact_en":"A boat moves on water."},
    {"gr":"Ποδήλατο","en":"Bicycle","symbol":"🚲","fact_gr":"Το ποδήλατο κινείται με πετάλια.","fact_en":"A bicycle moves with pedals."},
    {"gr":"Μοτοσικλέτα","en":"Motorcycle","symbol":"🏍️","fact_gr":"Η μοτοσικλέτα έχει δύο τροχούς.","fact_en":"A motorcycle has two wheels."},
    {"gr":"Ασθενοφόρο","en":"Ambulance","symbol":"🚑","fact_gr":"Το ασθενοφόρο βοηθά ανθρώπους που χρειάζονται γιατρό.","fact_en":"An ambulance helps people who need a doctor."}
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
    _show_vehicle()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#eef8ff")
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
    back.text = "← Μουσικά Όργανα"
    back.custom_minimum_size = Vector2(220, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://instruments.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Ο Κόσμος των Οχημάτων"
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
    quiz.text = "❓ Κουίζ οχημάτων"
    quiz.custom_minimum_size = Vector2(280, 58)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://vehicles_quiz.tscn"))
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

    var animals_button := Button.new()
    animals_button.text = "🐾 Ζώα από Α έως Ω"
    animals_button.custom_minimum_size = Vector2(280, 58)
    animals_button.pressed.connect(func(): get_tree().change_scene_to_file("res://animals_alphabet.tscn"))
    column.add_child(animals_button)

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()

    for i in range(vehicles.size()):
        var button := Button.new()
        var text := vehicles[i]["gr"] if language == "el" else vehicles[i]["en"]
        button.text = vehicles[i]["symbol"] + "\n" + text
        button.custom_minimum_size = Vector2(150, 90)
        button.add_theme_font_size_override("font_size", 20)
        button.pressed.connect(func(chosen=i): index = chosen; _show_vehicle())
        grid.add_child(button)

func _show_vehicle() -> void:
    var item = vehicles[index]
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
    _show_vehicle()

func _previous() -> void:
    index = (index - 1 + vehicles.size()) % vehicles.size()
    _show_vehicle()

func _next() -> void:
    index = (index + 1) % vehicles.size()
    _show_vehicle()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = vehicles[index]
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
