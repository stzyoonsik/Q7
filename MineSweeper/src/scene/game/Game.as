package scene.game
{	
	import starling.display.Sprite;
	
	public class Game extends Sprite
	{
		private var _board:Board;
		public function Game()
		{
			_board = new Board(10, 10, 10);
			addChild(_board);
		}
	}

}