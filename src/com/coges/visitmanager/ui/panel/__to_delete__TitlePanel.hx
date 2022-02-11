package com.coges.visitmanager.ui.panel;

import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.fonts.FontName;
import com.coges.visitmanager.ui.components.VMButton;
import com.coges.visitmanager.core.Locale;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.net.URLVariables;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
	 * ...
	 * @author Nicolas Bigot
	 */
class TitlePanel extends Sprite
{
    public var btBack:VMButton;
    public var txtMainTitle:TextField;
    
    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, init);
    }
    
    private function init(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        btBack.textFont = FontName.ARIAL_B_I_BI;
        btBack.label = Locale.get("BT_BACK_LABEL");
        btBack.addEventListener(MouseEvent.CLICK, clickBackHandler);
        var tf:TextFormat = new TextFormat(FontName.TREBUCHET_B_I_BI, 20, 0xFFFFFF, true);
        txtMainTitle.embedFonts = true;
        txtMainTitle.antiAliasType = AntiAliasType.ADVANCED;
        txtMainTitle.defaultTextFormat = tf;
        txtMainTitle.text = Locale.get("MAIN_TITLE");
    }
    
    private function clickBackHandler(e:MouseEvent):Void
    {
        var page:String = Config.INIT_PREVIOUS_PAGE_NAME + ".php";
        var url:URLRequest = new URLRequest(Config.goBackURL + page);
        
        var paramsString:String = Config.INIT_PREVIOUS_SEARCH_PARAMS.join("&");
        trace("paramsString:" + paramsString);
        if (paramsString.length > 0)
        {
            var params:URLVariables = new URLVariables();
            params.decode(paramsString);
            url.data = params;
            url.method = URLRequestMethod.GET;
        }
        
        flash.Lib.getURL(url, "_self");
    }
}

