package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Chris Cacciatore
	 */
	public class Onion extends Entity 
	{
		private var sprite:Spritemap;
		private var picked:Boolean;
		private var pickSfx:Sfx;
		
		public function Onion(x:int,y:int) 
		{
			sprite = new Spritemap(GA.WORLD_TILES, 48, 48);
			sprite.add("idle", [18], 0);
			sprite.add("pick", [19, 20, 21], 5, false);
			type = "Onion";
			setHitboxTo(sprite);
			super(x, y, sprite);
			picked = false;
			
			pickSfx = new Sfx(GA.ONION_SFX);
		}
		
		override public function added():void {
			sprite.play("idle");
		}
		
		public function pick():void {
			if (!picked) {
				Level.currentOnions += 1;
				picked = true;
				var targetY:Number = y - height*2;
				sprite.play("pick");
				TweenMax.to(sprite, 1.5, { y: -targetY, ease:Cubic.easeIn, onComplete:onComplete } );
				TweenMax.to(sprite, 1.0, { alpha: 0, ease:Cubic.easeIn } );
				pickSfx.play();
			}
		}
		
		public function onComplete():void {
			FP.world.remove(this);
		}
	}

}