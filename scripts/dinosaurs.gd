extends Control

var dinosaurs := [
    {"gr":"Τυραννόσαυρος Ρεξ","en":"Tyrannosaurus rex","symbol":"🦖","fact_gr":"Ο Τυραννόσαυρος Ρεξ ήταν μεγάλος σαρκοφάγος δεινόσαυρος με δυνατά σαγόνια.","fact_en":"Tyrannosaurus rex was a large meat-eating dinosaur with powerful jaws."},
    {"gr":"Τρικεράτοπας","en":"Triceratops","symbol":"🦕","fact_gr":"Ο Τρικεράτοπας είχε τρία κέρατα και μεγάλη οστέινη ασπίδα πίσω από το κεφάλι.","fact_en":"Triceratops had three horns and a large bony frill behind its head."},
    {"gr":"Βραχιόσαυρος","en":"Brachiosaurus","symbol":"🦕","fact_gr":"Ο Βραχιόσαυρος είχε πολύ μακρύ λαιμό και έτρωγε φύλλα από ψηλά δέντρα.","fact_en":"Brachiosaurus had a very long neck and ate leaves from tall trees."},
    {"gr":"Στεγόσαυρος","en":"Stegosaurus","symbol":"🦕","fact_gr":"Ο Στεγόσαυρος είχε μεγάλες πλάκες στην πλάτη και αγκάθια στην ουρά.","fact_en":"Stegosaurus had large plates on its back and spikes on its tail."},
    {"gr":"Βελοσιράπτορας","en":"Velociraptor","symbol":"🦖","fact_gr":"Ο Βελοσιράπτορας ήταν μικρός, γρήγορος και είχε αιχμηρά νύχια.","fact_en":"Velociraptor was small, fast and had sharp claws."},
    {"gr":"Σπινόσαυρος","en":"Spinosaurus","symbol":"🦖","fact_gr":"Ο Σπινόσαυρος είχε μεγάλο πτερύγιο στην πλάτη και ζούσε κοντά στο νερό.","fact_en":"Spinosaurus had a large sail on its back and lived near water."},
    {"gr":"Αγκυλόσαυρος","en":"Ankylosaurus","symbol":"🦕","fact_gr":"Ο Αγκυλόσαυρος είχε θωρακισμένο σώμα και βαριά ουρά σαν ρόπαλο.","fact_en":"Ankylosaurus had an armored body and a heavy club-like tail."},
    {"gr":"Παρασαυρόλοφος","en":"Parasaurolophus","symbol":"🦕","fact_gr":"Ο Παρασαυρόλοφος είχε μακριά καμπύλη προεξοχή στο κεφάλι.","fact_en":"Parasaurolophus had a long curved crest on its head."},
    {"gr":"Απατόσαυρος","en":"Apatosaurus","symbol":"🦕","fact_gr":"Ο Απατόσαυρος ήταν τεράστιος φυτοφάγος με μακρύ λαιμό και ουρά.","fact_en":"Apatosaurus was a huge plant-eater with a long neck and tail."},
    {"gr":"Διπλόδοκος","en":"Diplodocus","symbol":"🦕","fact_gr":"Ο Διπλόδοκος είχε πολύ μακρύ σώμα, λαιμό και ουρά.","fact_en":"Diplodocus had a very long body, neck and tail."},
    {"gr":"Καρνόταυρος","en":"Carnotaurus","symbol":"🦖","fact_gr":"Ο Καρνόταυρος είχε δύο μικρά κέρατα πάνω από τα μάτια.","fact_en":"Carnotaurus had two small horns above its eyes."},
    {"gr":"Ιγκουανόδοντας","en":"Iguanodon","symbol":"🦕","fact_gr":"Ο Ιγκουανόδοντας είχε ένα μεγάλο μυτερό νύχι στον αντίχειρα.","fact_en":"Iguanodon had a large pointed thumb spike."},
    {"gr":"Αλλόσαυρος","en":"Allosaurus","symbol":"🦖","fact_gr":"Ο Αλλόσαυρος ήταν μεγάλος σαρκοφάγος με δυνατά πίσω πόδια.","fact_en":"Allosaurus was a large meat-eater with strong hind legs."},
    {"gr":"Παχυκεφαλόσαυρος","en":"Pachycephalosaurus","symbol":"🦕","fact_gr":"Ο Παχυκεφαλόσαυρος είχε πολύ παχύ θόλο στο κεφάλι.","fact_en":"Pachycephalosaurus had a very thick dome on its head."},
    {"gr":"Πτεροδάκτυλος","en":"Pterodactyl","symbol":"🦅","fact_gr":"Ο Πτεροδάκτυλος ήταν ιπτάμενο ερπετό της εποχής των δεινοσαύρων.","fact_en":"Pterodactyl was a flying reptile from the age of dinosaurs."}
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
    _show_dinosaur()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#eef8e8")
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
    back.text = "← Ώρα και Ημερολόγιο"
    back.custom_minimum_size = Vector2(240, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://time_calendar.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Ο Κόσμος των Δεινοσαύρων"
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
    left.custom_minimum_size = Vector2(390, 0)
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
    symbol_label.custom_minimum_size = Vector2(0, 230)
    symbol_label.add_theme_font_size_override("font_size", 165)
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
    quiz.text = "❓ Κουίζ δεινοσαύρων"
    quiz.custom_minimum_size = Vector2(280, 56)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://dinosaurs_quiz.tscn"))
    column.add_child(quiz)

    var nav := HBoxContainer.new()
    nav.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_child(nav)

    var previous := Button.new()
    previous.text = "← Προηγούμενος"
    previous.custom_minimum_size = Vector2(190, 52)
    previous.pressed.connect(_previous)
    nav.add_child(previous)

    var next := Button.new()
    next.text = "Επόμενος →"
    next.custom_minimum_size = Vector2(190, 52)
    next.pressed.connect(_next)
    nav.add_child(next)

    var space_button := Button.new()
    space_button.text = "🚀 Διάστημα"
    space_button.custom_minimum_size = Vector2(290, 58)
    space_button.pressed.connect(func(): get_tree().change_scene_to_file("res://space.tscn"))
    column.add_child(space_button)

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()

    for i in range(dinosaurs.size()):
        var button := Button.new()
        var text := dinosaurs[i]["gr"] if language == "el" else dinosaurs[i]["en"]
        button.text = dinosaurs[i]["symbol"] + "\n" + text
        button.custom_minimum_size = Vector2(175, 94)
        button.add_theme_font_size_override("font_size", 17)
        button.pressed.connect(func(chosen=i): index = chosen; _show_dinosaur())
        grid.add_child(button)

func _show_dinosaur() -> void:
    var item = dinosaurs[index]
    symbol_label.text = item["symbol"]

    if language == "el":
        name_label.text = item["gr"]
        fact_label.text = item["fact_gr"]
    else:
        name_label.text = item["en"]
        fact_label.text = item["fact_en"]

    progress_label.text = "%d από %d" % [index + 1, dinosaurs.size()]

func _set_language(value: String) -> void:
    language = value
    _rebuild_grid()
    _show_dinosaur()

func _previous() -> void:
    index = (index - 1 + dinosaurs.size()) % dinosaurs.size()
    _show_dinosaur()

func _next() -> void:
    index = (index + 1) % dinosaurs.size()
    _show_dinosaur()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = dinosaurs[index]
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
