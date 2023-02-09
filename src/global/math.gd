class_name Math
static func approach(val: float, target: float, amount: float) -> float:
	if val == target:
		return target
	elif val > target:
		return clamp(val-amount, target, val)
	else:
		return clamp(val+amount, val, target)
	
static func angle_distance(from:float, to:float):
	var difference: float = fmod(to - from, TAU)
	var distance: float = fmod(2.0 * difference, TAU) - difference
	return distance
	
static func approach_angle(from: float, to: float, amount: float) -> float:
	var result = approach(from, from + angle_distance(from, to), amount)
#	print("from:", from,", to:", to, ", amount:", amount, ", result:", result)
	return result
