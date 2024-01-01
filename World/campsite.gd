extends Node2D

@onready var textBox = get_tree().current_scene.get_node("TextBox")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func text_win_instructions():
	textBox.queue_text("A peaceful place found... \n He may rest easy this night...")
	textBox.queue_text("A Hero's work done.")
	textBox.queue_text("Press ENTER to begin again. Try a diferent route! =)")

func _on_area_2d_area_entered(area):
	text_win_instructions()
