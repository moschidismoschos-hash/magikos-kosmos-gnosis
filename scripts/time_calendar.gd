extends Control

var hours := [
    {"gr":"Μία η ώρα","en":"One o'clock","value":"1:00"},
    {"gr":"Δύο η ώρα","en":"Two o'clock","value":"2:00"},
    {"gr":"Τρεις η ώρα","en":"Three o'clock","value":"3:00"},
    {"gr":"Τέσσερις η ώρα","en":"Four o'clock","value":"4:00"},
    {"gr":"Πέντε η ώρα","en":"Five o'clock","value":"5:00"},
    {"gr":"Έξι η ώρα","en":"Six o'clock","value":"6:00"},
    {"gr":"Επτά η ώρα","en":"Seven o'clock","value":"7:00"},
    {"gr":"Οκτώ η ώρα","en":"Eight o'clock","value":"8:00"},
    {"gr":"Εννέα η ώρα","en":"Nine o'clock","value":"9:00"},
    {"gr":"Δέκα η ώρα","en":"Ten o'clock","value":"10:00"},
    {"gr":"Έντεκα η ώρα","en":"Eleven o'clock","value":"11:00"},
    {"gr":"Δώδεκα η ώρα","en":"Twelve o'clock","value":"12:00"}
]

var days := [
    {"gr":"Δευτέρα","en":"Monday"},
    {"gr":"Τρίτη","en":"Tuesday"},
    {"gr":"Τετάρτη","en":"Wednesday"},
    {"gr":"Πέμπτη","en":"Thursday"},
    {"gr":"Παρασκευή","en":"Friday"},
    {"gr":"Σάββατο","en":"Saturday"},
    {"gr":"Κυριακή","en":"Sunday"}
]

var months := [
    {"gr":"Ιανουάριος","en":"January"},
    {"gr":"Φεβρουάριος","en":"February"},
    {"gr":"Μάρτιος","en":"March"},
    {"gr":"Απρίλιος","en":"April"},
    {"gr":"Μάιος","en":"May"},
    {"gr":"Ιούνιος","en":"June"},
    {"gr":"Ιούλιος","en":"July"},
    {"gr":"Αύγουστος","en":"August"},
    {"gr":"Σεπτέμβριος","en":"September"},
    {"gr":"Οκτώβριος","en":"October"},
    {"gr":"Νοέμβριος","en":"November"},
    {"gr":"Δεκέμβριος","en":"December"}
]

var section := "hours"
var index := 0
var language := "el"

var big_label: Label
var name_label: Label
var info_label: Label
var progress_label: Label
var grid: GridContainer
var title_label: Label

func _ready() -> void:
    _build()
    _rebuild_grid()
    _show_item()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#fff9e8")
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
    back.text = "← Εποχές και Καιρός"
    back.custom_minimum_size = Vector2(230, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://seasons.tscn"))
    top_row.add_child(back)

    title_label = Label.new()
    title_label.text = "Ώρα και Ημερολόγιο"
    title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 30)
    top_row.add_child(title_label)

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

    var tabs := HBoxContainer.new()
    tabs.position = Vector2(100, 95)
    tabs.size = Vector2(1080, 58)
    tabs.alignment = BoxContainer.ALIGNMENT_CENTER
    tabs.add_theme_constant_override("separation", 12)
    add_child(tabs)

    var hours_button := Button.new()
    hours_button.text = "🕒 Ώρες"
    hours_button.custom_minimum_size = Vector2(220, 52)
    hours_button.pressed.connect(func(): _change_section("hours"))
    tabs.add_child(hours_button)

    var days_button := Button.new()
    days_button.text = "📅 Ημέρες"
    days_button.custom_minimum_size = Vector2(220, 52)
    days_button.pressed.connect(func(): _change_section("days"))
    tabs.add_child(days_button)

    var months_button := Button.new()
    months_button.text = "🗓️ Μήνες"
    months_button.custom_minimum_size = Vector2(220, 52)
    months_button.pressed.connect(func(): _change_section("months"))
    tabs.add_child(months_button)

    var quiz_button := Button.new()
    quiz_button.text = "❓ Κουίζ"
    quiz_button.custom_minimum_size = Vector2(220, 52)
    quiz_button.pressed.connect(func(): get_tree().change_scene_to_file("res://time_calendar_quiz.tscn"))
    tabs.add_child(quiz_button)

    var body := HBoxContainer.new()
    body.position = Vector2(28, 165)
    body.size = Vector2(1224, 520)
    body.add_theme_constant_override("separation", 18)
    add_child(body)

    var left := PanelContainer.new()
    left.custom_minimum_size = Vector2(385, 0)
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
    column.add_theme_constant_override("separation", 18)
    right.add_child(column)

    big_label = Label.new()
    big_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    big_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    big_label.custom_minimum_size = Vector2(0, 220)
    big_label.add_theme_font_size_override("font_size", 130)
    column.add_child(big_label)

    name_label = Label.new()
    name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    name_label.add_theme_font_size_override("font_size", 40)
    column.add_child(name_label)

    info_label = Label.new()
    info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    info_label.custom_minimum_size = Vector2(0, 90)
    info_label.add_theme_font_size_override("font_size", 24)
    column.add_child(info_label)

    progress_label = Label.new()
    progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    progress_label.add_theme_font_size_override("font_size", 22)
    column.add_child(progress_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε"
    hear.custom_minimum_size = Vector2(280, 56)
    hear.pressed.connect(_speak_current)
    column.add_child(hear)

    var nav := HBoxContainer.new()
    nav.alignment = BoxContainer.ALIGNMENT_CENTER
    nav.add_theme_constant_override("separation", 14)
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

func _items() -> Array:
    if section == "days":
        return days
    if section == "months":
        return months
    return hours

func _change_section(value: String) -> void:
    section = value
    index = 0
    _rebuild_grid()
    _show_item()

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()

    var items := _items()

    for i in range(items.size()):
        var button := Button.new()
        var text := items[i]["gr"] if language == "el" else items[i]["en"]

        if section == "hours":
            button.text = items[i]["value"] + "\n" + text
        else:
            button.text = text

        button.custom_minimum_size = Vector2(175, 82)
        button.add_theme_font_size_override("font_size", 18)
        button.pressed.connect(func(chosen=i): index = chosen; _show_item())
        grid.add_child(button)

func _show_item() -> void:
    var items := _items()
    var item = items[index]

    if section == "hours":
        big_label.text = item["value"]
        title_label.text = "Μαθαίνω την Ώρα"
        info_label.text = "Οι δείκτες του ρολογιού δείχνουν " + item["gr"] + "." if language == "el" else "The clock shows " + item["en"] + "."
    elif section == "days":
        big_label.text = "📅"
        title_label.text = "Οι Ημέρες της Εβδομάδας"
        info_label.text = "Η εβδομάδα έχει επτά ημέρες." if language == "el" else "A week has seven days."
    else:
        big_label.text = "🗓️"
        title_label.text = "Οι Μήνες του Χρόνου"
        info_label.text = "Το έτος έχει δώδεκα μήνες." if language == "el" else "A year has twelve months."

    name_label.text = item["gr"] if language == "el" else item["en"]
    progress_label.text = "%d από %d" % [index + 1, items.size()]

func _set_language(value: String) -> void:
    language = value
    _rebuild_grid()
    _show_item()

func _previous() -> void:
    var items := _items()
    index = (index - 1 + items.size()) % items.size()
    _show_item()

func _next() -> void:
    var items := _items()
    index = (index + 1) % items.size()
    _show_item()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = _items()[index]
    var text := item["gr"] if language == "el" else item["en"]
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
