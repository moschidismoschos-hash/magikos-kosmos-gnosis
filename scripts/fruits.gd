extends Control

var fruits := [
    {"gr":"Μήλο","en":"Apple","symbol":"🍎","fact_gr":"Το μήλο έχει φυτικές ίνες και τρώγεται με τη φλούδα του.","fact_en":"An apple contains fiber and can be eaten with its skin."},
    {"gr":"Μπανάνα","en":"Banana","symbol":"🍌","fact_gr":"Η μπανάνα είναι μαλακή και πλούσια σε κάλιο.","fact_en":"A banana is soft and rich in potassium."},
    {"gr":"Πορτοκάλι","en":"Orange","symbol":"🍊","fact_gr":"Το πορτοκάλι έχει πολύ χυμό και βιταμίνη C.","fact_en":"An orange is juicy and contains vitamin C."},
    {"gr":"Αχλάδι","en":"Pear","symbol":"🍐","fact_gr":"Το αχλάδι είναι γλυκό και ζουμερό.","fact_en":"A pear is sweet and juicy."},
    {"gr":"Φράουλα","en":"Strawberry","symbol":"🍓","fact_gr":"Η φράουλα έχει μικρούς σπόρους στην εξωτερική της επιφάνεια.","fact_en":"A strawberry has tiny seeds on its outside."},
    {"gr":"Καρπούζι","en":"Watermelon","symbol":"🍉","fact_gr":"Το καρπούζι έχει πολύ νερό και είναι δροσερό.","fact_en":"Watermelon contains lots of water and is refreshing."},
    {"gr":"Σταφύλι","en":"Grape","symbol":"🍇","fact_gr":"Τα σταφύλια μεγαλώνουν σε τσαμπιά.","fact_en":"Grapes grow in bunches."},
    {"gr":"Κεράσι","en":"Cherry","symbol":"🍒","fact_gr":"Τα κεράσια είναι μικρά και έχουν κουκούτσι.","fact_en":"Cherries are small and have a stone."},
    {"gr":"Ροδάκινο","en":"Peach","symbol":"🍑","fact_gr":"Το ροδάκινο έχει απαλή χνουδωτή φλούδα.","fact_en":"A peach has soft fuzzy skin."},
    {"gr":"Ανανάς","en":"Pineapple","symbol":"🍍","fact_gr":"Ο ανανάς έχει σκληρή φλούδα και γλυκό εσωτερικό.","fact_en":"A pineapple has a hard skin and a sweet inside."},
    {"gr":"Λεμόνι","en":"Lemon","symbol":"🍋","fact_gr":"Το λεμόνι έχει ξινή γεύση.","fact_en":"A lemon has a sour taste."},
    {"gr":"Μάνγκο","en":"Mango","symbol":"🥭","fact_gr":"Το μάνγκο είναι τροπικό φρούτο με γλυκιά γεύση.","fact_en":"A mango is a sweet tropical fruit."},
    {"gr":"Ακτινίδιο","en":"Kiwi","symbol":"🥝","fact_gr":"Το ακτινίδιο έχει καφέ φλούδα και πράσινο εσωτερικό.","fact_en":"A kiwi has brown skin and a green inside."},
    {"gr":"Πεπόνι","en":"Melon","symbol":"🍈","fact_gr":"Το πεπόνι είναι γλυκό και αρωματικό καλοκαιρινό φρούτο.","fact_en":"Melon is a sweet and fragrant summer fruit."},
    {"gr":"Μανταρίνι","en":"Mandarin","symbol":"🍊","fact_gr":"Το μανταρίνι ξεφλουδίζεται εύκολα και έχει γλυκό χυμό.","fact_en":"A mandarin is easy to peel and has sweet juice."},
    {"gr":"Γκρέιπφρουτ","en":"Grapefruit","symbol":"🍊","fact_gr":"Το γκρέιπφρουτ έχει ελαφρώς πικρή και ξινή γεύση.","fact_en":"Grapefruit has a slightly bitter and sour taste."},
    {"gr":"Βερίκοκο","en":"Apricot","symbol":"🍑","fact_gr":"Το βερίκοκο είναι μικρό πορτοκαλί φρούτο με κουκούτσι.","fact_en":"An apricot is a small orange fruit with a stone."},
    {"gr":"Δαμάσκηνο","en":"Plum","symbol":"🟣","fact_gr":"Το δαμάσκηνο έχει λεία φλούδα και ζουμερό εσωτερικό.","fact_en":"A plum has smooth skin and a juicy inside."},
    {"gr":"Σύκο","en":"Fig","symbol":"🟤","fact_gr":"Το σύκο είναι γλυκό φρούτο με πολλούς μικρούς σπόρους.","fact_en":"A fig is a sweet fruit with many tiny seeds."},
    {"gr":"Ρόδι","en":"Pomegranate","symbol":"🔴","fact_gr":"Το ρόδι έχει πολλούς κόκκινους σπόρους.","fact_en":"A pomegranate contains many red seeds."},
    {"gr":"Καρύδα","en":"Coconut","symbol":"🥥","fact_gr":"Η καρύδα έχει σκληρό κέλυφος και λευκή σάρκα.","fact_en":"A coconut has a hard shell and white flesh."},
    {"gr":"Αβοκάντο","en":"Avocado","symbol":"🥑","fact_gr":"Το αβοκάντο έχει πράσινη σάρκα και μεγάλο κουκούτσι.","fact_en":"An avocado has green flesh and a large stone."},
    {"gr":"Παπάγια","en":"Papaya","symbol":"🧡","fact_gr":"Η παπάγια είναι τροπικό φρούτο με πορτοκαλί σάρκα.","fact_en":"Papaya is a tropical fruit with orange flesh."},
    {"gr":"Βατόμουρο","en":"Blackberry","symbol":"🫐","fact_gr":"Το βατόμουρο αποτελείται από πολλά μικρά σφαιρίδια.","fact_en":"A blackberry is made of many tiny sections."},
    {"gr":"Μύρτιλο","en":"Blueberry","symbol":"🫐","fact_gr":"Το μύρτιλο είναι μικρό μπλε φρούτο.","fact_en":"A blueberry is a small blue fruit."},
    {"gr":"Σμέουρο","en":"Raspberry","symbol":"🔴","fact_gr":"Το σμέουρο είναι μικρό, μαλακό και αρωματικό.","fact_en":"A raspberry is small, soft and fragrant."},
    {"gr":"Λωτός","en":"Persimmon","symbol":"🟠","fact_gr":"Ο λωτός είναι γλυκό πορτοκαλί φρούτο.","fact_en":"A persimmon is a sweet orange fruit."}
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
    _show_fruit()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#fff8ec")
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
    back.text = "← Ζώα Α–Ω"
    back.custom_minimum_size = Vector2(180, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://animals_alphabet.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Ο Κόσμος των Φρούτων"
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
    quiz.text = "❓ Κουίζ φρούτων"
    quiz.custom_minimum_size = Vector2(280, 58)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://fruits_quiz.tscn"))
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

    var vegetables_button := Button.new()
    vegetables_button.text = "🥕 Λαχανικά"
    vegetables_button.custom_minimum_size = Vector2(280, 58)
    vegetables_button.pressed.connect(func(): get_tree().change_scene_to_file("res://vegetables.tscn"))
    column.add_child(vegetables_button)

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()

    for i in range(fruits.size()):
        var button := Button.new()
        var text := fruits[i]["gr"] if language == "el" else fruits[i]["en"]
        button.text = fruits[i]["symbol"] + "\n" + text
        button.custom_minimum_size = Vector2(155, 92)
        button.add_theme_font_size_override("font_size", 20)
        button.pressed.connect(func(chosen=i): index = chosen; _show_fruit())
        grid.add_child(button)

func _show_fruit() -> void:
    var item = fruits[index]
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
    _show_fruit()

func _previous() -> void:
    index = (index - 1 + fruits.size()) % fruits.size()
    _show_fruit()

func _next() -> void:
    index = (index + 1) % fruits.size()
    _show_fruit()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = fruits[index]
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
