package com.coges.visitmanager.ui;

import com.coges.visitmanager.fonts.Fonts;
import nbigot.ui.control.Label;
import nbigot.utils.SpriteUtils;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;

/**
 * ...
 * @author Nicolas Bigot
 */
class DummyPanel extends Sprite 
{
	private var _l:Label;
	private var _lSize:Label;
	private var _bg:Sprite;
	private var _border:Sprite;
	
	public function new( label:String, color:Int = 0xcccccc, ?width:Int, ?height:Int) 
	{
		super();
		
		
		_bg = SpriteUtils.createSquare(50, 50, color);
		addChild( _bg );
		
		_l = new Label( label, new TextFormat( Fonts.OPEN_SANS, 14, 0, true ) );
		_l.x = 4;
		_l.y = 2;
		addChild(_l);
		
		_lSize = new Label( "", new TextFormat( Fonts.OPEN_SANS, 12 ) );
		_lSize.x = 4;
		_lSize.y = _l.y + _l.height;
		addChild(_lSize);
		
		_border = new Sprite();
		addChild( _border );
		
		_drawBorder();
		_updateSizeLabel();
	}
	
	function _updateSizeLabel() 
	{
		_lSize.setText( "x:"+ x + " - y:" + y + " - size:" + _bg.width + " x " + _bg.height  );
	}
	
	function _drawBorder() 
	{
		_border.graphics.clear();
		_border.graphics.lineStyle(1, 0, 0.8);
		_border.graphics.drawRect( 0, 0, _bg.width, _bg.height);		
	}
	
	
	override public function set_width( value:Float ):Float
	{
		_bg.width = value;
		_drawBorder();
		_updateSizeLabel();		
		
		return value;
	}
	override public function get_width():Float
	{
		return _bg.width;
	}
	override public function set_height( value:Float ):Float
	{
		_bg.height = value;
		_drawBorder();
		_updateSizeLabel();
		
		return value;
	}
	override public function get_height():Float
	{		
		return _bg.height;
	}
	
	public function setRect( rect:Rectangle)
	{
		x = rect.x;
		y = rect.y;
		
		_bg.width = rect.width;
		_bg.height = rect.height;
		
		_drawBorder();
		_updateSizeLabel();
	} 
}