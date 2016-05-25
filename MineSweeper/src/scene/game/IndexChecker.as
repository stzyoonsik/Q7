package scene.game
{
	import flash.geom.Point;

	public class IndexChecker
	{
		public static const CROSS:Vector.<Point> = Vector.<Point>([new Point(-1, 0), new Point(1, 0), new Point(0, -1), new Point(0, 1), new Point(0, 0)]);
		public static const SQUARE:Vector.<Point> = Vector.<Point>([new Point(-1, -1), new Point(-1, 0), new Point(-1, 1), new Point(0, -1), new Point(0, 0), new Point(0, 1), new Point(1, -1), new Point(1, 0), new Point(1, 1)]);
	}
}