## Extends [MovementGameCharacter] to implement steerable behavior for characters.
##
## This class enhances [MovementGameCharacter] by combining multiple [SteeringBehavior]s through
## [MovementAlgorithm]s. It allows characters to autonomously navigate the game world
## by combining multiple [SteeringBehavior]s to achieve more complex movement patterns. 
## Each movement algorithm is contributing the same amount to the resulting steering behavior
class_name SteerableCharacter extends MovementGameCharacter

## Specifies whether to use a kinematic update method for movement. When true, the linear and angular
## attributes of the [SteeringBehavior] are interpreted as desired velocities, and the movement is updated
## by using [method MovementGameCharacter.kinematic_update]. [br]
## When false (default), the linear and angular attributes are interpreted as accelerations, and the
## [method MovementGameCharacter.movement_physics_update] method is used for updating.
var _use_kinematic_update: bool = false

## Stores an [Array] of [MovementAlgorithm] instances that dictate the character's steering behavior.
var movementAlgorithms: Array[MovementAlgorithm]


## Called when the node is ready. It initializes movement algorithms and sets up
## all [SteeringBehavior]s
func _ready():
	# Calls the parent class's method to ensure any necessary initialization is performed.
	super()
	# Prepares the movement algorithms for use.
	_ready_movement_algorithms()


## Initializes the [MovementAlgorithm]s by injecting dependencies such as the character itself,
## the player as a target, and the [GeometryVisualizer2D]
func _ready_movement_algorithms():
	# Inject dependencies into all movement algorithms.
	for movementAlgorithm in movementAlgorithms:
		movementAlgorithm.set_character(self as MovementGameCharacter)
		movementAlgorithm.set_target(get_tree().get_first_node_in_group("Player"))
		movementAlgorithm.set_geometryVisualizer2D(_get_geometryVisualizer2D())


## Sets the [MovementAlgorithm]s for the character and initializes them. This function
## takes [param movementAlgorithms], an [Array] of [MovementAlgorithm] instances to be used by the character,
## and prepares them to be usable
func set_movement_algorithms(movementAlgorithms: Array[MovementAlgorithm]):
	self.movementAlgorithms = movementAlgorithms
	_ready_movement_algorithms()


## Switches the character's movement update method to kinematic. In kinematic mode, linear and angular
## velocities from [SteeringBehavior] are directly applied as desired velocities, providing smoother transitions
## without considering acceleration.
func use_kinematic_update():
	_use_kinematic_update = true

## Switches the character's movement update method to physics-based. In this mode, linear and angular
## velocities from [SteeringBehavior] are treated as accelerations, utilizing the [method MovementGameCharacter.movement_physics_update]
## for movement updates.
func use_movement_physics_update():
	_use_kinematic_update = false


## Overrides the [method MovementGameCharacter._physics_process] method to aggregate steering behaviors from all
## [MovementAlgorithm]s and apply the combined effect to the character's movement by calling  [method MovementGameCharacter.movement_physics_update]
## This process uses [param delta], the time elapsed since the last frame, for frame-independent updates.
func _physics_process(delta):
	# Aggregate the steering behavior from all algorithms.
	var steering_behaviour = SteeringBehavior.new()
	
	for movementAlgorithm in movementAlgorithms:
		var current_steering_behavior = movementAlgorithm.get_steering(delta)
		if _use_kinematic_update:
			steering_behaviour.disableLimitation()
		steering_behaviour.add(current_steering_behavior)
	
	# Update the character's movement physics with the combined steering behavior.
	if _use_kinematic_update:
		kinematic_update(steering_behaviour, delta)
	else:
		movement_physics_update(steering_behaviour, delta)

## Reference the [GeometryVisualizer2D] used as visualization interface
var geometryVisualizer2D: GeometryVisualizer2D

## Returns the [GeometryVisualizer2D] instance used as visualization interface. If not found, it throws an error
func _get_geometryVisualizer2D() -> GeometryVisualizer2D:
	# Retrieves the GeometryVisualizer2D reference.
	if geometryVisualizer2D == null:
		geometryVisualizer2D = get_tree().get_first_node_in_group("geometryVisualizer2D")
		if geometryVisualizer2D == null:
			push_error("error: no drawing node exists in the scene")
			return null
	return geometryVisualizer2D
