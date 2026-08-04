extends Control

var vegetables := [
    {"gr":"Καρότο","en":"Carrot","symbol":"🥕","fact_gr":"Το καρότο μεγαλώνει μέσα στο χώμα.","fact_en":"A carrot grows under the soil."},
    {"gr":"Ντομάτα","en":"Tomato","symbol":"🍅","fact_gr":"Η ντομάτα έχει πολλούς μικρούς σπόρους.","fact_en":"A tomato contains many tiny seeds."},
    {"gr":"Πατάτα","en":"Potato","symbol":"🥔","fact_gr":"Η πατάτα μεγαλώνει κάτω από το έδαφος.","fact_en":"A potato grows underground."},
    {"gr":"Κρεμμύδι","en":"Onion","symbol":"🧅","fact_gr":"Το κρεμμύδι έχει πολλές στρώσεις.","fact_en":"An onion has many layers."},
    {"gr":"Σκόρδο","en":"Garlic","symbol":"🧄","fact_gr":"Το σκόρδο αποτελείται από πολλές σκελίδες.","fact_en":"Garlic is made of several cloves."},
    {"gr":"Αγγούρι","en":"Cucumber","symbol":"🥒","fact_gr":"Το αγγούρι έχει πολύ νερό και είναι δροσερό.","fact_en":"A cucumber contains lots of water and is refreshing."},
    {"gr":"Πιπεριά","en":"Pepper","symbol":"🫑","fact_gr":"Η πιπεριά μπορεί να είναι πράσινη, κόκκινη ή κίτρινη.","fact_en":"A pepper can be green, red or yellow."},
    {"gr":"Μελιτζάνα","en":"Eggplant","symbol":"🍆","fact_gr":"Η μελιτζάνα έχει συνήθως μωβ χρώμα.","fact_en":"An eggplant is usually purple."},
    {"gr":"Μπρόκολο","en":"Broccoli","symbol":"🥦","fact_gr":"Το μπρόκολο μοιάζει με μικρό πράσινο δέντρο.","fact_en":"Broccoli looks like a small green tree."},
    {"gr":"Κουνουπίδι","en":"Cauliflower","symbol":"🥦","fact_gr":"Το κουνουπίδι έχει λευκά ανθάκια.","fact_en":"Cauliflower has white florets."},
    {"gr":"Μαρούλι","en":"Lettuce","symbol":"🥬","fact_gr":"Το μαρούλι έχει πολλά πράσινα φύλλα.","fact_en":"Lettuce has many green leaves."},
    {"gr":"Λάχανο","en":"Cabbage","symbol":"🥬","fact_gr":"Το λάχανο έχει φύλλα που σχηματίζουν μια σφιχτή μπάλα.","fact_en":"Cabbage leaves form a tight round head."},
    {"gr":"Καλαμπόκι","en":"Corn","symbol":"🌽","fact_gr":"Το καλαμπόκι έχει πολλούς κίτρινους σπόρους.","fact_en":"Corn has many yellow kernels."},
    {"gr":"Μπιζέλι","en":"Pea","symbol":"🟢","fact_gr":"Τα μπιζέλια μεγαλώνουν μέσα σε λοβούς.","fact_en":"Peas grow inside pods."},
    {"gr":"Φασολάκι","en":"Green bean","symbol":"🫛","fact_gr":"Τα φασολάκια μεγαλώνουν σε μακριούς πράσινους λοβούς.","fact_en":"Green beans grow in long green pods."},
    {"gr":"Κολοκύθα","en":"Pumpkin","symbol":"🎃","fact_gr":"Η κολοκύθα μπορεί να μεγαλώσει πολύ.","fact_en":"A pumpkin can grow very large."},
    {"gr":"Κολοκυθάκι","en":"Zucchini","symbol":"🥒","fact_gr":"Το κολοκυθάκι έχει μαλακή πράσινη φλούδα.","fact_en":"A zucchini has soft green skin."},
    {"gr":"Παντζάρι","en":"Beetroot","symbol":"🔴","fact_gr":"Το παντζάρι έχει βαθύ κόκκινο χρώμα.","fact_en":"Beetroot has a deep red color."},
    {"gr":"Ραπανάκι","en":"Radish","symbol":"🔴","fact_gr":"Το ραπανάκι είναι μικρό και τραγανό.","fact_en":"A radish is small and crunchy."},
    {"gr":"Σπανάκι","en":"Spinach","symbol":"🥬","fact_gr":"Το σπανάκι έχει σκούρα πράσινα φύλλα.","fact_en":"Spinach has dark green leaves."}
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
    _show_vegetable()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#f1faee")
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
    back.text = "← Φρούτα"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://fruits.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Ο Κόσμος των Λαχανικών"
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
    left.custom_minimum_size = Vector2(350, 0)
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
    quiz.text = "❓ Κουίζ λαχανικών"
    quiz.custom_minimum_size = Vector2(280, 58)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://vegetables_quiz.tscn"))
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

    for i in range(vegetables.size()):
        var button := Button.new()
        var text := vegetables[i]["gr"] if language == "el" else vegetables[i]["en"]
        button.text = vegetables[i]["symbol"] + "\n" + text
        button.custom_minimum_size = Vector2(155, 92)
        button.add_theme_font_size_override("font_size", 20)
        button.pressed.connect(func(chosen=i): index = chosen; _show_vegetable())
        grid.add_child(button)

func _show_vegetable() -> void:
    var item = vegetables[index]
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
    _show_vegetable()

func _previous() -> void:
    index = (index - 1 + vegetables.size()) % vegetables.size()
    _show_vegetable()

func _next() -> void:
    index = (index + 1) % vegetables.size()
    _show_vegetable()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = vegetables[index]
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
