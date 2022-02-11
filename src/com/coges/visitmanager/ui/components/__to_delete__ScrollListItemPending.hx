package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.Debug;
import com.coges.visitmanager.events.VisitSaveEvent;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.ui.panel.PendingPanel;
import com.coges.visitmanager.ui.VisitItem;
import com.coges.visitmanager.core.VisitSaveHelper;
import com.coges.visitmanager.vo.PendingVisit;
import com.coges.visitmanager.vo.Visit.VisitActivityJSON;
import com.coges.visitmanager.vo.remote.VisitActivityVO;
import com.coges.visitmanager.vo.SearchResult;
import com.coges.visitmanager.vo.FlagIconSize;
import com.coges.visitmanager.vo.Icon;
import com.coges.visitmanager.vo.VisitVotePeriodID;
import nbigot.ui.control.ToolTip;
import nbigot.utils.Collection;
import nbigot.utils.DateUtils;
import nbigot.utils.ImageUtils;
import com.coges.visitmanager.core.Locale;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.net.URLRequest;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ScrollListItemPending extends ScrollListItem
{
    public var selectType(get, never):Int;
    public var relatedVisitItem(get, never):VisitItem;

    //private var _iconRemove:DisplayObject;
    private var _selectType:Int = -1;
    private var _relatedVisitItem:VisitItem;
    private function get_selectType():Int
    {
        return _selectType;
    }
    
    private function get_relatedVisitItem():VisitItem
    {
        return _relatedVisitItem;
    }
    
    
    public function new(data:Dynamic = null, index:Int = -1, width:Float = 120, labelField:String = "label")
    {
        super(data, index, width, labelField);
        NORMAL_COLOR = 0xdddddd;
        OVER_COLOR = 0x91CDF7;
        LABEL_COLOR = 0x000000;
        BORDER_COLOR = 0x666666;
        
        addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
    }
    
    
    override private function draw():Void
    {
        var e:PendingVisit = try cast(_data, PendingVisit) catch(e:Dynamic) null;
        if (e != null)
        {
            if (e.relatedVisit.id == 0)
            {
				// NO RESULT
                
                _txtLabel = drawLabel();
                _txtLabel.autoSize = TextFieldAutoSize.LEFT;
                _txtLabel.multiline = true;
                _txtLabel.wordWrap = true;
                _txtLabel.x = 4;
                _txtLabel.htmlText = "<b>" + e.name + "</b>";
                _txtLabel.width = _width - 70;
                
                mouseChildren = false;
                mouseEnabled = false;
            }
            else
            {
                _relatedVisitItem = try cast(addChild(new VisitItem(e.relatedVisit, _width - 30, 20, true)), VisitItem) catch(e:Dynamic) null;
                _relatedVisitItem.x = 10;
                _relatedVisitItem.y = 10;
            }
        }
        
        
        
        
        ITEM_HEIGHT = as3hx.Compat.parseInt(height + 20);
    }
    
    override private function _rollOverHandler(e:MouseEvent):Void
    {
        if (cast((_data), PendingVisit).relatedVisit.idExhibitor > 0)
        {
            super._rollOverHandler(e);
            
            
            
            var toolTypeText:String = "";
            var pv:PendingVisit = try cast(_data, PendingVisit) catch(e:Dynamic) null;
            
            if (pv.relatedVisit.idDemand > 0)
            {
                toolTypeText += Locale.get("FLAG_WITH_DEMAND") + " | " + pv.relatedVisit.demandPriority + "<br>";
            }
            // += Locale.get("TOOLTIP_VISIT_DETAIL_DATE") + DateFormat.toText(pv.relatedVisit.dateStart, Config.LANG) + "<br>";
            //toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_FROM") + DateFormat.toShortTimeString(pv.relatedVisit.dateStart).substr(0, 5) + " " + Locale.get("TOOLTIP_VISIT_DETAIL_TO") + DateFormat.toShortTimeString(pv.relatedVisit.dateEnd).substr(0, 5) + "<br>";
            toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_DATE") + DateUtils.toText(pv.relatedVisit.dateStart, Config.LANG) + "<br>";
            toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_FROM") + DateUtils.toString(pv.relatedVisit.dateStart, "hh:mm") + " " + Locale.get("TOOLTIP_VISIT_DETAIL_TO") + DateUtils.toString(pv.relatedVisit.dateEnd, "hh:mm") + "<br>";
            
            if (pv.relatedVisit.idVotePeriod.length > 0)
            {
                var _sw0_ = (pv.relatedVisit.idVotePeriod);                

                switch (_sw0_)
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
                    toolTypeText = Locale.get("TOOLTIP_VISIT_DETAIL_VOTE_PERIOD") + toolTypeText + "<br>";
                }
            }
            if (pv.relatedVisit.location && pv.relatedVisit.location.length > 0)
            {
                toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_LOCATION") + pv.relatedVisit.location + "<br>";
            }
            //var va:VisitActivityVO;
            var activityList:Collection<VisitActivityJSON> = pv.relatedVisit.visitActivityList.filter("isChecked", true);
            if (activityList != null && activityList.length > 0)
            {
                toolTypeText += Locale.get("TOOLTIP_VISIT_DETAIL_ACTIVITIES");
                //var i:Int = -1;
				for ( va in activityList )
                //while (++i < activityList.length)
                {
                    //va = activityList.getItemAt(i);
                    toolTypeText += "<li>" + va.label + "</li>";
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
        if (cast((_data), PendingVisit).relatedVisit.idExhibitor > 0)
        {
            super._rollOutHandler(e);
            if (ToolTip.exists)
            {
                ToolTip.hide();
            }
        }
    }
    
    
    private function _mouseDownHandler(e:MouseEvent):Void
    //if ( _iconRemove && _iconRemove.hitTestPoint( stage.mouseX, stage.mouseY ) )
    {
        
        if (_relatedVisitItem.btRemove.hitTestPoint(stage.mouseX, stage.mouseY))
        {
            _relatedVisitItem.addEventListener(VisitSaveEvent.REMOVE, _removeVisitItemHandler);
            _relatedVisitItem.askForRemoveVisit();
        }
        else
        {
            _selectType = ScrollListItemSelectType.SELECT;
        }
    }
    
    private function _removeVisitItemHandler(e:VisitSaveEvent):Void
    // autorisation gérée dans VisitItem
    {
        
        //if ( Planning.selected.isLocked || !User.instance.isAuthorized ) return;
        VisitSaveHelper.instance.removeVisit(_relatedVisitItem.data);
        
        PendingPanel.instance.updatePendingList();
    }
}

