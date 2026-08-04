extends Control

var questions := [
    {"question":"Ποια ημέρα έρχεται μετά τη Δευτέρα;","answer":"Τρίτη","choices":["Τρίτη","Κυριακή","Παρασκευή","Σάββατο"]},
    {"question":"Ποιος μήνας έρχεται μετά τον Ιανουάριο;","answer":"Φεβρουάριος","choices":["Φεβρουάριος","Ιούλιος","Δεκέμβριος","Μάιος"]},
    {"question":"Πόσες ημέρες έχει η εβδομάδα;","answer":"7","choices":["7","5","10","12"]},
    {"question":"Πόσους μήνες έχει το έτος;","answer":"12","choices":["12","10","7","4"]},
    {"question":"Ποια ώρα δείχνει το 3:00;","answer":"Τρεις η ώρα","choices":["Τρεις η ώρα","Έξι η ώρα","Εννέα η ώρα","Δώδεκα η ώρα"]},
    {"question":"Ποια ημέρα έρχεται πριν από την Κυριακή;","answer":"Σάββατο","choices":["Σάββατο","Τρίτη","Δευτέρα","Πέμπτη"]}
]

var current := 0
var stars := 0
var question_label: Label
var options_box: VBoxContainer
var feedback_label: Label
var stars_label: Label
var next_button: Button
var answered := false

func _ready() -> void:
    randomize()
    questions.shuffle()
    stars = int(_load_value("stars", 0))
    _build()
    _show_question()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#fff9e8")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var top := HBoxContainer.new()
    top.position = Vector2(20, 18)
    top.size = Vector2(1240, 58)
    add_child(top)

    var back := Button.new()
    back.text = "← Ώρα και Ημερολόγιο"
    back.custom_minimum_size = Vector2(240, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://time_calendar.tscn"))
    top.add_child(back)

    var title := Label.new()
    title.text = "Κουίζ Ώρας και Ημερολογίου"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top.add_child(title)

    stars_label = Label.new()
    stars_label.text = "⭐ %d" % stars
    stars_label.add_theme_font_size_override("font_size", 24)
    top.add_child(stars_label)

    var panel := PanelContainer.new()
    panel.position = Vector2(230, 110)
    panel.size = Vector2(820, 560)
    add_child(panel)

    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 18)
    panel.add_child(column)

    question_label = Label.new()
    question_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    question_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    question_label.custom_minimum_size = Vector2(0, 100)
    question_label.add_theme_font_size_override("font_size", 31)
    column.add_child(question_label)

    var hear := Button.new()
    hear.text = "🔊 Άκουσε την ερώτηση"
    hear.custom_minimum_size = Vector2(0, 56)
    hear.pressed.connect(_speak_question)
    column.add_child(hear)

    options_box = VBoxContainer.new()
    options_box.add_theme_constant_override("separation", 10)
    column.add_child(options_box)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", 26)
    column.add_child(feedback_label)

    next_button = Button.new()
    next_button.text = "Επόμενη ερώτηση"
    next_button.custom_minimum_size = Vector2(0, 56)
    next_button.visible = false
    next_button.pressed.connect(_next_question)
    column.add_child(next_button)

func _show_question() -> void:
    answered = false
    feedback_label.text = ""
    next_button.visible = false

    var item = questions[current]
    question_label.text = item["question"]

    for child in options_box.get_children():
        child.queue_free()

    var choices = item["choices"].duplicate()
    choices.shuffle()

    for choice in choices:
        var button := Button.new()
        button.text = choice
        button.custom_minimum_size = Vector2(0, 62)
        button.add_theme_font_size_override("font_size", 23)
        button.pressed.connect(func(selected=choice): _answer(selected))
        options_box.add_child(button)

func _answer(selected: String) -> void:
    if answered:
        return

    if selected == questions[current]["answer"]:
        answered = true
        feedback_label.text = "Μπράβο! Σωστή απάντηση! ⭐"
        stars += 1
        stars_label.text = "⭐ %d" % stars
        _save_value("stars", stars)
        next_button.visible = true

        for child in options_box.get_children():
            child.disabled = true
    else:
        feedback_label.text = "Δοκίμασε ξανά."

func _next_question() -> void:
    current = (current + 1) % questions.size()
    _show_question()

func _speak_question() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var voices := DisplayServer.tts_get_voices_for_language("el")

    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(questions[current]["question"], voices[0])

func _save_value(key: String, value) -> void:
    var data := {}

    if FileAccess.file_exists("user://save.json"):
        var file := FileAccess.open("user://save.json", FileAccess.READ)
        var parsed = JSON.parse_string(file.get_as_text())
        if typeof(parsed) == TYPE_DICTIONARY:
            data = parsed

    data[key] = value
    var output := FileAccess.open("user://save.json", FileAccess.WRITE)
    output.store_string(JSON.stringify(data))

func _load_value(key: String, fallback):
    if not FileAccess.file_exists("user://save.json"):
        return fallback

    var file := FileAccess.open("user://save.json", FileAccess.READ)
    var parsed = JSON.parse_string(file.get_as_text())

    if typeof(parsed) != TYPE_DICTIONARY:
        return fallback

    return parsed.get(key, fallback)
