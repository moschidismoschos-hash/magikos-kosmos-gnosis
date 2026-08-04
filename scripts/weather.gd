extends Control

var weather_items := [
    {"gr":"Ήλιος","en":"Sunny","symbol":"☀️","fact_gr":"Όταν έχει ήλιο, ο ουρανός είναι φωτεινός και ζεστός.","fact_en":"When it is sunny, the sky is bright and warm."},
    {"gr":"Λίγες νεφώσεις","en":"Partly cloudy","symbol":"🌤️","fact_gr":"Υπάρχουν λίγα σύννεφα, αλλά φαίνεται και ο ήλιος.","fact_en":"There are a few clouds, but the sun is still visible."},
    {"gr":"Συννεφιά","en":"Cloudy","symbol":"☁️","fact_gr":"Ο ουρανός είναι γεμάτος σύννεφα.","fact_en":"The sky is covered with clouds."},
    {"gr":"Βροχή","en":"Rain","symbol":"🌧️","fact_gr":"Η βροχή πέφτει από τα σύννεφα σε σταγόνες.","fact_en":"Rain falls from clouds in drops."},
    {"gr":"Καταιγίδα","en":"Storm","symbol":"⛈️","fact_gr":"Η καταιγίδα μπορεί να έχει δυνατή βροχή, άνεμο και αστραπές.","fact_en":"A storm can bring heavy rain, wind and lightning."},
    {"gr":"Χιόνι","en":"Snow","symbol":"🌨️","fact_gr":"Το χιόνι πέφτει σε νιφάδες όταν κάνει πολύ κρύο.","fact_en":"Snow falls in flakes when the weather is very cold."},
    {"gr":"Ουράνιο τόξο","en":"Rainbow","symbol":"🌈","fact_gr":"Το ουράνιο τόξο εμφανίζεται όταν το φως περνά μέσα από σταγόνες νερού.","fact_en":"A rainbow appears when light passes through water drops."},
    {"gr":"Άνεμος","en":"Wind","symbol":"🌬️","fact_gr":"Ο άνεμος είναι αέρας που κινείται.","fact_en":"Wind is moving air."},
    {"gr":"Ομίχλη","en":"Fog","symbol":"🌫️","fact_gr":"Η ομίχλη κάνει δύσκολο να βλέπουμε μακριά.","fact_en":"Fog makes it hard to see far away."},
    {"gr":"Αστραπή","en":"Lightning","symbol":"⚡","fact_gr":"Η αστραπή είναι μια πολύ φωτεινή λάμψη στον ουρανό.","fact_en":"Lightning is a very bright flash in the sky."},
    {"gr":"Χαλάζι","en":"Hail","symbol":"🧊","fact_gr":"Το χαλάζι είναι μικρά κομμάτια πάγου που πέφτουν από τα σύννεφα.","fact_en":"Hail is made of small pieces of ice that fall from clouds."},
    {"gr":"Ανεμοστρόβιλος","en":"Tornado","symbol":"🌪️","fact_gr":"Ο ανεμοστρόβιλος είναι πολύ δυνατός άνεμος που περιστρέφεται.","fact_en":"A tornado is very strong rotating wind."}
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
    _show_weather()

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
    back.text = "← Εποχές"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://seasons.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Καιρικά Φαινόμενα"
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
    left.custom_minimum_size = Vector2(370, 0)
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

    progress_label = Label.new()
    progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    progress_label.add_theme_font_size_override("font_size", 22)
    column.add_child(progress_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε"
    hear.custom_minimum_size = Vector2(280, 58)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

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

    var time_button := Button.new()
    time_button.text = "🕒 Ώρα και Ημερολόγιο"
    time_button.custom_minimum_size = Vector2(290, 58)
    time_button.pressed.connect(func(): get_tree().change_scene_to_file("res://time_calendar.tscn"))
    column.add_child(time_button)

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()

    for i in range(weather_items.size()):
        var button := Button.new()
        var text := weather_items[i]["gr"] if language == "el" else weather_items[i]["en"]
        button.text = weather_items[i]["symbol"] + "\n" + text
        button.custom_minimum_size = Vector2(165, 92)
        button.add_theme_font_size_override("font_size", 18)
        button.pressed.connect(func(chosen=i): index = chosen; _show_weather())
        grid.add_child(button)

func _show_weather() -> void:
    var item = weather_items[index]
    symbol_label.text = item["symbol"]

    if language == "el":
        name_label.text = item["gr"]
        fact_label.text = item["fact_gr"]
    else:
        name_label.text = item["en"]
        fact_label.text = item["fact_en"]

    progress_label.text = "%d από %d" % [index + 1, weather_items.size()]

func _set_language(value: String) -> void:
    language = value
    _rebuild_grid()
    _show_weather()

func _previous() -> void:
    index = (index - 1 + weather_items.size()) % weather_items.size()
    _show_weather()

func _next() -> void:
    index = (index + 1) % weather_items.size()
    _show_weather()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = weather_items[index]
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
