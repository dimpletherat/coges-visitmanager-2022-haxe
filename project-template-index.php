<?php
                                    
$pDelId = filter_input( INPUT_GET, 'pDelId', FILTER_VALIDATE_INT );
if ( is_null($pDelId) || $pDelId === false )
{
    $pDelId = 450;
}
$pProgId = filter_input( INPUT_GET, 'pProgId', FILTER_VALIDATE_INT );
if ( is_null($pProgId) || $pProgId === false )
{
    $pProgId = 15;
}
if ( $pProgId > 0 )
{
	include "inc/initpage_prog.php";
}else{
	include "inc/initpage_oz.php";
}
$pOzId = filter_input( INPUT_GET, 'pOzId', FILTER_VALIDATE_INT );
if ( is_null($pOzId) || $pOzId === false )
{
    $pOzId = 0;
}
$pAdId = filter_input( INPUT_GET, 'pAdId', FILTER_VALIDATE_INT );
if ( is_null($pAdId) || $pAdId === false )
{
    $pAdId = 0;
}
$pMburId = filter_input( INPUT_GET, 'pMburId', FILTER_VALIDATE_INT );
if ( is_null($pMburId) || $pMburId === false )
{
    $pMburId = 0;
}
$pFlagProg = filter_input( INPUT_GET, 'pFlagProg', FILTER_VALIDATE_INT );
if ( is_null($pFlagProg) || $pFlagProg === false )
{
    $pFlagProg = 1;
}
$pLang = filter_input( INPUT_GET, 'pLang' );
if ( is_null($pLang) || $pLang === false )
{
    $pLang = 'fr';
}else{
    if ( $pLang === 'gb' )
    {
        $pLang = 'en';
    }
}
$checkSelect = filter_input( INPUT_GET, 'checkSelect' );
if ( is_null($checkSelect) || $checkSelect === false )
{
    $checkSelect = '';
}
$tri = filter_input( INPUT_GET, 'tri' );
if ( is_null($tri) || $tri === false )
{
    $tri = 'del_nom';
}
$ordre = filter_input( INPUT_GET, 'ordre' );
if ( is_null($ordre) || $ordre === false )
{
    $ordre = 'ASC';
}
$ordre_oz = filter_input( INPUT_GET, 'ordre_oz' );
if ( is_null($ordre_oz) || $ordre_oz === false )
{
    $ordre_oz = '';
}
$num_page = filter_input( INPUT_GET, 'num_page' );
if ( is_null($num_page) || $num_page === false )
{
    $num_page = '1';
}
$prem_connec = filter_input( INPUT_GET, 'prem_connec' );
if ( is_null($prem_connec) || $prem_connec === false )
{
    $prem_connec = '1';
}
$page = filter_input( INPUT_GET, 'page' );
if ( is_null($page) || $page === false )
{
    $page = 'on';
}
$etat = filter_input( INPUT_GET, 'etat' );
if ( is_null($etat) || $etat === false )
{
    $etat = 'Tous';
}
$dispo = filter_input( INPUT_GET, 'dispo' );
if ( is_null($dispo) || $dispo === false )
{
    $dispo = 'Tous';
}
$typedo = filter_input( INPUT_GET, 'typedo' );
if ( is_null($typedo) || $typedo === false )
{
    $typedo = 'Tous';
}
$oz = filter_input( INPUT_GET, 'oz' );
if ( is_null($oz) || $oz === false )
{
    $oz = 'Tous';
}
$do = filter_input( INPUT_GET, 'do' );
if ( is_null($do) || $do === false )
{
    $do = 'Toutes';
}
$oa = filter_input( INPUT_GET, 'oa' );
if ( is_null($oa) || $oa === false )
{
    $oa = 'Tous';
}
$pays = filter_input( INPUT_GET, 'pays' );
if ( is_null($pays) || $pays === false )
{
    $pays = 'Tous';
}
$nbParPage = filter_input( INPUT_GET, 'nbParPage' );
if ( is_null($nbParPage) || $nbParPage === false )
{
    $nbParPage = '10';
}
$pFrom = filter_input( INPUT_GET, 'pFrom' );
if ( is_null($pFrom) || $pFrom === false )
{
    $pFrom = 'planning_do_prog';
}

?>


<!DOCTYPE html>
<html lang="en">
<head>

	<meta charset="utf-8">

	<title>::APP_TITLE::</title>

	<meta id="viewport" name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
	<meta name="apple-mobile-web-app-capable" content="yes">

	::if favicons::::foreach (favicons)::
	<link rel="::__current__.rel::" type="::__current__.type::" href="::__current__.href::">::end::::end::

	::if linkedLibraries::::foreach (linkedLibraries)::
	<script type="text/javascript" src="::__current__::"></script>::end::::end::
	<script type="text/javascript" src="./::APP_FILE::.js"></script>

	<script>
		/*window.addEventListener ("touchmove", function (event) { event.preventDefault (); }, { capture: false, passive: false });*/
		if (typeof window.devicePixelRatio != 'undefined' && window.devicePixelRatio > 2) {
			var meta = document.getElementById ("viewport");
			meta.setAttribute ('content', 'width=device-width, initial-scale=' + (2 / window.devicePixelRatio) + ', user-scalable=no');
		}
	</script>

	<style>
		html,body { margin: 0; padding: 0; height: 100%; overflow: hidden; }
		#content { ::if (WIN_BACKGROUND)::background: #000000; ::end::width: ::if (WIN_RESIZABLE)::100%::elseif (WIN_WIDTH > 0)::::WIN_WIDTH::px::else::100%::end::; height: ::if (WIN_RESIZABLE)::100%::elseif (WIN_WIDTH > 0)::::WIN_HEIGHT::px::else::100%::end::; }
::foreach assets::::if (type == "font")::::if (cssFontFace)::::cssFontFace::::end::::end::::end::
	</style>

</head>
<body>
	::foreach assets::::if (type == "font")::
	<span style="font-family: ::id::"> </span>::end::::end::

	<div id="content"></div>

	<script type="text/javascript">
	
		var configParams = {
			"del-id":<?php echo $pDelId; ?>,
			"prog-id":<?php echo $pProgId; ?>,
			"oz-id":<?php echo $pOzId; ?>,
			"ad-id":<?php echo $pAdId; ?>,
			"mem-bur-id":<?php echo $pMburId; ?>,
			"flag-prog":<?php echo $pFlagProg; ?>,
			"lang":"<?php echo $pLang; ?>",
			"from":"<?php echo $pFrom; ?>",
			"previous-search-params":{
				"checkSelect":"<?php echo $checkSelect; ?>",
				"tri":"<?php echo $tri; ?>",
				"ordre":"<?php echo $ordre; ?>",
				"ordre_oz":"<?php echo $ordre_oz; ?>",
				"num_page":"<?php echo $num_page; ?>",
				"prem_connec":"<?php echo $prem_connec; ?>",
				"page":"<?php echo $page; ?>",
				"etat":"<?php echo $etat; ?>",
				"dispo":"<?php echo $dispo; ?>",
				"typedo":"<?php echo $typedo; ?>",
				"oz":"<?php echo $oz; ?>",
				"do":"<?php echo $do; ?>",
				"oa":"<?php echo $oa; ?>",
				"pays":"<?php echo $pays; ?>",
				"nbParPage":"<?php echo $nbParPage; ?>"
			}
		}
		
		lime.embed ("::APP_FILE::", "content", ::WIN_WIDTH::, ::WIN_HEIGHT::, { parameters: {configParams:configParams} });
	</script>

</body>
</html>