## This class can be used to make an object draggable
##
## It extends [CharacterBody2D] to provide physics-based drag-and-drop functionality, enhancing user interaction
## by allowing objects to be moved around with the mouse. The class utilizes an [Area2D] node for mouse hover
## detection. This is combined with a scale increase on hover.
class_name DraggableObject extends CharacterBody2D

## Indicates whether the object is draggable. 
## It is active by default and can be turned of with the method [method DraggableObject.deactivate_dragging] 
var _draggable = true

## The [Area2D] node used for mouse hover detection.
## Remember to have an [Area2D] node with the group "Area2D" attached as a child
var _area2D: Area2D

## Called when the node is ready. It sets up the object to be draggable. 
## Remember to call super() when inheriting and overwriting _ready() yourself
func _ready():
	activate_dragging()

## Enables the object to be draggable by making it input-pickable and connecting
## necessary signals for dragging and hover highlighting functionality.
func activate_dragging():
	_draggable = true
	self.input_pickable = true
	# connect event listeners for visual feedback of draggable
	self.connect("input_event", _on_collision_object_2d_input_event)
	_area2D = get_node("Area2D")
	if _area2D:
		_area2D.connect("mouse_entered", _on_area_2d_mouse_entered)
		_area2D.connect("mouse_exited", _on_area_2d_mouse_exited)

## Disables the object's ability to be dragged by making it non-input-pickable and disconnecting
## dragging-related signals.
func deactivate_dragging():
	self.input_pickable = false
	_draggable = false
	# disconnect event listeners
	self.disconnect("input_event", _on_collision_object_2d_input_event)
	if _area2D:
		_area2D.disconnect("mouse_entered", _on_area_2d_mouse_entered)
		_area2D.disconnect("mouse_exited", _on_area_2d_mouse_exited)

## Initiates the dragging process for the object by changing its parent to a new [DraggingObject].
func _start_dragging(position: Vector2):
	#create new parent node and make it a child of the canvas layer
	var new_draggable_parent: DraggingObject = preload("res://MovementAlgorithmGame/draggingNode.tscn").instantiate()
	var sceneRoute = get_tree().get_first_node_in_group("myCanvasLayer")
	sceneRoute.add_child(new_draggable_parent)
	
	# set position correctly
	new_draggable_parent.global_position = position
	
	# rearrange parent
	get_parent().remove_child(self)
	new_draggable_parent.add_child(self)
	self.position = Vector2.ZERO
	
	# start the dragging process
	new_draggable_parent.start_dragging()

## Marks the dragging process as stopped.
func stop_dragging():
	GlobalMovementAlgorithm.oneDragging = false

## Provides visual feedback by enlarging the object when the mouse enters its area.
func _on_area_2d_mouse_entered():
	scale = Vector2(1.10, 1.10)

## Reverts the object's scale when the mouse exits its area.
func _on_area_2d_mouse_exited():
	scale = Vector2(1, 1)

## Handles mouse input events on the object, starting the drag process upon a
## left mouse button press if the object is draggable and not already dragging.
## Takes [viewport] as the viewport where the input event was detected, [event] as the
## input event itself, which contains details about the mouse input, and [shape_idx] as
## the index of the collision shape in the object that received the event.
func _on_collision_object_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	# check for the right event, then start dragging
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if _draggable and not GlobalMovementAlgorithm.oneDragging:
				GlobalMovementAlgorithm.oneDragging = true
				_start_dragging(event.position)
