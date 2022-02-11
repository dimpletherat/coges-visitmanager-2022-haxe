package com.coges.visitmanager.ui.components;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.ui.components.PagerEvent;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.fonts.Fonts;
import feathers.controls.Button;
import feathers.controls.ButtonState;
import feathers.controls.LayoutGroup;
import feathers.events.FeathersEvent;
import feathers.layout.HorizontalLayout;
import feathers.layout.RelativePosition;
import nbigot.ui.IconPosition;
import nbigot.ui.control.ToolTip;
import nbigot.utils.SpriteUtils;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class Pager extends LayoutGroup
{
	private final _height:Int = 30;
	private final _buttonWidth:Int = 30;
	private final _buttonGap:Int = 4;
	
    public var minPage(get, never):Int;
    public var maxPage(get, never):Int;
    public var pageSize(get, never):Int;
    public var currentPage(get, set):Int;

    public var btLastPage:PagerNavigationButton;
    public var btFirstPage:PagerNavigationButton;
    public var btPreviousPage:PagerNavigationButton;
    public var btNextPage:PagerNavigationButton;
    
    private var _minPage:Int = 1;
    
    private function get_minPage():Int
    {
        return _minPage;
    }
    private var _maxPage:Int = 1;
    
    private function get_maxPage():Int
    {
        return _maxPage;
    }
    private var _currentPage:Int = 1;
    private var _pageSize:Int;
    
    private function get_pageSize():Int
    {
        return _pageSize;
    }
    private function get_currentPage():Int
    {
        return _currentPage;
    }
    private function set_currentPage(value:Int):Int
    {
        _currentPage = value;
        //_updateButtons();
        return value;
    }
    private var _pageButtonList:Array<PagerPageButton>;
    private var _pageButtonContainer:LayoutGroup;
    
    public function new()
    {
        super();
		
		var l = new HorizontalLayout();
		l.gap = _buttonGap;
		layout = l;
		
		btFirstPage = new PagerNavigationButton( _buttonWidth, _height, Icons.getIcon(Icon.PAGER_FIRST_GREY3), Icons.getIcon( Icon.PAGER_FIRST_GREY1 ), Locale.get("TOOLTIP_BT_FIRST_PAGE") );
        btFirstPage.addEventListener(MouseEvent.CLICK, _btFirstClickHandler);
		addChild(btFirstPage);
		
		btPreviousPage = new PagerNavigationButton( _buttonWidth, _height, Icons.getIcon(Icon.PAGER_PREVIOUS_GREY3), Icons.getIcon( Icon.PAGER_PREVIOUS_GREY1 ), Locale.get("TOOLTIP_BT_PREVIOUS_PAGE") );
        btPreviousPage.addEventListener(MouseEvent.CLICK, _btPreviousClickHandler);
		addChild(btPreviousPage);
		
		_pageButtonContainer = new LayoutGroup();
		_pageButtonContainer.layout = l;
		_pageButtonContainer.minWidth = 50;
		addChild( _pageButtonContainer );
		
		
		btNextPage = new PagerNavigationButton( _buttonWidth, _height, Icons.getIcon(Icon.PAGER_NEXT_GREY3), Icons.getIcon( Icon.PAGER_NEXT_GREY1 ), Locale.get("TOOLTIP_BT_NEXT_PAGE") );
        btNextPage.addEventListener(MouseEvent.CLICK, _btNextClickHandler);
		addChild(btNextPage);
		
		btLastPage = new PagerNavigationButton( _buttonWidth, _height, Icons.getIcon(Icon.PAGER_LAST_GREY3), Icons.getIcon( Icon.PAGER_LAST_GREY1 ), Locale.get("TOOLTIP_BT_LAST_PAGE") );
        btLastPage.addEventListener(MouseEvent.CLICK, _btLastClickHandler);
		addChild(btLastPage);
		
        
		btFirstPage.enabled = false;
		btPreviousPage.enabled = false;
		btLastPage.enabled = false;
		btNextPage.enabled = false;
		
		
        _pageButtonList = new Array<PagerPageButton>();
        addEventListener(Event.ADDED_TO_STAGE, _init);
    }
    
    private function _init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _init);
    }
    
    public function displayPages(itemNum:Int, pageSize:Int):Void
    {       
        _pageSize = pageSize;
        _maxPage = ((itemNum > 0)) ? Math.ceil(itemNum / _pageSize):1;
        _currentPage = _minPage;
        
		_draw();
    }
	
	private function _draw():Void
	{
        if (_pageButtonList.length > 0)
        {
            while ( _pageButtonContainer.numChildren > 0 )
            {
                _pageButtonContainer.removeChildAt(0);
            }
        }
		
        _pageButtonList = new Array<PagerPageButton>();
		
		
        var b:PagerPageButton;		
        var buttonCount:Int = Math.floor( _pageButtonContainer.minWidth / _buttonWidth);
		
        for( i in 0...buttonCount)
        {
			b = new PagerPageButton( _buttonWidth, _height);
			b.addEventListener( MouseEvent.CLICK, _btPageClickHandler );
			_pageButtonContainer.addChild(b);
            _pageButtonList.push(b);
			
            if (i == _maxPage - 1)
            {
                break;
            }
        }
        _updateButtons();
		
	}
    
    private function _updateButtons():Void
    {
        var buttonCount:Int = _pageButtonList.length;
        var i:Int = -1;
        var initPageNum:Int = 1;
        if (_currentPage > buttonCount - 1)
        {
            initPageNum = _currentPage - (buttonCount - 2);
        }
        if (_currentPage == _maxPage)
        {
            initPageNum = _currentPage - (buttonCount - 1);
        }
        
        var pageNum:Int;
		var b:PagerPageButton;
        
        for( i in 0...buttonCount )
        {
            pageNum = initPageNum + i;
			
            b = _pageButtonList[i];
			
            if (i == buttonCount - 1 && pageNum < _maxPage)
            {
                b.text = "...";
				b.displayAsRest();
            }
            else if (pageNum == _currentPage)
            {
                b.text = Std.string(pageNum);
				b.displayAsSelected();
            }
            else
            {
                b.text = Std.string(pageNum);
				b.pageNum = pageNum;
				b.displayAsNormal();
            }
			b.width = _buttonWidth;
        }
        
        if (_currentPage == _minPage)
        {
			btFirstPage.enabled = false;
			btPreviousPage.enabled = false;
        }
        else
        {
			btFirstPage.enabled = true;
			btPreviousPage.enabled = true;
        }
        if (_currentPage == _maxPage)
        {
			btLastPage.enabled = false;
			btNextPage.enabled = false;
        }
        else
        {
			btLastPage.enabled = true;
			btNextPage.enabled = true;
        }
    }
    
    
    private function _btPageClickHandler(e:MouseEvent):Void
    {
		var b:PagerPageButton = cast( e.target, PagerPageButton );
        _currentPage = b.pageNum;
        _updateButtons();
        dispatchEvent(new PagerEvent(PagerEvent.GO_PAGE, _currentPage));
    }
	
    private function _btNextClickHandler(e:MouseEvent):Void
    {
        _currentPage++;
        _updateButtons();
        dispatchEvent(new PagerEvent(PagerEvent.GO_PAGE, _currentPage));
    }
    
    private function _btPreviousClickHandler(e:MouseEvent):Void
    {
        _currentPage--;
        _updateButtons();
        dispatchEvent(new PagerEvent(PagerEvent.GO_PAGE, _currentPage));
    }
    
    private function _btLastClickHandler(e:MouseEvent):Void
    {
        _currentPage = _maxPage;
        _updateButtons();
        dispatchEvent(new PagerEvent(PagerEvent.GO_PAGE, _currentPage));
    }
    
    private function _btFirstClickHandler(e:MouseEvent):Void
    {
        _currentPage = _minPage;
        _updateButtons();
        dispatchEvent(new PagerEvent(PagerEvent.GO_PAGE, _currentPage));
    }
	
	
	
	override public function set_width( value:Float):Float
	{
		if (value < (_buttonWidth * 5 + _buttonGap * 4) )
			value = (_buttonWidth * 5 + _buttonGap * 4);
		super.width = value;
		_pageButtonContainer.minWidth = value - _buttonWidth * 4 - _buttonGap * 4;
		_draw();
		return value;
	}
	
	override public function get_height():Float
	{
		return _height;
	}
		
}

private class PagerNavigationButton extends Button
{
	var _tooltipContent:String;	
	
	public function new ( w:Int, h:Int, iconUp:DisplayObject, iconHover:DisplayObject, tooltipContent:String )
	{
		super();
		_tooltipContent = tooltipContent;
		backgroundSkin = SpriteUtils.createRoundSquare(w, h, 3, 3, Colors.GREY1);
		setSkinForState(ButtonState.HOVER, SpriteUtils.createRoundSquare(w, h, 3, 3, Colors.GREY3) );
		addEventListener( MouseEvent.MOUSE_OVER, _btMouseOverHandler );
		addEventListener( MouseEvent.MOUSE_OUT, _btMouseOutHandler );
		icon = iconUp;
		setIconForState( ButtonState.HOVER, iconHover );
		paddingLeft = 0;
		paddingRight = 0;
		width = w;
	}
	private function _btMouseOverHandler( e:MouseEvent ):Void
	{
		ToolTip.show(_tooltipContent );
	}
	
	private function _btMouseOutHandler( e:MouseEvent ):Void
	{
		ToolTip.hide();
	}	
	
	override public function set_enabled(value:Bool):Bool
	{
		super.enabled = value;
		
        mouseEnabled = value;
        alpha = ( value ) ? 1 : 0.4;
		return value;
	}
	
}



private class PagerPageButton extends Button
{
	private final _tfUp = new TextFormat( Fonts.OPEN_SANS, 14, Colors.GREY2, true );
	private final _tfHover = new TextFormat( Fonts.OPEN_SANS, 14, Colors.GREY1, true );
	private final _tfSelected = new TextFormat( Fonts.OPEN_SANS, 14, Colors.BLUE2, true );
	
	public var pageNum:Int;
	
	
	
	public function new (w:Int, h:Int)
	{
		super();
		backgroundSkin = SpriteUtils.createRoundSquare(w, h, 3, 3, Colors.GREY1);
		setSkinForState(ButtonState.HOVER, SpriteUtils.createRoundSquare(w, h, 3, 3, Colors.GREY2) );
		textFormat = _tfUp;
		setTextFormatForState( ButtonState.HOVER, _tfHover );
		width = w;
		paddingLeft = 0;
		paddingRight = 0;
	}	
	
	public function displayAsRest():Void
	{
		setTextFormatForState( ButtonState.DISABLED, _tfUp );
		enabled = false;
	}
	public function displayAsSelected():Void
	{
		setTextFormatForState( ButtonState.DISABLED, _tfSelected );
		enabled = false;
	}
	public function displayAsNormal():Void
	{
		enabled = true;
	}
}