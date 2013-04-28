package  
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import punk.ui.PunkButton;
	import punk.ui.PunkLabel;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author Chris Cacciatore
	 */
	public class Title extends World 
	{
		private var text:PunkLabel;
		private var startText:PunkLabel;
		private var sprite:Spritemap;
		private var aboutText:PunkLabel;
		private var selectSfx:Sfx;
		private var starting:Boolean;
		
		public function Title() 
		{
			text = new PunkLabel("Onion Harvester", 89, 55);
			text.punkText.color = 0xFF0000;
			text.size = 55;
			
			startText = new PunkLabel("Press start", 220, 144);
			startText.punkText.color = 0xFFFF00;
			startText.punkText.size = 34;
			
			sprite = new Spritemap(GA.WORLD_TILES, 48, 48);
			sprite.add("idle", [21], 0);
			sprite.play("idle");
			sprite.x = 180;
			sprite.y = 120;
			
			aboutText = new PunkLabel("@cacciatc - LD#26", 220, FP.height - 34);
			aboutText.punkText.color = 0xFF0000;
			aboutText.punkText.size = 21;
			add(aboutText);
			
			addGraphic(sprite);
			add(startText);
			add(text);
			
			selectSfx = new Sfx(GA.SELECT_SFX);
			starting = false;
		}
		
		public function startGame():void{
			FP.world = new Level(GA.LEVEL1);
		}
		
		override public function update():void {
			if (Input.check(Key.ANY) && !starting) {
				selectSfx.play();
				starting = true;
				TweenMax.to(startText.punkText, 0.5, { alpha:0, yoyo:true, repeat:5, onComplete:startGame } );
				TweenMax.to(sprite, 0.5, { alpha:0, yoyo:true, repeat:5} );
			}
		}
		
	}

}