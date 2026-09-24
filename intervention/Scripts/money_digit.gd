extends AnimatedSprite2D
var value = 0
var sign = false
var child
func _ready():
	child=get_child(0)
func increment():
	if sign:
		value =1
		sign=false
		child.frame=10
		child.sign=true
		frame=1
	else:
		value+=1
		if value>9:
			value=0
			child.increment()
		frame=value
func reset():
	sign=false
	frame=11
	if get_child(0):
		get_child(0).reset()
