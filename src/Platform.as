package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	/**
	 * ...
	 * @author Chris Cacciatore
	 */
	public class Platform extends Entity 
	{
		private static const DX:Number = 4.0*48;
		private var sprite:Spritemap;
		
		public function Platform(x:int,y:int) 
		{
			sprite = new Spritemap(GA.WORLD_TILES, 48, 48);
			sprite.add("idle",[24],0);
			sprite.play("idle");
			
			super(x, y, sprite);
			setHitboxTo(sprite);
			type = "Solid";
		}
		
		
		override public function added():void {
			toRight();
		}
		
		override public function update():void {
			super.update();
		}
		
		public function toRight():void {
			TweenMax.to(this, 4.5, { x:x + DX, onComplete:toLeft, ease:Cubic.easeInOut } );
		}
		
		public function toLeft():void {
			TweenMax.to(this, 4.5, { x:x - DX, onComplete:toRight,ease:Cubic.easeInOut } );
		}
		
	}

}