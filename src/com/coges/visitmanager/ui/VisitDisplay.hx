package com.coges.visitmanager.ui;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.vo.Country;
import com.coges.visitmanager.vo.User;
import com.coges.visitmanager.vo.UserType;
import com.coges.visitmanager.vo.Visit;
import com.coges.visitmanager.vo.VisitStatus;
import com.coges.visitmanager.vo.VisitStatusID;
import nbigot.utils.SpriteUtils;
import nbigot.utils.TextFieldUtils;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author Nicolas Bigot
 */
class VisitDisplay extends Sprite
{
	var _background:Sprite;
	var _data:Visit;
	var _width:Float;
	var _height:Float;
	var _btRemovePreservedSpace:Int;
	var _status:VisitStatus;
	var _txtVisit:TextField;
	var _txtLocation:TextField;
	var _iconFlag:DisplayObject;
	var _iconLocked:DisplayObject;
	var _localizationString:String;

	public function new( data:Visit , width:Float, height:Float, btRemovePreservedSpace:Int = 0 )
	{
		super();
		//mouseEnabled = false;
		mouseChildren = false;
		
		_data = data;
		_width = width;
		_height = height;
		_btRemovePreservedSpace = btRemovePreservedSpace;
		
		_background = new Sprite();
		addChild( _background );		
		
		//ASK: this status is never saved ?
        _status = VisitStatus.getVisitStatusByID(data.idStatus);
        if (_status.id == VisitStatusID.ACCEPTED)
        {
            if (data.isFrenchExhibitor)
            {
                _status = VisitStatus.getVisitStatusByID(VisitStatusID.ACCEPTED_FRANCE);
            }
        }
        if (_status.id == VisitStatusID.LOCKED)
        {
            if (data.idSpecialVisit > 0)
            {
                _status = VisitStatus.getVisitStatusByID(VisitStatusID.LOCKED_OFFICIAL);
            }
        }
		
		
        _txtVisit = _getLabel( 9, Colors.BLACK, true );
		//2022-evolution
		if ( User.instance.type == UserType.PROGRAMMEUR )
		{
			if ( _data.exhibitorIsSensitive )
				_txtVisit = _getLabel( 9, Colors.RED3, true );
		}
		
        addChild(_txtVisit);
		
		_localizationString = "";
        
        if (!_data.isSpecialVisit)
        {
            var iLoc:Int = _data.location.toLowerCase().indexOf("hall");
            if (iLoc != -1)
            {
                _localizationString = "H" + _data.location.substr(iLoc + 5, 1);
            }
            iLoc = _data.location.toLowerCase().indexOf("ext");
            if (iLoc != -1)
            {
                _localizationString = "EXT";
            }
            
            if (_localizationString.length > 0)
            {
                _txtLocation = _getLabel( 9, Colors.BLACK, true );
                _txtLocation.autoSize = TextFieldAutoSize.LEFT;
				addChild( _txtLocation );
            }
        }
        
        var c:Country = _data.exhibitorCountry;
        if (c != null)
        {
            _iconFlag = c.flag16;
            addChild(_iconFlag);
        }
        
		
        if (_data.isLocked)
        {
            _iconLocked = Icons.getIcon(Icon.LOCKED_VISIT);
            addChild(_iconLocked);
        }
		
		_draw();
	}
	
	function _draw() 
	{
		SpriteUtils.drawRoundSquare( _background, Std.int(_width), Std.int(_height), 4, 4, _status.colorLight, 1, _status.colorDark );
		
		var paddingV = 4;
		if ( _background.height <= 20 ) paddingV = 0;
		var paddingH = 4;
		
        var labelX:Float = paddingH;
        var labelWidth = _width - _btRemovePreservedSpace - paddingH;
		
		// client edit: the reserved space for location is always applied
		/*
		if ( _txtLocation != null )
		{
			_txtLocation.text = _localizationString;
			labelWidth -= _txtLocation.width;
			labelX += _txtLocation.width;
		}
		*/	
		
		labelWidth -= 18;
		labelX += 18;
		if ( _localizationString == "EXT" )
		{
			labelWidth -= 4;
			labelX += 4;
		}
		if ( _txtLocation != null )
		{
			_txtLocation.x = paddingH;
			_txtLocation.y = paddingV;
			_txtLocation.text = _localizationString;
		}
		// end client edit
        
		if ( _iconFlag != null )
		{
            _iconFlag.x = labelX;
            _iconFlag.y = paddingV;
            labelWidth -= _iconFlag.width + 2;
            labelX += _iconFlag.width + 2;
			
		}
		
        if (_iconLocked != null)
        {
            labelWidth -= (_iconLocked.width + 2);
            _iconLocked.x = labelX + labelWidth + 2;
            _iconLocked.y = paddingV;
        }
        
        _txtVisit.x = labelX;
        _txtVisit.y = paddingV;
        _txtVisit.width = labelWidth;
        
		var label:String =  _data.name;
		if ( _data.idDemand > 0 ) label = "* " + label;
        _txtVisit.text = TextFieldUtils.getAdaptedLabel(_txtVisit, label);
        
        _txtVisit.height = _background.height - 2;
	}
	
	
	
    private function _getLabel( textSize:Int, textColor:Int, bold:Bool = false ):TextField
    {
        var t:TextField = new TextField();
        var tf:TextFormat = new TextFormat();
        tf.font = Fonts.OPEN_SANS;
        tf.bold = bold;
        tf.color = textColor;
        tf.size = textSize;
        t.selectable = false;
        t.mouseEnabled = false;
        t.embedFonts = true;
        //t.wordWrap = true;
        //t.multiline = true;
        t.antiAliasType = AntiAliasType.ADVANCED;
        //t.autoSize = TextFieldAutoSize.LEFT;
        t.defaultTextFormat = tf;
        
        //t.borderColor = 0xff0000;
        //t.border = true;
        return t;
    }
	
	public function setSize( width:Float, height:Float ):Void
	{
		if ( width != _width || height != _height )
		{
			_width = width;
			_height = height;
			
			_draw();			
		}
	}
}
