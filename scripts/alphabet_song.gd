extends Control

var greek_letters := ["Α","Β","Γ","Δ","Ε","Ζ","Η","Θ","Ι","Κ","Λ","Μ","Ν","Ξ","Ο","Π","Ρ","Σ","Τ","Υ","Φ","Χ","Ψ","Ω"]
var english_letters := ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

var current = greek_letters
var language := "el"
var running := false
var current_index := 0

var letter_label: Label
var progress_label: Label
var play_button: Button
var timer: Timer

func _ready() -> void:
    _build()
    _show_current()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#fff4cf")
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
    back.text = "← Αλφαβήτα"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://alphabet.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Το Τραγουδάκι της Αλφαβήτας"
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
    column.add_theme_constant_override("separation", 20)
    panel.add_child(column)

    var languages := HBoxContainer.new()
    languages.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_child(languages)

    var gr := Button.new()
    gr.text = "Ελληνικό"
    gr.custom_minimum_size = Vector2(180, 52)
    gr.pressed.connect(func(): _set_language("el"))
    languages.add_child(gr)

    var en := Button.new()
    en.text = "Αγγλικό"
    en.custom_minimum_size = Vector2(180, 52)
    en.pressed.connect(func(): _set_language("en"))
    languages.add_child(en)

    var intro := Label.new()
    intro.text = "Άκουσε τον ρυθμό και πες μαζί τα γράμματα!"
    intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    intro.add_theme_font_size_override("font_size", 27)
    column.add_child(intro)

    letter_label = Label.new()
    letter_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    letter_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    letter_label.custom_minimum_size = Vector2(0, 250)
    letter_label.add_theme_font_size_override("font_size", 190)
    column.add_child(letter_label)

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
    timer.wait_time = 0.85
    timer.one_shot = false
    timer.timeout.connect(_next_beat)
    add_child(timer)

func _set_language(value: String) -> void:
    _stop()
    language = value
    current = greek_letters if value == "el" else english_letters
    current_index = 0
    _show_current()

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

    if current_index >= current.size():
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
    progress_label.text = "Μπράβο! Τελείωσε το τραγουδάκι! ⭐"

    if DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        var voices := DisplayServer.tts_get_voices_for_language(language)
        if voices.size() > 0:
            var message := "Μπράβο! Τελείωσε η αλφαβήτα!" if language == "el" else "Great job! The alphabet song is finished!"
            DisplayServer.tts_speak(message, voices[0])

func _show_current() -> void:
    letter_label.text = current[current_index]
    progress_label.text = "%d από %d" % [current_index + 1, current.size()]

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var voices := DisplayServer.tts_get_voices_for_language(language)
    if voices.size() > 0:
        DisplayServer.tts_stop()
        DisplayServer.tts_speak(current[current_index], voices[0], 60, 1.08, 1.0, 1)

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
