extends MenuButton

var textureList : Array[Texture2D] = []
var activeTexture : Texture2D = null

# Called when the node enters the scene tree for the first time.
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
	
	var i : int = 0
	for texture in textureList:
		get_popup().add_icon_radio_check_item(texture, "", i)
		get_popup().set_item_icon_max_width(i, 64)
		i += 1
	
	on_id_pressed(0)
	
	get_popup().connect("id_pressed", on_id_pressed)

func on_id_pressed(id):
	for i in range(get_popup().item_count):
		get_popup().set_item_checked(i, false)
	get_popup().set_item_checked(id, true)
	
	activeTexture = textureList[id]
	
	$"../Button".icon = activeTexture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

