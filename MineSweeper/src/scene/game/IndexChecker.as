package scene.game
{
	import flash.geom.Point;

	public class IndexChecker
	{
		/** 자기 자신 포함 십자 모양*/
		public static const CROSS:Vector.<Point> = Vector.<Point>([new Point(-1, 0), new Point(1, 0), new Point(0, -1), new Point(0, 1), new Point(0, 0)]);
		
		/** 자기 자신 미포함 사각 모양*/
		public static const SQUARE:Vector.<Point> = Vector.<Point>([new Point(-1, -1), new Point(-1, 0), new Point(-1, 1), new Point(0, -1), new Point(0, 0), new Point(0, 1), new Point(1, -1), new Point(1, 0), new Point(1, 1)]);
	}
}