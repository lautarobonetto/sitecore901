# escape=`

#Download base image Windows ASP.net 4.7+
FROM microsoft/aspnet:4.7.1

# Metadata indicating an image maintainer.
LABEL "com.example.vendor"="Xennon Group"
LABEL com.example.label-with-value="Sitecore 9.0.1"
LABEL version="0.1"
LABEL description="This docker image is a Microsoft ASP.Net image ready to perform the Sitcore 9.0.1 installation automatically."

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]

#Define the ENV variable
ENV SC_prefix = sc901
ENV SC_XConnectCollectionService = $SC_prefix.xconnect
ENV SC_sitecoreSiteName = $SC_prefix.local
ENV SC_SolrUrl = https://localhost:8983/solr
ENV SC_SqlServer = MSSQL\\SQLEXPRESS
ENV SC_SqlAdminUser = sa
ENV SC_SqlAdminPassword = P4ssw0d123

# Prepearing working folder
RUN mkdir c:\\installer_scripts
WORKDIR "c:\\installer_scripts"
ADD ./install .

RUN Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine; Set-ExecutionPolicy Bypass -Scope Process -Force; 

# Installing Chocolatery to support Sitecore dependencies installations
RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

# Installing Web Platform Installer 5
RUN choco install webpi -y

# Installing IIS WebAdministration module

# Installing Web Deploy 3.6 for Hosting Servers
RUN choco install webdeploy -y

# Installing URL Rewrite Module 2.1
RUN choco install urlrewrite -y

# Installing Microsoft SQL Server Data-Tier Application Framework (DAC Fx) version 17.1
RUN choco install sql2016-dacframework -y

# Installing Microsoft SQL Server Transact-SQL ScriptDom
RUN choco install sql2014-sqldom -y

# Installing Sitecore Installer Framwork
RUN Install-PackageProvider nuget -force; `
    Register-PSRepository -Name SitecoreGallery -SourceLocation https://sitecore.myget.org/F/sc-powershell/api/v2; `
    Install-Module SitecoreInstallFramework -Force -SkipPublisherCheck; `
    Install-Module SitecoreFundamentals -Force -SkipPublisherCheck; `
    Import-Module SitecoreFundamentals -Force; `
    Import-Module SitecoreInstallFramework -Force

EXPOSE 80

# Triggering Sitecore installation script
CMD powershell .\\Install-sitecore9.ps1






