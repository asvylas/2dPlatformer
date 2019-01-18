extends KinematicBody2D

var motion = Vector2(0, 0)
var inAir = false
var jumpOffPoint = 0
var falling = false
var swordDrawn = false
var friction = false
var casting = false
var fireballCreated = false
var isDead = false
var doingAction = false
var attack1 = false

const FIREBALL = preload("../scenes/Fireball.tscn")
const UP = Vector2(0, -1)
const JUMP_HEIGHT = -450
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200

#Phytics process
func _physics_process(delta):
	
	if !isDead:
		self.motion.y += GRAVITY
		# controls()
		if $AnimatedSprite.get_animation() == "casting" && $AnimatedSprite.get_frame() == 3 && !fireballCreated:
			print($AnimatedSprite.get_animation())
			var fireball = FIREBALL.instance()
			if sign($Position2D.position.x) == 1:
				fireball.setFireballDirection(1)
			else:
				fireball.setFireballDirection(-1)
			self.get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
			fireballCreated = true
		if $AnimatedSprite.get_animation() == "attack1" && attack1:
			print("attack frame 2")
			attack1 = false
	else:
		if $AnimatedSprite.get_animation() == "dead" && $AnimatedSprite.get_frame() == 3:
			self.queue_free()
			get_tree().change_scene("res://scenes/TitleScreen.tscn")

#Custom function and signals
func dead():
	self.isDead = true
	$AnimatedSprite.play("dead")
	self.motion = Vector2(0, 0)
	$CollisionShape2D.disabled = true
	pass

func drawSword(value):
	self.swordDrawn = true
	$AnimatedSprite.play("sword-draw")
	pass

func idleState():
	if self.swordDrawn:
		$AnimatedSprite.play("idle-sword")
	else:
		$AnimatedSprite.play("idle")
	self.friction = true

#Controls
func controls():
	#Right
	if Input.is_action_pressed("ui_right"):
		if !self.casting:
			self.motion.x = min(self.motion.x + ACCELERATION, MAX_SPEED)
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("run")
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
	#Left
	elif Input.is_action_pressed("ui_left"):
		if !self.casting:
			self.motion.x = -max(self.motion.x + ACCELERATION, MAX_SPEED)
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("run")
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
	else:
		if casting == false:
			idleState()
			
	#Jumping and inAir
	if self.is_on_floor():
		if self.inAir == true:
			self.casting = false 
		self.inAir = false
		if !self.casting:
			if Input.is_action_just_pressed("ui_up"):
				self.motion.y = JUMP_HEIGHT
			if friction == true:
				self.motion.x = lerp(motion.x, 0, 0.2)
	else:
		self.inAir = true
		if jumpOffPoint - JUMP_HEIGHT < self.motion.y:
			$AnimatedSprite.play("falling")
		elif motion.y < 0:
			$AnimatedSprite.play("jump")
			self.jumpOffPoint = self.motion.y
		else:
			$AnimatedSprite.play("fall")
		if friction == true:
			self.motion.x = lerp(motion.x, 0, 0.05)
	#Actions Attack1
	if Input.is_action_just_pressed("ui_attack1") && self.attack1 == false && self.inAir == false:
		if is_on_floor():
			motion.x = 0
		print("asd")
		self.attack1 = true
		$AnimatedSprite.play("attack1")
	#Actions FIREBALL
	if Input.is_action_just_pressed("ui_focus_next") && self.casting == false && self.inAir == false:
		if is_on_floor():
			motion.x = 0
		self.casting = true
		self.doingAction = true
		$AnimatedSprite.play("casting")
	#Action DRAW SWORD
	if Input.is_action_just_pressed("ui_draw_sword") && self.casting == false && self.inAir == false:
		if is_on_floor():
			motion.x = 0
			self.casting = true
			if !self.swordDrawn:
				$AnimatedSprite.play("sword-draw")
				self.swordDrawn = true
			else:
				$AnimatedSprite.play("sword-sheat")
				self.swordDrawn = false
		
	motion = self.move_and_slide(motion, UP)
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if "Enemy" in get_slide_collision(i).collider.name:
				self.dead()

#Signals
func _on_AnimatedSprite_animation_finished():
	self.casting = false
	self.fireballCreated = false