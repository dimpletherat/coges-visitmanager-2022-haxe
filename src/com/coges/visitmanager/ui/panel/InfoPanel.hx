package com.coges.visitmanager.ui.panel;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.datas.DataUpdater;
import com.coges.visitmanager.datas.DataUpdaterEvent;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.vo.DOAvailablePeriod;
import com.coges.visitmanager.vo.OppositeOwner;
import com.coges.visitmanager.vo.Period;
import com.coges.visitmanager.vo.Planning;
import com.coges.visitmanager.vo.Visit;
import motion.Actuate;
import nbigot.ui.control.Label;
import nbigot.utils.DateUtils;
import nbigot.utils.SpriteUtils;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
//import feathers.controls.Label;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

//TODO:control all event handlers and textfields
class InfoPanel extends Sprite
{
	public static final MIN_HEIGHT:Int = 100;
	
	private var _lblManager:Label;
    //private var _txtOA:TextField;
    private var _lblOA:Label;
    private var _lblPhone:Label;
    private var _lblSlots:Label;
    private var _lblAllocation:Label;
    private var _lblLastUpdate:Label;
    private var _lblPlanning:Label;
    private var _background:Sprite;
	private var _padding:Int;
    
    public function new()
    {
        super();
		
		_padding = 10;
		_background = SpriteUtils.createSquare(800, 80, Colors.GREY1);
		addChild(_background);
        
        var tf:TextFormat = new TextFormat( Fonts.OPEN_SANS, 12, 0x000000 );
		//FIX:adding negative leading fixes the unexpected ScrollV Bug
		//tf.leading = -2;
		
		_lblManager = new Label("", tf );
		//_lblManager.border = true;
		addChild(_lblManager);
		
		var tfOA = tf.clone();
		tfOA.color = Colors.GREY4;
		_lblOA = new Label( "", tfOA, TextFieldAutoSize.LEFT, true );
		//_lblOA.border = true;
		addChild(_lblOA);
		
		_lblPhone = new Label("",tf);
		//_lblPhone.border = true;
		addChild(_lblPhone);
		
		_lblSlots = new Label("",tf);
		//_lblSlots.border = true;
		addChild(_lblSlots);
		
		_lblAllocation = new Label("",tf);
		//_lblAllocation.border = true;
		addChild(_lblAllocation);
		
		var tfRight = tf.clone();
		tfRight.align = TextFormatAlign.RIGHT;
		
		_lblLastUpdate = new Label("",tfRight);
		//_lblLastUpdate.border = true;
		addChild(_lblLastUpdate);
		
		_lblPlanning = new Label("",tfRight);
		//_lblPlanning.border = true;
		addChild(_lblPlanning);
        
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
		DataUpdater.instance.addEventListener(DataUpdaterEvent.OPPOSITE_OWNER_SELECTED_CHANGE, _oppositeOwnerChangeHandler);
		DataUpdater.instance.addEventListener(DataUpdaterEvent.PLANNING_SELECTED_CHANGE, _planningChangeHandler);
		DataUpdater.instance.addEventListener(DataUpdaterEvent.VISIT_LIST_CHANGE, _visitListChangeHandler);
		
        addEventListener(MouseEvent.ROLL_OVER, _rolloverHandler);
        addEventListener(MouseEvent.ROLL_OUT, _rolloutHandler);
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
		
    }
    private function _rolloverHandler(e:MouseEvent):Void
    {
        show();
    }
    
    private function _rolloutHandler(e:MouseEvent):Void
    {
        hide();
    }
    
    public function show():Void
    {
        Actuate.tween(this, 0.5, {
                    y:MenuPanel.MIN_HEIGHT
                });
    }
    public function hide():Void
    {
        Actuate.tween(this, 0.5, {
                    y:MenuPanel.MIN_HEIGHT - InfoPanel.MIN_HEIGHT
                });
    }
    
    private function _serviceCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.getDOAvailablePeriodList)
        {
            var slotCount:Int = 0;
			for ( doap in DOAvailablePeriod.list )
			{
				slotCount += Std.int( doap.period.length / Config.INIT_SLOT_LENGTH_TIME );
			}
			
			_lblSlots.setText( Locale.get("LBL_SLOTS") + "<b>" + slotCount + "</b>");
        }
    }    
    
    
    private function _visitListChangeHandler(e:DataUpdaterEvent):Void
    {
		var frenchExhibitorTotal = 0;
		var foreignExhibitorTotal = 0;		
		
        if (Visit.list.length > 0)
        {
            var slotCount:Int = 0;
			for (v in Visit.list )
            {
                slotCount = Math.ceil(v.period.length / Config.INIT_SLOT_LENGTH_TIME);
                if (v.isFrenchExhibitor)
                {
                    frenchExhibitorTotal += slotCount;
                }
                else if (v.isForeignExhibitor)
                {
                    foreignExhibitorTotal += slotCount;
                }
            }
            //_updateAllocation(slotFranceNum, slotForeignerNum);
        }		
		
        var ratioIsFrance:Float = frenchExhibitorTotal / (frenchExhibitorTotal + foreignExhibitorTotal) * 100;
        var colorStr:String = (ratioIsFrance <= Config.INIT_RATIO_FRANCE_FOREIGNER) ? StringTools.hex( Colors.GREEN2 ):StringTools.hex( Colors.ORANGE );
		
        var strAllocation:String = Locale.get("LBL_ALLOCATION");
        strAllocation += "<b><font color='#" + colorStr + "'>" + Locale.get("LBL_FRANCE") + "(" + frenchExhibitorTotal + ")";
        strAllocation += " / ";
        strAllocation += Locale.get("LBL_FOREIGNER") + "(" + foreignExhibitorTotal + ")</font></b>";
		
        _lblAllocation.setText( strAllocation );
		
		
		_draw();
    }
    
    
    private function _oppositeOwnerChangeHandler(e:DataUpdaterEvent):Void
    {
		var manager = OppositeOwner.selected;
        var strManager = "NC";
		var strPhone = "NC";
        var strOA:String = "NC";
		var tmp:String = "";
        if (manager != null) 
		{
			if ( manager.phone.length > 0 ) strPhone =  manager.phone;
			strManager =  manager.lastName + " " + manager.firstName;
            tmp = "";
            for ( oa in manager.oaList)
            {
                tmp += oa + " - ";
            }
			if ( tmp.length > 0 ) strOA = tmp.substr(0, tmp.length - 3);
        }
        _lblManager.setText( Locale.get("LBL_MANAGER") + "<b>" + strManager + "</b>");
        _lblPhone.setText( " - " + Locale.get("LBL_PHONE") + "<b>" + strPhone + "</b>");
		_lblOA.setText( Locale.get("LBL_OA") + "<b>" + strOA + "</b>" );
		
		_draw();
    }
    
    
    private function _planningChangeHandler(e:DataUpdaterEvent):Void
    {		
        if (Planning.selected.version < 0)
        {
            _lblLastUpdate.visible = true;
            _lblLastUpdate.setText( Locale.get("LBL_LAST_UPDATE") + "<b>" + DateUtils.toString(Planning.selected.dateEdit, "DD/MM/YYYY hh:mm:ss") + "</b>");
        }
        else
        {
            _lblLastUpdate.visible = false;
        }
        _lblPlanning.setText( Locale.get("LBL_PLANNING") + "<b>" + Planning.selected.label + "</b>");
		
		_draw();
    }
	
	private function _draw():Void
	{
		var w = _background.width - 20;
		var h = _background.height;
		_lblManager.x = _padding;
		_lblManager.y = _padding;
		
		_lblPhone.x = _lblManager.x + _lblManager.width + _padding;
		_lblPhone.y = _padding;
		
		_lblOA.x = _padding;
		_lblOA.y = _lblManager.y + _lblManager.height - 4;	
		_lblOA.width = w - _padding * 2 - _lblLastUpdate.width;	
		
		_lblSlots.x = _padding;
		_lblSlots.y = h - _padding - _lblSlots.height;
		_lblAllocation.x = _lblSlots.x + _lblSlots.width + _padding;
		_lblAllocation.y = _lblSlots.y;
		
		_lblLastUpdate.x = w -_lblLastUpdate.width - _padding;
		_lblLastUpdate.y = _lblSlots.y;
		
		_lblPlanning.x = w -_lblPlanning.width - _padding;
		_lblPlanning.y = _lblSlots.y - _lblLastUpdate.height - _padding;
		
	}
	
	
	public function setRect( rect:Rectangle ):Void
	{
		x = rect.x;
		y = rect.y;
		_background.width = rect.width;
		_background.height = rect.height;
		_draw();
	}
}

