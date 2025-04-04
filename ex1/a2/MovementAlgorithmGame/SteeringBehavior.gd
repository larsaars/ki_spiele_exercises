## A class representing steering behaviors for dynamic character movement in games.
##
## This class encapsulates linear and angular steering components, allowing characters to navigate
## their environment. It supports the aggregation of multiple steering behaviors and the application
## of limitations on the resulting steering forces.
class_name SteeringBehavior extends RefCounted

## The linear steering component, representing acceleration. [br]
## When used as kinematic steering behavior this is the velocity
var linear: Vector2

## The angular steering component, representing rotational acceleration. [br]
## When used as kinematic steering behavior this is the angular velocity.
var angular: float

## Utility script preloaded to access global movement parameters like maximum acceleration.
var _MovementUtils = preload("res://MovementAlgorithmGame/MovementUtils.gd")

## The maximum linear acceleration allowed, fetched from _MovementUtils.
var maxLinearAcc = _MovementUtils.maxLinearAcceleration

## The maximum angular acceleration allowed, fetched from _MovementUtils.
var maxAngularAcc = _MovementUtils.maxAngularAcceleration

## Flag to determine if limitations on acceleration are active.
var limitationActive: bool = true

## Initializes a new SteeringBehavior instance with optional linear and angular components. [br]
## [param linear]: Initial linear component, defaulting to [enum Vector2.ZERO]. [br]
## [param angular]: Initial angular component, defaulting to 0.
func _init(linear: Vector2 = Vector2.ZERO, angular: float = 0):
	self.linear = linear
	self.angular = angular

## Adds the steering output from another SteeringBehavior instance to this one, optionally applying limitations. [br]
## [param steering_behaviour]: The SteeringBehavior instance to add to this one.
func add(steering_behaviour: SteeringBehavior):
	linear = linear + steering_behaviour.linear #Vectors
	angular += steering_behaviour.angular #floats
	if limitationActive:
		_limit()

## Applies limitations to the linear and angular components based on maximum allowed accelerations.
func _limit():
	if linear.length() >= maxLinearAcc:
		linear = linear / linear.length()
		linear = linear  * maxLinearAcc
	if abs(angular) >= maxAngularAcc:
		angular = angular / abs(angular) * maxAngularAcc

## Disables the application of limitations to the steering behavior, allowing accelerations to exceed predefined maxima.
func disableLimitation():
	limitationActive = false

## Enables the application of limitations to the steering behavior, ensuring accelerations do not exceed predefined maxima.
func enableLimitation():
	limitationActive = true
