package  
{
	import net.flashpunk.FP;
	import net.flashpunk.Engine;
	/**
	 * ...
	 * @author Chris Cacciatore
	 */
	public class Main extends Engine
	{
		public function Main() {
			super(64 * 10, 288, 60, true);
			FP.world = new Title();
		}
	}
}