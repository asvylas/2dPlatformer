extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const SPEED = 300
var motion = Vector2()
var direction = 1
 
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func setFireballDirection(dir):
	self.direction = dir
	if dir == -1:
		self.set_rotation(90 * PI/180)

func _process(delta):
	self.motion.x = SPEED * delta * direction
	self.translate(motion)
	$AnimatedSprite.play("flying")
	pass

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
	pass # replace with function body


func _on_Fireball_body_entered(body):
	if "Enemy" in body.name:
		body.dead()
	self.queue_free()
	pass # replace with function body
