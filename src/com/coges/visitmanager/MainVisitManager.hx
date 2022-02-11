package com.coges.visitmanager;

import com.coges.visitmanager.core.Colors;
import com.coges.visitmanager.core.Config;
import com.coges.visitmanager.core.Locale;
import com.coges.visitmanager.datas.ServiceEvent;
import com.coges.visitmanager.datas.ServiceManager;
import com.coges.visitmanager.fonts.Fonts;
import com.coges.visitmanager.ui.popup.*;
import com.coges.visitmanager.view.HomeView;
import com.coges.visitmanager.vo.Planning;
import com.coges.visitmanager.vo.User;
import com.coges.visitmanager.vo.UserType;
import nbigot.application.ResizeManager;
import nbigot.ui.control.ToolTip;
import nbigot.ui.control.ToolTipOptions;
import nbigot.ui.dialog.DialogManager;
import nbigot.ui.dialog.DialogSkin;
import openfl.Assets;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.system.ApplicationDomain;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
//import haxe.ui.Toolkit;
/**
	 * ...
	 * @author Nicolas Bigot
	 */

//@:access(com.coges.visitmanager.vo.UserType.Label)
class MainVisitManager extends Sprite
{
    private var _iconManagerDomainList:Array<ApplicationDomain>;
    private var _initDBConfigComplete:Bool;
    private var _resourcesComplete:Bool;
    private var _viewChangeFired:Bool;
    private var _typeUser:UserType;
    
    public function new()
    {
        super();
        _iconManagerDomainList = new Array<ApplicationDomain>();
        _initDBConfigComplete = false;
        _resourcesComplete = false;
        _viewChangeFired = false;
        _createInterface();
    }
    
    private function _addedToStageHandler(e:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
        _createInterface();
    }
    
    private function _createInterface():Void
    {
        if (stage == null)
        {
            addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
            return;
        }
        //Toolkit.init();
		
        stage.stageFocusRect = false;
        Fonts.initialize();
        ResizeManager.initialize(stage, stage.stageWidth, stage.stageHeight );
		
		trace( "RENDER::", stage.window.context.type, stage.window.context.version );
                
        var tto:ToolTipOptions = new ToolTipOptions();
        tto.font = Fonts.OPEN_SANS;
        tto.embedFont = true;
        tto.backgroundColor = Colors.GREY1;
        tto.borderColor = Colors.BLACK;
        tto.borderSize = 1;
        tto.maxWidth = 250;
        tto.fontSize = 12;
        tto.opacity = 1;
        tto.delay = 0;
        tto.roundCornerSize = 4;
        tto.shadow = false;
        ToolTip.options = tto;
        ToolTip.context = stage;
        
		
		if (stage.loaderInfo.parameters.configParams == null)
		{
			return;
			// TODO message ERREUR  
		}
		Config.initialize( stage.loaderInfo.parameters.configParams, stage.loaderInfo.url );
		Locale.initialize( Xml.parse( Assets.getText("assets/content/vm_content.xml") ), Config.LANG );
        Planning.initLocalizedLabels(Locale.get("LBL_WORKING_PLANNING"), Locale.get("LBL_SAVED_PLANNING"));
		
		
		var ds:DialogSkin = new DialogSkin();
		var tf:TextFormat = new TextFormat( Fonts.OPEN_SANS, 13, Colors.GREY1 );
		ds.cancelButtonFormat = tf;
		ds.cancelButtonLabel = Locale.get( "BT_CANCEL_LABEL" );
		ds.confirmButtonFormat = tf;
		ds.confirmButtonLabel = Locale.get( "BT_VALID_LABEL" );
		var tfClose = tf.clone();
		tfClose.align = TextFormatAlign.CENTER;
		ds.closeButtonFormat = tfClose;
		ds.closeButtonLabel = Locale.get( "BT_CLOSE_LABEL" );
		var tfContent:TextFormat = new TextFormat( Fonts.OPEN_SANS, 13, Colors.GREY1 );
		tfContent.size = 14;
		tfContent.color = Colors.BLACK;
		ds.contentFormat = tfContent;
		ds.titleFormat = tfContent.clone();
		ds.titleFormat.size = 16;
		ds.titleFormat.color = Colors.GREY3;
		ds.titleFormat.italic = true;
		//ds.titleFormat.align = TextFormatAlign.CENTER;
		ds.titleBackgroundColor = Colors.GREY3;
		ds.contentBackgroundColor = Colors.GREY1;
		ds.contentMargin = 20;
        DialogManager.initialize(stage, null, ds );
		
        
        var idUser:Int = 0;
		
        if (Config.INIT_ID_OZ != 0)
        {
            idUser = Config.INIT_ID_OZ;
            _typeUser = UserType.OZ;
        }
        else if (Config.INIT_ID_PROG != 0)
        {
            idUser = Config.INIT_ID_PROG;
            _typeUser = UserType.PROGRAMMEUR;
        }
        else if (Config.INIT_ID_ATT_DEF != 0)
        {
            idUser = Config.INIT_ID_ATT_DEF;
            _typeUser = UserType.ATTACHE_DEFENSE;
        }
        else if (Config.INIT_ID_MEM_BUR != 0)
        {
            idUser = Config.INIT_ID_MEM_BUR;
            _typeUser = UserType.MEMBRE_BUREAU;
        }
        
        if (idUser == 0 || _typeUser == null )
        {
            return;
			// TODO message ERREUR 
		}
        
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _getUserDatasCompleteHandler);
        ServiceManager.instance.getUserDatas(idUser, _typeUser);
		
		ServiceManager.instance.getActivityList();
        ServiceManager.instance.getSpecialVisitList();
		ServiceManager.instance.getCountryList();
    }
	
	
	
	
    private function _getUserDatasCompleteHandler(e:ServiceEvent):Void
    {		
        if (e.currentCall == ServiceManager.instance.getUserDatas)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _getUserDatasCompleteHandler);
			
            User.createUser(e.result, _typeUser);
			_loadResources();
        }
    }
   
    private function _loadResources():Void
    {
        ServiceManager.instance.addEventListener(ServiceEvent.COMPLETE, _initDBConfigCompleteHandler);
        ServiceManager.instance.getInitDBConfig();
        
        //PopupManager.instance.addEventListener(DialogEvent.COMPLETE, _popupLoaderCompleteHandler);
        //PopupManager.instance.openPopup(PopupType.LOADER, "", Locale.get("LBL_LOADING_RESOURCES"));
        
		
		/*DialogManager.instance.addEventListener(DialogEvent.COMPLETE, _popupLoaderCompleteHandler);
        DialogManager.instance.open(LoaderPopup, "", Locale.get("LBL_LOADING_RESOURCES"));*/
    }
    private function _initDBConfigCompleteHandler(e:ServiceEvent):Void
    {
        if (e.currentCall == ServiceManager.instance.getInitDBConfig)
        {
            ServiceManager.instance.removeEventListener(ServiceEvent.COMPLETE, _initDBConfigCompleteHandler);
            _initDBConfigComplete = true;
			
			
			//:TODO test
			_startVisitManager();
			/*
            if (_resourcesComplete && !_viewChangeFired)
            {
				_startVisitManager();
            }*/
        }
    }	
	function _startVisitManager() 
	{
		_viewChangeFired = true;
		addChild( new HomeView() );
		/*
		var fps = new FPS(10, 50, Colors.GREEN1 );
		fps.background = true;
		fps.autoSize = TextFieldAutoSize.LEFT;
        addChild( fps );*/
		
		
		//DialogManager.instance.open( new ConfirmVisitSerieDialog( "sdqfj jfjfqsdfj jqmfmdks j", "<b>Création du rendez-vous impossible.</b><br><br>Cet exposant a atteint sa capacité d'accueil de délégations pour le créneau demandé.{DOList}<b>Autres disponibilités :</b><br><font size='12'>{AvailabilityList}</font><br><br><b>Voulez-vous malgré tout créer ce rendez-vous ?</b>" ) );
		
		
				/*
		var bt2:BaseButton = new BaseButton( "tESt2", new TextFormat( Fonts.CAMBRIA_B, 20, 0xffffff ), SpriteCreator.createRoundSquare( 100, 30, 4, 4, 0x654862) );
		addChild( bt2 );
	*/
		/*
		var _txtPlanning = new TextField();
		_txtPlanning.x = 100;
		_txtPlanning.border = true;
        _txtPlanning.embedFonts = true;
		_txtPlanning.defaultTextFormat = new TextFormat( Fonts.CAMBRIA_B, 20, 0x000000 );
        _txtPlanning.antiAliasType = AntiAliasType.ADVANCED;
		_txtPlanning.wordWrap = true;
		_txtPlanning.multiline = true;
		_txtPlanning.autoSize = TextFieldAutoSize.LEFT;
        _txtPlanning.htmlText = "<font face=\"" + Fonts.OPEN_SANS + "\" size=\"12\" color=\"#666666\">" + Locale.get("LBL_OA") + "<br><b>sqkdqsskdmk  mqs qs </b>sqkdqsskdmk  mqs qs </font>";
		_txtPlanning.width = 600;
		_txtPlanning.height = _txtPlanning.textHeight;
		addChild(_txtPlanning);
		trace( _txtPlanning.textHeight );
		trace( _txtPlanning.height );
		_txtPlanning.width = 400;*/
		
		
		/*
		var _txtNotes2 = new TextField();
		_txtNotes2.embedFonts = true;
        _txtNotes2.antiAliasType = AntiAliasType.ADVANCED;
		_txtNotes2.type = TextFieldType.INPUT;
		_txtNotes2.border = true;
		//_txtNotes2.width = 300;
		//_txtNotes2.height = 200;
		//_txtNotes.multiline = true;
		//_txtNotes.wordWrap = true;
		//_txtNotes.defaultTextFormat = tfLabel;
		//BUG : Event.CHANGE is not fired with Dom renderer
		//FIX : while waiting for an update, we add TextEvent.TEXT_INPUT as a fallback
        //_txtNotes.addEventListener(Event.CHANGE, _txtNotesChangeHandler);
        //_txtNotes.addEventListener(TextEvent.TEXT_INPUT, _txtNotesChangeHandler);
		addChild( _txtNotes2 );*/
	}
    /*
    private function _popupLoaderCompleteHandler(e:DialogEvent):Void
    {
        //PopupManager.instance.removeEventListener(DialogEvent.COMPLETE, _popupLoaderCompleteHandler);
        DialogManager.instance.removeEventListener(DialogEvent.COMPLETE, _popupLoaderCompleteHandler);
        
        var ml:MultiLoader = new MultiLoader();
        ml.addEventListener(MultiLoaderEvent.FILE_COMPLETE, _multiLoaderFileCompleteHandler);
        ml.addEventListener(MultiLoaderEvent.PROGRESS, _multiLoaderProgressHandler);
        ml.addEventListener(MultiLoaderEvent.COMPLETE, _multiLoaderCompleteHandler);
        
        var filePathList:Array<Dynamic> = new Array<Dynamic>();
        filePathList.push("assets/lib/icons.swf?nocache=" + _getNoCacheValue());
        filePathList.push("assets/lib/flags16.swf?nocache=" + _getNoCacheValue());
        filePathList.push("assets/lib/flags24.swf?nocache=" + _getNoCacheValue());
        filePathList.push("assets/lib/flags32.swf?nocache=" + _getNoCacheValue());
        filePathList.push("assets/fonts/Arial.swf?nocache=" + _getNoCacheValue());
        filePathList.push("assets/fonts/TrebuchetMS.swf?nocache=" + _getNoCacheValue());
        
        ml.load(filePathList, MultiLoaderMethod.START_ALL);
    }
    
    private function _multiLoaderProgressHandler(e:MultiLoaderEvent):Void
    {
        var ml:MultiLoader = try cast(e.target, MultiLoader) catch(e:Dynamic) null;
        //PopupManager.instance.currentPopup.update(ml.byteLoaded, ml.byteTotal);
        DialogManager.instance.currentPopup.update(ml.byteLoaded, ml.byteTotal);
    }
    
    private function _multiLoaderFileCompleteHandler(e:MultiLoaderEvent):Void
    {
        var li:LoaderInfo = e.targetLoader.contentLoaderInfo;
        var url:String = li.url;
        var fileName = url.substring(url.lastIndexOf("/") + 1, url.lastIndexOf(".swf"));
        trace("fileName:" + fileName);
        switch (fileName)
        {
            case "flags16":
                _iconManagerDomainList.push(li.applicationDomain);
            case "flags24":
                _iconManagerDomainList.push(li.applicationDomain);
            case "flags32":
                _iconManagerDomainList.push(li.applicationDomain);
            case "icons":
                _iconManagerDomainList.push(li.applicationDomain);
        }
    }
    
    private function _multiLoaderCompleteHandler(e:MultiLoaderEvent):Void
    {
        //PopupManager.instance.closePopup();
        DialogManager.instance.close();
        Icons.initialize(_iconManagerDomainList);
        _resourcesComplete = true;
        if (_initDBConfigComplete && !_viewChangeFired)
        {
            _viewChangeFired = true;
			addChild( new HomeView() );
        }
    }*/
    /*
    private function _getNoCacheValue():String
    {
        return Std.string(Date.now().time);
    }
	*/
}

