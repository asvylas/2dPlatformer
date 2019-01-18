extends KinematicBody2D

var motion = Vector2(0, 0)
var friction = false
var inAir = false
var castingMagic = false
var alive = true
var hp = 70

const FIREBALL = preload("../scenes/Fireball.tscn")
const FAST_ATTACK = preload("../scenes/FastAttack.tscn")
const UP = Vector2(0, -1)
const JUMP_HEIGHT = -450
const GRAVITY = 20
const ACCELERATION = 50
const AIR_ACCELERATION = 20
const MAX_SPEED = 170

const IDLE_STATE = 0
const RUNNING_STATE = 1
const JUMP_STATE = 2
const FIREBALL_CAST_STATE = 3 
const DEAD_STATE = 4
const ATTACK_FAST_STATE = 5 

onready var state = Idle.new(self)

func _ready():
	pass

func _process(delta):
	pass
func _physics_process(delta):
	if alive:
		if state is Idle:
			self.friction = true
		motion.y += GRAVITY
		state._update(delta)
		motion = move_and_slide(motion, UP)

		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					self.setState(4)

func setState(new_state):
	state.exit()
	if new_state == RUNNING_STATE:
		state = Running.new(self)
	if new_state == IDLE_STATE:
		state = Idle.new(self)
	if new_state == JUMP_STATE:
		state = Jump.new(self)
	if new_state == FIREBALL_CAST_STATE:
		state = FireballCast.new(self)
	if new_state == DEAD_STATE:
		state = Dead.new(self)
	if new_state == ATTACK_FAST_STATE:
		state = AttackFast.new(self)
func get_state():
	if state is Running:
		return RUNNING_STATE
	elif state is Idle:
		return IDLE_STATE
	elif state is Jump:
		return JUMP_STATE
	elif state is FireballCast:
		return FIREBALL_CAST_STATE
	elif state is Dead:
		return DEAD_STATE
	elif state is AttackFast:
		return ATTACK_FAST_STATE
func _input(event):
	state._input(event)
	pass

# STATES-----------------------------------------------------------------

# RUNNING-----------------------------------------------------------------
class Running:
	var player
	func _init(object):
		self.player = object
		pass
	func _update(delta):
		print("run state")
		if Input.is_action_pressed("ui_right"):
			player.motion.x = min(player.motion.x + player.ACCELERATION, player.MAX_SPEED)
			player.get_node("AnimatedSprite").flip_h = false
			player.get_node("AnimatedSprite").play("run")
			if sign(player.get_node("Position2D").position.x) == -1:
				player.get_node("Position2D").position.x *= -1
		elif Input.is_action_pressed("ui_left"):
			player.motion.x = -max(player.motion.x + player.ACCELERATION, player.MAX_SPEED)
			player.get_node("AnimatedSprite").flip_h = true
			player.get_node("AnimatedSprite").play("run")
			if sign(player.get_node("Position2D").position.x) == 1:
				player.get_node("Position2D").position.x *= -1
		else:
			player.setState(0)
		pass
	func _input(event):
		if Input.is_action_just_pressed("ui_up"):
			player.setState(2)
		if Input.is_action_just_pressed("ui_attack1"):
			player.setState(3)
		if Input.is_action_just_pressed("ui_attackfast"):
			player.setState(5)
		pass

	func exit():
		pass
# IDLE-----------------------------------------------------------------
class Idle:
	var player
	func _init(object):
		self.player = object
		pass
	func _update(delta):
		print("idle state")
		if player.friction == true:
			player.motion.x = lerp(player.motion.x, 0, 0.3)
		player.get_node("AnimatedSprite").play("idle")
		pass
	func _input(event):
		if Input.is_action_pressed("ui_right"):
			player.setState(1)
		if Input.is_action_pressed("ui_left"):
			player.setState(1)
		if Input.is_action_just_pressed("ui_up"):
			player.setState(2)
		if Input.is_action_just_pressed("ui_attack1"):
			player.setState(3)
		if Input.is_action_just_pressed("ui_attackfast"):
			player.setState(5)
		pass
	func exit():
		pass
# JUMP-----------------------------------------------------------------
class Jump:
	var player
	func _init(object):
		self.player = object
		if player.is_on_floor() && !player.inAir:
			player.inAir = true
			player.motion.y = player.JUMP_HEIGHT
		pass
	func _update(delta):
		print("jump state")
		if player.inAir:
			player.get_node("AnimatedSprite").play("jump")
		# AIR MOVEMENT
		if Input.is_action_pressed("ui_right"):
			player.motion.x = min(player.motion.x + player.AIR_ACCELERATION, player.MAX_SPEED/1.2)
			player.get_node("AnimatedSprite").flip_h = false
			if sign(player.get_node("Position2D").position.x) == -1:
				player.get_node("Position2D").position.x *= -1
		elif Input.is_action_pressed("ui_left"):
			player.motion.x = -max(player.motion.x + player.AIR_ACCELERATION, player.MAX_SPEED/1.2)
			player.get_node("AnimatedSprite").flip_h = true
			if sign(player.get_node("Position2D").position.x) == 1:
				player.get_node("Position2D").position.x *= -1
		# IN AIR CHECK FOR STATE RELEASE
		if player.is_on_floor() && !player.inAir:
			player.setState(1)
		if player.is_on_floor():
			player.inAir = false
		
			
	func _input(event):
		pass
	func exit():
		pass
# JUMP-----------------------------------------------------------------
class FireballCast:
	var player
	var fireballCreated = false
	func _init(object):
		self.player = object
		if player.inAir || player.castingMagic:
			player.setState(0)
	func _update(delta):
		print("fireball state")
		player.motion.x = 0
		player.get_node("AnimatedSprite").play("casting")
		if player.get_node("AnimatedSprite").get_frame() == 3 && !fireballCreated:
			fireballCreated = true
			var fireball = player.FIREBALL.instance()
			if sign(player.get_node("Position2D").position.x) == 1:
				fireball.setFireballDirection(1)
			else:
				fireball.setFireballDirection(-1)
			player.get_parent().add_child(fireball)
			fireball.position = player.get_node("Position2D").global_position
		if player.get_node("AnimatedSprite").get_frame() == 6:
			player.setState(1)
		pass
	func _input(event):
		pass
	func exit():
		pass

# DEAD-----------------------------------------------------------------
class Dead:
	var player
	func _init(object):
		self.player = object
	func _update(delta):
		player.hp -= 2
		if player.hp <= 0:
			print("dead")
			player.get_node("AnimatedSprite").play("dead")
			player.motion = Vector2(0, 0)
			player.get_node("CollisionShape2D").disabled = true
			if player.get_node("AnimatedSprite").get_frame() == 4:
				player.queue_free()
				player.get_tree().change_scene("res://scenes/TitleScreen.tscn")
		else:
			player.alive = true
			player.setState(1)
	func _input(event):
		pass
	func exit():
		pass
# ATTACKFAST-----------------------------------------------------------------
class AttackFast:
	var player
	var justAttacked = false
	var fastAttack
	func _init(object):
		self.player = object
	func _update(delta):
		print("AttackFast state")
		player.motion.x = 0
		player.get_node("AnimatedSprite").play("attack_fast")
		if player.get_node("AnimatedSprite").get_frame() == 3 && !justAttacked:
			justAttacked = true
			fastAttack = player.FAST_ATTACK.instance()
			player.get_parent().add_child(fastAttack)
			fastAttack.position = player.get_node("Position2D").global_position
		if player.get_node("AnimatedSprite").get_frame() == 4:
			player.setState(1)
	func _input(event):
		pass
	func exit():
		pass