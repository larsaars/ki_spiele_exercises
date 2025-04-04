extends CheckButton

func _on_toggled(toggled_on):
	if toggled_on:
		GlobalMovementAlgorithm.showVisualisation = true
	else:
		GlobalMovementAlgorithm.showVisualisation = false
