package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.vo.SearchResult;
import nbigot.ui.list.BaseScrollItem;
import nbigot.ui.list.ScrollItemSelectType;
import nbigot.utils.ImageUtils;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.MouseEvent;
import openfl.filters.DropShadowFilter;
import openfl.geom.Rectangle;
import openfl.net.URLRequest;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ScrollItemResult extends BaseScrollItem<SearchResult>
{

    private var _iconLocalization:DisplayObject;
    private var _iconTriangles:Bitmap;    
    
    public function new(data:Dynamic = null, index:Int = -1, width:Float = 120, labelField:String = "label")
    {
        super(data, index, width, labelField);
        addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
    }
    
    
    override private function _draw():Void
    {
		/*
        NORMAL_COLOR = 0xdddddd;
        OVER_COLOR = 0x91CDF7;
        LABEL_COLOR = 0x000000;
        BORDER_COLOR = 0x666666;
		*/
		
		ITEM_HEIGHT = 40;
		LABEL_COLOR = Colors.BLACK;
		BACKGROUND_COLOR = Colors.GREY1;
		BACKGROUND_OVER_COLOR = Colors.GREY2;
		BACKGROUND_SELECTED_COLOR = Colors.GREY2;
		BORDER_COLOR = Colors.GREY2;
		BORDER_OVER_COLOR = Colors.GREY3;
		BORDER_SELECTED_COLOR = Colors.GREY3;
		BORDER_SIZE = 0;
		
        _txtLabel = _drawLabel();
        _txtLabel.multiline = true;
        _txtLabel.wordWrap = true;
        _txtLabel.border = true;
        var tf:TextFormat = _txtLabel.getTextFormat();
        //tf.leading = 4;
		tf.font = Fonts.OPEN_SANS;
        _txtLabel.defaultTextFormat = tf;
        _txtLabel.x = 4;
        var widthLabel:Float = _width - 70;
        if (_data != null)
        {
			
			var text:String = "<b>" + _data.exhibitorCompanyName + "</b>";
            
            if (_data.idExhibitor > 0)
            {
				if ( _data.exhibitorCountry != null )
				{
					var iconCountry:DisplayObject = _data.exhibitorCountry.flag16;
					if (iconCountry != null)
					{
						addChild(iconCountry);
						iconCountry.x = iconCountry.y = 2;
						_txtLabel.x += iconCountry.width;
						widthLabel -= iconCountry.width;
					}
				}
                
                /*
                trace("_data.exhibitorCompanyName:" + _data.exhibitorCompanyName);
                trace("_data.exhibitorWelcomeStand:" + _data.exhibitorWelcomeStand);
                trace("_data.idDemand:" + _data.idDemand);
                trace("_data.demandSlotDuration:" + _data.demandSlotDuration);
                trace("_data.demandSlotDay:" + _data.demandSlotDay);
                trace("----------------------------------------");*/
                
                text += "<br><font size='11'>";
                //var tf:TextFormat = _txtLabel.getTextFormat();
                //tf.leading = 4;
                //var index:Int = as3hx.Compat.parseInt(_txtLabel.length - 1);
                
                if (_data.idDemand != 0)
                {
                    text += _data.demandPriority + " | ";
                    if ( _data.demandSlotDay != null )
                    {
                        text += _data.demandSlotDay.label + " ";
                    }
                    if ( _data.demandSlotDuration != null )
                    {
                        text += _data.demandSlotDuration.label + " | ";
                    }
                }
                
                text += _data.exhibitorWelcomeStand + "</font>";
                _txtLabel.htmlText = text;
                //_txtLabel.setTextFormat(tf, index);
                
                _iconLocalization = Icons.getIcon(Icon.LOCALIZATION);
                if (_iconLocalization != null)
                {
                    var shadow:DropShadowFilter = new DropShadowFilter(1, 90, 0, 0.6, 6, 6);
                    _iconLocalization.filters = [shadow];
                    addChild(_iconLocalization);
                    ImageUtils.center(_iconLocalization, new Rectangle(_width - 60, 4, _iconLocalization.width, ITEM_HEIGHT - 4));
                }
                
                if (_data.urlTrianglesIcon.length > 0)
                {
                    var l:Loader = new Loader();
                    l.contentLoaderInfo.addEventListener(Event.COMPLETE, _trianglesIconCompleteHandler);
                    l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _trianglesIconErrorHandler);
                    l.load(new URLRequest(Config.trianglesFolderURL + _data.urlTrianglesIcon));
                }
            }
            else
            {
                mouseChildren = false;
                mouseEnabled = false;
            }
        }
        _txtLabel.width = _width - 70;
        
        ITEM_HEIGHT = Math.round(height + 10);
        
        _txtLabel.y = 2;  //( ITEM_HEIGHT - _txtLabel.height ) / 2;  ;
        addChild(_txtLabel);
		
		graphics.beginFill( BORDER_COLOR );
		graphics.drawRect( 0, ITEM_HEIGHT - 2, _width, 2 );
		graphics.endFill();
    }
	
	override public function set_width(value:Float):Float 
	{
		//super.set_width( value);
		
		_width = value;
        _txtLabel.width = _width - 70;
		
        
        ITEM_HEIGHT = Math.round(height + 10);
		
		graphics.beginFill( BORDER_COLOR );
		graphics.drawRect( 0, ITEM_HEIGHT - 2, _width, 2 );
		graphics.endFill();
		
		
		return value;
	}
    
    private function _trianglesIconErrorHandler(e:IOErrorEvent):Void
    {
        trace(e.text);
    }
    
    private function _trianglesIconCompleteHandler(e:Event):Void
    {
        var l:Loader = cast((e.target), LoaderInfo).loader;
        _iconTriangles = try cast(addChild(l.content), Bitmap) catch(e:Dynamic) null;
        ImageUtils.fitIn(_iconTriangles, new Rectangle(_width - 35, 0, 20, ITEM_HEIGHT));
    }
    
    override private function _rollOverHandler(e:MouseEvent):Void
    {
        if ( _data.idExhibitor > 0)
        {
            super._rollOverHandler(e);
        }
    }
    override private function _rollOutHandler(e:MouseEvent):Void
    {
        if (_data.idExhibitor > 0)
        {
            super._rollOutHandler(e);
        }
    }
    
    private function _mouseDownHandler(e:MouseEvent):Void
    {
        if (_iconLocalization != null && _iconLocalization.hitTestPoint(stage.mouseX, stage.mouseY))
        {
            _selectType = ScrollItemSelectType.VIEW;
            return;
        }
        if (_iconTriangles != null && _iconTriangles.hitTestPoint(stage.mouseX, stage.mouseY))
        {
            _selectType = ScrollItemSelectType.EXPORT;
            return;
        }
        _selectType = ScrollItemSelectType.SELECT;
    }
}

