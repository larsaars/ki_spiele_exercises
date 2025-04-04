## This class acts as a temporary parent for nodes being dragged.
##
## It extends `Node2D` and is used to temporarily reparent a draggable object during the drag operation,
## handling the dragging logic and visual feedback. The class allows for objects to be moved with mouse input,
## providing a seamless user experience by dynamically updating object positions based on mouse movement.
## Once the drag operation is complete, the object is reparented back to its original or designated parent.
class_name DraggingObject extends Node2D

## Indicates if the node is currently able to be dragged.
var draggable = true

## Tracks the dragging state of the node.
var isDragging = true

## Stores the offset between the node's position and the mouse position.
## This is used to maintain the correct relative position while dragging.
var offset: Vector2

## Reference to an `Area2D` node, if used for additional input detection.
var area2D: Area2D

## The name of the node, used for identification or debugging purposes.
var nodeName: String

## Initiates the dragging process for the child node of this `DraggingObject`.
## It deactivates the child node's processing to pause any of its ongoing actions.
func start_dragging():
	var child = get_child(0)
	# Deactivate the child's processes to pause its actions.
	child.set_process(false)
	child.set_physics_process(false)

## The process loop updates the position of the `DraggingObject` during dragging.
## It starts and stops dragging based on mouse click actions and moves the node accordingly.
func _process(delta):
	if draggable:
		# on start of dragging
		if Input.is_action_just_pressed("click"):
			# save offset
			offset = get_global_mouse_position() - global_position
			isDragging = true
		# while dragging
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		# on end of dragging
		elif Input.is_action_just_released("click"):
			isDragging = false
			# get scene and child
			var scene = get_tree().get_first_node_in_group("scene")
			var child : Node2D = get_child(0)
			if child == null:
				print("error: dragNode has no child")
				return
			
			# Reparent the dragged object back to the scene, maintaining its global position.
			get_parent().remove_child(self)
			scene.add_child(self)
			
			position = get_global_mouse_position()
			var offset = position
			self.remove_child(child)
			scene.add_child(child)
			child.position = offset
			
			# Reactivate the child's processes and finalize the dragging operation.
			child.stop_dragging()
			child.set_process(true)
			child.set_physics_process(true)
			
			# Cleanup by freeing this temporary dragging node.
			self.queue_free()

## Provides visual feedback by slightly enlarging the node when the mouse enters its area,
## indicating that it's ready to be dragged.
func _on_area2D_mouse_entered():
	if not isDragging:
		scale = Vector2(1.05, 1.05)
		draggable = true

## Restores the node's scale when the mouse exits its area, indicating that it's no longer
## in the ready-to-drag state.
func _on_area2D_mouse_exited():
	if not isDragging:
		scale = Vector2(1, 1)
		draggable = false
