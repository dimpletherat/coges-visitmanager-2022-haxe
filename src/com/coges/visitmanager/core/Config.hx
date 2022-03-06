package com.coges.visitmanager.core;

import com.coges.visitmanager.vo.Period;





typedef InitDBConfigJSON=
{
	var slotLength:Int;
	var slotStartTimeString:String;
	var slotEndTimeString:String;
	var ratioFranceForeigner:Float;
	var midDayTimeString:String;
	var startDateString:String;
	var endDateString:String;
}



/**
	 * ...
	 * @author Nicolas Bigot
	 */
class Config
{
    public static final LAYOUT1_MAX_WIDTH:Int = 1279;
    public static final LAYOUT2_MAX_WIDTH:Int = 1600;
	
    public static var isOnline(get, never):Bool;
    public static var notificationsURL(get, never):String;
    public static var servicesURL(get, never):String;
    public static var getDemandURL(get, never):String;
    public static var goBackURL(get, never):String;
    public static var exportURL(get, never):String;
    public static var exportWithEmailURL(get, never):String;
    public static var printURL(get, never):String;
    public static var trianglesFolderURL(get, never):String;
    public static var resultPageSize(get, never):Int;
    public static var LANG(get, never):String;
    public static var INIT_ID_DO(get, never):Int;
    public static var INIT_ID_OZ(get, never):Int;
    public static var INIT_ID_PROG(get, never):Int;
    public static var INIT_ID_ATT_DEF(get, never):Int;
    public static var INIT_ID_MEM_BUR(get, never):Int;
    public static var INIT_FLAG_PROG(get, never):Int;
    public static var localizationAppURL(get, never):String;
    public static var INIT_PREVIOUS_PAGE_NAME(get, never):String;
    public static var INIT_PREVIOUS_SEARCH_PARAMS(get, never):Array<Dynamic>;
    public static var INIT_SLOT_LENGTH_TIME(get, never):Int;
    public static var INIT_SLOT_START(get, never):Date;
    public static var INIT_SLOT_END(get, never):Date;
    public static var INIT_RATIO_FRANCE_FOREIGNER(get, never):Float;
    public static var INIT_MID_DAY_TIME(get, never):Float;
    public static var INIT_MID_DAY(get, never):Date;
    public static var INIT_START_DATE(get, never):Date;
    public static var INIT_END_DATE(get, never):Date;

    private static var _isOnline:Bool = false;
    private static function get_isOnline():Bool
    {
        return _isOnline;
    }
    
    
    private static var _notificationsURL:String;
    private static function get_notificationsURL():String
    {
        return _notificationsURL;
    }
    
    private static var _servicesURL:String;
    private static function get_servicesURL():String
    {
        return _servicesURL;
    }
    
    private static var _getDemandURL:String;
    private static function get_getDemandURL():String
    {
        return _getDemandURL;
    }
    
    private static var _goBackURL:String;
    private static function get_goBackURL():String
    {
        return _goBackURL;
    }
    
    private static var _exportURL:String;
    private static function get_exportURL():String
    {
        return _exportURL;
    }
    
    private static var _exportWithEmailURL:String;
    private static function get_exportWithEmailURL():String
    {
        return _exportWithEmailURL;
    }
    
    private static var _printURL:String;
    private static function get_printURL():String
    {
        return _printURL;
    }
    
    private static var _trianglesFolderURL:String;
    private static function get_trianglesFolderURL():String
    {
        return _trianglesFolderURL;
    }
    
        //pDelId=626&pProgId=15&pOzId=0&pAdId=0&pMburId=0&pFlagProg=1&pLang=fr&checkSelect=&tri=del_nom&ordre=ASC&ordre_oz=&num_page=1&prem_connec=1&page=on&etat=Tous&dispo=Tous&typedo=Tous&oz=Tous&do=Toutes&oa=Tous&pays=Tous&nbParPage=10&pFrom=planning_do_prog
	
	public static function initialize( initParams:Dynamic, url:String )
    {
		for ( key in Reflect.fields( initParams ) )
		{
			if ( key == "lang" )
			{
				_init_language = Reflect.field( initParams, "lang" );
			}
			if ( key == "del-id" )
			{
				_init_idDO = Reflect.field( initParams, "del-id" );
			}
			if ( key == "prog-id" )
			{
				_init_idProg = Reflect.field( initParams, "prog-id" );
			}
			if ( key == "oz-id" )
			{
				_init_idOZ = Reflect.field( initParams, "oz-id" );
			}
			if ( key == "ad-id" )
			{
				_init_idAttDef = Reflect.field( initParams, "ad-id" );
			}
			if ( key == "mem-bur-id" )
			{
				_init_idMemBur = Reflect.field( initParams, "mem-bur-id" );
			}
			if ( key == "flag-prog" )
			{
				_init_flagProg = Reflect.field( initParams, "flag-prog" );
			}
			if ( key == "from" )
			{
				_init_previousPageName = Reflect.field( initParams, "from" );
			}
			if ( key == "previous-search-params" )
			{
				var previousSearchParams = Reflect.field( initParams, "previous-search-params" );
				_init_previousSearchParams = new Array<String>();
				for ( key2 in Reflect.fields(previousSearchParams) )
				{
					_init_previousSearchParams.push( key2 + "=" + Reflect.field(previousSearchParams, key2) );
				}
			}
			//trace( _init_previousSearchParams );
		}
		_initializeURLs(url);
	}
    
    private static function _initializeURLs(url:String)
    {
        trace("url:" + url);
        _isOnline = ((url.indexOf("http://localhost") != 0) && (url.indexOf("https://localhost") != 0));   
		//trace( "_isOnline : " + _isOnline );
		
		
		var rootURL:String = "../"; //'/site/visitmanager' directory
		if ( !_isOnline )
		{
			//2022-evolution
			//rootURL = "http://eurosatory.dev.object23.fr/site/visitmanager/";
			//dev
			//rootURL = "https://rcpt-eurosatory.visitmanager.events/site/visitmanager/";
			//prod
			rootURL = "https://eurosatory.visitmanager.events/site/visitmanager/";
			
		}
		
		//TODO: to test
        _goBackURL = "../";
		
		_getDemandURL = rootURL + "selection_do_ajout.php";
		_servicesURL = rootURL + "vm-html5-ws/index.php";
		_notificationsURL = rootURL + "manage_notifs.php";
		_printURL = rootURL + "planning_do_synthese.php";
		_trianglesFolderURL = rootURL + "../f18/images/";
		_exportURL = rootURL + "gen_plan_excel.php";
		_exportWithEmailURL = rootURL + "manage_plan_excel.php";
        
        /*
        var sep:String = "://";
        var urlArr:Array<String> = url.split(sep);
        
        var protocol:String = urlArr[0];
        //trace("protocol:" + protocol);
        var domain:String = urlArr[1].substr(0, urlArr[1].indexOf("/"));
        //trace("domain:" + domain);
        
        var isDev:Bool = (protocol == "http");
        var isProd:Bool = (protocol == "https");
        
        //var rootURL:String = ( protocol == "file" ) ? "http://deveurosatory2014.ntic.fr/site":protocol + sep + domain;
        //var rootURL:String = ( protocol == "file" ) ? "http://aphs.visitmanager.events/site":protocol + sep + domain;
        //var rootURL:String = ( protocol == "file" ) ? "https://eurosatory.visitmanager.events/site":protocol + sep + domain;
        var rootURL:String = ((protocol == "file")) ? "http://eurosatory.dev.object23.fr/site":protocol + sep + domain;
        
        
        if (isDev)
        {
            rootURL += "/site";
        }
        //trace("isDev:" + isDev);
        //trace("isProd:" + isProd);
        //trace("rootURL:" + rootURL);
        
        
        _goBackURL = "../";
        
        if (isDev)
        {
            _getDemandURL = rootURL + "/visitmanager/selection_do_ajout.php";
            _servicesURL = rootURL + "/amfphp/gateway.php";
            //_notificationsURL = rootURL + "/visitmanager/manage_notifs.php";
            _notificationsURL = rootURL + "/../assets/tmp-datas/manage-notifs.json";
            _printURL = rootURL + "/visitmanager/planning_do_synthese.php";
            _trianglesFolderURL = rootURL + "/visitmanager/images/";
            _exportURL = rootURL + "/visitmanager/gen_plan_excel.php";
            _exportWithEmailURL = rootURL + "/visitmanager/manage_plan_excel.php";
        }
        else if (isProd)
        {
            _getDemandURL = rootURL + "/site/visitmanager/selection_do_ajout.php";
            _servicesURL = rootURL + "/site/amfphp/gateway.php";
            _notificationsURL = rootURL + "/site/visitmanager/manage_notifs.php";
            _printURL = rootURL + "/site/visitmanager/planning_do_synthese.php";
            _trianglesFolderURL = rootURL + "/site/visitmanager/images/";
            _exportURL = rootURL + "/site/visitmanager/gen_plan_excel.php";
            _exportWithEmailURL = rootURL + "/site/visitmanager/manage_plan_excel.php";
        }
        else
        {
            _getDemandURL = rootURL + "/visitmanager/selection_do_ajout.php";
            _servicesURL = rootURL + "/amfphp/gateway.php";
            _notificationsURL = rootURL + "/visitmanager/manage_notifs.php";
            _printURL = rootURL + "/visitmanager/planning_do_synthese.php";
            _trianglesFolderURL = rootURL + "/visitmanager/images/";
            _exportURL = rootURL + "/visitmanager/gen_plan_excel.php";
            _exportWithEmailURL = rootURL + "/visitmanager/manage_plan_excel.php";
        }*/
        
		/*
        trace("_getDemandURL:" + _getDemandURL);
        trace("_servicesURL:" + _servicesURL);
        trace("_notificationsURL:" + _notificationsURL);
        trace("_printURL:" + _printURL);
        trace("_trianglesFolderURL:" + _trianglesFolderURL);
        trace("_exportURL:" + _exportURL);
        trace("_exportWithEmailURL:" + _exportWithEmailURL);*/
    }
    
    
    private static var _resultPageSize:Int = 100;
    private static function get_resultPageSize():Int
    {
        return _resultPageSize;
    }
    
    private static var _init_language:String = "fr";
    private static function get_LANG():String
    {
        return _init_language;
    }
    
    private static var _init_idDO:Int = 0;
    private static function get_INIT_ID_DO():Int
    {
        return _init_idDO;
    }
    
    private static var _init_idOZ:Int = 0;
    private static function get_INIT_ID_OZ():Int
    {
        return _init_idOZ;
    }
    
    private static var _init_idProg:Int = 0;
    private static function get_INIT_ID_PROG():Int
    {
        return _init_idProg;
    }
    
    private static var _init_idAttDef:Int = 0;
    private static function get_INIT_ID_ATT_DEF():Int
    {
        return _init_idAttDef;
    }
    
    private static var _init_idMemBur:Int = 0;
    private static function get_INIT_ID_MEM_BUR():Int
    {
        return _init_idMemBur;
    }
    
    private static var _init_flagProg:Int = 0;
    private static function get_INIT_FLAG_PROG():Int
    {
        return _init_flagProg;
    }
    
    private static var _init_localizationAppURL:String = null;
    private static function get_localizationAppURL():String
    {
        return _init_localizationAppURL;
    }
    
    private static var _init_previousPageName:String = "";
    private static function get_INIT_PREVIOUS_PAGE_NAME():String
    {
        return _init_previousPageName;
    }
    
    private static var _init_previousSearchParams:Array<Dynamic>;
    private static function get_INIT_PREVIOUS_SEARCH_PARAMS():Array<Dynamic>
    {
        return _init_previousSearchParams;
    }
    
    private static var _init_SlotLengthTime:Int = 30 * 60 * 1000;
    private static function get_INIT_SLOT_LENGTH_TIME():Int
    {
        return _init_SlotLengthTime;
    }
    
    private static var _init_SlotStart:Date = null;
    private static function get_INIT_SLOT_START():Date
    {
        return _init_SlotStart;
    }
    
    private static var _init_SlotEnd:Date = null;
    private static function get_INIT_SLOT_END():Date
    {
        return _init_SlotEnd;
    }
    
    private static var _init_RatioFranceForeigner:Float = 0;
    private static function get_INIT_RATIO_FRANCE_FOREIGNER():Float
    {
        return _init_RatioFranceForeigner;
    }
    
    private static var _init_MidDayTime:Float;
    private static function get_INIT_MID_DAY_TIME():Float
    {
        return _init_MidDayTime;
    }
    
    private static var _init_MidDay:Date;
    private static function get_INIT_MID_DAY():Date
    {
        return _init_MidDay;
    }
    
    private static var _init_StartDate:Date;
    private static function get_INIT_START_DATE():Date
    {
        return _init_StartDate;
    }
    
    private static var _init_EndDate:Date;
    private static function get_INIT_END_DATE():Date
    {
        return _init_EndDate;
    }
    
    
    
    public static final COLOR_RED_LIGHT:Int = 0xD76666;  //EA0000  
    public static final COLOR_RED_DARK:Int = 0xA60D0D;  //880000  
    public static final COLOR_ORANGE_LIGHT:Int = 0xecaa6e;
    public static final COLOR_ORANGE_DARK:Int = 0xc78e5c;
    public static final COLOR_GREEN_LIGHT:Int = 0xBCDB8B;  // 0x96be32;  
    public static final COLOR_GREEN_DARK:Int = 0x97C44F;  // 0x7e9f2a;  
    public static final COLOR_DARKGREEN_LIGHT:Int = 0x95BD9D;  // 0x5a8264;  
    public static final COLOR_DARKGREEN_DARK:Int = 0x6B9C6C;  // 0x4c6d54;  
    public static final COLOR_GREY_LIGHT:Int = 0xdcdcdc;
    public static final COLOR_GREY_DARK:Int = 0xb9b9b9;
    public static final COLOR_WHITE_LIGHT:Int = 0xffffff;
    public static final COLOR_WHITE_DARK:Int = 0xe5e5e5;
    
    public static final COLOR_GREEN:Int = 0x007700;
    public static final COLOR_ORANGE:Int = 0xFF9900;
    
    public static var EXHIBITION_OPENING_PERIOD:Period = new Period(new Date(0, 0, 0, 9,0,0), new Date(0, 0, 0, 18,0,0));
    
    
    public static function setInit_language(value:String):Void
    {
        switch (value)
        {
            case "gb":
                _init_language = "en";
            case "esp":
                _init_language = "es";
            default:
                _init_language = "fr";
        }
    }
    public static function getLangForPHPServices():String
    {
        switch (_init_language)
        {
            case "en":
                return "gb";
            case "es":
                return "esp";
            default:
                return "fr";
        }
    }
    public static function setInit_idProg(value:Int):Void
    {
        _init_idProg = value;
    }
    public static function setInit_idDO(value:Int):Void
    {
        _init_idDO = value;
    }
    public static function setInit_idOZ(value:Int):Void
    {
        _init_idOZ = value;
    }
    public static function setInit_idAttDef(value:Int):Void
    {
        _init_idAttDef = value;
    }
    public static function setInit_idMemBur(value:Int):Void
    {
        _init_idMemBur = value;
    }
    public static function setInit_flagProg(value:Int):Void
    {
        _init_flagProg = value;
    }
    public static function setInit_localizationAppURL(value:String):Void
    {
        _init_localizationAppURL = value;
    }
    public static function setInit_previousPageName(value:String):Void
    {
        _init_previousPageName = value;
    }
	
    public static function setInitDBConfig(initDBConfig:InitDBConfigJSON):Void
    {
        _init_RatioFranceForeigner = initDBConfig.ratioFranceForeigner;
		//trace( "_init_RatioFranceForeigner : " + _init_RatioFranceForeigner );
        _init_SlotLengthTime = initDBConfig.slotLength * 60 * 1000;
		//trace( "_init_SlotLengthTime : " + _init_SlotLengthTime );
        
        var arr:Array<Dynamic>;
        
        arr = initDBConfig.slotStartTimeString.split(":");
        _init_SlotStart = new Date(null, null, null, arr[0], arr[1], 0);
		//trace( "_init_SlotStart : " + _init_SlotStart );
        
        arr = initDBConfig.slotEndTimeString.split(":");
        _init_SlotEnd = new Date(null, null, null, arr[0], arr[1], 0);
		//trace( "_init_SlotEnd : " + _init_SlotEnd );
        
        arr = initDBConfig.midDayTimeString.split(":");
        _init_MidDayTime = arr[0] * 60 * 60 * 1000 + arr[1] * 60 * 1000;
		//trace( "_init_MidDayTime : " + _init_MidDayTime );
        _init_MidDay = new Date(null, null, null, arr[0], arr[1], 0);
		//trace( "_init_MidDay : " + _init_MidDay );
        
        arr = initDBConfig.startDateString.split("-");
        _init_StartDate = new Date(arr[0], Std.parseInt(arr[1]) - 1, arr[2], 0, 0, 0);
		//trace( "_init_StartDate : " + _init_StartDate );
        
        arr = initDBConfig.endDateString.split("-");
        _init_EndDate = new Date(arr[0], Std.parseInt(arr[1]) - 1, arr[2], 0, 0, 0);
		//trace( "_init_EndDate : " + _init_EndDate );
    }

    private function new()
    {
    }
}

