class_name ColorUtils
#returns an array of 2 elements, 
#0: PoolColorArray with the resulting palette
#1: PoolColorArray with the removed colors
static func shift_palette_right(
		palette: PoolColorArray,
		input_colors: PoolColorArray
	) -> Array:
	var shift_size = input_colors.size()
	input_colors.append_array(palette)
	input_colors.resize(palette.size())
	palette = shrink_from_front(palette, palette.size()-shift_size)
	return [input_colors, palette]
	
#returns an array of 2 elements, 
#0: PoolColorArray with the resulting palette
#1: PoolColorArray with the removed colors
static func shift_palette_left(
		palette: PoolColorArray,
		input_colors: PoolColorArray
	) -> Array:
	var removed = PoolColorArray()
	for i in input_colors.size():
		removed.append(palette[0])
		palette.remove(0)
#		PoolColorArray().remove()
		
	palette.append_array(input_colors)
	return [palette,removed]

static func shrink_from_front(pool_array, amount):
	var size = pool_array.size()
	for i in size-amount:
		pool_array[i] = pool_array[amount+i]
	pool_array.resize(size-amount)
	return pool_array
