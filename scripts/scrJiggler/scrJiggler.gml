/// @func Jiggler
/// @param {Vector2} position
/// @param {real} stiffness
/// @param {real} amplitude
/// @param {Vector2} acceleration_max
/// @param {Vector2} [stiffness_range]
/// @param {real} [amplitude_multiplier]
/// @param {real} [divide_step_by]
/// @param {Vector2} [axis_affection]
function Jiggler(position, stiffness, amplitude, acceleration_max, stiffness_range = new Vector2(90, 30), amplitude_multiplier = 2, divide_step_by = 5, axis_affection = new Vector2(0, 1/20)) constructor {
	jiggler_stiffness_range = stiffness_range;
	jiggler_amplitude_multiplier = amplitude_multiplier;
	jiggler_divide_step_by = divide_step_by;
	jiggler_axis_affection = axis_affection;
	
	jiggler_position = position;
	jiggler_position_previous = position;
	
	jiggler_stiffness = stiffness;
	jiggler_amplitude = amplitude;
	
	jiggler_acceleration = new Vector2(0, 0);
	jiggler_acceleration_max = acceleration_max;
	
	jiggler_jiggle_coeff = new Vector2(0, 0);
	
	#region Getters
	/// @func GetAcceleration
	/// @desc Returns {Vector2};
	function GetAcceleration() {
		return jiggler_acceleration;
	}
	
	/// @func GetRealStiffness
	/// @desc Returns {real}.
	function GetRealStiffness() {
		var min_stiffness = jiggler_stiffness_range._x;
		var max_stiffness = jiggler_stiffness_range._y;
		var normalized_stiffness = Normalize(jiggler_stiffness);
	
		return (max_stiffness + (min_stiffness * (1 - normalized_stiffness)));
	}
	
	/// @func GetRealAmplitude
	/// @desc Returns {real}.
	function GetRealAmplitude() {
		var amplitude_mult = jiggler_amplitude_multiplier;
		var normalized_amplitude = Normalize(jiggler_amplitude);
	
		return normalized_amplitude * amplitude_mult;
	}
	
	/// @func GetStep
	/// @desc Returns {Vector2}.
	function GetStep() {
		var divide_by = jiggler_divide_step_by;
	
		return new Vector2(
			(jiggler_position_previous._x - jiggler_position._x) / divide_by,
			(jiggler_position_previous._y - jiggler_position._y) / divide_by
		);
	}
	
	/// @func GetJiggleCoeff
	/// @desc Returns {Vector2};
	function GetJiggleCoeff() {
		return jiggler_jiggle_coeff;
	}
	#endregion
	
	#region Setters
	/// @func SetPosition
	/// @desc
	/// @param {Vector2} pos
	function SetPosition(pos) {
		jiggler_position = pos;
	}
	
	/// @func SetAccelerationX
	/// @desc
	/// @param {real} accx
	function SetAccelerationX(accx) {
		jiggler_acceleration._x = accx;
		
		ClampAcceleration();
	}
	
	/// @func SetAccelerationY
	/// @desc
	/// @param {real} accy
	function SetAccelerationY(accy) {
		jiggler_acceleration._y = accy;
		
		ClampAcceleration();
	}
	
	/// @func SetJiggleCoeff
	/// @desc
	/// @param {Vector2} coeff
	function SetJiggleCoeff(coeff) {
		jiggler_jiggle_coeff = coeff;
	}
	#endregion
	
	#region Other
	/// @func Normalize
	/// @desc
	/// @param {real} value
	function Normalize(value) {
		return clamp(value, 0.0, 1.0);
	}
	
	
	/// @func UpdatePreviousPosition
	/// @desc
	function UpdatePreviousPosition() {
		jiggler_position_previous = jiggler_position;
	}
	
	/// @func Accelerate
	/// @desc
	function Accelerate() {
		var step = GetStep();
		
		jiggler_acceleration._x += step._x;
		jiggler_acceleration._y += step._y;
	}
	
	/// @func Decelerate
	/// @desc
	function Decelerate() {
		jiggler_acceleration._x = lerp(jiggler_acceleration._x, 0.0, 0.1);
		jiggler_acceleration._y = lerp(jiggler_acceleration._y, 0.0, 0.1);
	}
	
	/// @func ClampAcceleration
	/// @desc
	function ClampAcceleration() {
		jiggler_acceleration._x = clamp(jiggler_acceleration._x, -jiggler_acceleration_max._x, jiggler_acceleration_max._x);
		jiggler_acceleration._y = clamp(jiggler_acceleration._y, -jiggler_acceleration_max._y, jiggler_acceleration_max._y);
	}
	
	/// @func CalculateJiggle
	/// @desc
	function CalculateJiggle() {
		var acceleration_direction = new Vector2(
			sign(jiggler_acceleration._x), 
			sign(jiggler_acceleration._y)
		);
		var stiffness = GetRealStiffness();
		var amplitude = GetRealAmplitude();
		var multiplier = cos((acceleration_direction._x * current_time) / stiffness) * amplitude;
		
		SetJiggleCoeff(new Vector2(
			jiggler_acceleration._x * multiplier,
			jiggler_acceleration._y * multiplier,
		));
	}
	
	/// @func UpdatePosition
	/// @desc
	/// @param {Vector2} new_position
	function UpdatePosition(new_position) {
		SetPosition(new_position);
	}

	/// @func UpdatePhysics
	/// @desc
	function UpdatePhysics() {
		Accelerate();
	
		var acceleration = GetAcceleration();
		SetAccelerationX(acceleration._x + (acceleration._y * jiggler_axis_affection._x));
		SetAccelerationY(acceleration._y + (acceleration._x * jiggler_axis_affection._y));
		Decelerate();
	
		CalculateJiggle();
		UpdatePreviousPosition();
	}
	#endregion
}