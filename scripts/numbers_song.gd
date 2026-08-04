extends Control

var numbers: Array[int] = []
var current_index := 0
var running := false

var number_label: Label
var progress_label: Label
var objects_label: Label
var play_button: Button
var timer: Timer

func _ready() -> void:
    for value in range(21):
        numbers.append(value)

    _build()
    _show_current()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#fff3cf")
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
    back.text = "← Αριθμοί"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://numbers.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Το Τραγουδάκι των Αριθμών"
    title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 30)
    top_row.add_child(title)

    var panel := PanelContainer.new()
    panel.position = Vector2(190, 105)
    panel.size = Vector2(900, 580)
    panel.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.97), 30))
    add_child(panel)

    var column := VBoxContainer.new()
    column.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_theme_constant_override("separation", 18)
    panel.add_child(column)

    var intro := Label.new()
    intro.text = "Άκουσε τον ρυθμό και μέτρα μαζί!"
    intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    intro.add_theme_font_size_override("font_size", 28)
    column.add_child(intro)

    number_label = Label.new()
    number_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    number_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    number_label.custom_minimum_size = Vector2(0, 220)
    number_label.add_theme_font_size_override("font_size", 190)
    column.add_child(number_label)

    objects_label = Label.new()
    objects_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    objects_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    objects_label.custom_minimum_size = Vector2(0, 110)
    objects_label.add_theme_font_size_override("font_size", 38)
    column.add_child(objects_label)

    progress_label = Label.new()
    progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    progress_label.add_theme_font_size_override("font_size", 23)
    column.add_child(progress_label)

    var controls := HBoxContainer.new()
    controls.alignment = BoxContainer.ALIGNMENT_CENTER
    controls.add_theme_constant_override("separation", 14)
    column.add_child(controls)

    play_button = Button.new()
    play_button.text = "▶ Έναρξη"
    play_button.custom_minimum_size = Vector2(190, 58)
    play_button.pressed.connect(_toggle_play)
    controls.add_child(play_button)

    var restart := Button.new()
    restart.text = "↻ Από την αρχή"
    restart.custom_minimum_size = Vector2(190, 58)
    restart.pressed.connect(_restart)
    controls.add_child(restart)

    var stop := Button.new()
    stop.text = "⏹ Σταμάτησε"
    stop.custom_minimum_size = Vector2(190, 58)
    stop.pressed.connect(_stop)
    controls.add_child(stop)

    timer = Timer.new()
    timer.wait_time = 0.9
    timer.one_shot = false
    timer.timeout.connect(_next_beat)
    add_child(timer)

func _toggle_play() -> void:
    if running:
        running = false
        timer.stop()
        play_button.text = "▶ Συνέχεια"
        return

    running = true
    play_button.text = "⏸ Παύση"
    _speak_current()
    timer.start()

func _next_beat() -> void:
    if not running:
        return

    current_index += 1

    if current_index >= numbers.size():
        _finish_song()
        return

    _show_current()
    _speak_current()

func _restart() -> void:
    _stop()
    current_index = 0
    _show_current()
    _toggle_play()

func _stop() -> void:
    running = false
    timer.stop()
    play_button.text = "▶ Έναρξη"

    if DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        DisplayServer.tts_stop()

func _finish_song() -> void:
    running = false
    timer.stop()
    play_button.text = "▶ Ξανά"
    progress_label.text = "Μπράβο! Μέτρησες μέχρι το 20! ⭐"

    if DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        var voices := DisplayServer.tts_get_voices_for_language("el")
        if voices.size() > 0:
            DisplayServer.tts_speak("Μπράβο! Μέτρησες μέχρι το είκοσι!", voices[0])

func _show_current() -> void:
    var value := numbers[current_index]
    number_label.text = str(value)
    progress_label.text = "%d από %d" % [current_index + 1, numbers.size()]
    objects_label.text = _objects(value)

func _objects(value: int) -> String:
    if value == 0:
        return "Κανένα αντικείμενο"

    var symbols: Array[String] = []
    for i in range(value):
        symbols.append("⭐")

    return " ".join(symbols)

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var voices := DisplayServer.tts_get_voices_for_language("el")

    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(str(numbers[current_index]), voices[0], 60, 1.08, 1.0, 1)

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
