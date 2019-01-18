extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const GRAVITY = 60
export(int) var SPEED = 30
const FLOOR = Vector2(0,-1)
export(int) var hp = 4

var motion = Vector2()
var direction = 1
var isDead = false
var staggered = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$TextureProgress.max_value = hp
	pass

func dead():
	staggered = true
	hp -= 1
	if hp <= 0:
		isDead = true
		motion = Vector2(0,0)
		$AnimatedSprite.play("dead")
		$CollisionShape2D.disabled = true
		$Timer.start()

func _process(delta):
	$ProgressBar.value = hp
	$TextureProgress.value = hp
				

	if !isDead:
		motion.x = SPEED * direction
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("moving")
		

		motion.y += GRAVITY
		
		if staggered:
			self.motion.y = -300
			staggered = false
		motion = move_and_slide(motion, FLOOR)

		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Player" in get_slide_collision(i).collider.name:
					get_slide_collision(i).collider.setState(4)


		if is_on_wall():
			direction = direction * -1
			$AnimatedSprite.flip_h = true
			$RayCast2D.position.x *= -1
		
		if $RayCast2D.is_colliding() == false:
			direction = direction * -1
			$RayCast2D.position.x *= -1
	else:
		if $AnimatedSprite.get_animation() == "dead" && $AnimatedSprite.get_frame() == 14:
			$AnimatedSprite.play("deadd")
			pass
		pass
	
func _on_Timer_timeout():
	self.queue_free()
	pass # replace with function body
