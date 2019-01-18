extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var motion = Vector2()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Timer.start()
	pass

func _process(delta):
	self.translate(motion)
	pass

func _on_FastAttack_body_entered(body):
	if "Enemy" in body.name:
		body.dead()
		
	pass # replace with function body
	

func _on_Timer_timeout():
	self.queue_free()
	pass # replace with function body
