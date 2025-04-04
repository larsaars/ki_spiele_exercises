extends Area2D

var delete = false
var latestBody: Node2D

func _on_body_entered(body):
	delete = true
	latestBody = body


func _on_body_exited(body):
	delete = false

func _process(delta):
	if delete && Input.is_action_just_released("click"):
		print("Node " + latestBody.name + " queued for delete")
		latestBody.queue_free()
		

func _on_button_button_down():
	if get_tree() == null:
		return
	var allCharacters: Array[Node] = get_tree().get_nodes_in_group("NPC")
	for character in allCharacters:
		character.queue_free()
	
