package util
{
	public class EmbeddedAssets
	{
		// Game Texture
		[Embed(source="../assets/Game_SpriteSheet.png")]
		public static const Game_SpriteSheet:Class;
		
		// Game XML
		[Embed(source="../assets/Game_xml.xml", mimeType="application/octet-stream")]
		public static const Game_Xml:Class;
	}
}