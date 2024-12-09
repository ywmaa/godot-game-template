extends Node
class_name Main

@export var gui : CanvasLayer
@export var world_2d : Node2D
@export var world_3d : Node3D


func _ready() -> void:
	## assign main script (this) to global script for easy access across the whole game
	Global.main = self
