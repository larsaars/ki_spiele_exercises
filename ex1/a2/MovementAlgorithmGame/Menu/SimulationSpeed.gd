extends HSlider


func _on_value_changed(value):
	Engine.time_scale = value
	$"../HBoxContainer/TimeValueLabel".text = "%.2f" % value
