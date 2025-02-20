@tool
extends Node2D

func _process(delta):
	material.set_shader_parameter("mouse_position",get_global_mouse_position())
	material.set_shader_parameter("sprite_position",global_position)
