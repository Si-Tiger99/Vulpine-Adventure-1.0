extends StaticBody2D

@onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("bounce")



func _on_hitbox_area_entered(_area):
	queue_free()
