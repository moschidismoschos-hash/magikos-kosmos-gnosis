extends Control

var countries := [
    {"gr":"Ελλάδα","en":"Greece","flag":"🇬🇷","capital_gr":"Αθήνα","capital_en":"Athens","fact_gr":"Η Ελλάδα βρίσκεται στη νοτιοανατολική Ευρώπη.","fact_en":"Greece is in southeastern Europe."},
    {"gr":"Κύπρος","en":"Cyprus","flag":"🇨🇾","capital_gr":"Λευκωσία","capital_en":"Nicosia","fact_gr":"Η Κύπρος είναι νησί στην ανατολική Μεσόγειο.","fact_en":"Cyprus is an island in the eastern Mediterranean."},
    {"gr":"Ιταλία","en":"Italy","flag":"🇮🇹","capital_gr":"Ρώμη","capital_en":"Rome","fact_gr":"Η Ιταλία έχει σχήμα που μοιάζει με μπότα.","fact_en":"Italy has a shape that looks like a boot."},
    {"gr":"Γαλλία","en":"France","flag":"🇫🇷","capital_gr":"Παρίσι","capital_en":"Paris","fact_gr":"Η Γαλλία βρίσκεται στη δυτική Ευρώπη.","fact_en":"France is in western Europe."},
    {"gr":"Γερμανία","en":"Germany","flag":"🇩🇪","capital_gr":"Βερολίνο","capital_en":"Berlin","fact_gr":"Η Γερμανία βρίσκεται στην κεντρική Ευρώπη.","fact_en":"Germany is in central Europe."},
    {"gr":"Ισπανία","en":"Spain","flag":"🇪🇸","capital_gr":"Μαδρίτη","capital_en":"Madrid","fact_gr":"Η Ισπανία βρίσκεται στην Ιβηρική Χερσόνησο.","fact_en":"Spain is on the Iberian Peninsula."},
    {"gr":"Πορτογαλία","en":"Portugal","flag":"🇵🇹","capital_gr":"Λισαβόνα","capital_en":"Lisbon","fact_gr":"Η Πορτογαλία βρίσκεται στη δυτική άκρη της Ευρώπης.","fact_en":"Portugal is on the western edge of Europe."},
    {"gr":"Ηνωμένο Βασίλειο","en":"United Kingdom","flag":"🇬🇧","capital_gr":"Λονδίνο","capital_en":"London","fact_gr":"Το Ηνωμένο Βασίλειο αποτελείται από τέσσερα μέρη.","fact_en":"The United Kingdom is made up of four parts."},
    {"gr":"Ιρλανδία","en":"Ireland","flag":"🇮🇪","capital_gr":"Δουβλίνο","capital_en":"Dublin","fact_gr":"Η Ιρλανδία είναι νησιωτική χώρα της βορειοδυτικής Ευρώπης.","fact_en":"Ireland is an island country in northwestern Europe."},
    {"gr":"Ολλανδία","en":"Netherlands","flag":"🇳🇱","capital_gr":"Άμστερνταμ","capital_en":"Amsterdam","fact_gr":"Η Ολλανδία είναι γνωστή για τα κανάλια και τους ανεμόμυλους.","fact_en":"The Netherlands is known for canals and windmills."},
    {"gr":"Βέλγιο","en":"Belgium","flag":"🇧🇪","capital_gr":"Βρυξέλλες","capital_en":"Brussels","fact_gr":"Το Βέλγιο βρίσκεται στη δυτική Ευρώπη.","fact_en":"Belgium is in western Europe."},
    {"gr":"Ελβετία","en":"Switzerland","flag":"🇨🇭","capital_gr":"Βέρνη","capital_en":"Bern","fact_gr":"Η Ελβετία είναι γνωστή για τις Άλπεις.","fact_en":"Switzerland is known for the Alps."},
    {"gr":"Αυστρία","en":"Austria","flag":"🇦🇹","capital_gr":"Βιέννη","capital_en":"Vienna","fact_gr":"Η Αυστρία βρίσκεται στην κεντρική Ευρώπη.","fact_en":"Austria is in central Europe."},
    {"gr":"Νορβηγία","en":"Norway","flag":"🇳🇴","capital_gr":"Όσλο","capital_en":"Oslo","fact_gr":"Η Νορβηγία είναι γνωστή για τα φιόρδ της.","fact_en":"Norway is known for its fjords."},
    {"gr":"Σουηδία","en":"Sweden","flag":"🇸🇪","capital_gr":"Στοκχόλμη","capital_en":"Stockholm","fact_gr":"Η Σουηδία βρίσκεται στη βόρεια Ευρώπη.","fact_en":"Sweden is in northern Europe."},
    {"gr":"Φινλανδία","en":"Finland","flag":"🇫🇮","capital_gr":"Ελσίνκι","capital_en":"Helsinki","fact_gr":"Η Φινλανδία έχει πολλές λίμνες.","fact_en":"Finland has many lakes."},
    {"gr":"Δανία","en":"Denmark","flag":"🇩🇰","capital_gr":"Κοπεγχάγη","capital_en":"Copenhagen","fact_gr":"Η Δανία βρίσκεται στη βόρεια Ευρώπη.","fact_en":"Denmark is in northern Europe."},
    {"gr":"Πολωνία","en":"Poland","flag":"🇵🇱","capital_gr":"Βαρσοβία","capital_en":"Warsaw","fact_gr":"Η Πολωνία βρίσκεται στην κεντρική Ευρώπη.","fact_en":"Poland is in central Europe."},
    {"gr":"Τσεχία","en":"Czechia","flag":"🇨🇿","capital_gr":"Πράγα","capital_en":"Prague","fact_gr":"Η Τσεχία βρίσκεται στην κεντρική Ευρώπη.","fact_en":"Czechia is in central Europe."},
    {"gr":"Ρουμανία","en":"Romania","flag":"🇷🇴","capital_gr":"Βουκουρέστι","capital_en":"Bucharest","fact_gr":"Η Ρουμανία βρίσκεται στη νοτιοανατολική Ευρώπη.","fact_en":"Romania is in southeastern Europe."},
    {"gr":"Βουλγαρία","en":"Bulgaria","flag":"🇧🇬","capital_gr":"Σόφια","capital_en":"Sofia","fact_gr":"Η Βουλγαρία συνορεύει με την Ελλάδα.","fact_en":"Bulgaria shares a border with Greece."},
    {"gr":"Τουρκία","en":"Turkey","flag":"🇹🇷","capital_gr":"Άγκυρα","capital_en":"Ankara","fact_gr":"Η Τουρκία βρίσκεται ανάμεσα στην Ευρώπη και την Ασία.","fact_en":"Turkey lies between Europe and Asia."},
    {"gr":"Ηνωμένες Πολιτείες","en":"United States","flag":"🇺🇸","capital_gr":"Ουάσινγκτον","capital_en":"Washington, D.C.","fact_gr":"Οι Ηνωμένες Πολιτείες βρίσκονται στη Βόρεια Αμερική.","fact_en":"The United States is in North America."},
    {"gr":"Καναδάς","en":"Canada","flag":"🇨🇦","capital_gr":"Οτάβα","capital_en":"Ottawa","fact_gr":"Ο Καναδάς είναι πολύ μεγάλη χώρα της Βόρειας Αμερικής.","fact_en":"Canada is a very large country in North America."},
    {"gr":"Μεξικό","en":"Mexico","flag":"🇲🇽","capital_gr":"Πόλη του Μεξικού","capital_en":"Mexico City","fact_gr":"Το Μεξικό βρίσκεται νότια των Ηνωμένων Πολιτειών.","fact_en":"Mexico is south of the United States."},
    {"gr":"Βραζιλία","en":"Brazil","flag":"🇧🇷","capital_gr":"Μπραζίλια","capital_en":"Brasília","fact_gr":"Η Βραζιλία είναι η μεγαλύτερη χώρα της Νότιας Αμερικής.","fact_en":"Brazil is the largest country in South America."},
    {"gr":"Αργεντινή","en":"Argentina","flag":"🇦🇷","capital_gr":"Μπουένος Άιρες","capital_en":"Buenos Aires","fact_gr":"Η Αργεντινή βρίσκεται στη Νότια Αμερική.","fact_en":"Argentina is in South America."},
    {"gr":"Χιλή","en":"Chile","flag":"🇨🇱","capital_gr":"Σαντιάγο","capital_en":"Santiago","fact_gr":"Η Χιλή είναι μακριά και στενή χώρα της Νότιας Αμερικής.","fact_en":"Chile is a long and narrow country in South America."},
    {"gr":"Αίγυπτος","en":"Egypt","flag":"🇪🇬","capital_gr":"Κάιρο","capital_en":"Cairo","fact_gr":"Η Αίγυπτος είναι γνωστή για τις πυραμίδες.","fact_en":"Egypt is known for the pyramids."},
    {"gr":"Νότια Αφρική","en":"South Africa","flag":"🇿🇦","capital_gr":"Πρετόρια","capital_en":"Pretoria","fact_gr":"Η Νότια Αφρική βρίσκεται στο νότιο άκρο της Αφρικής.","fact_en":"South Africa is at the southern end of Africa."},
    {"gr":"Κένυα","en":"Kenya","flag":"🇰🇪","capital_gr":"Ναϊρόμπι","capital_en":"Nairobi","fact_gr":"Η Κένυα είναι γνωστή για την άγρια ζωή της.","fact_en":"Kenya is known for its wildlife."},
    {"gr":"Μαρόκο","en":"Morocco","flag":"🇲🇦","capital_gr":"Ραμπάτ","capital_en":"Rabat","fact_gr":"Το Μαρόκο βρίσκεται στη βορειοδυτική Αφρική.","fact_en":"Morocco is in northwestern Africa."},
    {"gr":"Κίνα","en":"China","flag":"🇨🇳","capital_gr":"Πεκίνο","capital_en":"Beijing","fact_gr":"Η Κίνα είναι μία από τις μεγαλύτερες χώρες του κόσμου.","fact_en":"China is one of the largest countries in the world."},
    {"gr":"Ιαπωνία","en":"Japan","flag":"🇯🇵","capital_gr":"Τόκιο","capital_en":"Tokyo","fact_gr":"Η Ιαπωνία αποτελείται από πολλά νησιά.","fact_en":"Japan is made up of many islands."},
    {"gr":"Ινδία","en":"India","flag":"🇮🇳","capital_gr":"Νέο Δελχί","capital_en":"New Delhi","fact_gr":"Η Ινδία βρίσκεται στη νότια Ασία.","fact_en":"India is in South Asia."},
    {"gr":"Νότια Κορέα","en":"South Korea","flag":"🇰🇷","capital_gr":"Σεούλ","capital_en":"Seoul","fact_gr":"Η Νότια Κορέα βρίσκεται στην ανατολική Ασία.","fact_en":"South Korea is in East Asia."},
    {"gr":"Ταϊλάνδη","en":"Thailand","flag":"🇹🇭","capital_gr":"Μπανγκόκ","capital_en":"Bangkok","fact_gr":"Η Ταϊλάνδη βρίσκεται στη νοτιοανατολική Ασία.","fact_en":"Thailand is in Southeast Asia."},
    {"gr":"Ινδονησία","en":"Indonesia","flag":"🇮🇩","capital_gr":"Τζακάρτα","capital_en":"Jakarta","fact_gr":"Η Ινδονησία αποτελείται από χιλιάδες νησιά.","fact_en":"Indonesia is made up of thousands of islands."},
    {"gr":"Αυστραλία","en":"Australia","flag":"🇦🇺","capital_gr":"Καμπέρα","capital_en":"Canberra","fact_gr":"Η Αυστραλία είναι χώρα και ήπειρος.","fact_en":"Australia is both a country and a continent."},
    {"gr":"Νέα Ζηλανδία","en":"New Zealand","flag":"🇳🇿","capital_gr":"Ουέλινγκτον","capital_en":"Wellington","fact_gr":"Η Νέα Ζηλανδία αποτελείται κυρίως από δύο μεγάλα νησιά.","fact_en":"New Zealand mainly consists of two large islands."}
]

var index := 0
var language := "el"
var flag_label: Label
var name_label: Label
var capital_label: Label
var fact_label: Label
var grid: GridContainer

func _ready() -> void:
    _build()
    _rebuild_grid()
    _show_country()

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#eef6ff")
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
    back.text = "← Έπιπλα"
    back.custom_minimum_size = Vector2(170, 50)
    back.pressed.connect(func(): get_tree().change_scene_to_file("res://furniture.tscn"))
    top_row.add_child(back)

    var title := Label.new()
    title.text = "Χώρες και Σημαίες"
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
    left.custom_minimum_size = Vector2(380, 0)
    left.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.97), 24))
    body.add_child(left)

    var scroll := ScrollContainer.new()
    left.add_child(scroll)

    grid = GridContainer.new()
    grid.columns = 2
    grid.add_theme_constant_override("h_separation", 8)
    grid.add_theme_constant_override("v_separation", 8)
    scroll.add_child(grid)

    var right := PanelContainer.new()
    right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    right.add_theme_stylebox_override("panel", _panel_style(Color(1,1,1,0.98), 28))
    body.add_child(right)

    var column := VBoxContainer.new()
    column.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_theme_constant_override("separation", 14)
    right.add_child(column)

    flag_label = Label.new()
    flag_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    flag_label.custom_minimum_size = Vector2(0, 220)
    flag_label.add_theme_font_size_override("font_size", 145)
    column.add_child(flag_label)

    name_label = Label.new()
    name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    name_label.add_theme_font_size_override("font_size", 40)
    column.add_child(name_label)

    capital_label = Label.new()
    capital_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    capital_label.add_theme_font_size_override("font_size", 28)
    column.add_child(capital_label)

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
    quiz.text = "❓ Κουίζ σημαιών"
    quiz.custom_minimum_size = Vector2(280, 56)
    quiz.pressed.connect(func(): get_tree().change_scene_to_file("res://countries_quiz.tscn"))
    column.add_child(quiz)

    var nav := HBoxContainer.new()
    nav.alignment = BoxContainer.ALIGNMENT_CENTER
    column.add_child(nav)

    var previous := Button.new()
    previous.text = "← Προηγούμενη"
    previous.custom_minimum_size = Vector2(180, 52)
    previous.pressed.connect(_previous)
    nav.add_child(previous)

    var next := Button.new()
    next.text = "Επόμενη →"
    next.custom_minimum_size = Vector2(180, 52)
    next.pressed.connect(_next)
    nav.add_child(next)

    var seasons_button := Button.new()
    seasons_button.text = "🌸 Οι Τέσσερις Εποχές"
    seasons_button.custom_minimum_size = Vector2(280, 58)
    seasons_button.pressed.connect(func(): get_tree().change_scene_to_file("res://seasons.tscn"))
    column.add_child(seasons_button)

func _rebuild_grid() -> void:
    for child in grid.get_children():
        child.queue_free()

    for i in range(countries.size()):
        var button := Button.new()
        var text := countries[i]["gr"] if language == "el" else countries[i]["en"]
        button.text = countries[i]["flag"] + "\n" + text
        button.custom_minimum_size = Vector2(170, 82)
        button.add_theme_font_size_override("font_size", 18)
        button.pressed.connect(func(chosen=i): index = chosen; _show_country())
        grid.add_child(button)

func _show_country() -> void:
    var item = countries[index]
    flag_label.text = item["flag"]

    if language == "el":
        name_label.text = item["gr"]
        capital_label.text = "Πρωτεύουσα: " + item["capital_gr"]
        fact_label.text = item["fact_gr"]
    else:
        name_label.text = item["en"]
        capital_label.text = "Capital: " + item["capital_en"]
        fact_label.text = item["fact_en"]

func _set_language(value: String) -> void:
    language = value
    _rebuild_grid()
    _show_country()

func _previous() -> void:
    index = (index - 1 + countries.size()) % countries.size()
    _show_country()

func _next() -> void:
    index = (index + 1) % countries.size()
    _show_country()

func _speak_current() -> void:
    if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
        return

    var item = countries[index]
    var text := item["gr"] + ". Πρωτεύουσα: " + item["capital_gr"] + ". " + item["fact_gr"] if language == "el" else item["en"] + ". Capital: " + item["capital_en"] + ". " + item["fact_en"]
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
