extends Control

var clothes := [
    {"gr":"Μπλούζα","en":"T-shirt","symbol":"👕","fact_gr":"Η μπλούζα φοριέται στο επάνω μέρος του σώματος.","fact_en":"A T-shirt is worn on the upper body."},
    {"gr":"Παντελόνι","en":"Trousers","symbol":"👖","fact_gr":"Το παντελόνι καλύπτει τα πόδια.","fact_en":"Trousers cover the legs."},
    {"gr":"Φούστα","en":"Skirt","symbol":"👗","fact_gr":"Η φούστα φοριέται γύρω από τη μέση.","fact_en":"A skirt is worn around the waist."},
    {"gr":"Φόρεμα","en":"Dress","symbol":"👗","fact_gr":"Το φόρεμα είναι ένα ενιαίο ρούχο.","fact_en":"A dress is one complete garment."},
    {"gr":"Πουκάμισο","en":"Shirt","symbol":"👔","fact_gr":"Το πουκάμισο έχει συνήθως κουμπιά.","fact_en":"A shirt usually has buttons."},
    {"gr":"Μπουφάν","en":"Jacket","symbol":"🧥","fact_gr":"Το μπουφάν μας προστατεύει από το κρύο.","fact_en":"A jacket protects us from the cold."},
    {"gr":"Ζακέτα","en":"Cardigan","symbol":"🧥","fact_gr":"Η ζακέτα ανοίγει μπροστά.","fact_en":"A cardigan opens at the front."},
    {"gr":"Παλτό","en":"Coat","symbol":"🧥","fact_gr":"Το παλτό είναι ζεστό εξωτερικό ρούχο.","fact_en":"A coat is a warm outer garment."},
    {"gr":"Κάλτσες","en":"Socks","symbol":"🧦","fact_gr":"Οι κάλτσες φοριούνται στα πόδια μέσα από τα παπούτσια.","fact_en":"Socks are worn on the feet inside shoes."},
    {"gr":"Παπούτσια","en":"Shoes","symbol":"👞","fact_gr":"Τα παπούτσια προστατεύουν τα πόδια μας.","fact_en":"Shoes protect our feet."},
    {"gr":"Αθλητικά παπούτσια","en":"Trainers","symbol":"👟","fact_gr":"Τα αθλητικά παπούτσια είναι κατάλληλα για τρέξιμο και παιχνίδι.","fact_en":"Trainers are suitable for running and playing."},
    {"gr":"Πέδιλα","en":"Sandals","symbol":"👡","fact_gr":"Τα πέδιλα είναι ανοιχτά παπούτσια για ζεστό καιρό.","fact_en":"Sandals are open shoes for warm weather."},
    {"gr":"Μπότες","en":"Boots","symbol":"🥾","fact_gr":"Οι μπότες καλύπτουν και μέρος του ποδιού πάνω από τον αστράγαλο.","fact_en":"Boots cover the foot and part of the leg above the ankle."},
    {"gr":"Παντόφλες","en":"Slippers","symbol":"🥿","fact_gr":"Οι παντόφλες φοριούνται συνήθως μέσα στο σπίτι.","fact_en":"Slippers are usually worn inside the home."},
    {"gr":"Καπέλο","en":"Hat","symbol":"🎩","fact_gr":"Το καπέλο φοριέται στο κεφάλι.","fact_en":"A hat is worn on the head."},
    {"gr":"Σκουφί","en":"Beanie","symbol":"🧢","fact_gr":"Το σκουφί κρατά το κεφάλι ζεστό.","fact_en":"A beanie keeps the head warm."},
    {"gr":"Καπέλο ηλίου","en":"Sun hat","symbol":"👒","fact_gr":"Το καπέλο ηλίου προστατεύει το πρόσωπο από τον ήλιο.","fact_en":"A sun hat protects the face from the sun."},
    {"gr":"Κασκόλ","en":"Scarf","symbol":"🧣","fact_gr":"Το κασκόλ φοριέται γύρω από τον λαιμό.","fact_en":"A scarf is worn around the neck."},
    {"gr":"Γάντια","en":"Gloves","symbol":"🧤","fact_gr":"Τα γάντια κρατούν τα χέρια ζεστά.","fact_en":"Gloves keep the hands warm."},
    {"gr":"Ζώνη","en":"Belt","symbol":"🟫","fact_gr":"Η ζώνη φοριέται γύρω από τη μέση.","fact_en":"A belt is worn around the waist."},
    {"gr":"Γραβάτα","en":"Tie","symbol":"👔","fact_gr":"Η γραβάτα φοριέται γύρω από τον λαιμό πάνω από πουκάμισο.","fact_en":"A tie is worn around the neck over a shirt."},
    {"gr":"Πιτζάμα","en":"Pyjamas","symbol":"🛌","fact_gr":"Η πιτζάμα φοριέται στον ύπνο.","fact_en":"Pyjamas are worn for sleeping."},
    {"gr":"Μαγιό","en":"Swimsuit","symbol":"🩱","fact_gr":"Το μαγιό φοριέται για κολύμπι.","fact_en":"A swimsuit is worn for swimming."},
    {"gr":"Σορτς","en":"Shorts","symbol":"🩳","fact_gr":"Το σορτς είναι κοντό παντελόνι.","fact_en":"Shorts are short trousers."},
    {"gr":"Αδιάβροχο","en":"Raincoat","symbol":"🧥","fact_gr":"Το αδιάβροχο μας προστατεύει από τη βροχή.","fact_en":"A raincoat protects us from the rain."}
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
    _show_clothing()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#f8f3ff")
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
    back.text = "← Τρόφιμα"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://foods.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Ο Κόσμος των Ρούχων"
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
    quiz.text = "❓ Κουίζ ρούχων"
    quiz.custom_minimum_size = Vector2(280, 58)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://clothes_quiz.tscn"))
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

    var house_button := Button.new()
    house_button.text = "🏠 Το Σπίτι"
    house_button.custom_minimum_size = Vector2(280, 58)
    house_button.pressed.connect(func(): get_tree().change_scene_to_file("res://house.tscn"))
    column.add_child(house_button)

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()

    for i in range(clothes.size()):
        var button := Button.new()
        var text := clothes[i]["gr"] if language == "el" else clothes[i]["en"]
        button.text = clothes[i]["symbol"] + "\n" + text
        button.custom_minimum_size = Vector2(160, 92)
        button.add_theme_font_size_override("font_size", 19)
        button.pressed.connect(func(chosen=i): index = chosen; _show_clothing())
        grid.add_child(button)

func _show_clothing() -> void:
    var item = clothes[index]
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
    _show_clothing()

func _previous() -> void:
    index = (index - 1 + clothes.size()) % clothes.size()
    _show_clothing()

func _next() -> void:
    index = (index + 1) % clothes.size()
    _show_clothing()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = clothes[index]
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
