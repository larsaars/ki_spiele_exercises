extends Button

var counter : int = 0 #default is 0 because one is naturally in the scene with index 0

var textureList : Array[Texture2D] = []

func _ready():
	var dir = DirAccess.open("res://assets/characters/")
	var spaceshipList : Array[String] = []
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.match("Spaceship*png"):
					spaceshipList.append(dir.get_current_dir() + "/" + file_name)
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	
	for path in spaceshipList:
		textureList.append(load(path))


func _on_button_down():
	counter += 1
	if counter >= textureList.size(): counter = 0
	var newSelectableAlgorithm = load("res://MovementAlgorithmGame/Menu/selectable_algorithm_element.tscn").instantiate()
	var menuItemList = get_tree().get_first_node_in_group("MenuItemList")
	
	menuItemList.add_child(newSelectableAlgorithm)
	newSelectableAlgorithm.get_child(0).get_child(0).get_child(0).icon = textureList[counter]
