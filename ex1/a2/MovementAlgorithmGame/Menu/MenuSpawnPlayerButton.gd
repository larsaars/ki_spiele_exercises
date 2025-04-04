extends Button

@export var NodeName : String = "seek"

func _ready():
	var label := Label.new()
	label.add_theme_font_size_override("font_size", 16)
	label.text = NodeName
	get_parent().add_child.call_deferred(label)

func _on_button_down():
	var canvasLayer = get_tree().get_first_node_in_group("myCanvasLayer")
	var character : Node2D = load("res://MovementAlgorithmGame/Characters/" + NodeName.to_lower() + ".tscn").instantiate()
	
	var new_draggable_parent : DraggingObject = preload("res://MovementAlgorithmGame/draggingNode.tscn").instantiate()
	
	new_draggable_parent.add_child(character)
	
	new_draggable_parent.global_position = get_global_mouse_position()
	canvasLayer.add_child(new_draggable_parent)
	
	new_draggable_parent.start_dragging()

