#region Draw Cass
draw_sprite_ext(sprCass, 0, x + (137 / 2), y + (144 / 2), 0.25, 0.25, 0, c_white, 1.0);
#endregion

#region Draw chest
draw_sprite_jiggle(chest_sprite, 0, new Vector2(x, y), new Vector2(0.25, 0.25), chest);
#endregion