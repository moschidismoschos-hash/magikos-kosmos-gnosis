extends Control

var space_items := [
    {"gr":"Ήλιος","en":"Sun","symbol":"☀️","fact_gr":"Ο Ήλιος είναι το αστέρι στο κέντρο του ηλιακού μας συστήματος.","fact_en":"The Sun is the star at the center of our solar system."},
    {"gr":"Ερμής","en":"Mercury","symbol":"🪐","fact_gr":"Ο Ερμής είναι ο κοντινότερος πλανήτης στον Ήλιο.","fact_en":"Mercury is the closest planet to the Sun."},
    {"gr":"Αφροδίτη","en":"Venus","symbol":"🪐","fact_gr":"Η Αφροδίτη είναι πολύ ζεστός πλανήτης και έχει πυκνή ατμόσφαιρα.","fact_en":"Venus is a very hot planet with a thick atmosphere."},
    {"gr":"Γη","en":"Earth","symbol":"🌍","fact_gr":"Η Γη είναι ο πλανήτης όπου ζούμε και έχει νερό και ζωή.","fact_en":"Earth is the planet where we live and it has water and life."},
    {"gr":"Σελήνη","en":"Moon","symbol":"🌙","fact_gr":"Η Σελήνη είναι ο φυσικός δορυφόρος της Γης.","fact_en":"The Moon is Earth's natural satellite."},
    {"gr":"Άρης","en":"Mars","symbol":"🔴","fact_gr":"Ο Άρης λέγεται και Κόκκινος Πλανήτης.","fact_en":"Mars is also called the Red Planet."},
    {"gr":"Δίας","en":"Jupiter","symbol":"🪐","fact_gr":"Ο Δίας είναι ο μεγαλύτερος πλανήτης του ηλιακού συστήματος.","fact_en":"Jupiter is the largest planet in the solar system."},
    {"gr":"Κρόνος","en":"Saturn","symbol":"🪐","fact_gr":"Ο Κρόνος είναι γνωστός για τους μεγάλους δακτυλίους του.","fact_en":"Saturn is known for its large rings."},
    {"gr":"Ουρανός","en":"Uranus","symbol":"🪐","fact_gr":"Ο Ουρανός περιστρέφεται σχεδόν ξαπλωμένος στο πλάι.","fact_en":"Uranus rotates almost on its side."},
    {"gr":"Ποσειδώνας","en":"Neptune","symbol":"🔵","fact_gr":"Ο Ποσειδώνας είναι πολύ μακρινός, κρύος και θυελλώδης πλανήτης.","fact_en":"Neptune is a very distant, cold and windy planet."},
    {"gr":"Αστέρι","en":"Star","symbol":"⭐","fact_gr":"Τα αστέρια είναι τεράστιες φωτεινές σφαίρες αερίων.","fact_en":"Stars are enormous glowing balls of gas."},
    {"gr":"Γαλαξίας","en":"Galaxy","symbol":"🌌","fact_gr":"Ένας γαλαξίας περιέχει δισεκατομμύρια αστέρια.","fact_en":"A galaxy contains billions of stars."},
    {"gr":"Κομήτης","en":"Comet","symbol":"☄️","fact_gr":"Ο κομήτης είναι παγωμένο σώμα που μπορεί να σχηματίζει φωτεινή ουρά.","fact_en":"A comet is an icy body that can form a bright tail."},
    {"gr":"Αστεροειδής","en":"Asteroid","symbol":"🪨","fact_gr":"Ο αστεροειδής είναι μικρό βραχώδες σώμα που κινείται στο διάστημα.","fact_en":"An asteroid is a small rocky object moving through space."},
    {"gr":"Αστροναύτης","en":"Astronaut","symbol":"🧑‍🚀","fact_gr":"Ο αστροναύτης ταξιδεύει και εργάζεται στο διάστημα.","fact_en":"An astronaut travels and works in space."},
    {"gr":"Πύραυλος","en":"Rocket","symbol":"🚀","fact_gr":"Ο πύραυλος μεταφέρει ανθρώπους και μηχανήματα στο διάστημα.","fact_en":"A rocket carries people and equipment into space."},
    {"gr":"Διαστημόπλοιο","en":"Spacecraft","symbol":"🛸","fact_gr":"Το διαστημόπλοιο ταξιδεύει πέρα από την ατμόσφαιρα της Γης.","fact_en":"A spacecraft travels beyond Earth's atmosphere."},
    {"gr":"Διαστημικός σταθμός","en":"Space station","symbol":"🛰️","fact_gr":"Ο διαστημικός σταθμός είναι εργαστήριο που κινείται γύρω από τη Γη.","fact_en":"A space station is a laboratory orbiting Earth."}
]

var index := 0
var language := "el"
var symbol_label: Label
var name_label: Label
var fact_label: Label
var progress_label: Label
var grid: GridContainer

func _ready() -> void:
    _build()
    _rebuild_grid()
    _show_item()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#10162f")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var top := PanelContainer.new()
    top.position = Vector2(18, 16)
    top.size = Vector2(1244, 72)
    top.add_theme_stylebox_override("panel", _panel_style(Color("#f7f8ff"), 22))
    add_child(top)

    var top_row := HBoxContainer.new()
    top.add_child(top_row)

    var back := Button.new()
    back.text = "← Δεινόσαυροι"
    back.custom_minimum_size = Vector2(190, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://dinosaurs.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Ο Μαγικός Κόσμος του Διαστήματος"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top_row.add_child(title)

    var gr := Button.new()
    gr.text = "Ελληνικά"
    gr.custom_minimum_size = Vector2(135, 50)
    gr.pressed.connect(func(): _set_language("el"))
    top_row.add_child(gr)

    var en := Button.new()
    en.text = "Αγγλικά"
    en.custom_minimum_size = Vector2(135, 50)
    en.pressed.connect(func(): _set_language("en"))
    top_row.add_child(en)

    var body := HBoxContainer.new()
    body.position = Vector2(28, 100)
    body.size = Vector2(1224, 585)
    body.add_theme_constant_override("separation", 18)
    add_child(body)

    var left := PanelContainer.new()
    left.custom_minimum_size = Vector2(400, 0)
    left.add_theme_stylebox_override("panel", _panel_style(Color("#f7f8ff"), 24))
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
    right.add_theme_stylebox_override("panel", _panel_style(Color("#f7f8ff"), 28))
    body.add_child(right)

    var column := VBoxContainer.new()
    column.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_theme_constant_override("separation", 16)
    right.add_child(column)

    symbol_label = Label.new()
    symbol_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    symbol_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    symbol_label.custom_minimum_size = Vector2(0, 225)
    symbol_label.add_theme_font_size_override("font_size", 155)
    column.add_child(symbol_label)

    name_label = Label.new()
    name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    name_label.add_theme_font_size_override("font_size", 40)
    column.add_child(name_label)

    fact_label = Label.new()
    fact_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    fact_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    fact_label.custom_minimum_size = Vector2(0, 105)
    fact_label.add_theme_font_size_override("font_size", 24)
    column.add_child(fact_label)

    progress_label = Label.new()
    progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    progress_label.add_theme_font_size_override("font_size", 22)
    column.add_child(progress_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε"
    hear.custom_minimum_size = Vector2(280, 56)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

    var quiz := Button.new()
    quiz.text = "❓ Κουίζ διαστήματος"
    quiz.custom_minimum_size = Vector2(280, 56)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://space_quiz.tscn"))
    column.add_child(quiz)

    var nav := HBoxContainer.new()
    nav.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_child(nav)

    var previous := Button.new()
    previous.text = "← Προηγούμενο"
    previous.custom_minimum_size = Vector2(190, 52)
    previous.pressed.connect(_previous)
    nav.add_child(previous)

    var next := Button.new()
    next.text = "Επόμενο →"
    next.custom_minimum_size = Vector2(190, 52)
    next.pressed.connect(_next)
    nav.add_child(next)

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()

    for i in range(space_items.size()):
        var button := Button.new()
        var text := space_items[i]["gr"] if language == "el" else space_items[i]["en"]
        button.text = space_items[i]["symbol"] + "\n" + text
        button.custom_minimum_size = Vector2(180, 94)
        button.add_theme_font_size_override("font_size", 17)
        button.pressed.connect(func(chosen=i): index = chosen; _show_item())
        grid.add_child(button)

func _show_item() -> void:
    var item = space_items[index]
    symbol_label.text = item["symbol"]

    if language == "el":
        name_label.text = item["gr"]
        fact_label.text = item["fact_gr"]
    else:
        name_label.text = item["en"]
        fact_label.text = item["fact_en"]

    progress_label.text = "%d από %d" % [index + 1, space_items.size()]

func _set_language(value: String) -> void:
    language = value
    _rebuild_grid()
    _show_item()

func _previous() -> void:
    index = (index - 1 + space_items.size()) % space_items.size()
    _show_item()

func _next() -> void:
    index = (index + 1) % space_items.size()
    _show_item()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = space_items[index]
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
