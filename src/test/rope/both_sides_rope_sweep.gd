extends Node2D
tool
"""
la soga arranca con 2 puntos, cuando ambos se mueven, 
si el movimiento no es cruzado, se genera un cuadrilatero 
compuesto de los vertices A0, A1, B0, B1, siendo 
A0 y A1 los puntos que representan los extremos de la soga antes de moverse, y
B0 y B1 los puntos que representan los extremos de la soga luego de moverse


```
		
A0---------------A1
		._____.
		|     |    B1
B0		|     | 
		._____.
```

```
para ordenar los puntos hay que ubicar el valor de t, t0, para el cual, si
f(t) = A0 + t*(B0 - A0)
g(t) = A1 + t*(B1 - A1)
F = f(t0) 
G = g(t0)
0 <= t0 <= 1

P está en el segmento FG, 

A0---------------A1
|                |
.F______.P_______.G
|                |
B0---------------B1

lo cual es cierto si el segmento FG esta alineado con FP
que significa que el producto vectorial entre FP y FG es 0

el producto vectorial entre FP y FG seria lo mismo que el producto vectorial
entre los vectores (P-F) y (G-F)
entonces queda

P-F = P - (A0 + t*(B0 - A0))
P-F = P - A0 - t*(B0 - A0)
P-F = (P - A0) + t*(A0 - B0)

G-F = (A1 + t*(B1 - A1)) - (A0 + t*(B0 - A0))
G-F = A1 + t*(B1 - A1) - A0 - t*(B0 - A0)
G-F = A1 - A0 + t*(B1 - A1) - t*(B0 - A0)
G-F = (A1 - A0) + t*(B1 - A1) + t*(A0 - B0)
G-F = (A1 - A0) + t*(B1 - A1 + A0 - B0)

el producto vectorial en R2 (dos dimensiones) entre vectores U y V es

UxV = U.x*V.y - U.y*V.x

en nuestro caso si U=P-F , V=G-F

UxV = (P-F).x*(G-F).y - (P-F).y*(G-F).x
UxV = ((P - A0) + t*(A0 - B0)).x*((A1 - A0) + t*(B1 - A1 + A0 - B0)).y 
	- ((P - A0) + t*(A0 - B0)).y*((A1 - A0) + t*(B1 - A1 + A0 - B0)).x
UxV = ((P.x - A0.x) + t*(A0.x - B0.x))*((A1.y - A0.y) + t*(B1.y - A1.y + A0.y - B0.y)) 
	- ((P.y - A0.y) + t*(A0.y - B0.y))*((A1.x - A0.x) + t*(B1.x - A1.x + A0.x - B0.x))
reemplazamos cada punto del vector por un termino 
para poder poner todo esto de input en un programita que agrupe por terminos
porque ni en pedo te despejo esto a mano
A0.x = a
A0.y = b
A1.x = c
A1.y = d
B0.x = u #e no porque lo toma como 2.71
B0.y = f
B1.x = g
B1.y = h
P.x = i
P.y = j



UxV = ((i - a) + t*(a - u))*((d - b) + t*(h - d + b - f)) 
	- ((j - b) + t*(b - f))*((c - a) + t*(g - c + a - u))

0 	= ((i - a) + t*(a - u))*((d - b) + t*(h - d + b - f)) 
	- ((j - b) + t*(b - f))*((c - a) + t*(g - c + a - u))

0 	= (i - a + t*a - t*u)*(d - b + t*h - t*d + t*b - t*f) 
	- (j - b + t*b - t*f)*(c - a + t*g - t*c + t*a - t*u)

0 = (i - a + t*a - t*u)*(d - b + t*h - t*d + t*b - t*f) - (j - b + t*b - t*f)*(c - a + t*g - t*c + t*a - t*u)


usando la magia de la computacion en internet para expresar como at2 + bt + c = 0:
(-ad+bc+du+ah-uh-cf-bg+fg)t2 + (2ad-2bc-di+bi+cj-aj-du+ju+ih-ah-if+cf-jg+bg)t + (-ad+bc+di-bi-cj+aj) = 0

_a = (-ad+bc+du+ah-uh-cf-bg+fg)
_b = (2ad-2bc-di+bi+cj-aj-du+ju+ih-ah-if+cf-jg+bg)
_c = (-ad+bc+di-bi-cj+aj)

_a = (-(A0.x)(A1.y)+(A0.y)(A1.x)+(A1.y)(B0.x)+(A0.x)(B1.y)-(B0.x)(B1.y)-(A1.x)(B0.y)-(A0.y)(B1.x)+(B0.y)(B1.x))
_b = (2(A0.x)(A1.y)-2(A0.y)(A1.x)-(A1.y)(P.x)+(A0.y)(P.x)+(A1.x)(P.y)-(A0.x)(P.y)-(A1.y)(B0.x)+(P.y)(B0.x)+(P.x)(B1.y)-(A0.x)(B1.y)-(P.x)(B0.y)+(A1.x)(B0.y)-(P.y)(B1.x)+(A0.y)(B1.x))
_c = (-(A0.x)(A1.y)+(A0.y)(A1.x)+(A1.y)(P.x)-(A0.y)(P.x)-(A1.x)(P.y)+(A0.x)(P.y))

_a = -(A0.x*A1.y)+(A0.y*A1.x)+(A1.y*B0.x)+(A0.x*B1.y)-(B0.x*B1.y)-(A1.x*B0.y)-(A0.y*B1.x)+(B0.y*B1.x)
_b = 2*(A0.x*A1.y)-2*(A0.y*A1.x)-(A1.y*P.x)+(A0.y*P.x)+(A1.x*P.y)-(A0.x*P.y)-(A1.y*B0.x)+(P.y*B0.x)+(P.x*B1.y)-(A0.x*B1.y)-(P.x*B0.y)+(A1.x*B0.y)-(P.y*B1.x)+(A0.y*B1.x)
_c = -(A0.x*A1.y)+(A0.y*A1.x)+(A1.y*P.x)-(A0.y*P.x)-(A1.x*P.y)+(A0.x*P.y)


```
"""


onready var _A0: Position2D = $"rope_movement/A/0"
onready var _A1: Position2D = $"rope_movement/A/1"
onready var _B0: Position2D = $"rope_movement/B/0"
onready var _B1: Position2D = $"rope_movement/B/1"

var lines_to_draw = []
var lines_to_draw_outside = []
var lines_to_draw_movement_range = []
var lines_to_draw_demo = []

onready var points: Node2D = $points

export var update_the_thing := false setget set_update_the_thing

export var traversal_lines := 5
	

func set_update_the_thing(val):
	test_it_out()
	pass



#solve x for 
#a*x*x + b*x + c == 0
static func solve_cuadratic(a,b,c):
	var discriminant = b*b - 4*a*c
	var x1 = null
	var x2 = null
	if (discriminant > 0):
		var sqrt_discriminant = sqrt(discriminant)
		x1 = (-b + sqrt_discriminant) / (2*a)
		x2 = (-b - sqrt_discriminant) / (2*a)
#		print("Roots are real and different." )
#		print("x1 = ", x1 )
#		print("x2 = ", x2 )
		return [x1,x2]
	
	
	elif (discriminant == 0):
#		print("Roots are real and same." )
		x1 = -b/(2*a)
#		print("x1 = x2 =", x1 )
		return [x1]

	else:
#		print("Imaginary result, we don't care about those.")
		return []

	pass

#b*x + c == 0
#x == -c/b 
static func solve_lineal(b,c):
	var solution = -c/b
#	print("x = ",solution)
	return solution

func test_it_out():
	
	var A0 = _A0.global_position
	var A1 = _A1.global_position
	var B0 = _B0.global_position
	var B1 = _B1.global_position
	
	var points_to_sort = points.get_children()
	
	
	"""
	(A0.x) = a
	(A0.y) = b
	(A1.x) = c
	(A1.y) = d
	(B0.x) = e
	(B0.y) = f
	(B1.x) = g
	(B1.y) = h
	(P.x) = i
	(P.y) = j
	"""
	var A = -(A0.x*A1.y)+(A0.y*A1.x)+(A1.y*B0.x)+(A0.x*B1.y)-(B0.x*B1.y)-(A1.x*B0.y)-(A0.y*B1.x)+(B0.y*B1.x)
	var sorted_point_indexes = []
	var i = 0
	for point in points_to_sort:
		var P : Vector2 = point.global_position
		var B = 2.0*(A0.x*A1.y)-2.0*(A0.y*A1.x)-(A1.y*P.x)+(A0.y*P.x)+(A1.x*P.y)-(A0.x*P.y)-(A1.y*B0.x)+(P.y*B0.x)+(P.x*B1.y)-(A0.x*B1.y)-(P.x*B0.y)+(A1.x*B0.y)-(P.y*B1.x)+(A0.y*B1.x)
		var C = -(A0.x*A1.y)+(A0.y*A1.x)+(A1.y*P.x)-(A0.y*P.x)-(A1.x*P.y)+(A0.x*P.y)
		var result = null
		if A:
			result = solve_cuadratic(A,B,C)
		elif B:
			result = [solve_lineal(B,C)]
		elif C:
#			print("no reals solve the equation")
			result = []
		else:
#			print("all reals solve the equation")
			result = []
		result.sort()
		point.set_text(str(result))
		var first = true
		for t in result:
			var F = A0.linear_interpolate(B0,t)
			var G = A1.linear_interpolate(B1,t)
			var line = [F,G]
#			var line = [A0+B0*t-A0*t, A1+B1*t-A1*t]
			
			if (t<=1.0 
			and t >= 0.0 
			and max((P-F).length_squared(),(P-G).length_squared())<=(G-F).length_squared()
			and first):
				lines_to_draw.append(line)
				first = false
			else:
				lines_to_draw_outside.append(line)
	for _t in 1000:
		var t = _t/1000.0
		var F = A0.linear_interpolate(B0,t)
		var G = A1.linear_interpolate(B1,t)
		var line = [F,G]
#			var line = [A0+B0*t-A0*t, A1+B1*t-A1*t]
		
		lines_to_draw_movement_range.append(line)
	
	
	
	dt += 5
	for offset in traversal_lines:
		var t = dt+offset*1000/traversal_lines
		var F = A0.linear_interpolate(B0, fmod(t/1000.0,1.0))
		var G = A1.linear_interpolate(B1, fmod(t/1000.0,1.0))
		lines_to_draw_demo.append([F,G])
		
func _ready() -> void:
#	test_it_out()
	pass


var dt = 0
func _physics_process(delta: float) -> void:

	lines_to_draw = []
	lines_to_draw_outside = []
	lines_to_draw_movement_range = []
	lines_to_draw_demo = []
	test_it_out()
	update()
	
	

func _draw() -> void:
	
	for line in lines_to_draw_movement_range:
		draw_line(to_local(line[0]),to_local(line[1]),Color.red.darkened(0.8),1.0)
	
	for line in lines_to_draw_demo:
		draw_line(to_local(line[0]),to_local(line[1]),Color.red.darkened(0.4),1.0)
	
	for line in lines_to_draw_outside:
		draw_line(to_local(line[0]),to_local(line[1]),Color.yellow.darkened(0.8),1.0)

	for line in lines_to_draw:
		draw_line(to_local(line[0]),to_local(line[1]),Color.yellow,1.0)
	

