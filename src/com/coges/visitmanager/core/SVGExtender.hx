package com.coges.visitmanager.core;
import format.SVG;
import openfl.display.Shape;

/**
 * ...
 * @author Nicolas Bigot
 */
class SVGExtender 
{

	static public function renderAsShape( svg:SVG, ?width:Int, ?height:Int ):Shape
	{
		var shape = new Shape();
		var ratio:Float;
		if ( width == null && height == null )
		{
			//ratio from Inkscape to convert mm into pixel.
			//since Inkscape SVG saves size in mm
			ratio = 0.26458;
			width = Math.round(svg.data.width / ratio);
			height = Math.round(svg.data.height / ratio);
		}else if (width == null)
		{
			ratio = svg.data.width / svg.data.height;
			width = Math.round(height * ratio);
		}else if (height == null)
		{
			ratio = svg.data.height / svg.data.width;
			height = Math.round(width * ratio);
		}
		svg.render( shape.graphics, 0, 0, width, height );
		return shape;
	}
	
}