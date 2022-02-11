package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
//import com.coges.visitmanager.core.VisitSaveHelper;
import com.coges.visitmanager.events.VisitSaveEvent;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.panel.PendingPanel;
import com.coges.visitmanager.vo.PendingVisit;
import com.coges.visitmanager.vo.SearchResult;
import com.coges.visitmanager.vo.Visit.VisitActivityJSON;
import com.coges.visitmanager.vo.VisitVotePeriodID;
import nbigot.ui.control.ToolTip;
import nbigot.ui.list.BaseScrollItem;
import nbigot.ui.list.ScrollItemSelectType;
import nbigot.utils.Collection;
import nbigot.utils.DateUtils;
import nbigot.utils.ImageUtils;
import nbigot.utils.SpriteUtils;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.display.Sprite;
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
class ScrollItemPending extends BaseScrollItem<PendingVisit>
{
    public var relatedVisitItem(default, null):VisitItem;
	
    private var _line:Sprite;
    
    public function new(data:PendingVisit = null, index:Int = -1, width:Float = 120, labelField:String = "label")
    {
        super(data, index, width, labelField);
        addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
    }
    
    
    override private function _draw():Void
    {		
		ITEM_HEIGHT = 40;
		LABEL_COLOR = Colors.WHITE;
		BACKGROUND_COLOR = Colors.DARK_BLUE1;
		BACKGROUND_OVER_COLOR = Colors.DARK_BLUE2;
		BACKGROUND_SELECTED_COLOR = Colors.DARK_BLUE2;
		BORDER_COLOR = Colors.BLUE2;
		BORDER_OVER_COLOR = Colors.GREY3;
		BORDER_SELECTED_COLOR = Colors.GREY3;
		BORDER_SIZE = 0;
		
		
		if ( _data.relatedVisit.id == 0)
		{
			// NO RESULT
			
			_txtLabel = _drawLabel();
			_txtLabel.autoSize = TextFieldAutoSize.LEFT;
			_txtLabel.multiline = true;
			_txtLabel.wordWrap = true;
			var tf:TextFormat = _txtLabel.getTextFormat();
			//tf.leading = 4;
			tf.font = Fonts.OPEN_SANS;
			_txtLabel.defaultTextFormat = tf;
			_txtLabel.x = 4;
			_txtLabel.htmlText = "<b>" + _data.name + "</b>";
			_txtLabel.width = _width - 70;
			_txtLabel.y = 2;  //( ITEM_HEIGHT - _txtLabel.height ) / 2;  ;
			addChild(_txtLabel);
			
			mouseChildren = false;
			mouseEnabled = false;
		}
		else
		{
			relatedVisitItem = new VisitItem( _data.relatedVisit, _width - 30, 30, true);
			addChild( relatedVisitItem );
		}
		
		// line
		_line = new Sprite();
		_line.x = 10;
		_line.y = 50;
		
        ITEM_HEIGHT = 50; 
               
		width = _width;
    }
	
	override public function set_width(value:Float):Float 
	{
		_width = value;
		
		if ( _txtLabel != null )
			_txtLabel.width = _width - 70;
			
		if ( relatedVisitItem != null )
			relatedVisitItem.setRect( new Rectangle( 10,10, _width - 30, 30 ) );
        
		
		// line
		if ( _line != null )
		{
			SpriteUtils.drawSquare(_line, Std.int(_width) - 30, 1, BORDER_COLOR );
		}
		
		if ( _isSelected )
			_drawSelectedState();
		else
			_drawNormalState();
		
		return value;
	}
	
	
	override private function _rollOverHandler(e:MouseEvent):Void
    {
            super._rollOverHandler(e);
        if ( _data.relatedVisit.idExhibitor > 0)
        {
			
            var toolTypeText:String = "";
            
            if (_data.relatedVisit.idDemand > 0)
            {
                toolTypeText += Locale.get("FLAG_WITH_DEMAND") + " | " + _data.relatedVisit.demandPriority + "\n";
            }
            // += Locale.get("TOOLTIP_VISIT_DETAIL_DATE") + DateFormat.toText(_data.relatedVisit.dateStart, Config.LANG) + "<br>";
            //toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_FROM") + DateFormat.toShortTimeString(_data.relatedVisit.dateStart).substr(0, 5) + " " + Locale.get("TOOLTIP_VISIT_DETAIL_TO") + DateFormat.toShortTimeString(_data.relatedVisit.dateEnd).substr(0, 5) + "<br>";
            toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_DATE") + DateUtils.toText(_data.relatedVisit.dateStart, Config.LANG) + "\n";
            toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_FROM") + DateUtils.toString(_data.relatedVisit.dateStart, "hh:mm") + " " + Locale.get("TOOLTIP_VISIT_DETAIL_TO") + DateUtils.toString(_data.relatedVisit.dateEnd, "hh:mm") + "\n";
            
            if (_data.relatedVisit.idVotePeriod.length > 0)
            {  
                switch (_data.relatedVisit.idVotePeriod)
                {
                    case VisitVotePeriodID.AM:
                        toolTypeText += Locale.get("VISIT_VOTE_AM_LABEL");
                    case VisitVotePeriodID.AM_DEJ:
                        toolTypeText += Locale.get("VISIT_VOTE_AM_DEJ_LABEL");
                    case VisitVotePeriodID.PM:
                        toolTypeText += Locale.get("VISIT_VOTE_PM_LABEL");
                    case VisitVotePeriodID.PM_DEJ:
                        toolTypeText += Locale.get("VISIT_VOTE_PM_DEJ_LABEL");
                }
                if (toolTypeText.length > 0)
                {
                    toolTypeText = Locale.get("TOOLTIP_VISIT_DETAIL_VOTE_PERIOD") + toolTypeText + "\n";
                }
            }
            if (_data.relatedVisit.location != null && _data.relatedVisit.location.length > 0)
            {
                toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_LOCATION") + _data.relatedVisit.location + "\n";
            }
			
            var activityList:Collection<VisitActivityJSON> = _data.relatedVisit.visitActivityList.filter("isChecked", true);
            if (activityList != null && activityList.length > 0)
            {
                toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_ACTIVITIES") + "\n";
				for ( va in activityList )				
                {
                    toolTypeText += "- " + va.label + "\n";
                }
            }
            
            if (toolTypeText.length > 0)
            {
                ToolTip.show(toolTypeText);
            }
        }
    }
    override private function _rollOutHandler(e:MouseEvent):Void
    {
            super._rollOutHandler(e);
        if ( _data.relatedVisit.idExhibitor > 0)
        {
            if (ToolTip.exists)
            {
                ToolTip.hide();
            }
        }
    }
   
	
    
    private function _mouseDownHandler(e:MouseEvent):Void
    {
        if ( relatedVisitItem.flaggedForRemove )
        {
			_selectType = ScrollItemSelectType.DELETE;
			
			//FIX: all delete logic has been moved to PendingPanel
			/*
			if ( relatedVisitItem.hasEventListener(VisitSaveEvent.REMOVE) )
				relatedVisitItem.removeEventListener(VisitSaveEvent.REMOVE, _removeVisitItemHandler);
            relatedVisitItem.addEventListener(VisitSaveEvent.REMOVE, _removeVisitItemHandler);
            relatedVisitItem.askForRemoveVisit();*/
			return;
        }
		_selectType = ScrollItemSelectType.SELECT;
    }
    
	//FIX: all delete logic is moved to PendingPanel
	/*
    private function _removeVisitItemHandler(e:VisitSaveEvent):Void
    {
		// authorization for removing already handled in VisitItem.askForRemoveVisit()     
		
		VisitSaveHelper.instance.removeVisit(relatedVisitItem.data);
       
        PendingPanel.instance.updatePendingList();
    } */
	
}
