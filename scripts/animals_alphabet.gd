extends Control

var animals := [
    {"letter":"Α","gr":"Αλεπού","en":"Fox","symbol":"🦊","fact":"Η αλεπού έχει πολύ καλή ακοή και όσφρηση."},
    {"letter":"Β","gr":"Βάτραχος","en":"Frog","symbol":"🐸","fact":"Ο βάτραχος ζει κοντά στο νερό και πηδά πολύ ψηλά."},
    {"letter":"Γ","gr":"Γάτα","en":"Cat","symbol":"🐱","fact":"Η γάτα έχει μουστάκια που τη βοηθούν να καταλαβαίνει τον χώρο."},
    {"letter":"Δ","gr":"Δελφίνι","en":"Dolphin","symbol":"🐬","fact":"Το δελφίνι είναι έξυπνο θαλάσσιο θηλαστικό."},
    {"letter":"Ε","gr":"Ελάφι","en":"Deer","symbol":"🦌","fact":"Το ελάφι τρέχει γρήγορα και ζει σε δάση."},
    {"letter":"Ζ","gr":"Ζέβρα","en":"Zebra","symbol":"🦓","fact":"Κάθε ζέβρα έχει διαφορετικές ρίγες."},
    {"letter":"Η","gr":"Ημίονος","en":"Mule","symbol":"🐴","fact":"Ο ημίονος είναι δυνατό και ανθεκτικό ζώο."},
    {"letter":"Θ","gr":"Θαλάσσιος ίππος","en":"Walrus","symbol":"🦭","fact":"Ο θαλάσσιος ίππος έχει μεγάλα χαυλιόδοντα και ζει σε παγωμένες θάλασσες."},
    {"letter":"Ι","gr":"Ιπποπόταμος","en":"Hippopotamus","symbol":"🦛","fact":"Ο ιπποπόταμος περνά πολλές ώρες μέσα στο νερό."},
    {"letter":"Κ","gr":"Κοάλα","en":"Koala","symbol":"🐨","fact":"Το κοάλα τρώει κυρίως φύλλα ευκαλύπτου."},
    {"letter":"Λ","gr":"Λιοντάρι","en":"Lion","symbol":"🦁","fact":"Το λιοντάρι ζει σε ομάδες που λέγονται αγέλες."},
    {"letter":"Μ","gr":"Μέλισσα","en":"Bee","symbol":"🐝","fact":"Η μέλισσα βοηθά τα λουλούδια να δημιουργούν καρπούς."},
    {"letter":"Ν","gr":"Νυχτερίδα","en":"Bat","symbol":"🦇","fact":"Η νυχτερίδα είναι θηλαστικό που μπορεί να πετά."},
    {"letter":"Ξ","gr":"Ξιφίας","en":"Swordfish","symbol":"🐟","fact":"Ο ξιφίας έχει μακρύ και μυτερό ρύγχος."},
    {"letter":"Ο","gr":"Όρκα","en":"Orca","symbol":"🐋","fact":"Η όρκα είναι μεγάλο και πολύ έξυπνο θαλάσσιο θηλαστικό."},
    {"letter":"Π","gr":"Πιγκουίνος","en":"Penguin","symbol":"🐧","fact":"Ο πιγκουίνος δεν πετά, αλλά κολυμπά εξαιρετικά."},
    {"letter":"Ρ","gr":"Ρινόκερος","en":"Rhinoceros","symbol":"🦏","fact":"Ο ρινόκερος έχει παχύ δέρμα και ένα ή δύο κέρατα."},
    {"letter":"Σ","gr":"Σκύλος","en":"Dog","symbol":"🐶","fact":"Ο σκύλος έχει πολύ δυνατή όσφρηση."},
    {"letter":"Τ","gr":"Τίγρη","en":"Tiger","symbol":"🐯","fact":"Η τίγρη είναι μεγάλη γάτα με πορτοκαλί και μαύρες ρίγες."},
    {"letter":"Υ","gr":"Ύαινα","en":"Hyena","symbol":"🐕","fact":"Η ύαινα ζει σε ομάδες και έχει πολύ δυνατό δάγκωμα."},
    {"letter":"Φ","gr":"Φάλαινα","en":"Whale","symbol":"🐋","fact":"Η φάλαινα είναι από τα μεγαλύτερα ζώα της Γης."},
    {"letter":"Χ","gr":"Χελώνα","en":"Turtle","symbol":"🐢","fact":"Η χελώνα προστατεύεται μέσα στο καβούκι της."},
    {"letter":"Ψ","gr":"Ψάρι","en":"Fish","symbol":"🐠","fact":"Το ψάρι αναπνέει μέσα στο νερό με βράγχια."},
    {"letter":"Ω","gr":"Ωταρία","en":"Sea lion","symbol":"🦭","fact":"Η ωταρία κολυμπά γρήγορα και ξεκουράζεται στις ακτές."}
]

var index := 0
var letter_label: Label
var symbol_label: Label
var greek_label: Label
var english_label: Label
var fact_label: Label
var grid: GridContainer

func _ready() -> void:
    _build()
    _rebuild_grid()
    _show_animal()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#eef8ee")
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
    back.text = "← Οχήματα"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://vehicles.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Ζώα από Α έως Ω"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top_row.add_child(title)

    var body := HBoxContainer.new()
    body.position = Vector2(28, 100)
    body.size = Vector2(1224, 585)
    body.add_theme_constant_override("separation", 18)
    add_child(body)

    var left := PanelContainer.new()
    left.custom_minimum_size = Vector2(365, 0)
    left.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.97), 24))
    body.add_child(left)

    var scroll := ScrollContainer.new()
    left.add_child(scroll)

    grid = GridContainer.new()
    grid.columns = 4
    grid.add_theme_constant_override("h_separation", 8)
    grid.add_theme_constant_override("v_separation", 8)
    scroll.add_child(grid)

    var right := PanelContainer.new()
    right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    right.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.98), 28))
    body.add_child(right)

    var column := VBoxContainer.new()
    column.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_theme_constant_override("separation", 12)
    right.add_child(column)

    letter_label = Label.new()
    letter_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    letter_label.add_theme_font_size_override("font_size", 90)
    column.add_child(letter_label)

    symbol_label = Label.new()
    symbol_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    symbol_label.add_theme_font_size_override("font_size", 130)
    column.add_child(symbol_label)

    greek_label = Label.new()
    greek_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    greek_label.add_theme_font_size_override("font_size", 40)
    column.add_child(greek_label)

    english_label = Label.new()
    english_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    english_label.add_theme_font_size_override("font_size", 26)
    column.add_child(english_label)

    fact_label = Label.new()
    fact_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    fact_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    fact_label.custom_minimum_size = Vector2(0, 90)
    fact_label.add_theme_font_size_override("font_size", 24)
    column.add_child(fact_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε"
    hear.custom_minimum_size = Vector2(280, 56)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

    var quiz := Button.new()
    quiz.text = "❓ Κουίζ ζώων Α–Ω"
    quiz.custom_minimum_size = Vector2(280, 56)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://animals_alphabet_quiz.tscn"))
    column.add_child(quiz)

    var nav := HBoxContainer.new()
    nav.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_child(nav)

    var previous := Button.new()
    previous.text = "← Προηγούμενο"
    previous.custom_minimum_size = Vector2(180, 52)
    previous.pressed.connect(_previous)
    nav.add_child(previous)

    var next := Button.new()
    next.text = "Επόμενο →"
    next.custom_minimum_size = Vector2(180, 52)
    next.pressed.connect(_next)
    nav.add_child(next)

    var fruits_button := Button.new()
    fruits_button.text = "🍎 Φρούτα"
    fruits_button.custom_minimum_size = Vector2(280, 58)
    fruits_button.pressed.connect(func(): get_tree().change_scene_to_file("res://fruits.tscn"))
    column.add_child(fruits_button)

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()

    for i in range(animals.size()):
        var button := Button.new()
        button.text = animals[i]["letter"] + "\n" + animals[i]["symbol"]
        button.custom_minimum_size = Vector2(76, 76)
        button.add_theme_font_size_override("font_size", 24)
        button.pressed.connect(func(chosen=i): index = chosen; _show_animal())
        grid.add_child(button)

func _show_animal() -> void:
    var item = animals[index]
    letter_label.text = item["letter"]
    symbol_label.text = item["symbol"]
    greek_label.text = item["gr"]
    english_label.text = item["en"]
    fact_label.text = item["fact"]

func _previous() -> void:
    index = (index - 1 + animals.size()) % animals.size()
    _show_animal()

func _next() -> void:
    index = (index + 1) % animals.size()
    _show_animal()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = animals[index]
    var voices := DisplayServer.tts_get_voices_for_language("el")

    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(item["letter"] + ". " + item["gr"] + ". " + item["fact"], voices[0])

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
