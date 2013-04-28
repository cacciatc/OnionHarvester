package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import org.flashdevelop.utils.FlashConnect;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author Chris Cacciatore
	 */
	public class Player extends Entity 
	{
		public static const MAX_SPEED:Number = 2.0;
		public static const ACCEL:Number = 0.1;
		public static const FRICTION:Number = MAX_SPEED / (MAX_SPEED + ACCEL);
		public static const MIN_SPEED:Number = ACCEL * FRICTION;
		public static const JUMP_SPEED:Number = 5.7;
		public static const GRAVITY:Number = 0.2;
		public static const MAX_FALL:Number = 8.0;
		
		private var sprite:Spritemap;
		private var speed:Point;
		private var safeSpot:Point;
		private var jumpCounter:int;
		
		private var jumpSfx:Sfx;
		private var currentOnion:Onion;
		private var e:Entity;
		
		public function Player(x:int,y:int) 
		{
			sprite = new Spritemap(GA.WORLD_TILES, 48, 48);
			sprite.add("Idle", [22], 0);
			
			setHitbox(8, 24, 4, 24);
			sprite.originX = 24;
			sprite.originY = 48;
			
			super(x, y, sprite);
			type = "Player";
			
			speed = new Point();
			jumpCounter = 0;
			safeSpot = new Point(x, y);
			
			jumpSfx = new Sfx(GA.JUMP_SFX);
			active = false;
		}
		
		override public function added():void {
			sprite.play("Idle");
			active = true;
		}
		
		override public function update():void {
			super.update();
			
			e = collide("Solid", x, y + 1);
			if(e)
			{
				jumpCounter = 0;
				if (Input.pressed(Key.UP))
				{
					speed.y = -JUMP_SPEED;
					jumpSfx.play();
					jumpCounter++;
					squish(0.8, 1.4);
				}
				else{
					if (e.getClass() == Platform)
					{
						x = FP.clamp(x, Platform(e).x+8, Platform(e).x+40);
					}
				}
				if (e.getClass() != Platform)
				{
					safeSpot.x = x;
					safeSpot.y = y;
				}
			}
			else
			{
				speed.y += GRAVITY;

				if (speed.y > MAX_FALL)
					speed.y = MAX_FALL;
					
				if (jumpCounter <= 1 && Input.pressed(Key.UP)){
					speed.y = -JUMP_SPEED;
					jumpSfx.play();
					jumpCounter++;
					squish(0.8, 1.4);
				}
			}

			if (Input.check(Key.RIGHT))
				speed.x += ACCEL;

			if (Input.check(Key.LEFT))
				speed.x -= ACCEL;

			speed.x *= FRICTION;

			if (Math.abs(speed.x) < MIN_SPEED)
				speed.x = 0;

			moveBy(speed.x, speed.y, "Solid", true);

			x = Math.max(x, 10);

			e = collide("Solid", x + 18, y);
			if (e) {
				speed.x = -ACCEL;
			}
			
			if (collide("Solid", x, y + 1))
			{
				if (Math.abs(speed.x) > MIN_SPEED)
				{
					//sprite.play("Run");
					//sprite.rate = FP.scale(Math.abs(speed.x), 0, MAX_SPEED, 0, 1);
				}
				else
				{
					sprite.play("Idle");
					sprite.rate = 0;
				}
			}
			//else
			//	sprite.frame = 3;

			if (speed.x != 0)
				sprite.flipped = speed.x < 0; 
				
			currentOnion = Onion(collide("Onion", x, y + 1));
			if(currentOnion) {
				if (Input.check(Key.SPACE)) {
					currentOnion.pick();
				}
			}
		}
		
		public function die():void {
			if(active){
				speed.x = speed.y = 0;
				active = false;
				sprite.alpha = 0.5;
				TweenMax.to(this, 1.0, { x:safeSpot.x, y:safeSpot.y, ease:Back.easeIn, onComplete:enable } );		
			}
		}
		
		public function enable():void
		{
			sprite.alpha = 1;
			active = true;
		}
		
		public function squish(x:Number, y:Number):void{
			sprite.scaleX = x;
			sprite.scaleY = y;
			TweenMax.killTweensOf(sprite);
			TweenMax.to(sprite, 0.15, { scaleX:1, scaleY:1, ease:Cubic.easeIn } );
		}
	}

}