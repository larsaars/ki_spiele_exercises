## The MovementUtils class provides utility functions for movement calculations.
## It includes methods for converting between vector orientations and angles, normalizing angles,
## and defining maximum parameters for linear and angular accelerations, as well as maximum speed.
class_name MovementUtils extends RefCounted

## Maximum linear acceleration allowed for movement.
static var maxLinearAcceleration = 200
## Maximum angular acceleration allowed for rotation.
static var maxAngularAcceleration = PI * 2
## Maximum speed a moving object can achieve.
static var maxLinearVel = 443.879913330078

## Calculates the rotation angle in radians for a given direction vector.
## [param vector] A Vector2 representing the direction to calculate the orientation for.
## Returns the orientation in radians as a float, where 0 is to the right, and PI/2 is upwards.
static func orientation_from_vec(vector: Vector2) -> float:
	if (vector.length() > 0):
		return atan2(vector.y, vector.x) # Note: Y is the first parameter, then X, to match Godot's coordinate system.
	return 0

## Converts an orientation angle in radians to a direction vector.
## [param orientation] The orientation angle in radians.
## Returns a normalized Vector2 representing the direction of the orientation.
static func vector_from_orientation(orientation: float) -> Vector2:
	return Vector2(cos(orientation), sin(orientation))

## Normalizes an angle to the range (-PI, PI].
## This method is useful for ensuring rotational values remain within a standard range,
## simplifying comparisons and operations involving angles.
## [param rotation] The angle in radians to normalize.
## Returns the normalized angle in radians, within the range [-PI, PI].
static func normalize_angle(rotation: float) -> float:
	while (rotation <= -PI || rotation > PI):
		if (rotation <= -PI): 
			rotation += 2*PI
		if (rotation > PI):
			rotation -= 2*PI
	return rotation
