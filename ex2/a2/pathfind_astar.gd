extends TileMap

# You can only create an AStar node from code, not from the Scene tab
onready var astar_node = AStar.new()
# The Tilemap node doesn't have clear bounds so we're defining the map's limits here
export(Vector2) var map_size = Vector2(16, 16)

# The path start and end variables use setter methods
# You can find them at the bottom of the script
var path_start_position = Vector2() setget _set_path_start_position
var path_end_position = Vector2() setget _set_path_end_position

var _point_path = []

const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color('#fff')

# get_used_cells_by_id is a method from the TileMap node
# here the id 0 corresponds to the grey tile, the obstacles
onready var obstacles = get_used_cells_by_id(0)
onready var _half_cell_size = cell_size / 2

func _ready():
	var walkable_cells_list = astar_add_walkable_cells(obstacles)
	astar_connect_walkable_cells(walkable_cells_list)
	# astar_connect_walkable_cells_diagonal(walkable_cells_list)


# Click and Shift force the start and end position of the path to update
# and the node to redraw everything
#func _input(event):
#	if event.is_action_pressed('click') and Input.is_key_pressed(KEY_SHIFT):
#		# To call the setter method from this script we have to use the explicit self.
#		self.path_start_position = world_to_map(get_global_mouse_position())
#	elif event.is_action_pressed('click'):
#		self.path_end_position = world_to_map(get_global_mouse_position())


# Loops through all cells within the map's bounds and
# adds all points to the astar_node, except the obstacles
func astar_add_walkable_cells(obstacles = []):
	var points_array = []
	for y in range(map_size.y):
		for x in range(map_size.x):
			var point = Vector2(x, y)
			if point in obstacles:
				continue

			points_array.append(point)
			# The AStar class references points with indices
			# Using a function to calculate the index from a point's coordinates
			# ensures we always get the same index with the same input point
			var point_index = calculate_point_index(point)
			# AStar works for both 2d and 3d, so we have to convert the point
			# coordinates from and to Vector3s
			astar_node.add_point(point_index, Vector3(point.x, point.y, 0.0))
	return points_array


# Once you added all points to the AStar node, you've got to connect them
func astar_connect_walkable_cells(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		
		# Check and connect to adjacent diagonal/orthogonal
		# define all points
		var top_left = Vector2(point.x - 1, point.y - 1)  # top left, 0
		var top = Vector2(point.x, point.y - 1)  # top, 1
		var top_right = Vector2(point.x + 1, point.y - 1)  # top right, 2
		var left = Vector2(point.x - 1, point.y)  # left, 3
		var right = Vector2(point.x + 1, point.y)  # right, 4
		var bottom_left = Vector2(point.x - 1, point.y + 1)  # bottom left, 5
		var bottom = Vector2(point.x, point.y + 1)  # bottom, 6
		var bottom_right = Vector2(point.x + 1, point.y + 1)  # bottom right, 7
		
		var neighbors = []
		
		var hasTop = top in points_array
		var hasBottom = bottom in points_array
		var hasLeft = left in points_array
		var hasRight = right in points_array
		
		# add orthogonal if walkable
		if hasTop: neighbors.append(top)
		if hasBottom: neighbors.append(bottom)
		if hasLeft: neighbors.append(left)
		if hasRight: neighbors.append(right)
		
		# add diagonal if walkable
		if hasTop or hasLeft:
			neighbors.append(top_left)
		if hasTop or hasRight:
			neighbors.append(top_right)
		if hasBottom or hasLeft:
			neighbors.append(bottom_left)
		if hasBottom or hasRight:
			neighbors.append(bottom_right)

		for neighbor in neighbors:
			var neighbor_index = calculate_point_index(neighbor)
			astar_node.connect_points(point_index, neighbor_index, false)


func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y


func calculate_point_index(point):
	return point.x + map_size.x * point.y


func find_path(world_start, world_end):
	self.path_start_position = world_to_map(world_start)
	self.path_end_position = world_to_map(world_end)
	_recalculate_path()
	var path_world = []
	for point in _point_path:
		var point_world = map_to_world(Vector2(point.x, point.y)) + _half_cell_size
		path_world.append(point_world)
	return path_world


func _recalculate_path():
	clear_previous_path_drawing()
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	# This method gives us an array of points. Note you need the start and end
	# points' indices as input
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)
	# Redraw the lines and circles from the start to the end point
	update()


func clear_previous_path_drawing():
	if not _point_path:
		return
	var point_start = _point_path[0]
	var point_end = _point_path[len(_point_path) - 1]
	set_cell(point_start.x, point_start.y, -1)
	set_cell(point_end.x, point_end.y, -1)


func _draw():
	if not _point_path:
		return
	var point_start = _point_path[0]
	var point_end = _point_path[len(_point_path) - 1]

	set_cell(point_start.x, point_start.y, 1)
	set_cell(point_end.x, point_end.y, 2)

	var last_point = map_to_world(Vector2(point_start.x, point_start.y)) + _half_cell_size
	for index in range(1, len(_point_path)):
		var current_point = map_to_world(Vector2(_point_path[index].x, _point_path[index].y)) + _half_cell_size
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		draw_circle(current_point, BASE_LINE_WIDTH * 2.0, DRAW_COLOR)
		last_point = current_point


# Setters for the start and end path values.
func _set_path_start_position(value):
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return

	set_cell(path_start_position.x, path_start_position.y, -1)
	set_cell(value.x, value.y, 1)
	path_start_position = value
	if path_end_position and path_end_position != path_start_position:
		_recalculate_path()


func _set_path_end_position(value):
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return

	set_cell(path_start_position.x, path_start_position.y, -1)
	set_cell(value.x, value.y, 2)
	path_end_position = value
	if path_start_position != value:
		_recalculate_path()
