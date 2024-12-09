extends Button


func _ready() -> void:
	connect("pressed", func(): var window = owner.get_parent(); if window is Window: window.close_requested.emit())
