package;
import kha.Assets;
import kha.Font;

class DefaultFont {

	static var font:Font;

	public static function get():Font {
		if (font == null) font = Assets.fonts.get('square');
		return font;
	}

}
