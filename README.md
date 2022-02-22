# Jiggler
## _Make dynamic sprite animation great again!_

Game Maker Studio 2.3 extension, which allows sprites jiggle after motion.

- Initialize a Jiggler object
- Update it's position
- Draw it
- ✨Magic ✨

```
/// @func Jiggler
/// @param {Vector2} position
/// @param {real} stiffness
/// @param {real} amplitude
/// @param {Vector2} acceleration_max
/// @param {Vector2} [stiffness_range]
/// @param {real} [amplitude_multiplier]
/// @param {real} [divide_step_by]
/// @param {Vector2} [axis_affection]
```

**Create** event:
```
var jiggler = new Jiggler(
	new Vector2(x, y), 
	0.5, 
	0.3, 
	new Vector2(60, 25)
);
```

**Step** event:
```
jiggler.UpdatePosition(new Vector2(x, y));
jiggler.UpdatePhysics();
```

**Draw** event:
```
draw_sprite_jiggle(sprite_index, image_index, new Vector2(x, y), new Vector2(1.0, 1.0), jiggler);
```