extends Control

var furniture := [
    {"gr":"Κρεβάτι","en":"Bed","symbol":"🛏️","fact_gr":"Στο κρεβάτι κοιμόμαστε και ξεκουραζόμαστε.","fact_en":"We sleep and rest in a bed."},
    {"gr":"Καναπές","en":"Sofa","symbol":"🛋️","fact_gr":"Στον καναπέ καθόμαστε και ξεκουραζόμαστε.","fact_en":"We sit and relax on a sofa."},
    {"gr":"Καρέκλα","en":"Chair","symbol":"🪑","fact_gr":"Στην καρέκλα καθόμαστε.","fact_en":"We sit on a chair."},
    {"gr":"Τραπέζι","en":"Table","symbol":"🪵","fact_gr":"Στο τραπέζι τρώμε, γράφουμε ή παίζουμε.","fact_en":"At a table we eat, write or play."},
    {"gr":"Γραφείο","en":"Desk","symbol":"🖥️","fact_gr":"Στο γραφείο διαβάζουμε, γράφουμε ή εργαζόμαστε.","fact_en":"At a desk we read, write or work."},
    {"gr":"Ντουλάπα","en":"Wardrobe","symbol":"🚪","fact_gr":"Στην ντουλάπα φυλάμε ρούχα.","fact_en":"We keep clothes in a wardrobe."},
    {"gr":"Συρταριέρα","en":"Chest of drawers","symbol":"🗄️","fact_gr":"Η συρταριέρα έχει συρτάρια για μικρά αντικείμενα και ρούχα.","fact_en":"A chest of drawers stores small items and clothes."},
    {"gr":"Βιβλιοθήκη","en":"Bookcase","symbol":"📚","fact_gr":"Στη βιβλιοθήκη τοποθετούμε βιβλία.","fact_en":"We place books in a bookcase."},
    {"gr":"Ράφι","en":"Shelf","symbol":"📚","fact_gr":"Στο ράφι τοποθετούμε αντικείμενα.","fact_en":"We place objects on a shelf."},
    {"gr":"Κομοδίνο","en":"Bedside table","symbol":"🛏️","fact_gr":"Το κομοδίνο βρίσκεται συνήθως δίπλα στο κρεβάτι.","fact_en":"A bedside table is usually next to the bed."},
    {"gr":"Πολυθρόνα","en":"Armchair","symbol":"🪑","fact_gr":"Η πολυθρόνα είναι άνετο κάθισμα με μπράτσα.","fact_en":"An armchair is a comfortable chair with arms."},
    {"gr":"Σκαμπό","en":"Stool","symbol":"🪑","fact_gr":"Το σκαμπό είναι μικρό κάθισμα χωρίς πλάτη.","fact_en":"A stool is a small seat without a back."},
    {"gr":"Τραπεζάκι","en":"Coffee table","symbol":"☕","fact_gr":"Το τραπεζάκι είναι χαμηλό και βρίσκεται συχνά μπροστά από τον καναπέ.","fact_en":"A coffee table is low and often sits in front of a sofa."},
    {"gr":"Καθρέφτης","en":"Mirror","symbol":"🪞","fact_gr":"Στον καθρέφτη βλέπουμε την εικόνα μας.","fact_en":"We see our reflection in a mirror."},
    {"gr":"Λάμπα","en":"Lamp","symbol":"💡","fact_gr":"Η λάμπα φωτίζει έναν χώρο.","fact_en":"A lamp lights a room."},
    {"gr":"Τηλεόραση","en":"Television","symbol":"📺","fact_gr":"Στην τηλεόραση βλέπουμε εικόνες και προγράμματα.","fact_en":"We watch pictures and programs on a television."},
    {"gr":"Ψυγείο","en":"Refrigerator","symbol":"🧊","fact_gr":"Το ψυγείο κρατά τα τρόφιμα κρύα.","fact_en":"A refrigerator keeps food cold."},
    {"gr":"Κουζίνα","en":"Cooker","symbol":"🍳","fact_gr":"Στην κουζίνα μαγειρεύουμε φαγητό.","fact_en":"We cook food on a cooker."},
    {"gr":"Πλυντήριο","en":"Washing machine","symbol":"🧺","fact_gr":"Το πλυντήριο πλένει τα ρούχα.","fact_en":"A washing machine washes clothes."},
    {"gr":"Μπανιέρα","en":"Bathtub","symbol":"🛁","fact_gr":"Στην μπανιέρα πλενόμαστε.","fact_en":"We wash in a bathtub."}
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
    _show_item()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#f7f3ef")
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
    back.text = "← Το Σπίτι"
    back.custom_minimum_size = Vector2(180, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://house.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Έπιπλα και Αντικείμενα"
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
    left.custom_minimum_size = Vector2(360, 0)
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
    quiz.text = "❓ Κουίζ επίπλων"
    quiz.custom_minimum_size = Vector2(280, 58)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://furniture_quiz.tscn"))
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

    for i in range(furniture.size()):
        var button := Button.new()
        var text := furniture[i]["gr"] if language == "el" else furniture[i]["en"]
        button.text = furniture[i]["symbol"] + "\n" + text
        button.custom_minimum_size = Vector2(160, 92)
        button.add_theme_font_size_override("font_size", 19)
        button.pressed.connect(func(chosen=i): index = chosen; _show_item())
        grid.add_child(button)

func _show_item() -> void:
    var item = furniture[index]
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
    _show_item()

func _previous() -> void:
    index = (index - 1 + furniture.size()) % furniture.size()
    _show_item()

func _next() -> void:
    index = (index + 1) % furniture.size()
    _show_item()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = furniture[index]
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
