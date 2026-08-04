extends Control

var current_number := 0
var number_label: Label
var word_label: Label
var objects_label: Label
var grid: GridContainer

var greek_words := {
    0:"μηδέν",1:"ένα",2:"δύο",3:"τρία",4:"τέσσερα",5:"πέντε",6:"έξι",7:"επτά",8:"οκτώ",9:"εννέα",10:"δέκα",
    11:"έντεκα",12:"δώδεκα",13:"δεκατρία",14:"δεκατέσσερα",15:"δεκαπέντε",16:"δεκαέξι",17:"δεκαεπτά",18:"δεκαοκτώ",19:"δεκαεννέα",20:"είκοσι"
}

func _ready() -> void:
    _build()
    _rebuild_grid()
    _show_number()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#eef9ff")
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
    back.text = "← Αλφαβήτα"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://alphabet.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Οι Αριθμοί 0–100"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top_row.add_child(title)

    var body := HBoxContainer.new()
    body.position = Vector2(28, 98)
    body.size = Vector2(1224, 590)
    body.add_theme_constant_override("separation", 18)
    add_child(body)

    var left_panel := PanelContainer.new()
    left_panel.custom_minimum_size = Vector2(360, 0)
    left_panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.96), 24))
    body.add_child(left_panel)

    var scroll := ScrollContainer.new()
    left_panel.add_child(scroll)

    grid = GridContainer.new()
    grid.columns = 5
    grid.add_theme_constant_override("h_separation", 6)
    grid.add_theme_constant_override("v_separation", 6)
    scroll.add_child(grid)

    var center_panel := PanelContainer.new()
    center_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    center_panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.98), 28))
    body.add_child(center_panel)

    var column := VBoxContainer.new()
    column.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_theme_constant_override("separation", 14)
    center_panel.add_child(column)

    number_label = Label.new()
    number_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    number_label.add_theme_font_size_override("font_size", 180)
    column.add_child(number_label)

    word_label = Label.new()
    word_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    word_label.add_theme_font_size_override("font_size", 38)
    column.add_child(word_label)

    objects_label = Label.new()
    objects_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    objects_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    objects_label.custom_minimum_size = Vector2(0, 150)
    objects_label.add_theme_font_size_override("font_size", 34)
    column.add_child(objects_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε τον αριθμό"
    hear.custom_minimum_size = Vector2(280, 58)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

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

    var counting := Button.new()
    counting.text = "🍎 Μέτρησε αντικείμενα"
    counting.custom_minimum_size = Vector2(280, 58)
    counting.pressed.connect(func(): get_tree().change_scene_to_file("res://numbers_counting.tscn"))
    column.add_child(counting)

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()

    for value in range(101):
        var button := Button.new()
        button.text = str(value)
        button.custom_minimum_size = Vector2(58, 48)
        button.add_theme_font_size_override("font_size", 18)
        button.pressed.connect(func(chosen=value): current_number = chosen; _show_number())
        grid.add_child(button)

func _show_number() -> void:
    number_label.text = str(current_number)
    word_label.text = _number_word(current_number)
    objects_label.text = _objects_for_number(current_number)

func _previous() -> void:
    current_number = (current_number - 1 + 101) % 101
    _show_number()

func _next() -> void:
    current_number = (current_number + 1) % 101
    _show_number()

func _number_word(value: int) -> String:
    if greek_words.has(value):
        return greek_words[value]

    if value < 30:
        return "είκοσι " + greek_words[value - 20]
    if value == 30:
        return "τριάντα"
    if value < 40:
        return "τριάντα " + greek_words[value - 30]
    if value == 40:
        return "σαράντα"
    if value < 50:
        return "σαράντα " + greek_words[value - 40]
    if value == 50:
        return "πενήντα"
    if value < 60:
        return "πενήντα " + greek_words[value - 50]
    if value == 60:
        return "εξήντα"
    if value < 70:
        return "εξήντα " + greek_words[value - 60]
    if value == 70:
        return "εβδομήντα"
    if value < 80:
        return "εβδομήντα " + greek_words[value - 70]
    if value == 80:
        return "ογδόντα"
    if value < 90:
        return "ογδόντα " + greek_words[value - 80]
    if value == 90:
        return "ενενήντα"
    if value < 100:
        return "ενενήντα " + greek_words[value - 90]
    return "εκατό"

func _objects_for_number(value: int) -> String:
    if value == 0:
        return "Δεν υπάρχει κανένα αντικείμενο."

    var shown := min(value, 20)
    var symbols: Array[String] = []

    for i in range(shown):
        symbols.append("🍎")

    var text := " ".join(symbols)

    if value > 20:
        text += "\nκαι άλλα %d μήλα" % (value - 20)

    return text

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var voices := DisplayServer.tts_get_voices_for_language("el")

    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(_number_word(current_number), voices[0])

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
