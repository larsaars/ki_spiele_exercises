## Extends DraggableObject to add movement and physics behavior to game characters.
##
## This class specializes DraggableObject to include customizable movement physics,
## such as linear and angular velocity. It's designed to work with a [SteeringBehavior]
## instance to dynamically update movement based on game logic, supporting both collision
## handling and drag effects.
class_name MovementGameCharacter extends DraggableObject

## This method is overridden from the parent class to use the custom [method MovementGameCharacter.movement_physics_update] method.
## The implementation only serves the purpose of illustrating the intended usage and provide a default behavior.
## If working with kinematic algorithms the method [method MovementGameCharacter.kinematic_update] can be used instead.
## Remember to call [method MovementGameCharacter.movement_physics_update] at the end to apply the calculated movement.
func _physics_process(delta):
	var steering_behaviour = SteeringBehavior.new()
	# implement custom steering behavior calculations here
	movement_physics_update(steering_behaviour, delta)

## Maximum angular velocity the character can achieve.
var max_angular_vel: float = PI * 10
## Maximum linear velocity the character can achieve.
var max_linear_vel: float = 443.879913330078

## Current linear velocity of the character.
var linear_velocity := Vector2(0, 0)
## Current angular velocity of the character.
var angular_velocity: float = 0

## Updates the character's physics state, including position and rotation, based on steering behavior and [param delta] time.
## This method integrates collision detection and handling, and applies drag to both linear and angular velocities to
## simulate realistic movement. It also enforces maximum velocity constraints.
## The [SteeringBehaviour] instance is providing the desired linear and angular acceleration
## [param delta] is the time elapsed since the last frame, used for frame-independent movement updates.
func movement_physics_update(steering_behaviour: SteeringBehavior, delta):
	
	# Update position. Using move_and_collide allows characters to interact with other objects.
	var collision = move_and_collide(linear_velocity * delta)
	# Update rotation based on angular velocity.
	rotation += angular_velocity * delta
	
	# Update velocities with current acceleration and detect collisions.
	if collision:
		linear_velocity = Vector2.ZERO
	else:
		linear_velocity += steering_behaviour.linear * delta
	
	angular_velocity += steering_behaviour.angular * delta
	
	# Apply drag to linear velocity.
	var drag_val = -0.001 * pow(linear_velocity.length(), 2)
	var drag_vec = linear_velocity.normalized() * drag_val
	linear_velocity = linear_velocity + drag_vec * delta
	
	# Apply constant drag to reduce linear velocity smoothly.
	var constant_drag = 0.7
	if linear_velocity.length() > constant_drag:
		linear_velocity = linear_velocity - linear_velocity.normalized() * constant_drag
	else:
		linear_velocity = Vector2.ZERO
	
	# Apply drag to angular velocity.
	var sign = angular_velocity / abs(angular_velocity)
	var angular_drag = -0.1 * sign * pow(angular_velocity, 2)
	angular_velocity = angular_velocity + angular_drag * delta
	
	# Apply constant angular drag to reduce angular velocity smoothly.
	var constant_angular_drag = 0.01
	if abs(angular_velocity) > constant_angular_drag:
		angular_velocity = angular_velocity - angular_velocity * constant_angular_drag
	else:
		angular_velocity = 0
	
	# Enforce maximum velocity limits.
	var size_angular_vel = abs(angular_velocity)
	if (size_angular_vel > max_angular_vel):
		print("Hit max angular vel")
		angular_velocity /= size_angular_vel
		angular_velocity = angular_velocity * max_angular_vel

	if linear_velocity.length() > max_linear_vel:
		print("Hit max linear vel")
		linear_velocity = linear_velocity.normalized()
		linear_velocity = linear_velocity * max_linear_vel


## Applies a kinematic approach to update the character's position and rotation, offering an alternative to 
## the default physics-based movement. This method provides smoother transitions between velocities and directions.
## [param steering]: The [SteeringBehavior] instance to apply for movement and rotation. The attributes linear and angular are interpreted as velocities with this function
## [param time]: The time step to simulate movement over.
func kinematic_update(steering: SteeringBehavior, time: float):
	# Set acceleration rates
	var linear_acceleration_rate = 0.7
	var angular_acceleration_rate = 0.7

	# For linear_velocity (Vector2 or Vector3), use linear_interpolate towards the desired velocity.
	linear_velocity = linear_velocity.lerp(steering.linear, linear_acceleration_rate * time)

	# For angular_velocity (scalar), use lerp for smooth interpolation.
	angular_velocity = lerp(angular_velocity, steering.angular, angular_acceleration_rate * time)

	# Update position and rotation based on current velocities.
	position += linear_velocity * time
	rotation += angular_velocity * time



## Returns the current linear velocity of the character.
## Returns the [Vector2] representing the character's current linear velocity.
func get_linear_velocity() -> Vector2:
	return linear_velocity

## Returns the current angular velocity of the character.
## Returns the current angular velocity as a [float].
func get_angular_velocity() -> float:
	return angular_velocity
