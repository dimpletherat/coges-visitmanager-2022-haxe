package com.coges.visitmanager.ui;

import com.coges.visitmanager.core.Icons;
import motion.Actuate;
import motion.easing.Linear;
import openfl.display.Bitmap;
import openfl.display.Sprite;

/**
 * ...
 * @author Nicolas Bigot
 */
class WaitWheel extends Sprite 
{

	public function new( rotationSpeed:Int = 1 ) 
	{
		super();
		var bd = cast(Icons.getIcon(Icon.WAIT_WHEEL), Bitmap) ;
		bd.x = - bd.width * 0.5;
		bd.y = - bd.height * 0.5;
		addChild( bd);
		
		Actuate.tween( this, rotationSpeed, {rotation:357} ).ease(Linear.easeNone).repeat();
	}
	
}