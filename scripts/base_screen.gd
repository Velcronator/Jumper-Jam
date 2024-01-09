extends Control

var tween_time = 0.5

func _ready() -> void:
	visible = false
	modulate.a = 0.0
	# disable all buttons
	get_tree().call_group("buttons", "set_disabled", true)

func appear():
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0 , tween_time)
	return tween


func  disappear():
	get_tree().call_group("buttons", "set_disabled", true)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0 , tween_time)
	return tween
