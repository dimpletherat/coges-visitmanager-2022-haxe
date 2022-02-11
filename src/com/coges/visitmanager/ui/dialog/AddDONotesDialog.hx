package com.coges.visitmanager.ui.dialog;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.vo.DO;
import nbigot.ui.control.BaseButton;
import nbigot.ui.control.RoundRectSprite;
import nbigot.ui.control.Scrollbar;
import nbigot.ui.control.Scrollbar.GripStyle;
import nbigot.ui.dialog.BaseDialog;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogSkin;
import nbigot.ui.dialog.DialogValue;
import nbigot.utils.SpriteUtils;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;

/**
	 * ...
	 * @author Nicolas Bigot
	 */

	 


class AddDONotesDialog extends BaseDialog
{
    private var _title:String;
    private var _message:String;
	private var _background:Sprite;
	private var _titleLine:Sprite;
    private var _btConfirm:BaseButton;
    private var _btCancel:BaseButton;
    private var _txtMessage:TextField;
	
    private var _txtTitle:TextField;
    private var _txtNotes:TextField;
    private var _backgroundNotes:RoundRectSprite;
    private var _sbNotes:Scrollbar;
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
		
		_backgroundNotes = new RoundRectSprite( 100, 100, 6, 6);
		addChild( _backgroundNotes );
		
		_txtNotes = new TextField();
		_txtNotes.embedFonts = true;
        _txtNotes.antiAliasType = AntiAliasType.ADVANCED;
		_txtNotes.type = TextFieldType.INPUT;
		//_txtNotes.border = true;
		_txtNotes.multiline = true;
		_txtNotes.wordWrap = true;
		_txtNotes.defaultTextFormat = _skin.contentFormat;
        _txtNotes.text = DO.selected.notes;		
		//BUG : Event.CHANGE is not fired with Dom renderer
		//FIX : while waiting for an update, we add TextEvent.TEXT_INPUT as a fallback
        _txtNotes.addEventListener(Event.CHANGE, _txtNotesChangeHandler);
        _txtNotes.addEventListener(TextEvent.TEXT_INPUT, _txtNotesChangeHandler);
		addChild( _txtNotes );
		
		_sbNotes = new Scrollbar();
		_sbNotes.options.gripStyle = GripStyle.LINE;
		_sbNotes.options.gripColor = Colors.GREY2;
		_sbNotes.options.background = false;
        _sbNotes.target = _txtNotes;
		addChild( _sbNotes );
		
        
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
		
        
        _updateNotesScrollBar();
    }
    override public function draw( parentSize:Point ) : Void
    {
		_parentSize = parentSize;
		
		var marg = _skin.contentMargin;
		var noteHeight:Int = 180;
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
		var dialogHeight:Float = _txtTitle.height + _titleLine.height + _txtMessage.height + noteHeight + _btCancel.height + _skin.contentMargin * 6.5;
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
		
		
		_backgroundNotes.x = contentRect.left;
		_backgroundNotes.y = _txtMessage.y + _txtMessage.height + marg;
		_backgroundNotes.width = contentRect.width;
		_backgroundNotes.height = noteHeight;
		_txtNotes.x = _backgroundNotes.x + 10;
		_txtNotes.y = _backgroundNotes.y + 10;
		_txtNotes.width = _backgroundNotes.width - 20;
		_txtNotes.height = noteHeight - 20;
		
		_sbNotes.x = _txtNotes.x + _txtNotes.width;
		_sbNotes.y = _txtNotes.y;
		_sbNotes.update();	
		
		_btCancel.x = contentRect.left;
		_btCancel.y = contentRect.bottom - _btCancel.height;
		_btConfirm.x = contentRect.right - _btConfirm.width;
		_btConfirm.y = contentRect.bottom - _btConfirm.height;
    }
	
	
    private function _txtNotesChangeHandler(e:Event):Void
    {
        _updateNotesScrollBar(true);
    }
    
    private function _updateNotesScrollBar(showAlwaysLastLine:Bool = false):Void
    {
        _sbNotes.visible = (_txtNotes.maxScrollV > 1);
        if (showAlwaysLastLine)
        {
            _txtNotes.scrollV = _txtNotes.maxScrollV;
        }
        else
        {
            _txtNotes.scrollV = 1;
        }
        _sbNotes.updatePosition(true);
    }
	
    private function _clickConfirmHandler(e : MouseEvent) : Void
    {
        DialogManager.instance.close( DialogValue.DATA(_txtNotes.text));
    }
    
    private function _clickCancelHandler(e : MouseEvent) : Void
    {
        DialogManager.instance.close(DialogValue.CANCEL);
    }
}

