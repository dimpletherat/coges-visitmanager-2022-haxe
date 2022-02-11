package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.ui.components.ScrollItemEmail;
import com.coges.visitmanager.ui.components.TextInputEmail;
import nbigot.ui.IconPosition;
import nbigot.ui.control.BaseButton;
import nbigot.ui.control.Scrollbar.GripStyle;
import nbigot.ui.dialog.BaseDialog;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogSkin;
import nbigot.ui.dialog.DialogValue;
import nbigot.ui.list.ScrollList;
import nbigot.utils.Collection;
import nbigot.utils.SpriteUtils;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

	 


class ExportExcelDialog extends BaseDialog
{
    private var _title:String;
    private var _message:String;
	private var _background:Sprite;
	private var _titleLine:Sprite;
    private var _btConfirm:BaseButton;
    private var _btCancel:BaseButton;
    private var _btAddEmail:BaseButton;
    private var _emailList:Collection<String>;
    private var _emailScrollList:ScrollList<String>;
    private var _txtEmail:TextInputEmail;
    private var _txtTitle:TextField;
    private var _txtMessage:TextField;
    private var _icon:DisplayObject;
    
    public function new(title:String, message:String, ?icon:DisplayObject)
    {
		super();
		_message = message;
		_title = title;
		_icon = icon;
    }
    
    override public function init(skin:DialogSkin):Void
    {
		_skin = skin;
		
		_background = new Sprite();
		addChild( _background );
		
		
		_txtMessage = new TextField();
		_txtMessage.embedFonts = true;
        _txtMessage.antiAliasType = AntiAliasType.ADVANCED;
        _txtMessage.autoSize = TextFieldAutoSize.LEFT;
		_txtMessage.multiline = true;
		_txtMessage.wordWrap = true;
		_txtMessage.defaultTextFormat = _skin.contentFormat;
		_txtMessage.htmlText = _message;		
		addChild( _txtMessage );	
		
		
		
		_txtTitle = new TextField();
		_txtTitle.embedFonts = true;
        _txtTitle.antiAliasType = AntiAliasType.ADVANCED;
        _txtTitle.autoSize = TextFieldAutoSize.LEFT;
		_txtTitle.multiline = true;
		//_txtTitle.wordWrap = true;
		//_txtTitle.border = true;
		_txtTitle.defaultTextFormat = _skin.titleFormat;
		_txtTitle.htmlText = _title;		
		addChild( _txtTitle );
		
		_titleLine = new Sprite();
		addChild( _titleLine );
		
		if ( _icon != null )
			addChild( _icon );	
        
        _txtEmail = new TextInputEmail();
        addChild(_txtEmail);
		
        _btAddEmail = new BaseButton("", null, SpriteUtils.createRoundSquare( 80, 30, 6, 6, Colors.GREEN2) );
		_btAddEmail.borderEnabled = false;
		_btAddEmail.setIcon( Icons.getIcon(Icon.PLUS), null, IconPosition.CENTER );
        _btAddEmail.addEventListener(MouseEvent.CLICK, _addEmailClickHandler);
		addChild( _btAddEmail );
		
		_emailScrollList = new ScrollList<String>( null, 50, 50, "whatever", ScrollItemEmail );
		_emailScrollList.scrollbarOptions.gripStyle = GripStyle.LINE;
		_emailScrollList.scrollbarOptions.gripColor = Colors.GREY2;
		_emailScrollList.scrollbarOptions.backgroundColor = Colors.GREY4;
		_emailScrollList.scrollbarOptions.alwaysVisible = true;
        _emailScrollList.addEventListener(Event.SELECT, _selectListItemHandler);
		addChild( _emailScrollList );
		
        
        _btCancel = new BaseButton( _skin.cancelButtonLabel, _skin.cancelButtonFormat, SpriteUtils.createRoundSquare( 140, 30, 6, 6, Colors.RED2 ));
		_btCancel.borderEnabled = false;
		_btCancel.setIcon( Icons.getIcon(Icon.CANCEL), new Point( 50, 30) );
        _btCancel.addEventListener(MouseEvent.CLICK, _clickCancelHandler);
		addChild( _btCancel );
		
        
        _btConfirm = new BaseButton( _skin.confirmButtonLabel, _skin.confirmButtonFormat, SpriteUtils.createRoundSquare( 140, 30, 6, 6, Colors.GREEN2 ));
		_btConfirm.setIcon( Icons.getIcon(Icon.VALID), new Point( 50, 30) );
		_btConfirm.borderEnabled = false;
        _btConfirm.addEventListener(MouseEvent.CLICK, _clickConfirmHandler);
		addChild( _btConfirm );
		
		
		
        _emailList = new Collection<String>();
    }
    override public function draw( parentSize:Point ) : Void
    {
		_parentSize = parentSize;
		
		var marg = _skin.contentMargin;
		var emailScrollHeight:Int = 120;
		var dialogWidth:Float = _parentSize.x * 0.30;
		var dialogHeight:Float = 100;	
		var contentRect:Rectangle = new Rectangle( (parentSize.x - dialogWidth) * 0.5 + marg, (parentSize.y - dialogHeight) * 0.5 + marg, dialogWidth - marg * 2, dialogHeight - marg * 2 );
		
		_txtMessage.width = contentRect.width;
		var titleMaxWidth:Float = ( _icon != null ) ? contentRect.width - _icon.width - marg * 0.5  : contentRect.width;
        _txtTitle.autoSize = TextFieldAutoSize.LEFT;
		_txtTitle.wordWrap = false;
		if ( _txtTitle.width > titleMaxWidth )
		{
			_txtTitle.wordWrap = true;	
			_txtTitle.width = titleMaxWidth;
		}
		
		SpriteUtils.drawSquare( _titleLine, Std.int(contentRect.width), 1, _skin.titleBackgroundColor );		
		
		// Set the height resulting of all resized elements
		var dialogHeight:Float = _txtTitle.height + _titleLine.height + _txtMessage.height + _txtEmail.height + emailScrollHeight + _btCancel.height + _skin.contentMargin * 6.5;
		// Change contentRect accordingly
		contentRect.height = dialogHeight - marg * 2;
		contentRect.y = (parentSize.y - dialogHeight) * 0.5 + marg;
		
		SpriteUtils.drawRoundSquare( _background, Std.int(dialogWidth), Std.int(dialogHeight), 8, 8, _skin.contentBackgroundColor );
		_background.x = (parentSize.x - dialogWidth) * 0.5;
		_background.y = (parentSize.y - dialogHeight) * 0.5;
		
		_txtTitle.y = contentRect.top;
		if ( _icon != null )
		{
			_icon.x = contentRect.left + ( contentRect.width - _icon.width - marg * 0.5 - _txtTitle.width ) * 0.5;
			_icon.y = _txtTitle.y + 4;
			_txtTitle.x = _icon.x + _icon.width + marg * 0.5;
		}else{			
			_txtTitle.x = contentRect.left + ( contentRect.width - _txtTitle.width ) * 0.5;
		}
		
		_titleLine.x  = contentRect.left;
		_titleLine.y  = _txtTitle.y + _txtTitle.height + marg * 0.5;
		
		_txtMessage.x = contentRect.left;
		_txtMessage.y = _titleLine.y + _titleLine.height + marg;
		
		_txtEmail.width = contentRect.width - marg - _btAddEmail.width;
		_txtEmail.x = contentRect.left;
		_txtEmail.y = _txtMessage.y + _txtMessage.height + marg;
		
		_btAddEmail.x = contentRect.right - _btAddEmail.width;
		_btAddEmail.y = _txtMessage.y + _txtMessage.height + marg;
		
		
		_btCancel.x = contentRect.left;
		_btCancel.y = contentRect.bottom - _btCancel.height;
		_btConfirm.x = contentRect.right - _btConfirm.width;
		_btConfirm.y = contentRect.bottom - _btConfirm.height;
		
		//var scrollHeight:Float = _btConfirm.y - (_btAddEmail.y + _btAddEmail.height ) - marg * 3;
		_emailScrollList.setRect( new Rectangle( contentRect.left, _btAddEmail.y + _btAddEmail.height + marg, contentRect.width, emailScrollHeight ) );
    }
    
    private function _selectListItemHandler(e:Event):Void
    {
        var selectedEmail:String = _emailScrollList.selectedData;
        _emailList.removeItem(selectedEmail);
        _emailScrollList.datas = _emailList;
    }
    
    private function _addEmailClickHandler(e:MouseEvent):Void
    {
        if (_txtEmail.text.length > 0)
        {
            _emailList.addItemAt(_txtEmail.text, 0);
			_emailScrollList.datas = _emailList;
            _txtEmail.clear();
        }
    }
    
	
    private function _clickConfirmHandler(e : MouseEvent) : Void
    {
        DialogManager.instance.close( DialogValue.DATA(_emailList));
    }
    
    private function _clickCancelHandler(e : MouseEvent) : Void
    {
        DialogManager.instance.close(DialogValue.CANCEL);
    }
}

