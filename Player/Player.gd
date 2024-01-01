extends CharacterBody2D

# To comment multiple lines, highlight them and use ctrl+K to toggle comments
@export var MAX_SPEED = 80
@export var ACCELERATION = 400
@export var FRICTION = 500
@export var ROLL_SPEED = MAX_SPEED * 1.5
@export var ROLL_SKID = 0.0

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_vector = Vector2.DOWN
var stats = PlayerStats

const PlayerHurtSound = preload("res://Player/player_hurt_sound.tscn")

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var hurtBox = $Hurtbox
@onready var animationState = animationTree.get("parameters/playback")
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
@onready var textBox = get_tree().current_scene.get_node("TextBox")
	# ctrl click and drag from Scenetree
	# shorthand for 
		#var animationPlayer = null
		#func _ready():
		#	animationPlayer = $AnimationPlayer

func _ready():
	#randomize()
		#changes seed for game, so same "random" things don't haappen every time.
		#leave off for testing to get same results
	#print("hello world")
	PlayerStats.health = PlayerStats.max_health
	self.stats.connect("no_health", text_box_death_instructions)
	animationTree.active = true
	text_box_instructions()


#Velocity is a built in property now so the below definition isn't needed
	#var velocity = Vector2.ZERO
# Character Movement
# "delta" is a variable and is time since last frame processed, `1/60 of a second
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
		# Basically a cleaner if... elif... else statements
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
		# "normalized" takes any vector and makes it have a unit of 1 in the same direction
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
#			Instead of:
#			velocity += (input_vector*ACCELERATION)*delta
#				# += increases variable by ammount each frame
#			velocity = velocity.limit_length(MAX_SPEED)
#				#multiplying velocity times delta sets our movement relative to the frame rate, lower frame rate, faster speed	
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	
	set_motion_mode(CharacterBody2D.MOTION_MODE_FLOATING)
	move()
	
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	if Input.is_key_pressed(KEY_ENTER):
		get_tree().reload_current_scene()
	#Use above instead of defining each direction with if statements like so:
	#func _physics_process(delta):
	#	if Input.is_action_pressed("ui_right"):
	#		velocity.x = 4
	#	elif Input.is_action_pressed("ui_left"):
	#		velocity.x = -4
	#	elif Input.is_action_pressed("ui_up"):
	#		velocity.y = -4
	#	elif Input.is_action_pressed("ui_down"):
	#		velocity.y = 4
	#	else:
	#		velocity.x = 0
	#		velocity.y = 0

func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED * (1-ROLL_SKID)
	#ROLL_SKID is changed in the animation, 0 for full speed, .5 after landing
	animationState.travel("Roll")
	move()

func attack_state(delta):
	animationState.travel("Attack")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	move()

func move():
	move_and_slide() #handles delta in physics engine
	
func roll_animation_finished():
	#velocity = roll_vector * MAX_SPEED * .5
	#if velocity = Vector2.ZERO:
	state = MOVE

func attack_animation_finished():
	state = MOVE

func text_box_instructions():
	print(textBox)
	textBox.queue_text("Welcome Adventurer!\n(Press \"J\" or \"X\")")
	textBox.queue_text("The Night is falling...\nOur Hero must make camp soon...")
	textBox.queue_text("Find safe place to rest.")
	textBox.queue_text("  W \nA S D or arrow keys to move")
	textBox.queue_text("Press \"J\" or \"X\" to Attack\nPress \"K\" or \"Z\" to Roll")
	textBox.queue_text("Press \"C\" to clear or skip instructions next time")

func text_box_death_instructions():
	textBox.queue_text("Our brave hero falls... \n Overwhelmed by swarms of bats...")
	textBox.queue_text("He will succeed yet.")
	textBox.queue_text("Press ENTER to try again")
	queue_free()
	

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtBox.start_invincibility(0.5)
	hurtBox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instantiate()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")
	
func _on_hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
