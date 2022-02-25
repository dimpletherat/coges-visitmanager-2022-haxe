<?
session_start();
$_SESSION["sESTDEBUG"]=false;

$PATH_DLIB = "../../dlib";

require_once("../../inc/inc_global.php");
require_once("../../inc/inc_bdd.php");

include "$PATH_DLIB/dl_inc_all.php";

include "../../lib/libgen.php";
include "../../lib/libsite.php";
include "../../class/csysparam.php";
include "../../class/cuser.php";
include "../../class/cvmtraduction.php";
include "../../class/cpays.php";
include "../../class/cnationalites.php";
include "../../class/cdataexpaccdo.php";
include "../../class/cdelegoff.php";
include "../../class/cprog.php";
include "../../class/cdemande.php";
include "../../class/ccreneau.php";
include "../../class/cvmactivites.php";
include "../../class/cvmgroupe.php";
include "../../class/cvmoffzone.php";
include "../../class/cvmexposant.php";
include "../../class/cvmdossier.php";
include "../../class/cvmcivilites.php";
include "../../class/cvmplage.php";
include "../../class/cvmattachdef.php";
include "../../class/cvmadmin.php";
include "../../class/cvmmembrebursalon.php";
include "../../class/cvmactvis.php";
include "../../class/cvmvisite.php";
include "../../class/cvmplanning.php";
include "../../class/cvmtache.php";
//include_once "../../class/cauthentificationexposantubiqus.php";

$BASE_URL = "http://cataloguedev.salon-du-bourget.fr";
$BASE_HOST_FR= "cataloguedev.salon-du-bourget.fr";
$BASEPATH_TMP = "/servers/apache/sites/fr/cataloguedev.salon-du-bourget/site/tmp/";
$baseFicForm = "file/";

$db = new dlDb(BDD_HOST, BDD_NAME, BDD_USER, BDD_PWD);

//error_reporting  (0 );
//error_reporting  (E_WARNING );
error_reporting  (E_ALL);

$_SESSION["osUser"]=new cUser($db);
$_SESSION["osExposant"]=new cVmExposant($db);


// Gestion de la connexion depuis l'extérieur.
if (isset($_GET['lg']) && isset($_GET['lp']))
{
	//Modif du 07/08/2013
	/*
	//Connexion auto depuis un site exterieur
	$oUser = new cUser($db);
	//$oUser->findByExposant($_POST['chpId']);	
	$oUser->findByLoginMdp($_GET['lg'], $_GET['lp']);
	if ($oUser->estIdentifie())	
	{
		//$_SESSION["vsUserType"]=iif($oUser->estDirect,"D","I");
		$_SESSION["vsUserId"]=$oUser->id;
		$_SESSION["vsEstAdmin"]=true;
	}
	else
	{
		$vMsg=$oUser->msgErr;
	}*/
	
	// Modif
	
	//Connexion auto depuis un site exterieur
	$oVmExposant = new cVmExposant($db);
	//$oUser->findByExposant($_POST['chpId']);	
	$oVmExposant->findByLoginMdp($_GET['lg'], $_GET['lp']);
	
	if ($oVmExposant->isLoaded())	
	{
		$_SESSION["vsUserId"]=$oVmExposant->id;
		$_SESSION["vsEstAdmin"]=true;
		$_SESSION["UserStatut"] = "Exposant";
	}
	else
	{
		$vMsg=$oUser->msgErr;
	}
	
	// Fin modif
	
}
else if (isset($_GET['login']) && isset($_GET['pwd']))
{
    // connexion depuis l'extranet (ou autre site)
    $oVmExposant = new cVmExposant($db);	
    $bool = $oVmExposant->findByLogin($_GET['login'], $_GET['pwd'], $SALT);
    if ($bool != true)
    {
        //$vMsg = $oUser->msgErr;
    }
}


if (!isset($_SESSION["vsUserId"]))
{
	// Session non initialis�e
	//$_SESSION["vsUserType"]="";
	$_SESSION["vsUserId"]="";
	$_SESSION["vsEstAdmin"]=false;
	
	if(lg_nompage($_SERVER['PHP_SELF']) != "" && lg_nompage($_SERVER['PHP_SELF'])!="index.php" && $_SESSION["vsUserId"] == "" && lg_nompage($_SERVER['PHP_SELF'])!="selection_do_ajout.php") 
	{
		header("Location:../acces_refuse.php");
	}
}
else
{
	if(lg_nompage($_SERVER['PHP_SELF']) != "" && lg_nompage($_SERVER['PHP_SELF'])!="index.php" && lg_nompage($_SERVER['PHP_SELF'])!="selection_do_ajout.php" && lg_nompage($_SERVER['PHP_SELF'])!="genereHTML.php" && lg_nompage($_SERVER['PHP_SELF'])!="genereHTMLcasiers.php" && lg_nompage($_SERVER['PHP_SELF'])!="generefacture.php" && $_SESSION["vsUserId"] == "" && lg_nompage($_SERVER['PHP_SELF'])!="genereHTMLforPDF.php" && lg_nompage($_SERVER['PHP_SELF'])!="generePDF.php" && lg_nompage($_SERVER['PHP_SELF'])!="re_generefacture.php") 
	{
		//echo "a".lg_nompage($_SERVER['PHP_SELF'])."b";
		header("Location:../acces_refuse.php");
	}
	
	$_SESSION["osUser"]->init($_SESSION["vsUserId"]);
	$_SESSION["osExposant"]->findById($_SESSION['osUser']->expId);
	if ($_SESSION["osExposant"]->isLoaded())
	{
		if ($_SESSION["osExposant"]->bloque == "O")
		{
			header("Location:../acces_refuse.php");
		}
		
		$_SESSION["osDossier"] = new cVmDossier ($db);	
		$_SESSION["osDossier"]->findByLastDosExp($_SESSION["osExposant"]->id);
	}
	
}

if (isset($_SESSION["vsEstAdmin"]) && $_SESSION["vsEstAdmin"])
{ 
	$_SESSION["osUser"]->estAdmin=true;	
}

if((isset($_GET['lg']) && isset($_GET['pLang'])) || isset($_POST['login'])){
	unset($_SESSION["vsLang"]);
}


if (isset($_GET['pLang']) && !empty($_GET['pLang']))
{ 
	$_SESSION["vsLang"]=$_GET['pLang'];	
}
elseif(!isset($_SESSION["vsLang"])){	
	if($_SESSION["osExposant"]->pays=="FRANCE"){
		$_SESSION["vsLang"]="fr";
	}
	else{
		$_SESSION["vsLang"]="en";
	}
}

//Gestion de la connexion avec un autre MDP depuis le fichier d'identification
if(isset($_GET['lg_exp']) && isset($_GET["lp_exp"]))
{
	//On voit si on a la possibilité de se connecter
	$_SESSION["osUser"] = new cUser($db);
	//$oUser->findByExposant($_POST['chpId']);	
	$_SESSION["osUser"]->findByLoginMdpF18($_GET['lg_exp'], $_GET['lp_exp'], $_SESSION["vsUserId"]);
	$_SESSION["osUser"]->id = $_SESSION["vsUserId"];
	if (!$_SESSION["osUser"]->isIdentifieF18())	
	{
		header("Location:../acces_refuse.php");
	}
	else
	{
		$_SESSION["IDENTIF_F18"] = true;
	}
}


//Initialisation du tableau lstTrads en session
$_SESSION['lstTrads']=array();
$o=new cvmtraduction($db);

$lstTmp = $o->findByPage(lg_nompage($_SERVER['PHP_SELF']),$_SESSION["vsLang"]);

/******* A supprimer *******/
if(lg_nompage($_SERVER['PHP_SELF']) == "selection_do_old.php")
	$lstTmp = $o->findByPage(lg_nompage("selection_do.php",$_SESSION["vsLang"]));
	
/******* Fin *******/

foreach ($lstTmp as $t)
{
	$_SESSION['lstTrads'][$t->code]=stripslashes($t->libelle);	
}

//Initialisation du tableau lstTradsGen en session
$_SESSION['lstTradsGen']=array();
$o=new cvmtraduction($db);
$lstTmp=$o->findByPage(lg_nompage('_gen'),$_SESSION["vsLang"]);

foreach ($lstTmp as $t)
{
	$_SESSION['lstTradsGen'][$t->code]=$t->libelle;	
}

//Initialisation du tableau lstTradsErreur en session
$_SESSION['lstTradsErreur']=array();
$o=new cvmtraduction($db);
$lstTmp=$o->findByPage(lg_nompage('erreur'),$_SESSION["vsLang"]);

foreach ($lstTmp as $t)
{
	$_SESSION['lstTradsErreur'][$t->code]=$t->libelle;	
}

$_SESSION["sDEBUG_REQ"]=false;					//	Echo des requetes
$_SESSION["sDEBUG_REQEXEC"]=false;				//  Echo des resultats de requetes

$vsTitrePage = 'Espace Exposant';				// Titre général des pages

function getTradActivite($sLibelle, $lng)
{
    $db = new dlDb(BDD_HOST, BDD_NAME, BDD_USER, BDD_PWD);
    
    $aListActivites = array();
    $return = "";
    
    if (!empty($lng))
    {
        $oCvmActivite = new cVmActivite($db);
        $lstActivites = $oCvmActivite->getAllActivites();
        //echo"Activités=<pre>";print_r($lstActivites);echo"</pre>";
        
        // tableau de toutes les activités
        foreach ($lstActivites as $uneActivite)
        {
            // activités intérieures
            if (!empty($uneActivite['vm_activites_int_lib_fr'])) {
                $aListActivites[$uneActivite['vm_activites_int_lib_fr']]['fr'] = $uneActivite['vm_activites_int_lib_fr'];
                if (!empty($uneActivite['vm_activites_int_lib_gb'])) $aListActivites[$uneActivite['vm_activites_int_lib_gb']]['fr'] = $uneActivite['vm_activites_int_lib_fr'];
                if (!empty($uneActivite['vm_activites_int_lib_esp'])) $aListActivites[$uneActivite['vm_activites_int_lib_esp']]['fr'] = $uneActivite['vm_activites_int_lib_fr'];
            }
            if (!empty($uneActivite['vm_activites_int_lib_gb'])) {
                if (!empty($uneActivite['vm_activites_int_lib_fr'])) $aListActivites[$uneActivite['vm_activites_int_lib_fr']]['gb'] = $uneActivite['vm_activites_int_lib_gb'];
                $aListActivites[$uneActivite['vm_activites_int_lib_gb']]['gb'] = $uneActivite['vm_activites_int_lib_gb'];
                if (!empty($uneActivite['vm_activites_int_lib_esp'])) $aListActivites[$uneActivite['vm_activites_int_lib_esp']]['gb'] = $uneActivite['vm_activites_int_lib_gb'];
            }
            if (!empty($uneActivite['vm_activites_int_lib_esp'])) {
                if (!empty($uneActivite['vm_activites_int_lib_fr'])) $aListActivites[$uneActivite['vm_activites_int_lib_fr']]['esp'] = $uneActivite['vm_activites_int_lib_esp'];
                if (!empty($uneActivite['vm_activites_int_lib_gb'])) $aListActivites[$uneActivite['vm_activites_int_lib_gb']]['esp'] = $uneActivite['vm_activites_int_lib_esp'];
                $aListActivites[$uneActivite['vm_activites_int_lib_esp']]['esp'] = $uneActivite['vm_activites_int_lib_esp'];
            }
            
            // activités extérieures
            if (!empty($uneActivite['vm_activites_ext_lib_fr'])) {
                $aListActivites[$uneActivite['vm_activites_ext_lib_fr']]['fr'] = $uneActivite['vm_activites_ext_lib_fr'];
                if (!empty($uneActivite['vm_activites_ext_lib_gb'])) $aListActivites[$uneActivite['vm_activites_ext_lib_gb']]['fr'] = $uneActivite['vm_activites_ext_lib_fr'];
                if (!empty($uneActivite['vm_activites_ext_lib_esp'])) $aListActivites[$uneActivite['vm_activites_ext_lib_esp']]['fr'] = $uneActivite['vm_activites_ext_lib_fr'];
            }
            if (!empty($uneActivite['vm_activites_ext_lib_gb'])) {
                if (!empty($uneActivite['vm_activites_ext_lib_fr'])) $aListActivites[$uneActivite['vm_activites_ext_lib_fr']]['gb'] = $uneActivite['vm_activites_ext_lib_gb'];
                $aListActivites[$uneActivite['vm_activites_ext_lib_gb']]['gb'] = $uneActivite['vm_activites_ext_lib_gb'];
                if (!empty($uneActivite['vm_activites_ext_lib_esp'])) $aListActivites[$uneActivite['vm_activites_ext_lib_esp']]['gb'] = $uneActivite['vm_activites_ext_lib_gb'];
            }
            if (!empty($uneActivite['vm_activites_ext_lib_esp'])) {
                if (!empty($uneActivite['vm_activites_ext_lib_fr'])) $aListActivites[$uneActivite['vm_activites_ext_lib_fr']]['esp'] = $uneActivite['vm_activites_ext_lib_esp'];
                if (!empty($uneActivite['vm_activites_ext_lib_gb'])) $aListActivites[$uneActivite['vm_activites_ext_lib_gb']]['esp'] = $uneActivite['vm_activites_ext_lib_esp'];
                $aListActivites[$uneActivite['vm_activites_ext_lib_esp']]['esp'] = $uneActivite['vm_activites_ext_lib_esp'];
            }
        }
        //echo"aListActivites=<pre>";print_r($aListActivites);echo"</pre>";
        
        if (isset($aListActivites[$sLibelle][$lng]))
            $return = $aListActivites[$sLibelle][$lng];
        else
            $return = $sLibelle;
    }
    else
    {
        $return = $sLibelle;
    }
    
    return $return;
}

function getTrad($pCode, $pPage = "")	
{
	if (isset($_SESSION['lstTrads'][$pCode]))	
	{	
		return stripslashes($_SESSION['lstTrads'][$pCode]);	
	}
	else if (isset($_SESSION['lstTradsGen'][$pCode]))	
	{	
		return stripslashes($_SESSION['lstTradsGen'][$pCode]);	
	}
	else if (isset($_SESSION['lstTradsErreur'][$pCode]))	
	{	
		return stripslashes($_SESSION['lstTradsErreur'][$pCode]);	
	}
	else
			return "Trad. inconnue : '$pCode' ($_SESSION[vsLang])";
}

function getTrad2($pCode, $pPage = "")	
{
	if (isset($_SESSION['lstTrads'][$pCode]))	
	{	
		return addslashes($_SESSION['lstTrads'][$pCode]);	
	}
	else if (isset($_SESSION['lstTradsGen'][$pCode]))	
	{	
		return addslashes($_SESSION['lstTradsGen'][$pCode]);	
	}
	else if (isset($_SESSION['lstTradsErreur'][$pCode]))	
	{	
		return addslashes($_SESSION['lstTradsErreur'][$pCode]);	
	}
	else
		return addslashes("Trad. inconnue : '$pCode' ($_SESSION[vsLang])");
}
?>