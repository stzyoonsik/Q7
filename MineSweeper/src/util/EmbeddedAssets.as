package util
{
	public class EmbeddedAssets
	{
		// Game Texture
		[Embed(source="../assets/GameSprite.png")]
		public static const GameSprite:Class;
		
		// Game XML
		[Embed(source="../assets/GameXml.xml", mimeType="application/octet-stream")]
		public static const GameXml:Class;
	}
}