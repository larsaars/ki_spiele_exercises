## The base class for movement algorithms in a game, designed to be extended for implementing
## specific steering behaviors. It also provides a default implementation.
##
## This class serves as a template for creating custom movement algorithms by overriding the
## [method get_steering] method. It includes methods for setting the character and target, which
## the algorithm will use to compute steering behaviors. These member variables are usually 
## injected by the [SteerableCharacter] using the [MovementAlgorithm]. Additionally, it provides 
## the reference to the drawing node which is also injected, which can be used as visualization interface.
## It also provides a reference to [MoveMovementUtils] which provides static utility methods for movement algorithms.
class_name MovementAlgorithm extends RefCounted

## Preloaded [MovementUtils] script, providing utility functions that can be used by the movement algorithms.
const MovementUtils = preload("res://MovementAlgorithmGame/MovementUtils.gd")

## The character that the movement algorithm is controlling. This should be an instance of [MovementGameCharacter]
## or any of its subclasses. This dependency is usually injected by the [SteerableCharacter].
var character: MovementGameCharacter

## The target that the movement algorithm aims to move towards or away from. This is also expected to be
## an instance of [MovementGameCharacter] or any of its subclasses. This dependency is usually injected by the [SteerableCharacter].
var target: MovementGameCharacter

## The [GeometryVisualizer2D] used for visualizing the steering behavior or other relevant information.
## This is particularly useful for debugging or visually understanding the algorithm's steering behavior
## This dependency is usually injected by the [SteerableCharacter].
var geometryVisualizer2D : GeometryVisualizer2D = null

## Sets the character that this movement algorithm will control.
## [param character] The character to be controlled, must be an instance of [MovementGameCharacter].
func set_character(character: MovementGameCharacter) -> void:
	self.character = character

## Sets the target for the movement algorithm. The algorithm will use this target to determine how to
## steer the controlled character.
## [param target] The target object, which should be an instance of [MovementGameCharacter].
func set_target(target: MovementGameCharacter) -> void:
	self.target = target

## Assigns a [GeometryVisualizer2D] to the movement algorithm, allowing it to visualize its behavior.
## [param geometryVisualizer2D] The [GeometryVisualizer2D] instance for visualization.
func set_geometryVisualizer2D(geometryVisualizer2D : GeometryVisualizer2D):
	self.geometryVisualizer2D = geometryVisualizer2D

## Computes and returns the steering behavior for the character. This method is intended to be
## overridden by subclasses to implement specific steering logic.
## By default, it returns a new instance of [SteeringBehavior] with results in no movement.
## [param delta] The time elapsed since the last frame, used for time-dependent calculations.
## returns the computed steering behavior for the character.
func get_steering(delta) -> SteeringBehavior:
	return SteeringBehavior.new()
