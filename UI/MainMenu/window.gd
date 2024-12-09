extends Window


func _init():
	close_requested.connect(func(): queue_free())


func _process(_delta: float) -> void:
	position = Vector2.ZERO
	size = get_parent().size
