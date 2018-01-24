#define parameters 
$prefix = $Env:SC_prefix
$PSScriptRoot2 = "c:\installer_scripts"
$XConnectCollectionService = $Env:SC_XConnectCollectionService
$sitecoreSiteName = $Env:SC_sitecoreSiteName
$SolrUrl = $Env:SC_SolrUrl
#$SolrRoot = "c:\solr"
#$SolrService = "Solr662"
$SqlServer = $Env:SC_SqlServer
$SqlAdminUser = $Env:SC_SqlAdminUser
$SqlAdminPassword = $Env:SC_SqlAdminPassword
 
#install client certificate for xconnect 
$certParams = 
@{     
    Path = "$PSScriptRoot2\xconnect-createcert.json"     
    CertificateName = "$prefix.xconnect_client" 
} 
Install-SitecoreConfiguration @certParams -Verbose

#install solr cores for xdb 
# $solrParams = 
# @{
#     Path = "$PSScriptRoot2\xconnect-solr.json"     
#     SolrUrl = $SolrUrl    
#     SolrRoot = $SolrRoot  
#     SolrService = $SolrService  
#     CorePrefix = $prefix 
# } 
# Install-SitecoreConfiguration @solrParams -Verbose

#deploy xconnect instance 
$xconnectParams = 
@{
    Path = "$PSScriptRoot2\xconnect-xp0.json"     
    Package = "$PSScriptRoot2\Sitecore 9.0.1 rev. 171219 (OnPrem)_xp0xconnect.scwdp.zip"
    LicenseFile = "$PSScriptRoot2\license.xml"
    Sitename = $XConnectCollectionService   
    XConnectCert = $certParams.CertificateName    
    SqlDbPrefix = $prefix  
    SqlServer = $SqlServer  
    SqlAdminUser = $SqlAdminUser
    SqlAdminPassword = $SqlAdminPassword
    SolrCorePrefix = $prefix
    SolrURL = $SolrUrl      
} 
Install-SitecoreConfiguration @xconnectParams -Verbose

#install solr cores for sitecore 
# $solrParams = 
# @{
#     Path = "$PSScriptRoot2\sitecore-solr.json"
#     SolrUrl = $SolrUrl
#     SolrRoot = $SolrRoot
#     SolrService = $SolrService     
#     CorePrefix = $prefix 
# } 
# Install-SitecoreConfiguration @solrParams -Verbose
 
#install sitecore instance 
$sitecoreParams = 
@{     
    Path = "$PSScriptRoot2\sitecore-XP0.json"
    Package = "$PSScriptRoot2\Sitecore 9.0.1 rev. 171219 (OnPrem)_single.scwdp.zip" 
    LicenseFile = "$PSScriptRoot2\license.xml"
    SqlDbPrefix = $prefix  
    SqlServer = $SqlServer  
    SqlAdminUser = $SqlAdminUser     
    SqlAdminPassword = $SqlAdminPassword     
    SolrCorePrefix = $prefix  
    SolrUrl = $SolrUrl     
    XConnectCert = $certParams.CertificateName     
    Sitename = $sitecoreSiteName         
    XConnectCollectionService = "https://$XConnectCollectionService"    
} 
Install-SitecoreConfiguration @sitecoreParams -Verbose

