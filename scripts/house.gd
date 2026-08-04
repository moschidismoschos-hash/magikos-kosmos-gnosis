extends Control

var places := [
    {"gr":"Σπίτι","en":"House","symbol":"🏠","fact_gr":"Το σπίτι είναι ο χώρος όπου ζούμε και ξεκουραζόμαστε.","fact_en":"A house is the place where we live and rest."},
    {"gr":"Είσοδος","en":"Entrance","symbol":"🚪","fact_gr":"Η είσοδος είναι το σημείο από όπου μπαίνουμε στο σπίτι.","fact_en":"The entrance is where we enter the house."},
    {"gr":"Σαλόνι","en":"Living room","symbol":"🛋️","fact_gr":"Στο σαλόνι καθόμαστε, μιλάμε και ξεκουραζόμαστε.","fact_en":"In the living room we sit, talk and relax."},
    {"gr":"Κουζίνα","en":"Kitchen","symbol":"🍳","fact_gr":"Στην κουζίνα ετοιμάζουμε και μαγειρεύουμε το φαγητό.","fact_en":"In the kitchen we prepare and cook food."},
    {"gr":"Τραπεζαρία","en":"Dining room","symbol":"🍽️","fact_gr":"Στην τραπεζαρία τρώμε μαζί στο τραπέζι.","fact_en":"In the dining room we eat together at the table."},
    {"gr":"Υπνοδωμάτιο","en":"Bedroom","symbol":"🛏️","fact_gr":"Στο υπνοδωμάτιο κοιμόμαστε και ξεκουραζόμαστε.","fact_en":"In the bedroom we sleep and rest."},
    {"gr":"Παιδικό δωμάτιο","en":"Children's room","symbol":"🧸","fact_gr":"Στο παιδικό δωμάτιο παίζουμε, διαβάζουμε και κοιμόμαστε.","fact_en":"In a children's room we play, read and sleep."},
    {"gr":"Μπάνιο","en":"Bathroom","symbol":"🛁","fact_gr":"Στο μπάνιο πλενόμαστε και φροντίζουμε την καθαριότητά μας.","fact_en":"In the bathroom we wash and take care of our hygiene."},
    {"gr":"Διάδρομος","en":"Hallway","symbol":"🚶","fact_gr":"Ο διάδρομος συνδέει τα δωμάτια του σπιτιού.","fact_en":"A hallway connects the rooms of the house."},
    {"gr":"Μπαλκόνι","en":"Balcony","symbol":"🌇","fact_gr":"Το μπαλκόνι είναι εξωτερικός χώρος του σπιτιού.","fact_en":"A balcony is an outdoor part of the house."},
    {"gr":"Κήπος","en":"Garden","symbol":"🌳","fact_gr":"Στον κήπο φυτεύουμε λουλούδια και δέντρα.","fact_en":"In the garden we plant flowers and trees."},
    {"gr":"Αυλή","en":"Yard","symbol":"🏡","fact_gr":"Στην αυλή μπορούμε να παίζουμε και να καθόμαστε έξω.","fact_en":"In the yard we can play and sit outside."},
    {"gr":"Γκαράζ","en":"Garage","symbol":"🚗","fact_gr":"Στο γκαράζ σταθμεύουμε συνήθως το αυτοκίνητο.","fact_en":"We usually park the car in the garage."},
    {"gr":"Αποθήκη","en":"Storage room","symbol":"📦","fact_gr":"Στην αποθήκη φυλάμε αντικείμενα που δεν χρησιμοποιούμε συχνά.","fact_en":"In the storage room we keep things we do not use often."},
    {"gr":"Σκάλα","en":"Stairs","symbol":"🪜","fact_gr":"Η σκάλα μάς βοηθά να ανεβαίνουμε ή να κατεβαίνουμε όροφο.","fact_en":"Stairs help us go up or down a floor."},
    {"gr":"Πόρτα","en":"Door","symbol":"🚪","fact_gr":"Η πόρτα ανοίγει και κλείνει την είσοδο ενός χώρου.","fact_en":"A door opens and closes the entrance to a room."},
    {"gr":"Παράθυρο","en":"Window","symbol":"🪟","fact_gr":"Το παράθυρο αφήνει το φως και τον αέρα να μπαίνουν στο σπίτι.","fact_en":"A window lets light and air enter the house."},
    {"gr":"Στέγη","en":"Roof","symbol":"🏠","fact_gr":"Η στέγη προστατεύει το σπίτι από τη βροχή και τον ήλιο.","fact_en":"The roof protects the house from rain and sun."},
    {"gr":"Καμινάδα","en":"Chimney","symbol":"🏭","fact_gr":"Η καμινάδα βγάζει τον καπνό έξω από το σπίτι.","fact_en":"A chimney carries smoke outside the house."},
    {"gr":"Γραφείο","en":"Study","symbol":"💻","fact_gr":"Στο γραφείο διαβάζουμε, γράφουμε ή εργαζόμαστε.","fact_en":"In the study we read, write or work."}
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
    _show_place()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#f3f8ff")
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
    back.text = "← Ρούχα"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://clothes.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Το Σπίτι"
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
    quiz.text = "❓ Κουίζ σπιτιού"
    quiz.custom_minimum_size = Vector2(280, 58)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://house_quiz.tscn"))
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

    for i in range(places.size()):
        var button := Button.new()
        var text := places[i]["gr"] if language == "el" else places[i]["en"]
        button.text = places[i]["symbol"] + "\n" + text
        button.custom_minimum_size = Vector2(160, 92)
        button.add_theme_font_size_override("font_size", 19)
        button.pressed.connect(func(chosen=i): index = chosen; _show_place())
        grid.add_child(button)

func _show_place() -> void:
    var item = places[index]
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
    _show_place()

func _previous() -> void:
    index = (index - 1 + places.size()) % places.size()
    _show_place()

func _next() -> void:
    index = (index + 1) % places.size()
    _show_place()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = places[index]
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
