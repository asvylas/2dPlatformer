extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var state = Idle.new(self)
var motion = Vector2()

const STATE_RUNNING	= 0
const STATE_IDLE	= 1
const STATE_JUMPING = 2	

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
func _fixed_process(delta):
	pass
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		self.setState(0)
	if Input.is_action_pressed("ui_down"):
		self.setState(1)
	state.update(self, delta)
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func setState(new_state):
	state.exit()
	if new_state == STATE_RUNNING:
		state = Running.new(self)
	if new_state == STATE_IDLE:
		state = Idle.new(self)
	if new_state == STATE_JUMPING:
		state = Jumping.new(self)
func get_state():
	if state is Running:
		return STATE_RUNNING
	elif state is Idle:
		return STATE_IDLE
	elif state is Jumping:
		return STATE_JUMPING
	pass






# IDLE CLASSS -----------------------------------
class Idle:
	const FLOOR = Vector2(0,-1)
	var SPEED = 30
	var direction = 1
	var enemy = null
	func _init(enemy):
		self.enemy = enemy
		pass
	func update(object, delta):
		print("I'm in idle state")
		pass
	func input(event):
		pass
	func exit():
		pass
# Jumping CLASSS -----------------------------------
class Jumping:
	func _init():
		pass
	func update(delta):
		pass
	func input(event):
		pass
	func exit():
		pass
# Running CLASSS -----------------------------------
class Running:
	const FLOOR = Vector2(0,-1)
	var SPEED = 30
	var direction = 1
	var enemy = null
	func _init(enemy):
		self.enemy = enemy
		pass
	func update(object, delta):
		print("I'm in running state")
		if object.position.x > 960 - 32:
			object.motion.x = -1
		elif object.position.x < 0 + 32:
			object.motion.x = 1
		else:
			object.motion.x = 1
		print(object.motion.x)

		object.motion.x = object.motion.x * SPEED
		object.motion = object.move_and_slide(object.motion, FLOOR)
		pass
	func input(event):
		pass
	func exit():
		pass