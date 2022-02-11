package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.vo.SearchResult;
import haxe.ui.core.ItemRenderer;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import openfl.display.DisplayObject;
import openfl.events.Event;

/**
 * ...
 * @author 
 */

@:xml('
<itemrenderer width="100%">
	<style>
		.scroll .inc, .scroll .deinc { 
			hidden: true;
		}
		.vertical-scroll {
			opacity: .5;
			width: 12px;
			padding: 0px;
			background-color: none;
		}
		.vertical-scroll .thumb {
			width: 12px;
			min-height:60px;
			border-radius: 4px;
		}
	</style>
	<hbox id="mainHbox" width="100%">
		<image id="icon2" style="vertical-align:top" />
		<vbox width="100%" style="vertical-align:center;">
			<label id="lblName" width="100%" style="font-name:Open Sans; font-size:14px" />
			<label id="lblDemand" width="100%" style="font-name:Open Sans; font-size:11px" />
		</vbox>
		<button id="btAction" text="Action" style="vertical-align:center;" />
	</hbox> 
</itemrenderer>
')
class VMHaxeUIItemRendererResult extends ItemRenderer
{
	public var selectType:String;
	
	

	public function new() 
	{
		super();
		
		
		/*
		btAction.onClick = _btActionClickHandler;
		onClick = _ClickHandler;
		onChange = _changeHandler;*/
		
		/*
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
		*/
		/*
		lblName.customStyle.fontName = Fonts.OPEN_SANS;
		lblName.customStyle.fontSize = 14;
		
		lblDemand.customStyle.fontName = Fonts.OPEN_SANS;
		lblDemand.customStyle.fontSize = 11;*/
		
        registerEvent(MouseEvent.MOUSE_DOWN, _onItemMouseDown2);
	}
	
	
	override private function validateComponentData():Void
	{
		super.validateComponentData();
		//TODO: investigate why code below is ignored if we do super.validateComponentData()
		
		var sr:SearchResult = cast( data, SearchResult);
		if ( sr != null)
		{
			 if (sr.idExhibitor > 0)
            {
				if ( sr.exhibitorCountry != null )
				{
					var iconCountry:DisplayObject = sr.exhibitorCountry.flag16;
					if (iconCountry != null)
					{
						mainHbox.addChild(iconCountry);
						iconCountry.x = iconCountry.y = 2;
					}
				}
			}
				
				
			lblName.text = sr.exhibitorCompanyName;
			lblDemand.htmlText = "<b>Ahahahahah</b>hfdsh shdkj hskd";
		}
	}
	
	
	/*
	function _btActionClickHandler(e:MouseEvent) 
	{
		trace( "TestItemRenderer._btActionClickHandler > e : " + e );
		if ( e.target == btAction)
			e.cancel();
		dispatchEvent( new Event( Event.SELECT ) );
	}
	
	function _ClickHandler(e:MouseEvent) 
	{
		trace( "TestItemRenderer._ClickHandler > e : " + e );
	}
	
	function _changeHandler(e:UIEvent) 
	{
		trace( "TestItemRenderer._changeHandler > e : " + e );
	}*/
	
	function _onItemMouseDown2(e:MouseEvent) 
	{
		//trace( "TestItemRenderer._onItemMouseDown > e : " + e._originalEvent.target );
		if ( e._originalEvent.target == btAction )
		{
			selectType = "SELECT ACTION";
		}else{
			selectType = "SELECT ITEM";
		}
		//*dispatch( new UIEvent( UIEvent.CHANGE, true ) );
		dispatchEvent( new Event( Event.CHANGE,false ) );
		e.cancel();
	}
	
}