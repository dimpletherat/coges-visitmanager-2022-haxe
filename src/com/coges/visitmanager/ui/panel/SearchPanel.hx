package com.coges.visitmanager.ui.panel;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.events.VMEvent;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.components.ComboListCountry;
import com.coges.visitmanager.ui.components.ComboListSearch;
import com.coges.visitmanager.ui.components.TextInputSearch;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.vo.Country;
import com.coges.visitmanager.vo.DO;
import com.coges.visitmanager.vo.DemandSlotDay;
import com.coges.visitmanager.vo.ExhibitorGroup;
import com.coges.visitmanager.vo.SearchParameter;
import feathers.controls.TextInput;
import motion.Actuate;
import nbigot.ui.control.CheckBox;
import nbigot.ui.control.Label;
import nbigot.ui.control.TextAreaInput;
import nbigot.ui.list.BaseScrollItem;
import nbigot.utils.Collection;
import nbigot.utils.ImageUtils;
import nbigot.utils.SpriteUtils;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class SearchPanel extends Sprite
{
	public static final MIN_WIDTH:Int = 290;
	public static final MIN_HEIGHT:Int = 280;	
	
    public static var instance(default, null):SearchPanel;
	
    
    private var _openTab:Sprite;
    private var _lblTitle:Label;
    private var _background:Sprite;
    private var _searchTextInput:TextInputSearch;
    private var _searchTextInput2:TextInput;
    private var _searchTextInput3:TextAreaInput;
    private var _clCountry:ComboListCountry;
	private var _lineCountry:Sprite;
    private var _clExhibitorGroup:ComboListSearch<ExhibitorGroup>;
	private var _lineExhibitorGroup:Sprite;
    private var _clDay:ComboListSearch<DemandSlotDay>;
	private var _lineDay:Sprite;
    private var _cbInvitation:CheckBox;
    private var _btSearch:VMButton;
	
	
	public var mode(default, set):PanelMode;
	public function set_mode(value:PanelMode):PanelMode
	{
		mode = value;
		if ( hasEventListener( Event.ENTER_FRAME ) )
		{
			removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
		//TODO: close combolist ?
		}
		return value;
	}
	
	
    /*
    public var resultPager(get, set):Pager;
    private var _resultPager:Pager;
    private function get_resultPager():Pager
    {
        return _resultPager;
    }
    private function set_resultPager(value:Pager):Pager
    {
        _resultPager = value;
        return value;
    }*/
	
	
	
	
    
    public function new()
    {
        super();
        instance = this;
		
		mode = PanelMode.FIXE;
		
		_openTab = SpriteUtils.createRoundSquare(40, 70, 4, 4, Colors.DARK_BLUE1);
		var i = Icons.getIcon( Icon.SEARCH_GREY1, 20 );
		ImageUtils.center( i, new Rectangle( 10, 0, _openTab.width - 10, _openTab.height ) );
		_openTab.addChild(i);
		addChild( _openTab );
		
		_background = SpriteUtils.createSquare( 40, 40, Colors.DARK_BLUE1 );
		addChild(_background);
		
		
		_lblTitle = new Label( Locale.get("LBL_SEARCH_EXHIBITOR").toUpperCase(), new TextFormat( Fonts.OPEN_SANS, 16, Colors.GREY3 ) );
		addChild( _lblTitle );
		
		_searchTextInput = new TextInputSearch();
		addChild( _searchTextInput );
		/*
		var toto = new haxe.ui.components.TextField();
		toto.placeholder = "umh...";
		toto.text = "<b>fddskjfsdkj</b>sdf sdfsd";
		Screen.instance.addComponent(toto);*/
		
		
		/*
		var t = new TextField();
		t.defaultTextFormat = new TextFormat( Fonts.OPEN_SANS, 14, 0x009999 );
		t.addEventListener( TextEvent.LINK, tmp );
		t.addEventListener( Event.CHANGE, tmp2 );
		t.autoSize = TextFieldAutoSize.LEFT;
		t.wordWrap = true;
		t.multiline = true;
		//t.type = TextFieldType.INPUT;
		addChild(t);
		t.htmlText = "<a href=\"event:toto\">SWEDEN</a> 3 (Gal GORANSON)<br><i><span style=\"font-size:10px;\">Gal Bengt SVENSSON représente Gal GORANSON</span></i>";
		*/
		
		/*
		_searchTextInput2 = new TextInput();
		_searchTextInput2.promptTextFormat = new TextFormat( Fonts.OPEN_SANS, 12, Colors.GREY3, null, true );
		_searchTextInput2.prompt = Locale.get("LBL_SEARCH_TEXT_INPUT");
		addChild( _searchTextInput2 );*/
		
		/*
		_searchTextInput3 = new TextAreaInput( new Rectangle(0, 0, 200, 100));
		_searchTextInput3.placeholderTextFormat = new TextFormat( Fonts.OPEN_SANS, 12, Colors.GREY3, null, true );
		_searchTextInput3.placeholder = Locale.get("LBL_SEARCH_TEXT_INPUT");
		_searchTextInput3.textFormat = new TextFormat( Fonts.OPEN_SANS, 14, Colors.GREY4 );
		//_searchTextInput2.opaqueBackground = Colors.GREY1;
		addChild( _searchTextInput3 );*/
		
	
		
		
		
		_clCountry = new ComboListCountry(null);
        addChild(_clCountry);
        if (Country.list.length == 0)
        {
            _loadCountryList();
        }
        else
        {
            _fillComboListCountry();
        }
		_lineCountry = new Sprite();
		addChild( _lineCountry );
		
		
		_clExhibitorGroup = new ComboListSearch<ExhibitorGroup>(null);
        addChild(_clExhibitorGroup);
        if (ExhibitorGroup.list.length == 0)
        {
            _loadExhibitorGroupList();
        }
        else
        {
            _fillComboListExhibitorGroup();
        }
		_lineExhibitorGroup = new Sprite();
		addChild( _lineExhibitorGroup );
		
		
        var clDayDatas:Collection<DemandSlotDay> = DemandSlotDay.list.clone();
        clDayDatas.addItemAt(new DemandSlotDay(0, Locale.get("LBL_SEARCH_ANY_DAY")), 0);
		_clDay = new ComboListSearch<DemandSlotDay>(clDayDatas);		
        _clDay.selectedIndex = 0;
        //_clDay.visible = false;
        addChild(_clDay);
		_lineDay = new Sprite();
        //_lineDay.visible = false;
		addChild( _lineDay );
		
		
		_cbInvitation = new CheckBox();
		_cbInvitation.icon = Icons.getIcon( Icon.CHECK_SOLID_GREY2 );
		_cbInvitation.iconSelected = Icons.getIcon( Icon.CHECK_SOLID_GREY2_SELECTED );
        _cbInvitation.selected = true;
		//_cbInvitation.alpha = 0.5;
		_cbInvitation.setText( Locale.get("LBL_CB_INVITATION"), new TextFormat( Fonts.OPEN_SANS, 14, Colors.GREY2 ) );
        _cbInvitation.addEventListener(Event.CHANGE, _cbInvitationChangeHandler);
		addChild( _cbInvitation );
		
		
		_btSearch = new VMButton(Locale.get("BT_SEARCH_LABEL"), new TextFormat( Fonts.OPEN_SANS, 14, Colors.GREY1/*, null,null,null,null,null,TextFormatAlign.CENTER*/ ), SpriteUtils.createRoundSquare(140, 30, 6, 6, Colors.BLUE1) );
		_btSearch.toolTipContent = Locale.get("TOOLTIP_BT_SEARCH");
		_btSearch.borderEnabled = false;
        _btSearch.addEventListener(MouseEvent.CLICK, _btSearchClickHandler);
		_btSearch.setIcon( Icons.getIcon( Icon.SEARCH_GREY1), new Point( 40, 30 ) );
		addChild(_btSearch);
		
        addEventListener(Event.ADDED_TO_STAGE, init);
        //focusRect = null;
        addEventListener(KeyboardEvent.KEY_DOWN, _keyDownHandler);
        addEventListener(FocusEvent.FOCUS_OUT, _focusOutHandler);
        addEventListener(MouseEvent.ROLL_OVER, _rolloverHandler);
    }
	
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function _rolloverHandler(e:MouseEvent):Void
    {
        if (!CalendarPanel.instance.isEditDOAvailablePeriodMode)
        {
			if (mode == PanelMode.MOVABLE)
			{
				dispatchEvent(new VMEvent(VMEvent.OPEN_SEARCH));
				addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			}
		}
		
    }
    
    private function _enterFrameHandler(e:Event):Void
    {
        if (stage.mouseX > x + width)
        {
            removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
            dispatchEvent(new VMEvent(VMEvent.CLOSE_SEARCH));
            _closeAllCombolists();
        }
    }
    private function _focusOutHandler(e:FocusEvent):Void
    {
        if (Std.isOfType(e.relatedObject, BaseScrollItem))
        {
            stage.focus = this;
        }
    }
    private function _keyDownHandler(e:KeyboardEvent):Void
    {
        if (e.keyCode == 13)
        {
            _btSearchClickHandler(null);
        }
    }
    
    private function _loadCountryList():Void
    {
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _loadCountryListCompleteHandler);
        ServiceManager.instance.getCountryList();
    }
    
    private function _loadCountryListCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.getCountryList)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _loadCountryListCompleteHandler);
            
            _fillComboListCountry();
        }
    }
    
    private function _fillComboListCountry():Void
    {
        var datas:Collection<Country> = Country.list.clone();
        datas.addItemAt(new Country( { id:0, label:Locale.get("LBL_SEARCH_ALL_COUNTRIES"), ISOCode:""} ), 0);
        datas.addItemAt(new Country( { id:-1, label:Locale.get("LBL_SEARCH_FRANCE_EUROPE"), ISOCode:""} ), 1);
        datas.addItemAt(new Country( { id:-2, label:Locale.get("LBL_SEARCH_FOREIGNER"), ISOCode:""} ), 2);
        _clCountry.datas = datas;
        _clCountry.selectedIndex = 0;
    }
    private function _loadExhibitorGroupList():Void
    {
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _loadExhibitorGroupListCompleteHandler);
        ServiceManager.instance.getExhibitorGroupList();
    }
    
    private function _loadExhibitorGroupListCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.getExhibitorGroupList)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _loadExhibitorGroupListCompleteHandler);
            
            _fillComboListExhibitorGroup();
        }
    }
    
    private function _fillComboListExhibitorGroup():Void
    {
        var datas:Collection<ExhibitorGroup> = ExhibitorGroup.list.clone();
        datas.addItemAt(new ExhibitorGroup( {id:0, label:Locale.get("LBL_SEARCH_ALL_EXHIBITOR_GROUPS")}), 0);
        _clExhibitorGroup.datas = datas;
        _clExhibitorGroup.selectedIndex = 0;
    }
	
	function _closeAllCombolists():Void 
	{
		if (_clCountry.isOpen)
		{
			_clCountry.close();
		}
		if (_clExhibitorGroup.isOpen)
		{
			_clExhibitorGroup.close();
		}
		if (_clDay.isOpen)
		{
			_clDay.close();
		}
	}
    
    
    
    private function _cbInvitationChangeHandler(e:Event):Void
    {
        _clDay.visible = _cbInvitation.selected;
        _lineDay.visible = _cbInvitation.selected;
    }
    
    private function _btSearchClickHandler(e:MouseEvent):Void
    {
        var country:Country = _clCountry.selectedData;
        SearchParameter.instance.country = (country.id != 0) ? country:null;
        var group:ExhibitorGroup = _clExhibitorGroup.selectedData;
        SearchParameter.instance.exhibitorGroup = (group.id != 0) ? group:null;
        SearchParameter.instance.name = _searchTextInput.text;
        SearchParameter.instance.day = _clDay.selectedData;
        SearchParameter.instance.hasInvitationDemand = _cbInvitation.selected;
        SearchParameter.instance.startIndex = 0;
        SearchParameter.instance.pageSize = Config.resultPageSize;
        
        if (DO.selected != null)
        {
            ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _getSearchResultCountCompleteHandler);
            ServiceManager.instance.getSearchResultCount(SearchParameter.instance, DO.selected);
        }
    }
    
    private function _getSearchResultCountCompleteHandler(e:ServiceEvent):Void
    {		
        if (e.currentCall == ServiceManager.instance.getSearchResultCount)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _getSearchResultCountCompleteHandler);
			
			//ASK: Do we really need to call ServiceManager.instance.getSearchResultCount now ???
            
            if (DO.selected != null)
            {
                ServiceManager.instance.getSearchResultList(SearchParameter.instance, DO.selected);
            }
        }
    }
	
    
    public function show():Void
    {
        Actuate.tween(this, 0.5, {
                    x:0
                });
        Actuate.tween(_openTab, 0.5, {
                    x:MIN_WIDTH - _openTab.width
                });
    }
    public function hide():Void
    {
        Actuate.tween(this, 0.5, {
                    x:-MIN_WIDTH
                });
		Actuate.tween(_openTab, 0.5, {
                    x:MIN_WIDTH - 10
                });
    }
	
	
	
	
	public function setRect( rect:Rectangle)
	{
		x = rect.x;
		y = rect.y;
		
		_closeAllCombolists();
		
		//already handled in HomeView._draw()
		/*
		if ( rect.width < MIN_WIDTH ) rect.width = MIN_WIDTH;
		if ( rect.height < MIN_HEIGHT ) rect.height = MIN_HEIGHT;
		*/
		var marginH:Int = 26;
		var marginV:Int = 18;
		var spacer:Int = 8;
		
		_background.width = rect.width;
		_background.height = rect.height;
		
		_openTab.x = ( mode == PanelMode.FIXE ) ? -10 : rect.width - 10 ;
		_openTab.y = (stage.stageHeight - MessagePanel.MIN_HEIGHT - _openTab.height ) * 0.5;
		
		_lblTitle.y = marginV;
		_lblTitle.x = (rect.width - _lblTitle.width ) * 0.5;
		
		
		_searchTextInput.x = marginH;
		_searchTextInput.width = rect.width - marginH * 2;
		_searchTextInput.y = _lblTitle.y + _lblTitle.height + marginV;
		/*
		_searchTextInput2.x = marginH;
		_searchTextInput2.width = rect.width - marginH * 2;
		_searchTextInput2.y = _lblTitle.y + _lblTitle.height + marginV;*/
		/*
		_searchTextInput3.x = marginH;
		_searchTextInput3.width = rect.width - marginH * 2;
		_searchTextInput3.y = _lblTitle.y + _lblTitle.height + marginV;*/
		_clCountry.x = marginH;
		_clCountry.width = rect.width - marginH * 2;
		_clCountry.y = _searchTextInput.y + _searchTextInput.height + spacer;
		_lineCountry.x = marginH;
		_lineCountry.y = _clCountry.y + _clCountry.height;
		SpriteUtils.drawSquare( _lineCountry, Std.int( _clCountry.width ), 1, Colors.GREY2 );
		
		_clExhibitorGroup.x = marginH;
		_clExhibitorGroup.width = rect.width - marginH * 2;
		_clExhibitorGroup.y = _clCountry.y + _clCountry.height + spacer;	
		_lineExhibitorGroup.x = marginH;
		_lineExhibitorGroup.y = _clExhibitorGroup.y + _clExhibitorGroup.height;
		SpriteUtils.drawSquare( _lineExhibitorGroup, Std.int( _clExhibitorGroup.width ), 1, Colors.GREY2 );
		
		_cbInvitation.x = marginH;
		_cbInvitation.y = _clExhibitorGroup.y + _clExhibitorGroup.height + spacer * 1.5;
		_clDay.x = marginH;
		_clDay.width = rect.width - marginH * 2;
		_clDay.y = _cbInvitation.y + _cbInvitation.height + spacer * 0.5;
		_lineDay.x = marginH;
		_lineDay.y = _clDay.y + _clDay.height;
		SpriteUtils.drawSquare( _lineDay, Std.int( _clDay.width ), 1, Colors.GREY2 );
		
		_btSearch.x = (rect.width - _btSearch.width ) * 0.5;
		_btSearch.y = rect.height - _btSearch.height - spacer;
	} 
}

