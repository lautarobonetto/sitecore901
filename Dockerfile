# escape=`

#Download base image Windows ASP.net 4.7+
FROM microsoft/aspnet:4.7.1

# Metadata indicating an image maintainer.
MAINTAINER Lautaro Bonetto "lautaro.bonetto@globant.com"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]

#Define the ENV variable
ENV SC_prefix = sc901
ENV SC_XConnectCollectionService = $SC_prefix.xconnect
ENV SC_sitecoreSiteName = $SC_prefix.local
ENV SC_SolrUrl = https://localhost:8983/solr
#ENV SC_SolrService = solr6
ENV SC_SqlServer = MSSQL\\SQLEXPRESS
ENV SC_SqlAdminUser = sa
ENV SC_SqlAdminPassword = P4ssw0d123


RUN mkdir c:\\solr; mkdir c:\\installer_scripts

WORKDIR "c:\\installer_scripts"

ADD ./install/Install-sitecore9.ps1 .

RUN Install-PackageProvider nuget -force
RUN Register-PSRepository -Name SitecoreGallery -SourceLocation https://sitecore.myget.org/F/sc-powershell/api/v2; `
    Install-Module SitecoreInstallFramework -Force -SkipPublisherCheck; `
    Install-Module SitecoreFundamentals -Force -SkipPublisherCheck; `
    Import-Module SitecoreFundamentals -Force; `
    Import-Module SitecoreInstallFramework -Force

EXPOSE 80

CMD powershell .\\Install-sitecore9.ps1




