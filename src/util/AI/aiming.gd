class_name Aiming

#/**
# * Return the firing solution for a projectile starting at 'src' with
# * velocity 'v', to hit a target, 'dst'.
# *
# * @param src position of shooter
# * @param dst position of target
# * @param dstv velocity of target
# * @param v speed of projectile
# *
# * @return Vector2 at which to fire (and where intercept occurs). Or null if target cannot be hit.
# */
static func intercept(src:Vector2, dst:Vector2, dstv:Vector2, v:float):
	var tx = dst.x - src.x;
	var ty = dst.y - src.y;
	var tvx = dstv.x;
	var tvy = dstv.y;

#  // Get quadratic equation components
	var a = tvx * tvx + tvy * tvy - v * v;
	var b = 2 * (tvx * tx + tvy * ty);
	var c = tx * tx + ty * ty;

#  // Solve quadratic
	var ts = quad(a, b, c); #// See quad(), below

#  // Find smallest positive solution
	var sol = null;
	if ts:
		var t0 = ts[0];
		var t1 = ts[1];
		var t = min(t0, t1);
		if (t < 0): 
			t = max(t0, t1);
		if (t > 0):
			sol = Vector2(
				dst.x + dstv.x * t,
				dst.y + dstv.y * t
			);
	return sol;


#/**
# * Return the firing solution for a projectile starting at 'src' with
# * velocity 'v', to hit a target, 'dst', but only accounting for the
# * travelling time the projectile would take to reach dst, not dst+dstv*t.
# *
# * @param src position of shooter
# * @param dst position of target
# * @param dstv velocity of target
# * @param v speed of projectile
# *
# * @return Vector2 at which to fire (and where intercept occurs). Or null if target cannot be hit.
# */
static func intercept_flawed(src:Vector2, dst:Vector2, dstv:Vector2, v:float):
	var tx = dst.x - src.x
	var ty = dst.y - src.y
	var t = Vector2(tx,ty).length()/v
	return dst + dstv*t

static func quad(a, b, c):
	var sol = null;
	if abs(a) < 1e-6:
		if abs(b) < 1e-6:
			sol =  [0, 0] if abs(c) < 1e-6 else null
		else:
			sol = [-c / b, -c / b]
	else:
		var disc = b * b - 4 * a * c
		if disc >= 0:
			disc = sqrt(disc)
			a = 2 * a
			sol = [(-b - disc) / a, (-b + disc) / a]
  return sol;



