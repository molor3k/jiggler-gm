/// @func array_contains
/// @param {array of any} array
/// @param {any} value
function array_contains(array, value) {
	for(var i = 0; i < array_length(array); i++) {
		if (array[i] == value) {
			return true;	
		}
	}
	
	return false;
}

/// @func draw_sprite_jiggle
/// @param {asset} sprite
/// @param {real} subimg
/// @param {Vector2} position
/// @param {Vector2} scale
/// @param {Jiggler} jiggler
/// @param {array of real} [pin_points]
/// @param {bool} [is_using_sprite_uvs]
function draw_sprite_jiggle(sprite, subimg, position, scale, jiggler, pin_points = [1, 2], is_using_sprite_uvs = false) {
	var texture = sprite_get_texture(sprite, subimg);
	var uvs = is_using_sprite_uvs ? sprite_get_uvs(sprite, subimg) : [0, 0, 1, 1];
	var size = new Vector2(
		sprite_get_width(sprite) * scale._x,
		sprite_get_height(sprite) * scale._y
	);
	var offset = new Vector2(
		sprite_get_xoffset(sprite) * scale._x,
		sprite_get_yoffset(sprite) * scale._y
	);
	
	var vertex_pos = {
		x1: position._x - offset._x,
		x2: position._x - offset._x + size._x,
		y1: position._y - offset._y,
		y2: position._y - offset._y + size._y
	};
	var deformation_coeff = jiggler.GetJiggleCoeff();
	
	draw_set_color(c_white);
	draw_primitive_begin_texture(pr_trianglelist, texture);
	
	var vertex_order = [1, 2, 3, 2, 4, 3];
	for(var i = 0; i < 6; i++) {
		var is_pinned = array_contains(pin_points, vertex_order[i]);
		draw_vertex_jiggle(vertex_order[i], vertex_pos, deformation_coeff, uvs, is_pinned);	
	}

	draw_primitive_end();
}

/// @func draw_vertex_jiggle
/// @param {real} vertex_id
/// @param {Vector2} vertex_pos
/// @param {Vector2} deformation_coeff
/// @param {array} uvs
/// @param {bool} is_pinned
function draw_vertex_jiggle(vertex_id, vertex_pos, deformation_coeff, uvs, is_pinned) {
	var is_vertex_id_even = (vertex_id mod 2 == 0);
	var is_vertex_id_bottom = (vertex_id > 2);
	
	var posx = (is_vertex_id_even) ? vertex_pos.x2 : vertex_pos.x1;
	var posy = (is_vertex_id_bottom) ? vertex_pos.y2 : vertex_pos.y1;

	#region Deformation
	var is_compensating_deformation = is_pinned;
	
	if (is_compensating_deformation) {
		deformation_coeff = new Vector2(
			-deformation_coeff._x / 5,
			-deformation_coeff._y / 5
		);
	}
	#endregion
	
	draw_vertex_texture(posx + deformation_coeff._x, posy + deformation_coeff._y, uvs[is_vertex_id_even * 2], uvs[(is_vertex_id_bottom * 2) + 1]);
}