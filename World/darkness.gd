extends Node2D

@onready var colorRect = $ColorRect
@onready var darknessSprite = $DarknessSprite
#
var TW = 0
# Called when the node enters the scene tree for the first time.
func _ready():
#	print(colorRect.color.a)
	colorRect.color.a = 0
	darknessSprite.self_modulate.a=0
#	print(colorRect.color)
#	print(darknessSprite.self_modulate)
	darken(5*60)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func darken(time):
	TW= create_tween()
	TW.tween_property(colorRect, "color:a",.625, time*.625)#.set_trans(Tween.TRANS_LINEAR)
	TW.tween_property(darknessSprite, "self_modulate:a",1, time*.375)
#	TW.tween_callback(print.bind("dark?")) doesn't work?
