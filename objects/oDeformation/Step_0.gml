if (is_dragging) {
	x = start_pos._x + (current_mpos._x - start_mpos._x);	
	y = start_pos._y + (current_mpos._y - start_mpos._y);	
}

chest.UpdatePosition(new Vector2(x, y));
chest.UpdatePhysics();