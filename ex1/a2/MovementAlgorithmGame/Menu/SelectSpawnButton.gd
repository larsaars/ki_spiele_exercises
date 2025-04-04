extends Button

var controller : UICharacterController

func _ready():
	controller = get_parent().get_parent().get_parent()

func _on_button_down():
	var canvasLayer = get_tree().get_first_node_in_group("myCanvasLayer")
	var character : ConcreteSteerableCharacter = load("res://MovementAlgorithmGame/ConcreteSteerableCharacter.tscn").instantiate()
	
	controller.add_character(character)
	
	var new_draggable_parent : DraggingObject = preload("res://MovementAlgorithmGame/draggingNode.tscn").instantiate()
	
	new_draggable_parent.add_child(character)
	
	new_draggable_parent.global_position = get_global_mouse_position()
	canvasLayer.add_child(new_draggable_parent)
	
	var algorithm_name_list : Array[String] = controller.active_classes
	character.set_movement_algorithms_by_name(algorithm_name_list)
	character.get_child(0).texture = icon
	
	new_draggable_parent.start_dragging()
