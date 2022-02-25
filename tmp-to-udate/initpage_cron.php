<?php
session_start();

$PATH_DLIB = "../../dlib";
include "$PATH_DLIB/dl_inc_all.php";

include "../../lib/libgen.php";
include "../../lib/libsite.php";

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
include "../../class/cvmactvis.php";
include "../../class/cvmdossier.php";
include "../../class/cvmtache.php";

require_once("../../inc/inc_global.php");
require_once("../../inc/inc_bdd.php");

$db = new dlDb(BDD_HOST, BDD_NAME, BDD_USER, BDD_PWD);

$_SESSION['osUser'] = new cUser($db);

//error_reporting  (0 );
error_reporting  (E_ALL);

$_SESSION["sDEBUG_REQ"]=false;				//	Echo des requetes
$_SESSION["sDEBUG_REQEXEC"]=false;			//  Echo des resultats de requetes

?>