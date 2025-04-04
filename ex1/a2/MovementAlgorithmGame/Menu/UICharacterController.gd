class_name UICharacterController extends MarginContainer

var active_classes : Array[String] = []

var _live_characters : Array[ConcreteSteerableCharacter]

func add_character(character: ConcreteSteerableCharacter):
	_live_characters.append(character)


func active_classes_append(clazz_name : String):
	active_classes.append(clazz_name)
	_update_live_characters()

func active_classes_remove_at(index: int):
	active_classes.remove_at(index)
	_update_live_characters()


func _update_live_characters():
	# if character was deleted by the player null remains in the list
	_live_characters = _live_characters.filter(func(character): return character != null)
	
	for character: ConcreteSteerableCharacter in _live_characters:
		character.set_movement_algorithms_by_name(active_classes)
	

