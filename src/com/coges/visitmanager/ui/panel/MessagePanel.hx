package com.coges.visitmanager.ui.panel;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Icons;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.datas.DataUpdater;
import com.coges.visitmanager.datas.DataUpdaterEvent;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.components.TextInputMessage;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.vo.DO;
import com.coges.visitmanager.vo.Message;
import com.coges.visitmanager.vo.OppositeOwner;
import com.coges.visitmanager.vo.User;
import feathers.controls.ScrollPolicy;
import feathers.controls.TextArea;
import feathers.graphics.FillStyle;
import feathers.skins.RectangleSkin;
import nbigot.ui.IconPosition;
import nbigot.ui.control.ButtonState;
import nbigot.ui.control.Scrollbar;
import nbigot.utils.DateUtils;
import nbigot.utils.SpriteUtils;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFormat;
import com.coges.visitmanager.core.Utils;
/**
	 * ...
	 * @author Nicolas Bigot
	 */
class MessagePanel extends Sprite
{
	public static final MIN_HEIGHT:Int = 100;

    private var _background:Sprite;
	private var _backgroundColorized:Sprite;
	private var _line:Sprite;
    private var _planningChanged:Bool;
    private var _oppositeOwnerChanged:Bool;
	private var _txtInput:TextInputMessage;
	private var _icoMessage:DisplayObject;
	private var _btRefresh:VMButton;
	private var _btSendMessage:VMButton;	
	
	// WITH FeathersUi --> issue: TextArea cannot display html text
	// private var _txtMessages:TextArea;
	
	// With my lib
	private var _txtMessages:TextField;
    private var _sbMessages:Scrollbar;
	//--
	
	
	
	/*
    public var messageTextInput:MessageTextInput;
    public var txtMessageView:TextField;
	*/
    
    
    public function new()
    {
        super();
		
		
		_background = SpriteUtils.createSquare( 40, 40, Colors.GREY1 );
		addChild(_background);
		_backgroundColorized = SpriteUtils.createRoundSquare( 40, 40, 4, 4, Colors.GREY2 );
		addChild(_backgroundColorized);
		
		
		// WITH FeathersUi --> issue: TextArea cannot display html text
		/*
		_txtMessages = new TextArea();
		_txtMessages.editable = false;
		_txtMessages.textFormat = tf;
		_txtMessages.scrollPolicyY = ScrollPolicy.AUTO;
		_txtMessages.scrollPolicyX = ScrollPolicy.OFF;
		_txtMessages.backgroundSkin = new RectangleSkin( FillStyle.None );
		addChild( _txtMessages );
		*/
		
		// With my lib
		_txtMessages = new TextField();
		_txtMessages.embedFonts = true;
        _txtMessages.antiAliasType = AntiAliasType.ADVANCED;
		//_txtMessages.border = true;
		_txtMessages.multiline = true;
		_txtMessages.wordWrap = true;
		_txtMessages.defaultTextFormat = new TextFormat( Fonts.OPEN_SANS, 12 );
		addChild( _txtMessages );
		
		_sbMessages = new Scrollbar();
		_sbMessages.options.gripStyle = GripStyle.LINE;
		_sbMessages.options.gripColor = Colors.GREY3;
		_sbMessages.options.background = false;
        _sbMessages.target = _txtMessages;
		addChild( _sbMessages );
		//--
		
		_txtInput = new TextInputMessage();
		addChild( _txtInput );
		
		
		_icoMessage = Icons.getIcon( Icon.MESSAGES );
		addChild(_icoMessage);
		
		_btRefresh = new VMButton( "", null, SpriteUtils.createRoundSquare(48, 22, 4, 4, Colors.GREY2) );
		_btRefresh.borderEnabled = false;
		_btRefresh.setBackground( SpriteUtils.createRoundSquare(48, 22, 4, 4, Colors.GREY3), ButtonState.HOVER );
		_btRefresh.setIcon( Icons.getIcon( Icon.MESSAGES_REFRESH ), null, IconPosition.CENTER );
		_btRefresh.toolTipContent = Locale.get("TOOLTIP_BT_REFRESH_MESSAGES");
		_btRefresh.addEventListener( MouseEvent.CLICK, _clickRefreshHandler );
		addChild( _btRefresh );
		
		_btSendMessage = new VMButton( "", null, SpriteUtils.createRoundSquare(48, 22, 4, 4, Colors.GREY2) );
		_btSendMessage.borderEnabled = false;
		_btSendMessage.setBackground( SpriteUtils.createRoundSquare(48, 22, 4, 4, Colors.GREY3), ButtonState.HOVER );
		_btSendMessage.setIcon( Icons.getIcon( Icon.MESSAGES_SEND ), null, IconPosition.CENTER );
		_btSendMessage.toolTipContent = Locale.get("TOOLTIP_SEND_MESSAGE");
		_btSendMessage.addEventListener( MouseEvent.CLICK, _clickSendMessageHandler );
		addChild( _btSendMessage );
		
		_line = SpriteUtils.createSquare( 50, 2, Colors.GREY3 );
		addChild( _line );
		
        DataUpdater.instance.addEventListener(DataUpdaterEvent.OPPOSITE_OWNER_SELECTED_CHANGE, _oppositeOwnerChangeHandler);
        //OppositeOwner.addEventListener(DataUpdaterEvent.OPPOSITE_OWNER_SELECTED_CHANGE, _oppositeOwnerChangeHandler);
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _serviceCompleteHandler);
		
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    //private function _planningOrOppositeOwnerChangeHandler(e:DataUpdateEvent):void
    private function _oppositeOwnerChangeHandler(e:DataUpdaterEvent):Void
    {
        _loadUserMessageList();
    }
    
    private function _serviceCompleteHandler(e:ServiceEvent):Void
    {
        if ( e.currentCall == ServiceManager.instance.getUserMessageList )
		{
			_displayMessages();
			return;
		}else if (e.currentCall == ServiceManager.instance.saveUserMessage ) {
			_loadUserMessageList();
			return;
        }
    }
    
    private function _loadUserMessageList():Void
    {
        _clearMessages();
        //var o:OppositeOwner = OppositeOwner.selected;
        // TODO message si pas o ?
        //if ( o )
        //ServiceManager.instance.getUserMessageList( User.instance, OppositeOwner.list, Planning.selected );
        ServiceManager.instance.getUserMessageList(User.instance, OppositeOwner.list, DO.selected);
    }
	
	
	
    
    
    private function _clickRefreshHandler(e:MouseEvent):Void
    {
        _oppositeOwnerChanged = true;
        _planningChanged = true;
        _loadUserMessageList();
    }
    
    private function _clickSendMessageHandler(e:MouseEvent):Void
    {
		//var o:OppositeOwner = OppositeOwner.selected;
        // TODO message si pas o ?
        // if ( o ){		
		var m:MessageJSON = {			
			id:0,
			idAuthor:User.instance.id,
			authorFirstName:User.instance.firstName,
			authorLastName:User.instance.lastName,
			idDO:DO.selected.id,
			content:_txtInput.text,
			dateString:DateUtils.toDBString(Date.now())
		}
		
        ServiceManager.instance.saveUserMessage(m, User.instance);
    }
    
    
    private function _displayMessages():Void
    {
        var text:String = "";
        var m:Message;
        for ( i in 0...Message.list.length)
        {
            m = Message.list.getItemAt(i);
            if (m.idAuthor == User.instance.id)
            {
                //text += "<font face='" + FontName.ARIAL_B_I_BI + "' color='#555555'><b>" + Locale.get("MESSAGE_PANEL_YOU") + "</b><font size='10'> | " + DateFormat.toCompleteString(m.date, "/", "-") + "</font> <b>> </b>" + m.content + "</font><br>";
                text += "<font face='" + Fonts.OPEN_SANS + "' color='#555555'><b>" + Locale.get("MESSAGE_PANEL_YOU") + "</b><font size='10'> | " + DateUtils.toString(m.date, "DD/MM/YYYY hh:mm:ss") + "</font> <b>> </b>" + m.content + "</font><br>";
            }
            else
            {
                //text += "<font face='" + FontName.ARIAL_B_I_BI + "' color='#000000'><b>" + m.authorFirstName + " " + m.authorLastName + "</b><font size='10'> | " + DateFormat.toCompleteString(m.date, "/", "-") + "</font> <b>> </b>" + m.content + "</font><br>";
                text += "<font face='" + Fonts.OPEN_SANS + "' color='#000000'><b>" + m.authorFirstName + " " + m.authorLastName + "</b><font size='10'> | " + DateUtils.toString(m.date, "DD/MM/YYYY hh:mm:ss") + "</font> <b>> </b>" + m.content + "</font><br>";
            }
        }
        _txtMessages.htmlText = text;
        _updateMessagesScrollBar(true);
    }
    private function _updateMessagesScrollBar(showAlwaysLastLine:Bool = false):Void
    {
        _sbMessages.visible = (_txtMessages.maxScrollV > 1);
        if (showAlwaysLastLine)
        {
            _txtMessages.scrollV = _txtMessages.maxScrollV;
        }
        else
        {
            _txtMessages.scrollV = 1;
        }
        _sbMessages.updatePosition(true);
    }
    
    private function _clearMessages():Void
    {
		_txtMessages.text = "";
		_txtInput.clear();
		/*
        _updateScrollBar(true);*/
    }
	
	public function setRect( rect:Rectangle)
	{
		x = rect.x;
		y = rect.y;
		
		//already handled in HomeView._draw()
		/*
		if ( rect.height < MIN_HEIGHT ) rect.height = MIN_HEIGHT;
		*/
		var padding:Int = 10;
		
		_background.width = rect.width;
		_background.height = rect.height;
		_backgroundColorized.x = padding;
		_backgroundColorized.y = 6;
		SpriteUtils.drawRoundSquare( _backgroundColorized, Std.int(rect.width - padding * 2), Std.int(rect.height - 12), 4, 4, Colors.GREY2 );
		
		
		
		// WITH FeathersUi --> issue: TextArea cannot display html text
		/*
		_txtMessages.x = padding * 2;
		_txtMessages.y = padding;
		_txtMessages.setSize( rect.width - padding * 4, rect.height - padding * 2 - _txtInput.height );
		*/
		
		// With my lib	
		_txtMessages.x = padding * 2;
		_txtMessages.y = padding;
		_txtMessages.width = rect.width - padding * 4;
		_txtMessages.height = rect.height - padding * 2.5 - _txtInput.height;
		
		_sbMessages.x = _txtMessages.x + _txtMessages.width;
		_sbMessages.y = _txtMessages.y;
		_sbMessages.update();
		
		var lowerPos:Int = Std.int(_txtMessages.y + _txtMessages.height +  padding * 0.5 );
		_icoMessage.x = padding * 2;
		_icoMessage.y = lowerPos + (_txtInput.height - _icoMessage.height ) * 0.5;
		
		_btRefresh.x = rect.width - padding * 2 - _btRefresh.width;
		_btRefresh.y = lowerPos;
		_btSendMessage.x = _btRefresh.x - padding - _btSendMessage.width;
		_btSendMessage.y = lowerPos;		
		
		_txtInput.x = _icoMessage.x + _icoMessage.width + padding;
		_txtInput.y = lowerPos;
		_txtInput.width = _btSendMessage.x - _txtInput.x - padding;
		
		_line.x = padding * 2;
		_line.y = lowerPos - 2;
		SpriteUtils.drawSquare(_line, Std.int(rect.width - padding * 4), 2, Colors.GREY3 );
		
		
	} 
}

