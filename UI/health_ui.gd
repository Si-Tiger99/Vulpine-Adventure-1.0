extends Control

@onready var heartUIFull = $HeartUIFull
@onready var heartUIEmpty = $HeartUIEmpty
@onready var batCounter = $BatCounter
@onready var bats = get_tree().current_scene.get_child(9).get_child_count()

var max_hearts = 3:
	get:
		return max_hearts
	set(value):
		max_hearts = max(value,1)
		self.hearts = min(hearts, max_hearts)
		if heartUIEmpty != null:
			heartUIEmpty.set_size(Vector2(max_hearts * 15,11))
		
var hearts = max_hearts: 
	get:
		return hearts
	set(value):
		hearts = clamp(value, 0, max_hearts)
		if heartUIFull != null:
			heartUIFull.set_size(Vector2(hearts * 15,11))
#		if label != null:
#			label.txt = "HP = " + str(hearts)



func _set_hearts(value):
	hearts = value

func _set_max_hearts(value):
	max_hearts = value

func _ready():
	self.max_hearts = PlayerStats.max_health
	hearts = PlayerStats.health
	#print("playerstats.health = ", PlayerStats.health)
	PlayerStats.health_changed.connect(_set_hearts)
	PlayerStats.max_health_changed.connect(_set_max_hearts)
	#PlayerStats.health_changed.connect(_print_hearts)
	#set("max_hearts",5)
	#set("hearts",5)
	#print("Max Hearts = ", max_hearts)
	#_print_hearts()
	batCounter.text = "Bats: " + str(bats)
	

func _process(_delta):
	pass
	

func _print_hearts():
	print("hearts= ",hearts)
	

func _on_bat_enemy_died():
	bats -= 1
	batCounter.text = "Bats: " + str(bats)


func _on_enemies_child_exiting_tree(node):
	if node.has_node("Stats"):
		bats -= 1
		batCounter.text = "Bats: " + str(bats)


#func _on_enemies_child_entered_tree(node):
#	var bats = 0
#	bats = bats + 1
#	print(bats)
#	batCounter.text = "Bats: " + str(bats)
