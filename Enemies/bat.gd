extends CharacterBody2D

var knockbackDirection = Vector2.ZERO
const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")
@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 500
@export var WANDER_TARGET_RANGE = 4


enum {
	IDLE,
	WANDER,
	CHASE,
}

var state = IDLE

@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var sprite = $AnimatedSprite
@onready var hurtBox = $Hurtbox
@onready var softCollision = $SoftCollision
@onready var wanderController = $WanderController
@onready var animationPlayer = $AnimationPlayer

func _ready():
	randomize()
	sprite.frame = randf_range(0,sprite.sprite_frames.get_frame_count("Fly")-1)
	state = pick_random_state([IDLE, WANDER])
#	print(stats.max_health)
#	print(stats.health)

func _physics_process(delta):
		
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(randf_range(1, 3))
			
		WANDER:
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(randf_range(1, 3))
			accellerate_towards(wanderController.target_position, delta)
			
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(randf_range(1, 3))
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accellerate_towards(player.global_position, delta)
				#var direction = (player.global_position - global_position).normalized()
			else:
				state = IDLE
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector()* delta *400
	move_and_slide()

func accellerate_towards(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
		#Call Down, Signal Up
		#use above instead of:
		#if health <= 0:
			#queue_free()
	knockbackDirection = (position - area.owner.position).normalized()
	velocity = knockbackDirection * 150
	hurtBox.start_invincibility(0.4)
	hurtBox.create_hit_effect()

func _on_stats_no_health():
	await get_tree().create_timer(0.3).timeout
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position	
	emit_signal("enemyDied")

func _on_hurtbox_invincibility_started():
	animationPlayer.play("Start")

func _on_hurtbox_invincibility_ended():
	animationPlayer.play("Stop")

signal enemyDied
