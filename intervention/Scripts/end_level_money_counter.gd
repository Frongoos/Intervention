extends Node
var money_target: int
var money_count=0
var inbetween_level_UI
func _ready():
	inbetween_level_UI=get_node("../InbetweenLevelUI")

func start_count(money: int):
	
	$CompletedSprite.visible=true
	$FirstDigit.visible=true
	$FirstDigit.frame=0
	$FirstDigit/SecondDigit.frame=10
	$FirstDigit/SecondDigit.sign=true
	money_target=money
	if money<=0:
		$FinishedDelay.start(0.0)
		await $FinishedDelay.timeout
		reset()
		inbetween_level_UI.display(1)
	else:
		$DigitChangeInterval.connect("timeout",_on_digit_change_interval_timeout)
		$DigitChangeInterval.start(0.0)
		
func _on_digit_change_interval_timeout() -> void:
	if  money_count<money_target:
		$FirstDigit.increment()
		money_count+=1
		$DigitChangeInterval.start(0.0)
	else:
		$DigitChangeInterval.disconnect("timeout",_on_digit_change_interval_timeout)
		$FinishedDelay.start(0.0)
		await $FinishedDelay.timeout
		reset()
		inbetween_level_UI.display(1) 
		get_node("")
func reset():
	money_target=0
	money_count=0
	$CompletedSprite.visible=false
	$FirstDigit.visible=false
	$FirstDigit.reset()
