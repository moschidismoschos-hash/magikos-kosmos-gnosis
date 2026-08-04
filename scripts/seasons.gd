extends Control

var seasons := [
    {
        "gr":"Άνοιξη",
        "en":"Spring",
        "symbol":"🌸",
        "fact_gr":"Την άνοιξη ο καιρός γίνεται πιο ζεστός και ανθίζουν τα λουλούδια.",
        "fact_en":"In spring the weather gets warmer and flowers bloom."
    },
    {
        "gr":"Καλοκαίρι",
        "en":"Summer",
        "symbol":"☀️",
        "fact_gr":"Το καλοκαίρι έχει ζέστη, μεγάλες ημέρες και συχνά πηγαίνουμε στη θάλασσα.",
        "fact_en":"Summer is warm, the days are long and we often go to the sea."
    },
    {
        "gr":"Φθινόπωρο",
        "en":"Autumn",
        "symbol":"🍂",
        "fact_gr":"Το φθινόπωρο ο καιρός δροσίζει και πολλά φύλλα πέφτουν από τα δέντρα.",
        "fact_en":"In autumn the weather gets cooler and many leaves fall from the trees."
    },
    {
        "gr":"Χειμώνας",
        "en":"Winter",
        "symbol":"❄️",
        "fact_gr":"Τον χειμώνα κάνει κρύο και σε ορισμένα μέρη χιονίζει.",
        "fact_en":"Winter is cold and in some places it snows."
    }
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
    _show_season()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#eef8ff")
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
    back.text = "← Χώρες και Σημαίες"
    back.custom_minimum_size = Vector2(230, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://countries.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Οι Τέσσερις Εποχές"
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
    body.position = Vector2(40, 110)
    body.size = Vector2(1200, 560)
    body.add_theme_constant_override("separation", 20)
    add_child(body)

    var left := PanelContainer.new()
    left.custom_minimum_size = Vector2(360, 0)
    left.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.97), 24))
    body.add_child(left)

    grid = GridContainer.new()
    grid.columns = 1
    grid.add_theme_constant_override("v_separation", 12)
    left.add_child(grid)

    var right := PanelContainer.new()
    right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    right.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.98), 28))
    body.add_child(right)

    var column := VBoxContainer.new()
    column.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_theme_constant_override("separation", 18)
    right.add_child(column)

    symbol_label = Label.new()
    symbol_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    symbol_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    symbol_label.custom_minimum_size = Vector2(0, 230)
    symbol_label.add_theme_font_size_override("font_size", 170)
    column.add_child(symbol_label)

    name_label = Label.new()
    name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    name_label.add_theme_font_size_override("font_size", 44)
    column.add_child(name_label)

    fact_label = Label.new()
    fact_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    fact_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    fact_label.custom_minimum_size = Vector2(0, 110)
    fact_label.add_theme_font_size_override("font_size", 26)
    column.add_child(fact_label)

    progress_label = Label.new()
    progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    progress_label.add_theme_font_size_override("font_size", 22)
    column.add_child(progress_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε την εποχή"
    hear.custom_minimum_size = Vector2(290, 58)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

    var nav := HBoxContainer.new()
    nav.alignment = BoxContainer.ALIGNMENT_CENTER
    nav.add_theme_constant_override("separation", 16)
    column.add_child(nav)

    var previous := Button.new()
    previous.text = "← Προηγούμενη"
    previous.custom_minimum_size = Vector2(190, 54)
    previous.pressed.connect(_previous)
    nav.add_child(previous)

    var next := Button.new()
    next.text = "Επόμενη →"
    next.custom_minimum_size = Vector2(190, 54)
    next.pressed.connect(_next)
    nav.add_child(next)

    var weather_button := Button.new()
    weather_button.text = "🌦️ Καιρικά Φαινόμενα"
    weather_button.custom_minimum_size = Vector2(290, 58)
    weather_button.pressed.connect(func(): get_tree().change_scene_to_file("res://weather.tscn"))
    column.add_child(weather_button)

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()

    for i in range(seasons.size()):
        var button := Button.new()
        var text := seasons[i]["gr"] if language == "el" else seasons[i]["en"]
        button.text = seasons[i]["symbol"] + "  " + text
        button.custom_minimum_size = Vector2(310, 105)
        button.add_theme_font_size_override("font_size", 25)
        button.pressed.connect(func(chosen=i): index = chosen; _show_season())
        grid.add_child(button)

func _show_season() -> void:
    var item = seasons[index]
    symbol_label.text = item["symbol"]

    if language == "el":
        name_label.text = item["gr"]
        fact_label.text = item["fact_gr"]
    else:
        name_label.text = item["en"]
        fact_label.text = item["fact_en"]

    progress_label.text = "%d από %d" % [index + 1, seasons.size()]

func _set_language(value: String) -> void:
    language = value
    _rebuild_grid()
    _show_season()

func _previous() -> void:
    index = (index - 1 + seasons.size()) % seasons.size()
    _show_season()

func _next() -> void:
    index = (index + 1) % seasons.size()
    _show_season()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = seasons[index]
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
    style.content_margin_left = 18
    style.content_margin_right = 18
    style.content_margin_top = 16
    style.content_margin_bottom = 16
    return style
