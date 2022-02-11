package com.coges.visitmanager.ui 
{
	import com.coges.visitmanager.datas.ServiceManager;
	import com.coges.visitmanager.Debug;
	import com.coges.visitmanager.events.ServiceEvent;
	import com.coges.visitmanager.fonts.FontName;
	import com.coges.visitmanager.IconManager;
	import com.coges.visitmanager.ui.components.*;
	import com.coges.visitmanager.vo.*;
	import com.greensock.TweenLite;
	import com.ibs.ui.components.ScrollBar;
	import com.ibs.ui.popup.*;
	import com.ibs.utils.*;
	import fl.lang.Locale;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.*;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.*;
	/**
	 * ...
	 * @author Nicolas Bigot
	 */
	public class DuplicateVisitPanel  extends Sprite
	{
		private static const _BACKGROUND_DEPTH:int = 0;
		private static const _GRADIENT_DEPTH:int = 1;
		
		private var _data:Visit;
		private var _mainArea:Rectangle;		
		private var _availableDOScrollList:ScrollList;
		private var _selectedDOScrollList:ScrollList;
		private var _borders:Shape;
		
		public var btValid:Button;
		public var btCancel:Button;
		public var btSelectAll:Button;
		public var btClearSelected:Button;
		public var txtMessage:TextField;
		public var txtResult:TextField;
		public var txtSelectedList:TextField;
		public var txtAvailableList:TextField;
		public var chevronAnim:MovieClip;
		public var background:Sprite;
		
		public function DuplicateVisitPanel( data:Visit = null )
		{
			_data = data;
			alpha = 0;
			addEventListener( Event.ADDED_TO_STAGE, _init );
			addEventListener( Event.REMOVED_FROM_STAGE, _destroy );
		}
		
		private function _destroy( e:Event ):void 
		{
			if ( stage.hasEventListener( Event.COPY ) )
				stage.removeEventListener( Event.COPY, _copyHandler );
		}
			
		private function _init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, _init);	
			
			_mainArea = background.getRect( this );			
			
			var tfLabels:TextFormat = new TextFormat();
			tfLabels.size = 18;
			tfLabels.font = FontName.ARIAL_B_I_BI;
			_initializeTextFields( tfLabels );
			
			tfLabels.size = 16;
			txtResult.defaultTextFormat = tfLabels;
			
			tfLabels.size = 13;
			tfLabels.bold = true;
			
			txtSelectedList.defaultTextFormat = tfLabels;
			txtAvailableList.defaultTextFormat = tfLabels;			
			
			var gradient:Shape = Colorizer.colorizeGradient( this, 0xFFFFFF, 0xCCCCCC, background.getRect(this));
			
			// remise au premier plan apres colorisation
			addChildAt( background, _BACKGROUND_DEPTH );
			addChildAt( gradient, _GRADIENT_DEPTH );
			
			btValid.textFont = FontName.ARIAL_B_I_BI;
			btValid.label = Locale.loadString( "BT_VALID_LABEL" );
			var iconValid:DisplayObject = IconManager.instance.getIcon( IconID.VALID );
			if ( iconValid ) btValid.icon = iconValid;
			btValid.addEventListener( MouseEvent.CLICK, _clickValidHandler );
			
			btCancel.textFont = FontName.ARIAL_B_I_BI;
			btCancel.label = Locale.loadString( "BT_CANCEL_LABEL" );
			var iconCancel:DisplayObject = IconManager.instance.getIcon( IconID.CANCEL );
			if ( iconCancel ) btCancel.icon = iconCancel;
			btCancel.addEventListener( MouseEvent.CLICK, _clickCancelHandler );
			
			
			btSelectAll.textFont = FontName.ARIAL_B_I_BI;
			btSelectAll.label = Locale.loadString( "BT_SELECT_ALL_LABEL" );
			btSelectAll.addEventListener( MouseEvent.CLICK, _clickSelectAllHandler );
			btClearSelected.textFont = FontName.ARIAL_B_I_BI;
			btClearSelected.label = Locale.loadString( "BT_CLEAR_LABEL" );
			btClearSelected.addEventListener( MouseEvent.CLICK, _clickClearSelectedHandler );
			
			stage.focus = this;
			
			_displayScrollLists();
			
			_displaySelectView();
			TweenLite.to( this, 0.5, { alpha:1 } );	
		}
		
		private function _displayScrollLists():void 
		{
			_borders = new Shape();
			addChild( _borders );
			_borders.graphics.lineStyle( 2, 0xFFFFFF );
			
			var listWidth:int = 370;
			var listHeight:int = 300;
			
			_availableDOScrollList = new ScrollList( DO.list.clone(), listWidth, listHeight, "labelFullForButton", ScrollListItemDO );	
			_availableDOScrollList.x = background.x + 10;	
			_availableDOScrollList.y = 220;	
			_availableDOScrollList.addEventListener( Event.SELECT, _selectListItemHandler );
			addChild( _availableDOScrollList );	
			_borders.graphics.drawRect( _availableDOScrollList.x-2, _availableDOScrollList.y-2, listWidth+4, listHeight+4 );
			
			_selectedDOScrollList = new ScrollList( new ArrayCollection(), listWidth, listHeight, "labelFullForButton", ScrollListItemDO );	
			_selectedDOScrollList.x = _availableDOScrollList.x + listWidth + 40;// background.x + ( background.width - 600) / 2;	
			_selectedDOScrollList.y = 220;	
			_selectedDOScrollList.addEventListener( Event.SELECT, _selectListItemHandler );
			addChild( _selectedDOScrollList );
			_borders.graphics.drawRect( _selectedDOScrollList.x-2, _selectedDOScrollList.y-2, listWidth+4, listHeight+4 );
		}
		
		private function _selectListItemHandler(e:Event):void 
		{
			switch( e.target )
			{
				case _availableDOScrollList:
					_selectedDOScrollList.datas.addItemAt( _availableDOScrollList.selectedData, 0 );
					_availableDOScrollList.datas.removeItem( _availableDOScrollList.selectedData );
					break
				case _selectedDOScrollList:
					_availableDOScrollList.datas.addItem( _selectedDOScrollList.selectedData );
					_availableDOScrollList.datas.sort( "label" );
					_selectedDOScrollList.datas.removeItem( _selectedDOScrollList.selectedData );
					break;
				default:
					return;				
			}			
			_selectedDOScrollList.update();
			var scrollPosition:Number = _availableDOScrollList.scrollPosition;
			_availableDOScrollList.update();
			_availableDOScrollList.scrollPosition = scrollPosition;
		}
		private function _clickClearSelectedHandler(e:MouseEvent):void 
		{
			_selectedDOScrollList.clear();
			_availableDOScrollList.update( DO.list.clone() );
		}
		
		private function _clickSelectAllHandler(e:MouseEvent):void 
		{
			_selectedDOScrollList.update( DO.list.clone() );
			_availableDOScrollList.clear();
		}
		
		
		private function _displaySelectView():void 
		{		
			txtResult.visible = false;
			txtMessage.text = Locale.loadString( "DUPLICATE_VISIT_MESSAGE" );
			
			txtAvailableList.wordWrap = txtSelectedList.wordWrap = false;
			txtAvailableList.y = txtSelectedList.y = _availableDOScrollList.y - 24;
			txtAvailableList.x = _availableDOScrollList.x;
			txtAvailableList.autoSize = TextFieldAutoSize.LEFT;
			txtAvailableList.text = Locale.loadString( "LABEL_AVAILABLE_DO_LIST" );
			txtSelectedList.x = _selectedDOScrollList.x;
			txtSelectedList.autoSize = TextFieldAutoSize.LEFT;
			txtSelectedList.text = Locale.loadString( "LABEL_SELECTED_DO_LIST" );
			
			chevronAnim.x = _selectedDOScrollList.x - 20 - chevronAnim.width / 2;
			chevronAnim.y = _availableDOScrollList.y + _availableDOScrollList.height / 2 - chevronAnim.height / 2;
			
			btClearSelected.y = txtSelectedList.y;
			btClearSelected.x = _mainArea.right - 10 - btClearSelected.width;
			
			btSelectAll.y = txtAvailableList.y;
			btSelectAll.x = _selectedDOScrollList.x - 40 - btSelectAll.width;
			
		}		
		
		private function _initializeTextFields(tfLabels:TextFormat):void 
		{
			var i:int = numChildren;
			var t:DisplayObject;
			while ( --i >= 0 ) {
				t = getChildAt( i );
				if ( t is TextField ) {
					TextField(t).defaultTextFormat = tfLabels;
					TextField(t).embedFonts = true;
					TextField(t).antiAliasType = AntiAliasType.ADVANCED;
					TextField(t).wordWrap = true;
					TextField(t).multiline = true;
					
					
					//TextField(t).border = true;
				}
			}
		}
		
		
		
					
		private function _clickCancelHandler(e:MouseEvent):void 
		{
			parent.removeChild( this );
		}	
		private function _clickValidHandler(e:MouseEvent):void 
		{
			if ( _selectedDOScrollList.datas.length > 0 )
			{
				ServiceManager.instance.addEventListener( ServiceEvent.COMPLETE, _duplicateCompleteHandler );
				ServiceManager.instance.duplicateDOVisit( _data, _selectedDOScrollList.datas ); 
			}
		}		
		
		private function _duplicateCompleteHandler(e:ServiceEvent):void 
		{
			if ( e.currentCall == ServiceManager.instance.duplicateDOVisit )
			{
				ServiceManager.instance.removeEventListener( ServiceEvent.COMPLETE, _duplicateCompleteHandler );
				var resultXML:XML = new XML( e.result );
				var success:Boolean = resultXML.success == "true";
				if ( success )
				{
					_displayDuplicateCompleteView( Locale.loadString( "DUPLICATE_VISIT_COMPLETE_OK_MESSAGE" ), new ArrayCollection() ); 				
				}else {
					var conflictDOList:ArrayCollection = new ArrayCollection();
					var arrId:Array = resultXML.conflictDOIdList.split( "|" );
					var i:int = -1;
					while (  ++i < arrId.length )
					{
						conflictDOList.addItem( DO.list.getItemBy( "id", arrId[i] ) );
					}								
					_displayDuplicateCompleteView( Locale.loadString( "DUPLICATE_VISIT_COMPLETE_ERROR_MESSAGE" ), conflictDOList); 	
				}
			}
		}
		
		private function _displayDuplicateCompleteView( message:String, conflictDOList:ArrayCollection ):void 
		{
			txtAvailableList.visible = false;
			txtSelectedList.visible = false;
			_selectedDOScrollList.visible = false;
			_availableDOScrollList.visible = false;
			btClearSelected.visible = false;
			btSelectAll.visible = false;
			chevronAnim.visible = false;
			_borders.graphics.clear();
			_borders.graphics.lineStyle( 2, 0xFFFFFF );
			_borders.graphics.drawRect( txtResult.x, txtResult.y, txtResult.width, txtResult.height );
			btCancel.visible = false;
			btValid.x = _mainArea.left + _mainArea.width * 0.5 - btValid.width * 0.5;
			btValid.icon = null;
			btValid.label = Locale.loadString( "BT_CLOSE_LABEL" );
			btValid.removeEventListener( MouseEvent.CLICK, _clickValidHandler );
			btValid.addEventListener( MouseEvent.CLICK, _clickCancelHandler );
			txtMessage.height *= 2;
			txtMessage.text = message
			
			txtResult.visible = true;			
			txtResult.selectable = true;
			txtResult.mouseEnabled = true;
			txtResult.useRichTextClipboard = true;
			
			stage.addEventListener( Event.COPY, _copyHandler );
			
			
			var i:int = -1;
			var str:String = "";
			while ( ++i < conflictDOList.length )
			{
				str +=  "- " + conflictDOList.getItemAt( i ).label + "\n";
			}
			txtResult.text = str;
			if ( txtResult.maxScrollV > 1 )
			{
				var sb:ScrollBar = new ScrollBar( txtResult, txtResult.getBounds(this) );
				sb.y = txtResult.y;
				sb.x = txtResult.x + txtResult.width;
				addChild( sb );
			}
		}
		
		private function _copyHandler(e:Event):void 
		{
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData( ClipboardFormats.TEXT_FORMAT, txtResult.selectedText );
		}
		
		
	}

}