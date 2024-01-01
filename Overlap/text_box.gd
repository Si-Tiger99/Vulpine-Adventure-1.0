extends CanvasLayer

const char_read_rate = .04

@onready var textBoxContainter = $TextBoxContainer
@onready var startSymbol = $TextBoxContainer/MarginContainer/HBoxContainer/Start
@onready var label = $TextBoxContainer/MarginContainer/HBoxContainer/Label
@onready var endSymbol = $TextBoxContainer/MarginContainer/HBoxContainer/End

var TW = 0 #Tween var
var text_queue = []

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY

func _ready():
	print("Starting at READY State")
	hide_textbox()
	await get_tree().create_timer(1).timeout
	#queue_text("Welcome Adventurer! (Press \"J\" or \"X\" to Attack or Continue)")
	

func _process(_delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
				get_tree().paused = true
		State.READING:
			endSymbol.text = ""
			if Input.is_action_just_pressed("Attack"):
				label.visible_ratio=1
				TW.stop()
				endSymbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("Attack"):
				change_state(State.READY)
				if text_queue.is_empty():
					change_state(State.READY)
					hide_textbox()
					get_tree().paused = false
	if Input.is_key_pressed(KEY_C):
		change_state(State.READY)
		hide_textbox()
		text_queue.clear()
		get_tree().paused = false
	if Input.is_key_pressed(KEY_ENTER):
		get_tree().reload_current_scene()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	startSymbol.text = ""
	endSymbol.text = ""
	label.text = ""
	textBoxContainter.hide()
	
func show_textbox():
	startSymbol.text = "*"
	textBoxContainter.show()

func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	#label.add_theme_font_size_override("font_size", 12)
	change_state(State.READING)
	show_textbox()
	label.visible_ratio = 0
	TW= create_tween()
	TW.tween_property(label, "visible_ratio", 1, len(next_text) * char_read_rate).set_trans(Tween.TRANS_LINEAR)
	TW.tween_callback(endSymbol.set.bind("text", "v"))
	TW.tween_callback(change_state.bind(State.FINISHED))	
#	label.visible_characters = 0
#	while label.visible_characters <= len(next_text):
#		if label.visible_characters == -1:
#			break
#		label.visible_characters +=1
#		await get_tree().create_timer(.02).timeout
#		if label.visible_characters > len(next_text):
#			label.visible_characters ==-1
#			endSymbol.text = "v"			
#			current_state = state.FINISHED
	#change all "Label.visible_ratio = 0" to "Label.visible_characters = 0" where necessary
	
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			pass
			#print("Changing to READY State")
		State.READING:
			pass
			#print("Changing to READING State")
		State.FINISHED:
			pass
			#print("Changing to FINISHED State")
			
			
