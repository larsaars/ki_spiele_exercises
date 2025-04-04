extends MenuButton

var controller : UICharacterController

var initialText = text

# Initializes dropdown menu
# sets initial text 
# gets movement algorithms 
func _ready():
	controller = get_parent().get_parent()
	
	self.set_text(initialText)
	
	get_popup().hide_on_checkable_item_selection = false
	get_popup().allow_search = false
	
	var classList : Array[Dictionary] = ProjectSettings.get_global_class_list()
	
	add_all_movement_algorithms(classList, ["MovementAlgorithm"])
	get_popup().connect("id_pressed", on_id_pressed)
	
	get_popup().connect("mouse_exited", func(): get_popup().hide())
	


# adds all valid classes to popup menu
func add_all_movement_algorithms(classList, validClassNames: Array[String]):
	
	var newValidClassNames : Array[String] = []
	
	for classEntry in classList:
		var name : String = classEntry["class"]
		if validClassNames.find(classEntry["base"]) != -1:
			newValidClassNames.append(name)
			name = name.get_slice("\"", 1)
			get_popup().add_check_item(name)
	
	if newValidClassNames.size() != 0:
		add_all_movement_algorithms(classList, newValidClassNames)


# when item is clicked
func on_id_pressed(id):
	
	# switches check mark
	var checked: bool = get_popup().is_item_checked(id)
	get_popup().set_item_checked(id, not checked)
	checked = not checked
	
	# gets current text of the character and clicked algorithm name
	var name = get_popup().get_item_text(id)
	var current_text = self.get_text()
	
	# if algorithm was enabled 
	if checked:
		controller.active_classes_append(name)
		var new_text = ""
		if controller.active_classes.size() == 1:
			new_text = name
		else:
			new_text = current_text + ",\n" + name
		self.set_text(new_text)
	
	# if algorithm was disabled
	else:
		controller.active_classes_remove_at(controller.active_classes.find(name))
		var new_text = ""
		var nameArray = current_text.split(",\n")
		if nameArray.size() == 1:
			new_text = initialText
		else:
			for nameInArray in nameArray:
				if name != nameInArray:
					new_text += nameInArray + ",\n"
			new_text = new_text.erase(new_text.length()-2, 2)
		self.set_text(new_text)
	



