extends hurtbox
var enabled=false
func area_entered(hit: hitbox):
	if enabled:
		hit.owner.take_damage(damage, type)
		print("hit")
