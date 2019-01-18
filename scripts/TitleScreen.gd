extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/Button.grab_focus()
	pass

func _process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/Button.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/Button.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/Button2.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/Button2.grab_focus()
	


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/World.tscn")
	pass # replace with function body


func _on_Button2_pressed():
	get_tree().quit()
	pass # replace with function body
