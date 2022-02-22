/// @desc 

x = 200;
y = 200;

is_dragging = false;

start_pos = new Vector2(x, y);
start_mpos = new Vector2(0, 0);
current_mpos = new Vector2(0, 0);

chest_sprite = sprChest;

chest = new Jiggler(
	new Vector2(x, y), 
	0.5, 
	0.3, 
	new Vector2(60, 25)
);