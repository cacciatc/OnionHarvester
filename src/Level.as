package  
{
	import com.greensock.loading.core.LoaderItem;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import org.flashdevelop.utils.FlashConnect;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import punk.ui.PunkLabel;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	/**
	 * ...
	 * @author Chris Cacciatore
	 */
	public class Level extends World 
	{
		private var backgroundTiles:Tilemap;
		private var foregroundTiles:Tilemap;
		private var width:int;
		private var height:int;
		private var boundaries:Grid;
		private var player:Player;
		
		private var timeText:PunkLabel;
		private var onionText:PunkLabel;
		public static var currentOnions:int;
		private var timer:Number;
		private var done:Boolean;
		
		private var levelDone:PunkLabel;
		
		private var onionGUI:Spritemap;
		private var music:Sfx;
		private var currentLevel:Class;
		
		public function Level(level:Class) 
		{
			var tileMap:XML = FP.getXML(level);
			var layer:XML;
			var tile:XML;
		
			currentLevel = level;
			
			width = int(tileMap.@tileswide)*48;
			height = int(tileMap.@tileshigh)*48;
			
			backgroundTiles = new Tilemap(GA.WORLD_TILES, width, height, 48, 48);
			foregroundTiles = new Tilemap(GA.WORLD_TILES, width, height, 48, 48);
			boundaries = new Grid(width, height, 48, 48);
			
			GV.onionCount = 0;
			
			for each(layer in tileMap.layer) { 
				for each(tile in layer.tile) {
					if (layer.@number == 0) {
						if(int(tile.@index) >= 0){
							backgroundTiles.setTile(int(tile.@x), int(tile.@y), int(tile.@index));
							
							// sloppy, but will do.
							if (tile.@index == "0" || tile.@index == "1" || tile.@index == "8" || tile.@index == "11" || tile.@index == "12"
								|| tile.@index == "13" || tile.@index == "10" || tile.@index == "7") {
								boundaries.setTile(int(tile.@x), int(tile.@y), true);
							}
							else {
								boundaries.setTile(int(tile.@x), int(tile.@y), false);
							}
							
							if (tile.@index == '24') {
								add(new Platform(int(tile.@x) * 48, int(tile.@y) * 48));
								backgroundTiles.setTile(int(tile.@x), int(tile.@y), 5);	
							}
						}
					}
					else if (layer.@number == 1) {
						if (int(tile.@index) >= 0 && tile.@index != '24') {
							foregroundTiles.setTile(int(tile.@x), int(tile.@y), int(tile.@index));
						}
						
						if (int(tile.@index == 22)) {
							player = new Player(int(tile.@x) * 48, int(tile.@y) * 48);
							add(player);
							foregroundTiles.setTile(int(tile.@x), int(tile.@y), 23);
						}
						
						if (tile.@index == '18') {
							GV.onionCount += 1;
							add(new Onion(int(tile.@x) * 48, int(tile.@y) * 48));
							foregroundTiles.setTile(int(tile.@x), int(tile.@y), 23);	
						}
					}
				}
			}
			addMask(boundaries, "Solid");
			addGraphic(backgroundTiles, 10);
			addGraphic(foregroundTiles, 0);
			
			if(level == GA.LEVEL1){
				GV.timeLeft = 60;
			}
			else if (level == GA.LEVEL2) {
				GV.timeLeft = 90;
			}
			timer = 0.0;
			currentOnions = 0;
			
			timeText = new PunkLabel(Sprintf.format("%03d",[GV.timeLeft]), 8, 8,1,1);
			timeText.size = 21;
			timeText.collidable = false;
			timeText.punkText.color = 0;
			add(timeText);
			
			onionText = new PunkLabel(Sprintf.format("%d / %d",[currentOnions, GV.onionCount]), 89, 8,1,1);
			onionText.size = 21;
			onionText.collidable = false;
			onionText.punkText.color = 0;
			add(onionText);
			
			onionGUI = new Spritemap(GA.WORLD_TILES, 48, 48);
			onionGUI.add("idle", [21], 0);
			onionGUI.play("idle");
			onionGUI.x = 50;
			onionGUI.scale = 0.75;
			onionGUI.y = -10;
			addGraphic(onionGUI);
			
			done = false;
			
			music = new Sfx(GA.MUSIC);
			music.loop();
		}
		
			
		override public function update():void {
			super.update();
			camera.x += (FP.clamp(player.x - FP.halfWidth, 0, width - FP.width) - camera.x) * 0.1;
			
			if (player.y >= FP.height+48) {
				player.die();
			}
			
			timer += FP.elapsed;
			if (timer > 1 && !done) {
				GV.timeLeft -= 1;
				timer = 0.0;
			}
			timeText.text = Sprintf.format("%03d", [GV.timeLeft]);
			timeText.x = Math.ceil(camera.x + 8);
			
			onionText.text = Sprintf.format("%d/%d", [currentOnions, GV.onionCount]);
			onionText.x = Math.ceil(camera.x + 89);
			onionGUI.x = camera.x + 60;
			
			if (currentOnions == GV.onionCount && !done) {
			//if(!done){
				done = true;
				levelDone = new PunkLabel("Level complete!", camera.x + FP.halfWidth - 130, 120 );
				levelDone.punkText.color = 0;
				levelDone.punkText.size = 34;
				levelDone.layer = -1;
				levelDone.punkText.scale = 0.01;
				TweenMax.to(levelDone.punkText, 2.0, { scale:1, onComplete:bounce } );
				add(levelDone);
			}
			
			if (GV.timeLeft <= 0  && !done) {
			//if(!done){
				done = true;
				levelDone = new PunkLabel("Out of time...", camera.x + FP.halfWidth - 130, 120 );
				levelDone.punkText.color = 0;
				levelDone.punkText.size = 34;
				levelDone.layer = -1;
				levelDone.punkText.scale = 0.01;
				levelDone.punkText.scale = 0.01;
				TweenMax.to(levelDone.punkText, 2.0, { scale:1});
				FP.alarm(300, backToTitle);
				add(levelDone);
			}
			
			if (levelDone) {
				levelDone.x = camera.x + FP.halfWidth - 130;
			}
		}	
		
		public function bounce():void {
			TweenMax.to(levelDone.punkText, 1.0, { scale:0.5, yoyo:true, repeat:5, ease:Back.easeIn,onComplete:nextLevel } );
		}
		public function nextLevel():void {
			music.stop();
			if (currentLevel == GA.LEVEL1) {
				FP.world = new Level(GA.LEVEL2);
			}
			else if (currentLevel == GA.LEVEL2) {
				FP.world = new EndGame();
			}
		}
		public function backToTitle():void {
			music.stop();
			FP.world = new Title();
		}
	}

}