package  
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import punk.ui.PunkButton;
	import punk.ui.PunkLabel;
	
	/**
	 * ...
	 * @author Chris Cacciatore
	 */
	public class EndGame extends World 
	{
		private var img:Image;
		private var minSoup:PunkLabel;
		
		public function EndGame() 
		{
			img = new Image(GA.END);
			img.x -= 30;
			addGraphic(img);
			FP.screen.color = 0xFFFFFF;
			
			minSoup = new PunkLabel("You now have enough onions for a \nminimalism soup....\n\n\nThanks for playing!\n- @cacciatc", 170, 55);
			minSoup.punkText.color = 0;
			minSoup.punkText.size = 21;
			add(minSoup);
		}
		
	}

}