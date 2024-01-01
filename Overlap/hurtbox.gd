extends Area2D

const HitEffect = preload("res://Effects/hit_effect.tscn")

@onready var timer = $Timer
@onready var collisionShape = $CollisionShape2D

@onready var invincible = false:
	get:
		return invincible
		
	set(value):
		invincible = value
		if invincible == true:
			emit_signal("invincibility_started")
		
		else:
			emit_signal("invincibility_ended")

signal invincibility_started
signal invincibility_ended
	

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position=global_position

#@export var show_hit = true
#func _on_area_entered(_area):
#	if show_hit:
#		var effect = HitEffect.instantiate()
#		var main = get_tree().current_scene
#		main.add_child(effect)
#		effect.global_position=global_position

func _on_timer_timeout():
	self.invincible = false

func _on_invincibility_started():
	#set_deferred("monitoring",false)
	collisionShape.set_deferred("disabled",true)
	

func _on_invincibility_ended():
	#set_deferred("monitoring",true)
	collisionShape.set_deferred("disabled",false)
