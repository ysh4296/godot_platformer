using Godot;
using System;

public partial class Player : CharacterBody2D
{
	public const float Speed = 200.0f;
	public const float JumpVelocity = -300.0f;
	public const float SpeedAcceleration = 20.0f;
	public const float JumpAcceleration = 30.0f;
	private AnimatedSprite2D _animatedSprite;
	
	public override void _Ready()
	{
		_animatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		//_animatedSprite.Play("idle");
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
		{
			velocity += GetGravity() * (float)delta;
		}

		// Handle Jump.
		if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
		{
			velocity.Y = JumpVelocity;
		}
		if(!Input.IsActionPressed("ui_accept") && !IsOnFloor() && velocity.Y < 0)
		{
			velocity.Y = ApplyAcceleration(velocity.Y,0,JumpAcceleration);
		}
		
		if(Input.IsActionPressed("ui_accept") && !IsOnFloor())
		{
			_animatedSprite.Play("jump");
		}

		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		if (direction != Vector2.Zero)
		{
			velocity.X = ApplyAcceleration(velocity.X,direction.X * Speed,SpeedAcceleration);
			
			// player is running
			if(IsOnFloor()) 
			{	
				_animatedSprite.Play("run");
			}
			if(direction.X > 0)
				_animatedSprite.FlipH = true;
			else
				_animatedSprite.FlipH = false;
		}
		else
		{
			velocity.X = ApplyAcceleration(Velocity.X, 0, SpeedAcceleration);
			if(IsOnFloor()) 
			{	
				_animatedSprite.Play("idle");
			}
		}

		Velocity = velocity;
		MoveAndSlide();
	}
	
	public float ApplyAcceleration(float from, float to, float Acceleration) {
		return Mathf.MoveToward(from, to, Acceleration);
	}
}
