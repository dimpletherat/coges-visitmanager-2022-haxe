package com.coges.visitmanager.ui;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.components.ScrollItemDO;
import com.coges.visitmanager.vo.DO;
import com.coges.visitmanager.vo.Visit;
import motion.Actuate;
import motion.easing.Linear;
import nbigot.ui.control.BaseButton;
import nbigot.ui.control.Label;
import nbigot.ui.control.Scrollbar;
import nbigot.ui.control.Scrollbar.GripStyle;
import nbigot.ui.list.ScrollList;
import nbigot.utils.Collection;
import nbigot.utils.SpriteUtils;
import openfl.display.DisplayObject;
import openfl.display.Shape;
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

/**
 * ...
 * @author Nicolas Bigot
 */

private enum DisplayMode
{
	SELECT;
	RESULT;
}
 
 
class VisitDetailDuplicateVisitOverlay extends Sprite 
{
	private var _data:Visit;
	private var _mainArea:Rectangle;
	private var _width:Float;
	private var _height:Float;
	private var _currentDisplayMode:DisplayMode;

	private var _background:Sprite;
	private var _itemsBackgrounds:Shape;
	private var _btValid:BaseButton;
	private var _btCancel:BaseButton;
	private var _btClose:BaseButton;
	private var _btSelectAll:BaseButton;
	private var _btClearSelected:BaseButton;
	private var _txtMessage:TextField;
	private var _txtResult:TextField;
	private var _sbResult:Scrollbar;
	private var _lblDOSelected:Label;
	private var _lblDOAvailable:Label;
	private var _arrow:DisplayObject;
	private var _doAvailableScrollList:ScrollList<DO>;
	private var _doSelectedScrollList:ScrollList<DO>;


	public function new( visit:Visit = null, width:Float, height:Float )
	{
		super();
		_data = visit;
		_width = width;
		_height = height;
		alpha = 0;
		
		_background = SpriteUtils.createRoundSquare( 50, 50, 8,8 , Colors.GREY1 );
		addChild( _background );
		
		_itemsBackgrounds = new Shape();
		addChild( _itemsBackgrounds );
		
		var tfText:TextFormat = new TextFormat( Fonts.OPEN_SANS, 14 );
		
		_txtMessage = new TextField();
		_txtMessage.embedFonts = true;
        _txtMessage.antiAliasType = AntiAliasType.ADVANCED;
        _txtMessage.autoSize = TextFieldAutoSize.LEFT;
		_txtMessage.multiline = true;
		_txtMessage.wordWrap = true;
		_txtMessage.defaultTextFormat = tfText;
		addChild( _txtMessage );
		
		_txtResult = new TextField();
		_txtResult.embedFonts = true;
        _txtResult.antiAliasType = AntiAliasType.ADVANCED;
		_txtResult.multiline = true;
		_txtResult.wordWrap = true;
		_txtResult.defaultTextFormat = tfText;
		
		
		var tfLabel:TextFormat = tfText.clone();
		tfLabel.color = Colors.GREY3;	
		
		_lblDOAvailable = new Label( Locale.get( "LABEL_AVAILABLE_DO_LIST" ), tfLabel);
		
		_lblDOSelected = new Label( Locale.get( "LABEL_SELECTED_DO_LIST" ), tfLabel);		
		
		
		var tfButton:TextFormat = tfText.clone();
		tfButton.size = 13;
		tfButton.color = Colors.GREY1;      
		
        _btValid = new BaseButton( Locale.get( "BT_VALID_LABEL" ), tfButton, SpriteUtils.createRoundSquare( 140, 30, 6, 6, Colors.GREEN2 ));
		_btValid.setIcon( Icons.getIcon(Icon.VALID), new Point( 50, 30) );
		_btValid.borderEnabled = false;
		
        _btCancel = new BaseButton( Locale.get( "BT_CANCEL_LABEL" ), tfButton, SpriteUtils.createRoundSquare( 140, 30, 6, 6, Colors.RED2 ));
		_btCancel.borderEnabled = false;
		_btCancel.setIcon( Icons.getIcon(Icon.CANCEL), new Point( 50, 30) );
		
		var tf13Grey1Centered = tfButton.clone();
		tf13Grey1Centered.align = TextFormatAlign.CENTER;
        _btClose = new BaseButton(Locale.get( "BT_CLOSE_LABEL" ), tf13Grey1Centered, SpriteUtils.createRoundSquare( 120, 30, 6, 6, Colors.GREY3 ) );
		_btClose.borderEnabled = false;
		
		
		var tfButtonSmall:TextFormat = tfButton.clone();
		tfButtonSmall.size = 11;
		tfButtonSmall.align = TextFormatAlign.CENTER;
		
        _btSelectAll = new BaseButton( Locale.get( "BT_SELECT_ALL_LABEL" ), tfButtonSmall, SpriteUtils.createRoundSquare( 120, 24, 4, 4, Colors.DARK_BLUE2 ));
		_btSelectAll.borderEnabled = false;
		//_btSelectAll.setIcon( Icons.getIcon(Icon.CANCEL), new Point( 50, 30) );
		
        _btClearSelected = new BaseButton( Locale.get( "BT_CLEAR_LABEL" ), tfButtonSmall, SpriteUtils.createRoundSquare( 120, 24, 4, 4, Colors.DARK_BLUE2 ));
		_btClearSelected.borderEnabled = false;
		//_btClearSelected.setIcon( Icons.getIcon(Icon.CANCEL), new Point( 50, 30) );
		
        _doAvailableScrollList = new ScrollList<DO>(null, 400, 200, "labelFullForButton", ScrollItemDO);
		_doAvailableScrollList.scrollbarOptions.gripStyle = GripStyle.LINE;
		_doAvailableScrollList.scrollbarOptions.gripColor = Colors.BLUE2;
		_doAvailableScrollList.scrollbarOptions.backgroundColor = Colors.DARK_BLUE2;
		
        _doSelectedScrollList = new ScrollList<DO>(null, 400, 200, "labelFullForButton", ScrollItemDO);
		_doSelectedScrollList.scrollbarOptions.gripStyle = GripStyle.LINE;
		_doSelectedScrollList.scrollbarOptions.gripColor = Colors.BLUE2;
		_doSelectedScrollList.scrollbarOptions.backgroundColor = Colors.DARK_BLUE2;
		
		_arrow = Icons.getIcon( Icon.PAGER_NEXT_GREY3 );
		
		_displayMode(  DisplayMode.SELECT );
		
		_draw();
		
		addEventListener( Event.ADDED_TO_STAGE, _init );
		addEventListener( Event.REMOVED_FROM_STAGE, _destroy );		
	}

	private function _init(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, _init);	

		_mainArea = _background.getRect( this );			


		stage.focus = this;

		Actuate.tween( this, 0.5, { alpha:1 } );
	}
	

	private function _destroy( e:Event ):Void 
	{
		//not used in html5
		/*
		if ( stage.hasEventListener( Event.COPY ) )
			stage.removeEventListener( Event.COPY, _stageCopyHandler );
		*/
	}
	
	private function _draw()
	{
		SpriteUtils.drawRoundSquare( _background, Std.int(_width), Std.int(_height), 8, 8, Colors.GREY1 );
		
		var padding:Int = 20;
		var contentRect:Rectangle = new Rectangle( padding, padding, _width - padding * 2, _height - padding * 2 );
		var contentCenter:Float = contentRect.left + contentRect.width * 0.5;
		var restV:Float = contentRect.height;
		
		
		if ( _currentDisplayMode == DisplayMode.SELECT )
		{					
			_txtMessage.x = contentRect.left;
			_txtMessage.y = contentRect.top;
			_txtMessage.width = contentRect.width;
			
			_btSelectAll.x = contentCenter - _btSelectAll.width - padding;
			_btSelectAll.y = _txtMessage.y + _txtMessage.height + padding;
			_lblDOAvailable.x = contentRect.left;
			_lblDOAvailable.y = _txtMessage.y + _txtMessage.height + padding;
			_lblDOAvailable.width = _btSelectAll.x - _lblDOAvailable.x;
			_btClearSelected.x = contentRect.right - _btClearSelected.width;
			_btClearSelected.y = _txtMessage.y + _txtMessage.height + padding;
			_lblDOSelected.x = contentCenter + padding;
			_lblDOSelected.y = _txtMessage.y + _txtMessage.height + padding;
			_lblDOSelected.width = _btClearSelected.x - _lblDOSelected.x;
			
			_arrow.x = contentCenter - _arrow.width * 0.5;
			_arrow.y = contentRect.height * 0.5;	
			
			_btCancel.x = contentRect.x + ( contentCenter - _btCancel.width ) *0.5 - padding;
			_btCancel.y = contentRect.bottom - _btCancel.height;
			_btValid.x = contentCenter + ( contentCenter - _btValid.width ) *0.5;
			_btValid.y = contentRect.bottom - _btValid.height;		
			
			var leftListRect:Rectangle = new Rectangle( contentRect.x, _lblDOAvailable.y + _lblDOAvailable.height + padding / 2, contentRect.width * 0.5 - padding, _btCancel.y - padding - _lblDOAvailable.y - _lblDOAvailable.height - padding / 2 );
			var rightListRect:Rectangle = new Rectangle( contentCenter + padding, _lblDOSelected.y + _lblDOSelected.height + padding / 2, leftListRect.width, _btValid.y - padding - _lblDOSelected.y - _lblDOSelected.height - padding / 2 );
			
			_itemsBackgrounds.graphics.clear();
			_itemsBackgrounds.graphics.beginFill( Colors.DARK_BLUE2 );
			_itemsBackgrounds.graphics.drawRoundRect( leftListRect.x, leftListRect.y, leftListRect.width, leftListRect.height, 4, 4 );
			_itemsBackgrounds.graphics.drawRoundRect( rightListRect.x, rightListRect.y, rightListRect.width, rightListRect.height, 4, 4 );
			_itemsBackgrounds.graphics.endFill();
			
			leftListRect.inflate( -8, -8 );
			_doAvailableScrollList.setRect( leftListRect );
			rightListRect.inflate( -8, -8 );
			_doSelectedScrollList.setRect( rightListRect );
		}
	
		if ( _currentDisplayMode == DisplayMode.RESULT )
		{		
			_txtMessage.x = contentRect.left;
			_txtMessage.y = contentRect.top;
			_txtMessage.width = contentRect.width;			
			
			_btClose.x = contentCenter - _btClose.width *0.5;
			_btClose.y = contentRect.bottom - _btClose.height;
			
			
			_itemsBackgrounds.graphics.clear();
			
			if ( _txtResult.text.length > 0 )
			{
			
				var resultRect:Rectangle = new Rectangle( contentRect.x, _txtMessage.y + _txtMessage.height + padding, contentRect.width, _btClose.y - padding - _txtMessage.y - _txtMessage.height - padding );
				
				_itemsBackgrounds.graphics.beginFill( Colors.WHITE );
				_itemsBackgrounds.graphics.drawRoundRect( resultRect.x, resultRect.y, resultRect.width, resultRect.height, 4, 4 );
				_itemsBackgrounds.graphics.endFill();
				
				resultRect.inflate( -8, -8 );
				_txtResult.x = resultRect.x;
				_txtResult.y = resultRect.y;
				_txtResult.width = resultRect.width;
				_txtResult.height = resultRect.height;			
				
				_sbResult.visible = ( _txtResult.maxScrollV > 1 );
				_sbResult.x = _txtResult.x + _txtResult.width;
				_sbResult.y = _txtResult.y;
				_sbResult.update();
			}else{
				_txtResult.visible = false;
				_sbResult.visible = false;
			}
		}
	}

	private function _displayMode( mode:DisplayMode, ?resultMessage:String, ?resultContent:String ):Void 
	{		
		_currentDisplayMode = mode;
		
		switch (_currentDisplayMode)
		{
			case SELECT:
				_txtMessage.text = Locale.get( "DUPLICATE_VISIT_MESSAGE" );
				_lblDOAvailable.setText( Locale.get( "LABEL_AVAILABLE_DO_LIST" ) );
				addChild( _lblDOAvailable );
				_lblDOSelected.setText( Locale.get( "LABEL_SELECTED_DO_LIST" ) );
				addChild( _lblDOSelected );
				_btValid.addEventListener(MouseEvent.CLICK, _validClickHandler);
				addChild( _btValid );
				_btCancel.addEventListener(MouseEvent.CLICK, _cancelClickHandler);
				addChild( _btCancel );
				_btSelectAll.addEventListener(MouseEvent.CLICK, _selectAllClickHandler);
				addChild( _btSelectAll );
				_btClearSelected.addEventListener(MouseEvent.CLICK, _clearSelectedClickHandler);
				addChild( _btClearSelected );
				addChild( _arrow);
				Actuate.tween( _arrow, 0.3, {alpha:0} ).ease(Linear.easeNone).repeat().reflect();
				_doAvailableScrollList.addEventListener(Event.SELECT, _selectListItemHandler);
				_doAvailableScrollList.update( DO.list.clone() );
				addChild(_doAvailableScrollList);
				_doSelectedScrollList.addEventListener(Event.SELECT, _selectListItemHandler);
				addChild(_doSelectedScrollList);
				_doSelectedScrollList.update( new Collection<DO>() );
				
			case RESULT:							
				removeChild( _lblDOAvailable );
				removeChild( _lblDOSelected );
				_btValid.removeEventListener(MouseEvent.CLICK, _validClickHandler);
				removeChild( _btValid );
				_btCancel.removeEventListener(MouseEvent.CLICK, _cancelClickHandler);
				removeChild( _btCancel );
				_btSelectAll.removeEventListener(MouseEvent.CLICK, _selectAllClickHandler);
				removeChild( _btSelectAll );
				_btClearSelected.removeEventListener(MouseEvent.CLICK, _clearSelectedClickHandler);
				removeChild( _btClearSelected );
				Actuate.stop( _arrow );
				removeChild( _arrow);				
				_doAvailableScrollList.removeEventListener(Event.SELECT, _selectListItemHandler);
				removeChild(_doAvailableScrollList);				
				_doSelectedScrollList.removeEventListener(Event.SELECT, _selectListItemHandler);				
				removeChild( _doSelectedScrollList );
				
				
				_btClose.addEventListener(MouseEvent.CLICK, _cancelClickHandler);
				addChild( _btClose );
				addChild( _txtResult );
				
				if ( resultMessage != null ) _txtMessage.text = resultMessage;
				if ( resultContent != null ) _txtResult.text = resultContent;
				
				_sbResult = new Scrollbar();
				_sbResult.options.gripStyle = GripStyle.LINE;
				_sbResult.options.gripColor = Colors.GREY2;
				_sbResult.options.background = false;
				_sbResult.target = _txtResult;
				_sbResult.visible = false;
				addChild( _sbResult );
				
				
				//not used in html5
				/*
				stage.addEventListener( Event.COPY, _stageCopyHandler );
				*/
		}
		
	}	
	


	private function _selectListItemHandler(e:Event):Void 
	{
		if ( e.target == _doAvailableScrollList )
		{
			_doSelectedScrollList.datas.addItemAt( _doAvailableScrollList.selectedData, 0 );
			_doAvailableScrollList.datas.removeItem( _doAvailableScrollList.selectedData );			
		}
		if ( e.target == _doSelectedScrollList )
		{
			_doAvailableScrollList.datas.addItem( _doSelectedScrollList.selectedData );
			_doAvailableScrollList.datas.sort( "label" );
			_doSelectedScrollList.datas.removeItem( _doSelectedScrollList.selectedData );		
		}	
		_doSelectedScrollList.update();
		var scrollPosition:Float = _doAvailableScrollList.scrollPosition;
		_doAvailableScrollList.update();
		_doAvailableScrollList.scrollPosition = scrollPosition;
	}
	
	
	private function _clearSelectedClickHandler(e:MouseEvent):Void 
	{
		_doSelectedScrollList.clear();
		_doAvailableScrollList.update( DO.list.clone() );
	}

	private function _selectAllClickHandler(e:MouseEvent):Void 
	{
		_doSelectedScrollList.update( DO.list.clone() );
		_doAvailableScrollList.clear();
	}




			
	private function _cancelClickHandler(e:MouseEvent):Void 
	{
		dispatchEvent( new Event( Event.CLOSE ) );
	}	
	private function _validClickHandler(e:MouseEvent):Void 
	{
		if ( _doSelectedScrollList.datas.length > 0 )
		{
			ServiceManager.instance.addEventListener( ServiceEvent.COMPLETE, _duplicateCompleteHandler );
			ServiceManager.instance.duplicateDOVisit( _data, _doSelectedScrollList.datas ); 
		}
	}		

	private function _duplicateCompleteHandler(e:ServiceEvent):Void 
	{
		if ( e.currentCall == ServiceManager.instance.duplicateDOVisit )
		{
			ServiceManager.instance.removeEventListener( ServiceEvent.COMPLETE, _duplicateCompleteHandler );
			
			var idDOInConflictList:Array<Int> = e.result;
			//var idDOInConflictList:Array<Int> = e.result.split( "|" );			
			
			if ( idDOInConflictList.length == 0 )
			{				
				_displayMode( DisplayMode.RESULT, Locale.get( "DUPLICATE_VISIT_COMPLETE_OK_MESSAGE" ) ); 				
			}else {
				
				var resultContent:String = "";
				
				for ( idDO in idDOInConflictList )
				{
					resultContent += "- " + DO.list.getItemBy( "id", idDO ).label + "\n";
				}
				_displayMode( DisplayMode.RESULT, Locale.get( "DUPLICATE_VISIT_COMPLETE_ERROR_MESSAGE" ), resultContent); 
			}
			
			_draw();
		}
	}

	

	//not used in html5
	/*
	private function _stageCopyHandler(e:Event):Void 
	{
		Clipboard.generalClipboard.clear();
		Clipboard.generalClipboard.setData( ClipboardFormats.TEXT_FORMAT, _txtResult.selectedText );
		
	}
	*/
	
	
	
	public function  setRect( rect:Rectangle ):Void
	{
		x = rect.x;
		y = rect.y;
		_width = rect.width;
		_height = rect.height;
		
		_draw();
	}
}