## Extends [SteerableCharacter] to dynamically load and apply movement algorithms by name.
##
## This class allows for the dynamic configuration of [SteerableCharacter]'s movement algorithms through
## external inputs, such as editor properties or runtime assignment. It leverages the Godot
## project settings to map algorithm names to script paths, enabling the instantiation and application
## of [MovementAlgorithm] instances by name. [MovementAlgorithm]s can be easily switched out and so it can 
## be experimented with different movement behaviors without hardcoding script paths or modifying 
## the character's source code directly.
class_name ConcreteSteerableCharacter extends SteerableCharacter

## A list of movement algorithm names intended for dynamic loading. These names should correspond
## to the class_name of the algorithms class which also needs to inherit [MovementAlgorithm].
## This property can be set in the Godot editor or through scripts to easily modify the character's behavior.
## Remember to use [method set_movement_algorithms_by_name] to set the scripts so that they get loaded correctly 
@export var movementAlgorithmNames : Array[String] = []

## Called when the node is ready. It performs initial setup by calling [method ConcreteSteerableCharacter._ready] method
## and loading the movement algorithms specified by their names.
func _ready():
	super()
	_load_algorithms()

## Sets the movement algorithms by their names and reloads the algorithms. This method allows for runtime
## changes to the character's behavior by specifying a new list of algorithm names.
## [param movementAlgorithms] is an [Array] of [String] containing the names of the movement algorithms to be loaded.
func set_movement_algorithms_by_name(movementAlgorithms: Array[String]):
	self.movementAlgorithmNames = movementAlgorithms
	_load_algorithms()

## Loads and instantiates the movement algorithms based on the names provided in [member movementAlgorithmNames].
## This method utilizes the project settings to map the algorithm names to their respective script paths,
## enabling dynamic instantiation.
func _load_algorithms():
	# Fills dictionary with class name as key and path as value
	var classPathDictionary : Dictionary = {}
	for clazz in ProjectSettings.get_global_class_list():
		classPathDictionary[str(clazz["class"])] = clazz["path"]
	
	# Goes through movement algorithm names and loads MovementAlgorithm script by path if found.
	# Fills movementAlgorithms list with the MovementAlgorithms
	var movementAlgorithms : Array[MovementAlgorithm] = []
	for movementAlgorithmName in movementAlgorithmNames:
		var classPath = classPathDictionary.get(str(movementAlgorithmName))
		if classPath == null:
			continue
		
		var movementAlgorithm : MovementAlgorithm = load(classPath).new()
		movementAlgorithms.append(movementAlgorithm)
	
	# Dependency injection of movement algorithms
	super.set_movement_algorithms(movementAlgorithms)
