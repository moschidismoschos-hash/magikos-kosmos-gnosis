extends Control

var foods := [
    {"gr":"Ψωμί","en":"Bread","symbol":"🍞","fact_gr":"Το ψωμί φτιάχνεται συνήθως από αλεύρι, νερό και μαγιά.","fact_en":"Bread is usually made from flour, water and yeast."},
    {"gr":"Γάλα","en":"Milk","symbol":"🥛","fact_gr":"Το γάλα χρησιμοποιείται και για την παρασκευή γιαουρτιού και τυριού.","fact_en":"Milk is also used to make yogurt and cheese."},
    {"gr":"Τυρί","en":"Cheese","symbol":"🧀","fact_gr":"Το τυρί φτιάχνεται από γάλα.","fact_en":"Cheese is made from milk."},
    {"gr":"Γιαούρτι","en":"Yogurt","symbol":"🥣","fact_gr":"Το γιαούρτι είναι μαλακό γαλακτοκομικό τρόφιμο.","fact_en":"Yogurt is a soft dairy food."},
    {"gr":"Αυγό","en":"Egg","symbol":"🥚","fact_gr":"Το αυγό έχει κέλυφος, ασπράδι και κρόκο.","fact_en":"An egg has a shell, white and yolk."},
    {"gr":"Ρύζι","en":"Rice","symbol":"🍚","fact_gr":"Το ρύζι είναι βασική τροφή σε πολλές χώρες.","fact_en":"Rice is a staple food in many countries."},
    {"gr":"Μακαρόνια","en":"Pasta","symbol":"🍝","fact_gr":"Τα μακαρόνια φτιάχνονται κυρίως από σιμιγδάλι και νερό.","fact_en":"Pasta is mainly made from semolina and water."},
    {"gr":"Πατάτες τηγανητές","en":"French fries","symbol":"🍟","fact_gr":"Οι πατάτες τηγανητές γίνονται από κομμένες πατάτες.","fact_en":"French fries are made from sliced potatoes."},
    {"gr":"Πίτσα","en":"Pizza","symbol":"🍕","fact_gr":"Η πίτσα έχει ζύμη και μπορεί να έχει πολλά διαφορετικά υλικά.","fact_en":"Pizza has dough and can have many different toppings."},
    {"gr":"Σάντουιτς","en":"Sandwich","symbol":"🥪","fact_gr":"Το σάντουιτς έχει ψωμί και γέμιση.","fact_en":"A sandwich has bread and a filling."},
    {"gr":"Σούπα","en":"Soup","symbol":"🍲","fact_gr":"Η σούπα τρώγεται ζεστή και μπορεί να έχει λαχανικά.","fact_en":"Soup is eaten warm and can contain vegetables."},
    {"gr":"Σαλάτα","en":"Salad","symbol":"🥗","fact_gr":"Η σαλάτα μπορεί να έχει πολλά φρέσκα λαχανικά.","fact_en":"A salad can contain many fresh vegetables."},
    {"gr":"Κοτόπουλο","en":"Chicken","symbol":"🍗","fact_gr":"Το κοτόπουλο μπορεί να μαγειρευτεί με πολλούς τρόπους.","fact_en":"Chicken can be cooked in many ways."},
    {"gr":"Ψάρι","en":"Fish","symbol":"🐟","fact_gr":"Το ψάρι είναι τροφή που προέρχεται από τη θάλασσα ή τα ποτάμια.","fact_en":"Fish is food that comes from the sea or rivers."},
    {"gr":"Μέλι","en":"Honey","symbol":"🍯","fact_gr":"Το μέλι το φτιάχνουν οι μέλισσες.","fact_en":"Honey is made by bees."},
    {"gr":"Μπισκότο","en":"Cookie","symbol":"🍪","fact_gr":"Το μπισκότο είναι μικρό ψημένο γλυκό.","fact_en":"A cookie is a small baked sweet."},
    {"gr":"Κέικ","en":"Cake","symbol":"🍰","fact_gr":"Το κέικ ψήνεται και μπορεί να έχει πολλά αρώματα.","fact_en":"Cake is baked and can have many flavors."},
    {"gr":"Παγωτό","en":"Ice cream","symbol":"🍦","fact_gr":"Το παγωτό είναι κρύο και γλυκό επιδόρπιο.","fact_en":"Ice cream is a cold and sweet dessert."},
    {"gr":"Σοκολάτα","en":"Chocolate","symbol":"🍫","fact_gr":"Η σοκολάτα φτιάχνεται από κακάο.","fact_en":"Chocolate is made from cocoa."},
    {"gr":"Δημητριακά","en":"Cereal","symbol":"🥣","fact_gr":"Τα δημητριακά τρώγονται συχνά με γάλα.","fact_en":"Cereal is often eaten with milk."}
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
    _show_food()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#fff8ef")
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
    back.text = "← Λαχανικά"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://vegetables.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Ο Κόσμος των Τροφίμων"
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
    quiz.text = "❓ Κουίζ τροφίμων"
    quiz.custom_minimum_size = Vector2(280, 58)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://foods_quiz.tscn"))
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

    for i in range(foods.size()):
        var button := Button.new()
        var text := foods[i]["gr"] if language == "el" else foods[i]["en"]
        button.text = foods[i]["symbol"] + "\n" + text
        button.custom_minimum_size = Vector2(155, 92)
        button.add_theme_font_size_override("font_size", 20)
        button.pressed.connect(func(chosen=i): index = chosen; _show_food())
        grid.add_child(button)

func _show_food() -> void:
    var item = foods[index]
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
    _show_food()

func _previous() -> void:
    index = (index - 1 + foods.size()) % foods.size()
    _show_food()

func _next() -> void:
    index = (index + 1) % foods.size()
    _show_food()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = foods[index]
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
