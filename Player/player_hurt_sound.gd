extends AudioStreamPlayer

func _ready():
	self.finished.connect(queue_free)
#	pass

func _on_finished():
	#queue_free()
	pass
