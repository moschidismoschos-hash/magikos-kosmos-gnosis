extends Control

var greek := [
{"l":"Α","w":"Αεροπλάνο","e":"✈️"},{"l":"Β","w":"Βάρκα","e":"⛵"},{"l":"Γ","w":"Γάτα","e":"🐱"},{"l":"Δ","w":"Δέντρο","e":"🌳"},
{"l":"Ε","w":"Ελέφαντας","e":"🐘"},{"l":"Ζ","w":"Ζέβρα","e":"🦓"},{"l":"Η","w":"Ήλιος","e":"☀️"},{"l":"Θ","w":"Θάλασσα","e":"🌊"},
{"l":"Ι","w":"Ιπποπόταμος","e":"🦛"},{"l":"Κ","w":"Καμηλοπάρδαλη","e":"🦒"},{"l":"Λ","w":"Λιοντάρι","e":"🦁"},{"l":"Μ","w":"Μήλο","e":"🍎"},
{"l":"Ν","w":"Νερό","e":"💧"},{"l":"Ξ","w":"Ξυλόφωνο","e":"🎼"},{"l":"Ο","w":"Ομπρέλα","e":"☂️"},{"l":"Π","w":"Παγωτό","e":"🍦"},
{"l":"Ρ","w":"Ρολόι","e":"🕒"},{"l":"Σ","w":"Σκύλος","e":"🐶"},{"l":"Τ","w":"Τρένο","e":"🚆"},{"l":"Υ","w":"Υποβρύχιο","e":"🚤"},
{"l":"Φ","w":"Φεγγάρι","e":"🌙"},{"l":"Χ","w":"Χελώνα","e":"🐢"},{"l":"Ψ","w":"Ψάρι","e":"🐟"},{"l":"Ω","w":"Ώρα","e":"⌚"}
]

var english := [
{"l":"A","w":"Apple","e":"🍎"},{"l":"B","w":"Ball","e":"⚽"},{"l":"C","w":"Cat","e":"🐱"},{"l":"D","w":"Dog","e":"🐶"},
{"l":"E","w":"Elephant","e":"🐘"},{"l":"F","w":"Fish","e":"🐟"},{"l":"G","w":"Giraffe","e":"🦒"},{"l":"H","w":"House","e":"🏠"},
{"l":"I","w":"Ice cream","e":"🍦"},{"l":"J","w":"Juice","e":"🧃"},{"l":"K","w":"Kite","e":"🪁"},{"l":"L","w":"Lion","e":"🦁"},
{"l":"M","w":"Moon","e":"🌙"},{"l":"N","w":"Nest","e":"🪺"},{"l":"O","w":"Orange","e":"🍊"},{"l":"P","w":"Parrot","e":"🦜"},
{"l":"Q","w":"Queen","e":"👸"},{"l":"R","w":"Rabbit","e":"🐰"},{"l":"S","w":"Sun","e":"☀️"},{"l":"T","w":"Train","e":"🚆"},
{"l":"U","w":"Umbrella","e":"☂️"},{"l":"V","w":"Violin","e":"🎻"},{"l":"W","w":"Whale","e":"🐋"},{"l":"X","w":"Xylophone","e":"🎼"},
{"l":"Y","w":"Yacht","e":"⛵"},{"l":"Z","w":"Zebra","e":"🦓"}
]

var current = greek
var language := "el"
var index := 0
var letter_label: Label
var word_label: Label
var emoji_label: Label
var grid: GridContainer

func _ready() -> void:
    _build()
    _rebuild_grid()
    _show_letter()

func _build() -> void:
    var bg := ColorRect.new()
    bg.color = Color("#dff4ff")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    var top := HBoxContainer.new()
    top.position = Vector2(20, 18)
    top.size = Vector2(1240, 58)
    add_child(top)

    var back := Button.new()
    back.text = "← Χάρτης"
    back.custom_minimum_size = Vector2(150, 54)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://main.tscn"))
    top.add_child(back)

    var title := Label.new()
    title.text = "Η Μεγάλη Αλφαβήτα"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top.add_child(title)

    var gr := Button.new()
    gr.text = "Ελληνικά"
    gr.custom_minimum_size = Vector2(140, 54)
    gr.pressed.connect(func(): _set_language("el"))
    top.add_child(gr)

    var en := Button.new()
    en.text = "Αγγλικά"
    en.custom_minimum_size = Vector2(140, 54)
    en.pressed.connect(func(): _set_language("en"))
    top.add_child(en)

    var body := HBoxContainer.new()
    body.position = Vector2(28, 95)
    body.size = Vector2(1224, 590)
    add_child(body)

    var scroll := ScrollContainer.new()
    scroll.custom_minimum_size = Vector2(320, 0)
    body.add_child(scroll)

    grid = GridContainer.new()
    grid.columns = 4
    scroll.add_child(grid)

    var center := VBoxContainer.new()
    center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    center.alignment = BoxContainer.ALIGNMENT_CENTER
    body.add_child(center)

    letter_label = Label.new()
    letter_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    letter_label.add_theme_font_size_override("font_size", 150)
    center.add_child(letter_label)

    emoji_label = Label.new()
    emoji_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    emoji_label.add_theme_font_size_override("font_size", 95)
    center.add_child(emoji_label)

    word_label = Label.new()
    word_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    word_label.add_theme_font_size_override("font_size", 36)
    center.add_child(word_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε"
    hear.custom_minimum_size = Vector2(250, 58)
    hear.pressed.connect(_speak_current)
    center.add_child(hear)

    var nav := HBoxContainer.new()
    nav.alignment = BoxContainer.ALIGNMENT_CENTER
    center.add_child(nav)

    var prev := Button.new()
    prev.text = "← Προηγούμενο"
    prev.pressed.connect(_previous)
    nav.add_child(prev)

    var next := Button.new()
    next.text = "Επόμενο →"
    next.pressed.connect(_next)
    nav.add_child(next)

func _set_language(value: String) -> void:
    language = value
    current = greek if value == "el" else english
    index = 0
    _rebuild_grid()
    _show_letter()

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()
    for i in range(current.size()):
        var b := Button.new()
        b.text = current[i]["l"]
        b.custom_minimum_size = Vector2(64, 58)
        b.add_theme_font_size_override("font_size", 24)
        b.pressed.connect(func(chosen=i): index = chosen; _show_letter())
        grid.add_child(b)

func _show_letter() -> void:
    var item = current[index]
    letter_label.text = item["l"]
    emoji_label.text = item["e"]
    word_label.text = item["w"]

func _previous() -> void:
    index = (index - 1 + current.size()) % current.size()
    _show_letter()

func _next() -> void:
    index = (index + 1) % current.size()
    _show_letter()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return
    var item = current[index]
    var voices := DisplayServer.tts_get_voices_for_language(language)
    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(item["l"] + ". " + item["w"], voices[0])
