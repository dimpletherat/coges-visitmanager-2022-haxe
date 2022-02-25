package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import nbigot.ui.control.BaseButton;
import nbigot.ui.dialog.BaseDialog;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogSkin;
import nbigot.ui.dialog.DialogValue;
import nbigot.utils.SpriteUtils;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
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
class VMMessageDialog extends BaseDialog
{
    private var _title:String;
    private var _message:String;
	private var _background:Sprite;
	private var _titleLine:Sprite;
    private var _btClose:BaseButton;
    
    private var _txtTitle:TextField;
    private var _txtMessage:TextField;
    private var _icon:DisplayObject;
    
    public function new(title:String, message:String, ?icon:DisplayObject)
    {
		super();
		_title = title;
		_message = message;
		_icon = icon;
    }
    
    override public function init(skin:DialogSkin):Void
    {
		_skin = skin;
		
		_background = new Sprite();
		addChild( _background );
		
		
		_txtTitle = new TextField();
		_txtTitle.embedFonts = true;
        _txtTitle.antiAliasType = AntiAliasType.ADVANCED;
        _txtTitle.autoSize = TextFieldAutoSize.LEFT;
		_txtTitle.multiline = true;
		//_txtTitle.wordWrap = true;
		_txtTitle.defaultTextFormat = _skin.titleFormat;
		_txtTitle.htmlText = _title;		
		addChild( _txtTitle );
		
		_titleLine = new Sprite();
		addChild( _titleLine );
		
		if ( _icon != null )
			addChild( _icon );
		
		
		_txtMessage = new TextField();
		_txtMessage.embedFonts = true;
        _txtMessage.antiAliasType = AntiAliasType.ADVANCED;
        _txtMessage.autoSize = TextFieldAutoSize.LEFT;
		_txtMessage.multiline = true;
		_txtMessage.wordWrap = true;
		_txtMessage.defaultTextFormat = _skin.contentFormat;
		_txtMessage.htmlText = _message;		
		addChild( _txtMessage );
		
        
        _btClose = new BaseButton( _skin.closeButtonLabel, _skin.closeButtonFormat, SpriteUtils.createRoundSquare( 140, 30, 6, 6, Colors.GREY3 ));
		_btClose.borderEnabled = false;
        _btClose.addEventListener(MouseEvent.CLICK, _clickCloseHandler);
		addChild( _btClose );
    }
    override public function draw( parentSize:Point ) : Void
    {
		_parentSize = parentSize;
		
		var marg = _skin.contentMargin;
		//var dialogWidth:Float = _parentSize.x * 0.25;		
		var dialogWidth:Float = _parentSize.x * 0.30;		
		if ( _parentSize.x <= Config.LAYOUT2_MAX_WIDTH )
		{
			dialogWidth = _parentSize.x * 0.50;	
		}
		if ( _parentSize.x <= Config.LAYOUT1_MAX_WIDTH )
		{
			dialogWidth = _parentSize.x * 0.60;	
		}
		
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
		var dialogHeight:Float = _txtTitle.height + _titleLine.height + _txtMessage.height + _btClose.height + _skin.contentMargin * 5.5;		
		
		//2022-evolution
		if ( _icon != null )
		{
			if ( _icon.height > _txtTitle.height )
				dialogHeight += (_icon.height - _txtTitle.height);
		}
		
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
		
		//2022-evolution
		if ( _icon != null )
		{
			if ( _icon.height > _txtTitle.height )
				_titleLine.y  = _icon.y + _icon.height + marg * 0.5;
		}
		
		_txtMessage.x = contentRect.left;
		_txtMessage.y = _titleLine.y + _titleLine.height + marg;		
		
		_btClose.x = contentRect.left + ( contentRect.width - _btClose.width ) * 0.5;
		_btClose.y = contentRect.bottom	 - _btClose.height;
    }
    
    
    private function _clickCloseHandler(e : MouseEvent) : Void
    {
        DialogManager.instance.close(DialogValue.CLOSE);
    }
}

