extends Node

@export var max_health: int = 4:
	get:
		return max_health
	set(value):
		max_health = value
		emit_signal("max_health_changed", max_health)
		self.health = min(health, max_health)

var health = max_health:
	get:
		return health

	set(value):
		health = min(value, max_health)
		emit_signal("health_changed", health)
		#print("Health = ", health)
		if health <= 0:
			emit_signal("no_health")

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func _ready():
	self.health = max_health
