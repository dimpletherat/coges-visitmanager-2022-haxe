package com.coges.visitmanager.ui.panel;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.DraggerEvent;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.core.SearchResultDragger;
import com.coges.visitmanager.datas.DataUpdater;
import com.coges.visitmanager.datas.DataUpdaterEvent;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.WaitWheel;
import com.coges.visitmanager.ui.components.ListViewResult;
import com.coges.visitmanager.ui.components.Pager;
import com.coges.visitmanager.ui.components.PagerEvent;
import com.coges.visitmanager.ui.dialog.VMMessageDialog;
import com.coges.visitmanager.vo.DO;
import com.coges.visitmanager.vo.Planning;
import com.coges.visitmanager.vo.SearchOrder;
import com.coges.visitmanager.vo.SearchParameter;
import com.coges.visitmanager.vo.SearchResult;
import com.coges.visitmanager.vo.User;
import feathers.controls.ToggleButton;
import feathers.data.ArrayCollection;
import motion.Actuate;
import nbigot.ui.control.Label;
import nbigot.ui.control.ToolTip;
import nbigot.ui.control.WaitPanel;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.list.ScrollItemSelectType;
import nbigot.ui.list.ScrollList;
import nbigot.utils.Collection;
import nbigot.utils.SpriteUtils;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.external.ExternalInterface;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;
//import com.coges.visitmanager.ui.components.ScrollItemResult;
//import com.coges.visitmanager.ui.components.VMHaxeUIListView;
//import com.coges.visitmanager.ui.components.VMHaxeUIItemRendererResult;
//import com.coges.visitmanager.ui.components.ScrollList;
//import com.coges.visitmanager.ui.components.ScrollListItemResult;
//import com.coges.visitmanager.ui.components.ScrollListItemSelectType;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class ResultPanel extends Sprite
{
	public static final MIN_WIDTH:Int = 290;
	
    public static var instance(default, null):ResultPanel;
    
    
	
	private final _btOrderSize:Int = 26;	
	
	
	
    private var _lblResult:Label;
		
    private var _pager:Pager;
    private var _btOrder:ToggleButton;
   
	private var _background:Sprite;

    private var _scrollListResult:ScrollList<SearchResult>;
    /*private var _selectedScrollListItemResult:ScrollListItemResult;*/
    private var _waitPanel:WaitPanel;
	private var _scrollListResultRect:Rectangle;
	var _listViewResult:ListViewResult;
	//var _haxeuiList:VMHaxeUIListView<SearchResult>;
	
	
	
	
    
    public function new()
    {
        super();
        instance = this;
		
		_background = SpriteUtils.createSquare( 40, 40, Colors.GREY1 );
		addChild(_background);
		
		_lblResult = new Label("", new TextFormat( Fonts.OPEN_SANS, 13, Colors.GREY3) );
		addChild( _lblResult );
        _updateResultNumber(0);
		
		_btOrder = new ToggleButton();
		_btOrder.backgroundSkin = SpriteUtils.createSquare( _btOrderSize, _btOrderSize, Colors.GREY1 );
		_btOrder.icon = Icons.getIcon( Icon.SORT_ASC_GREY2);
		_btOrder.selectedIcon = Icons.getIcon( Icon.SORT_DESC_GREY2);
        _btOrder.addEventListener(Event.CHANGE, _orderChangeHandler);
        _btOrder.addEventListener(MouseEvent.ROLL_OVER, _rolloverOrderHandler);
        _btOrder.addEventListener(MouseEvent.ROLL_OUT, _rolloutOrderHandler);
		addChild( _btOrder );
		
		_pager = new Pager();
        _pager.addEventListener(PagerEvent.GO_PAGE, changePageHandler);
		addChild( _pager );
		
		
		_scrollListResultRect = new Rectangle( 0, 0, 100, 100);
		/*_haxeuiList = new VMHaxeUIListView<SearchResult>(null, VMHaxeUIItemRendererResult, true );
		addChild( _haxeuiList );*/
		
		_listViewResult = new ListViewResult();
		_listViewResult.addEventListener( Event.SELECT, selectListItemHandler );
		addChild( _listViewResult );
		
        ServiceManager.instance.addEventListener(ServiceEvent.START, _searchStartHandler);
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _searchCompleteHandler);
		
		DataUpdater.instance.addEventListener( DataUpdaterEvent.DO_SELECTED_CHANGE, _doChangeHandler );
		
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        
    }
	
	function _doChangeHandler(e:DataUpdaterEvent):Void 
	{
		// clear the result list when the DO is changed
        SearchResult.list.clear();
        SearchResult.selected = null;
		_listViewResult.dataProvider = null;		
        _pager.displayPages(1, Config.resultPageSize);
		_updateResultNumber(0);
	}
    
    private function _searchStartHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.getSearchResultCount || e.currentCall == ServiceManager.instance.getSearchResultList)
        {
            if (_waitPanel == null)
            {
                _waitPanel = new WaitPanel(new Rectangle(0, 0, _background.width, _background.height) );
                _waitPanel.displayMessage( Locale.get("LBL_WAIT_ITEM_SEARCH"), new TextFormat(Fonts.OPEN_SANS, 11, Colors.WHITE) );
                _waitPanel.displayIcon( new WaitWheel() );
				
                addChild(_waitPanel);
            }
		}
    }
    
    
    private function _searchCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.getSearchResultCount)
        {
            _pager.displayPages(e.result, Config.resultPageSize);
            _updateResultNumber(e.result);
        }
        if (e.currentCall == ServiceManager.instance.getSearchResultList)
        {
            _displayResult(e.result);
            if (_waitPanel != null)
            {
                removeChild(_waitPanel);
                _waitPanel = null;
            }
        }
    }
    
    private function _displayResult(result:Array<Dynamic>):Void
    {		
        if (_scrollListResult != null)
        {
            removeChild(_scrollListResult);
        }
		
		
		
		
        if ( SearchResult.list.length == 0 )
        {
            SearchResult.list.addItem( SearchResult.createDummy( Locale.get("NO_RESULT") ) );
        }
		
		
		
		
		
		
	
		_listViewResult.dataProvider = null;
		_listViewResult.dataProvider = new ArrayCollection( SearchResult.list.innerArray );



		
		
		/*
        _scrollListResult = new ScrollList(SearchResult.list, Std.int(_scrollListResultRect.width), Std.int( _scrollListResultRect.height ), "whatever", ScrollItemResult );
        _scrollListResult.x = _scrollListResultRect.x;
        _scrollListResult.y = _scrollListResultRect.y;
        _scrollListResult.addEventListener(Event.SELECT, selectListItemHandler);
        addChild(_scrollListResult);
		*/
		/*
		_haxeuiList.updateDatas( SearchResult.list.innerArray );
		_haxeuiList.width = _scrollListResultRect.width;
		_haxeuiList.height = _scrollListResultRect.height;*/
    }
    
    private function selectListItemHandler(e:Event):Void
    {
		/*
		trace( _listViewResult.selectType );
		trace( _listViewResult.selectedItem );
		*/
		
		
		/*
        _selectedScrollListItemResult = try cast(_scrollListResult.selectedItem, ScrollListItemResult) catch(e:Dynamic) null;*/
        
        if (!User.instance.isAuthorized)
        {
            return;
        }
        
           

        switch (_listViewResult.selectType)
        {
            case ScrollItemSelectType.VIEW:
                var data:SearchResult = cast(_listViewResult.selectedItem, SearchResult) ;
                if (data == null)
                {
                    return;
                }
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("localizeExhibitor", data.exhibitorCode, User.instance.id, Config.LANG);
                }
                else
                {
                    //PopupManager.instance.openPopup(PopupType.MESSAGE, "", Locale.get("LOCALIZATION_ERROR_MESSAGE"));
                    DialogManager.instance.open( new VMMessageDialog( "Title", Locale.get("LOCALIZATION_ERROR_MESSAGE") ) );
                }
            case ScrollItemSelectType.VALIDATE:
				ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _insertDemandIntoPlanningCompleteHandler);
				// TODO: test les datas, et l'idDemand
				ServiceManager.instance.insertDemandIntoPlanning(_listViewResult.selectedItem);
				//ServiceManager.instance.insertDemandIntoPlanning(_selectedScrollListItemResult.getData());				
            case ScrollItemSelectType.SELECT:
                SearchResultDragger.instance.startDrag( _listViewResult.selectedItem, stage);
                //SearchResultDragger.instance.startDrag(_selectedScrollListItemResult );
                SearchResultDragger.instance.addEventListener(DraggerEvent.DROP, draggerDropHandler);
                _listViewResult.alpha = 0.5;
                //_selectedScrollListItemResult.alpha = 0.5;
			case _:
				return;
        }
    }
    
    private function _insertDemandIntoPlanningCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.insertDemandIntoPlanning)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _insertDemandIntoPlanningCompleteHandler);
            ServiceManager.instance.getDOVisitList(DO.selected, Planning.selected, User.instance);			
			
			//reload result list
            ServiceManager.instance.getSearchResultList(SearchParameter.instance, DO.selected);
        }
    }
    
    private function draggerDropHandler(e:DraggerEvent):Void
    {
        SearchResultDragger.instance.removeEventListener(DraggerEvent.DROP, draggerDropHandler);
        _listViewResult.alpha = 1;
    }
    
    
    private function _rolloverOrderHandler(e:MouseEvent):Void
    {
        ToolTip.show(Locale.get("TOOLTIP_BT_RESULT_ORDER"));
    }
    
    private function _rolloutOrderHandler(e:MouseEvent):Void
    {
        ToolTip.hide();
    }
    
    private function _orderChangeHandler(e:Event):Void
    {
        var order:String = SearchParameter.instance.order;
        if (order == SearchOrder.ASCENDENT)
        {
            SearchParameter.instance.order = SearchOrder.DESCENDENT;
        }
        else
        {
            SearchParameter.instance.order = SearchOrder.ASCENDENT;
        }
        
        SearchParameter.instance.startIndex = 0;
        _pager.currentPage = 1;
        
        if (DO.selected != null)
        {
            ServiceManager.instance.getSearchResultList(SearchParameter.instance, DO.selected);
        }
    }
    
    
    private function changePageHandler(e:PagerEvent):Void
    {
        var startIndex:Int = (_pager.currentPage - 1) * _pager.pageSize;
        
        SearchParameter.instance.startIndex = startIndex;
        if (DO.selected != null )
        {
            ServiceManager.instance.getSearchResultList(SearchParameter.instance, DO.selected);
        }
    }
    
    
    public function updateSearchResultList(resultList:Collection<SearchResult>):Void
    {
        _pager.displayPages(resultList.length, Config.resultPageSize);
		_updateResultNumber(resultList.length);
        
		/*
        if (_scrollListResult != null)
        {
            removeChild(_scrollListResult);
        }
        
        _scrollListResult = new ScrollList(SearchResult.list, 223, 476, "firstname", ScrollListItemResult);
        _scrollListResult.y = 26;
        _scrollListResult.addEventListener(Event.SELECT, selectListItemHandler);
        addChild(_scrollListResult);
		*/
		
		
		_listViewResult.dataProvider = null;
		_listViewResult.dataProvider = new ArrayCollection( SearchResult.list.innerArray );
		
    }
	
    private function _updateResultNumber(num:Float):Void
    {
        _lblResult.setText( Locale.get("LBL_EXHIBITOR") + " <b>(" + num + ")</b>" );
    }
	
	
    public function show():Void
    {
        Actuate.tween(this, 0.5, {
                    x:0
                });
    }
    public function hide():Void
    {
        Actuate.tween(this, 0.5, {
                    x:-MIN_WIDTH
                });
    }
	
	public function setRect( rect:Rectangle)
	{
		x = rect.x;
		y = rect.y;
		
		//already handled in HomeView._draw()
		/*
		if ( rect.width < MIN_WIDTH ) rect.width = MIN_WIDTH;
		*/
		var marginH:Int = 26;
		var marginV:Int = 18;
		var spacer:Int = 6;
		
		_background.width = rect.width;
		_background.height = rect.height;
		
        if (_waitPanel != null)
		{
			_waitPanel.setRect( new Rectangle( 0, 0, rect.width, rect.height ) );
		}
		
		_lblResult.x = marginH;
		_lblResult.y = spacer;
		
		_btOrder.x = rect.width - marginH - _btOrderSize;
		_btOrder.y = spacer;
		
		_pager.x = marginH;
		_pager.y = rect.height - spacer - _pager.height;
		_pager.width = rect.width - marginH * 2;
		
		//magic number 12 to add the scrollbar width
		_scrollListResultRect = new Rectangle( marginH, _lblResult.y + _lblResult.height + spacer, rect.width - marginH * 2 + 12, _pager.y - _lblResult.y - _lblResult.height - spacer - spacer );
		
		/*
		if ( _haxeuiList != null )
		{
			
		_haxeuiList.width = _scrollListResultRect.width;
		_haxeuiList.height = _scrollListResultRect.height;
		}
		*/
		if ( _scrollListResult != null )
		{
			
			
			/*
			_scrollListResult.removeEventListener(Event.SELECT, selectListItemHandler);
			removeChild( _scrollListResult );
			
			_scrollListResult = new ScrollList(SearchResult.list, Std.int(_scrollListResultRect.width), Std.int( _scrollListResultRect.height ), "whatever", ScrollItemResult );
			_scrollListResult.x = _scrollListResultRect.x;
			_scrollListResult.y = _scrollListResultRect.y;
			_scrollListResult.addEventListener(Event.SELECT, selectListItemHandler);
			addChild(_scrollListResult);
			*/
			
			
			
			
			
			_scrollListResult.setRect( _scrollListResultRect );
		}
		
		
		
		
		if ( _listViewResult != null )
		{
			_listViewResult.x = _scrollListResultRect.x;
			_listViewResult.y = _scrollListResultRect.y;
			_listViewResult.width = _scrollListResultRect.width;
			_listViewResult.height = _scrollListResultRect.height;
		}
		
	} 
}
