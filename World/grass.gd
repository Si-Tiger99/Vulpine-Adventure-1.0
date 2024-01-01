extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	if Input.is_action_just_pressed("Attack"):
#		var GrassEffect = load("res://Effects/grasseffect.tscn")
#		var grassEffect = GrassEffect.instantiate()
#		var world = get_tree().current_scene
#		world.add_child(grassEffect)
#		grassEffect.global_position = global_position
#		queue_free()

const GrassEffect = preload("res://Effects/grass_effect.tscn")
const Heart = preload("res://Items/heart.tscn")

func create_grass_effect():
	var grassEffect = GrassEffect.instantiate()
	get_parent().add_child(grassEffect)
		#Instead of:
	#		var world = get_tree().current_scene
	#		world.add_child(grassEffect)
	grassEffect.global_position = global_position
	

func _on_hurtbox_area_entered(_area):
	create_grass_effect()
	if randi_range(1,8) == 8:
		var heart = Heart.instantiate()
		get_parent().add_child(heart)
		heart.global_position = global_position
	queue_free()
