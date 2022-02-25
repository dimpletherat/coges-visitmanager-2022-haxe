<?
session_start();

$PATH_DLIB = "../../dlib";
include "$PATH_DLIB/dl_inc_all.php";

include "../../lib/libgen.php";
include "../../lib/libsite.php";

if (isset($_GET['deco']) && $_GET['deco'] == 1)
{
	$_SESSION = array();
	session_destroy();
	header("Location:index.php");
	exit;
}

include "../../class/csysparam.php";
include "../../class/cuser.php";
include "../../class/cpays.php";
include "../../class/cnationalites.php";
include "../../class/cvmexposant.php";
include "../../class/cdataexpaccdo.php";
include "../../class/cdelegoff.php";
include "../../class/cprog.php";
include "../../class/cvmoffzone.php";
include "../../class/cdemande.php";
include "../../class/ccreneau.php";
include "../../class/cvmactivites.php";
include "../../class/cvmoffac.php";
include "../../class/cvmvisite.php";
include "../../class/cvmgroupe.php";
include "../../class/cvmcivilites.php";
include "../../class/cvmplage.php";
include "../../class/cvmplanning.php";
include "../../class/cvmattachdef.php";
include "../../class/cvmmembrebursalon.php";
include "../../class/cvmtraduction.php";
include "../../class/cvmactvis.php";
include "../../class/cvmdossier.php";
include "../../class/cvmtache.php";
include "../../class/cvmautrvis.php";

require_once("../../inc/inc_global.php");
require_once("../../inc/inc_bdd.php");

$db = new dlDb(BDD_HOST, BDD_NAME, BDD_USER, BDD_PWD);

$_SESSION['osUser'] = new cUser($db);

//error_reporting  (0 );
error_reporting  (E_ALL);

$_SESSION["sDEBUG_REQ"]=false;				//	Echo des requetes
$_SESSION["sDEBUG_REQEXEC"]=false;			//  Echo des resultats de requetes


$vsTitrePage = 'VisitManager - Demandes des exposants';	// Titre g�n�ral des pages


/********************* Tests d'accès à la page ***************************/

//by pass de l'authentification pour l'impression des pdf
if (!isset($_GET['pass']) || $_GET['pass'] != 1){
	//Si nous ne sommes pas sur la page de login
	if (lg_nompage($_SERVER['PHP_SELF'])!="index.php" && lg_nompage($_SERVER['PHP_SELF'])!="planning_do_synthese.php" && lg_nompage($_SERVER['PHP_SELF'])!="gen_plan_excel.php")
	{
		//Test le statut de l'utilisateur
		if (isset($_SESSION["UserStatut"]))
		{
			if ($_SESSION["UserStatut"] != "Programmeur")
			{
				header("Location:acces_refuse.php");
			}
		}
		else
		{
			header("Location:acces_refuse.php");
		}
	}
}

$page= substr(
		 $_SERVER['PHP_SELF'],
		 strrpos($_SERVER['PHP_SELF'], '/')+1,
		 strrpos($_SERVER['PHP_SELF'],'.')-1
	);

/********************* Langue ***************************/
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

// EK - 19/10/2021
elseif (isset($_SESSION["vsLang"]) && $_SESSION["vsLang"] == "gb")
{
	$_SESSION["vsLang"]="en";
}
//echo "rocks=" . $_SESSION['vsLang'];

/********************* Traduction ***************************/
//Initialisation du tableau lstTrads en session
$_SESSION['lstTrads']=array();
$o=new cvmtraduction($db);

$lstTmp = $o->findByPage(lg_nompage($_SERVER['PHP_SELF']),$_SESSION["vsLang"]);

// une seule page de trad pour planning_do_prog et planning_do
if(lg_nompage($_SERVER['PHP_SELF']) == "planning_do_prog.php")
	$lstTmp = $o->findByPage(lg_nompage("planning_do.php"),$_SESSION["vsLang"]);
if(lg_nompage($_SERVER['PHP_SELF']) == "planning_do_prog_imprim.php")
	$lstTmp = $o->findByPage(lg_nompage("planning_do.php"),$_SESSION["vsLang"]);
if(lg_nompage($_SERVER['PHP_SELF']) == "planning_do_edit.php")
	$lstTmp = $o->findByPage(lg_nompage("manage_do.php"),$_SESSION["vsLang"]);
if(lg_nompage($_SERVER['PHP_SELF']) == "planning_do_synthese.php")
	$lstTmp = $o->findByPage(lg_nompage("planning_do.php"),$_SESSION["vsLang"]);
if(lg_nompage($_SERVER['PHP_SELF']) == "gen_plan_excel.php")
	$lstTmp = $o->findByPage(lg_nompage("planning_do.php"),$_SESSION["vsLang"]);
if(lg_nompage($_SERVER['PHP_SELF']) == "planning_exposant_imprim.php")
	$lstTmp = $o->findByPage(lg_nompage("planning_exposant.php"),$_SESSION["vsLang"]);
if(lg_nompage($_SERVER['PHP_SELF']) == "demandes_exposants_imprim.php")
	$lstTmp = $o->findByPage(lg_nompage("demandes_exposants.php"),$_SESSION["vsLang"]);

//echo"rocks=<pre>";print_r($lstTmp);echo"</pre>";

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

//Initialisation du tableau lstTradsGenVM en session
$_SESSION['lstTradsGenVM']=array();
$o=new cvmtraduction($db);
$lstTmp=$o->findByPage(lg_nompage('_vm'),$_SESSION["vsLang"]);

foreach ($lstTmp as $t)
{
	$_SESSION['lstTradsGenVM'][$t->code]=$t->libelle;	
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

$formLng = "en";
if (isset($_SESSION["vsLang"]))
{
	$formLng = strtolower($_SESSION["vsLang"]);
}
if ($formLng == "en")
{
	$formLng = "gb";
}

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
    else if (isset($_SESSION['lstTradsGenVM'][$pCode]))	
	{	
		return stripslashes($_SESSION['lstTradsGenVM'][$pCode]);	
	}
	else if (isset($_SESSION['lstTradsErreur'][$pCode]))	
	{	
		return stripslashes($_SESSION['lstTradsErreur'][$pCode]);	
	}
	else
		return "Trad. inconnue : '$pCode' ($_SESSION[vsLang])";
}

function getTradJs($pCode, $pCarac)
{
	$trad = getTrad($pCode);
	
	return str_replace($pCarac, "\\".$pCarac, $trad);
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
    else if (isset($_SESSION['lstTradsGenVM'][$pCode]))	
	{	
		return addslashes($_SESSION['lstTradsGenVM'][$pCode]);	
	}
	else if (isset($_SESSION['lstTradsErreur'][$pCode]))	
	{	
		return addslashes($_SESSION['lstTradsErreur'][$pCode]);	
	}
	else
		return addslashes("Trad. inconnue : '$pCode' ($_SESSION[vsLang])");
}

?>