o2r Reproducibility Service Load Testing
========================================

In order to evaluate the performance of the o2r reproducibility service,
we conduct a suite of load tests for expected usage scenarios: an **ERC
creation scenario**, an **ERC examination scenario**, and a **combined
scenario**. The data collected during these load tests allows operators
of the reproducibility service to estimate the required infrastructure
and helps developers to improve the performance. Each section of the
document contains the functions required to test the o2r service both in
`local` implementation and in the `remote`
[o2r.uni-muenster.de](o2r.uni-muenster.de) implementation.

The ERC creation scenario assumes that a number of authors across all
time zones prepare an ERC-based submission to a special issue. A special
issue call is usually open for ~ 6 months, but often has a high number
of submissions close to the deadline. Because of the temporal
distribution and the unclear expected activity, we assume **3 parallel
creation sessions**.

The number of sessions for the examination scenario is aligned with a
typical number of papers in a special issue, i.e. 10 papers, and
simulates the case of two concurrent readers per paper, i.e. viewing
sessions 20 in total per issue. The test evaluates the performance of
the API separately for the first two scenarios.

Finally, a third scenario evaluates the parallel execution of the first
two scenarios. This would be the case for a reproducibility service
operated by a publisher who continuously runs special issues, **having
both readers** and open calls for submissions.

Load testing basics
-------------------

TODO: what is load testing? (how is not) add some links/literature here

Creation scenario
-----------------

### Overview

From the Author perspective the test simulates four main steps:

1.  Service authentication

2.  Upload of either a workspace or an ERC via either direct file upload
    or from one of two supported public shares

3.  Metadata editing

4.  Compendium execution and bindings testing

Every creation session has two main variables: the source and the type
of upload. Six combinations of upload type and origin origin are
possible in the first step. As the objective is to simulate three
parallel cases, the creation scenario will have subsequent creation
sessions to cover all the possible cases.

TODO: how often do we run each combinations to get trustworthy data?

### Upload type and origin

The test differentiates between the **two types of uploads**, which can
either be a workspace or a complete ERC. A workspace is an archive (.zip
Format) of all files needed for a scientific workflow, i.e. the main
file in R Markdown format, e.g., main.Rmd, the file for reading, e.g.,
display.html, and all additionally required data and software files (see
ERC specification for details). The finished ERC in addition contains
the ERC configuration file (erc.yml) and the files for the computing
environment (the manifest in a Dockerfile, the image in image.tar).

The type of upload is configured via the `content_type` parameter for
upload requests, see
<a href="http://o2r.info/api/compendium/upload/" class="uri">http://o2r.info/api/compendium/upload/</a>.

It is of interest if one of the formats significantly impact
performance, e.g., because the file sizes of ERC are much bigger because
of the image tarball, while the processing is reduced since the manifest
and image must not be created during submission.

The test includes three types of **upload origins**:

1.  [Direct file upload](http://o2r.info/api/compendium/upload/)
2.  [Public Share from
    Zenodo](http://o2r.info/api/compendium/public_share/#zenodo)
3.  [Public Share from
    Sciebo](http://o2r.info/api/compendium/public_share/#sciebo)

It is of interest if any of these sources perform better or worse than
others. For the Zenodo option, only the Record ID identification is
used.

### Metadata editing

As described on the compendium life cycle, the ‘candidate process’
should be applied to the compendium or workspaces in order to be
publicly available. This process should include a modifiable time that
the user would take interacting with the platform. Each user just saves
the metadata once. After metadata editing the ERC is published.

TODO: document task
(<a href="https://github.com/o2r-project/api/issues" class="uri">https://github.com/o2r-project/api/issues</a>)
for later: have authors save metadata several times before publishing

### Execution and interaction

After the publication of the compendiums the authors will most likely
also execute the ERCs and test the interaction with bindings, if the
latter exist. Therefore at least one execution job is started after each
upload, see
<a href="http://o2r.info/api/job/#execute-a-compendium" class="uri">http://o2r.info/api/job/#execute-a-compendium</a>.

Examination scenario
--------------------

### Overview

The reading sessions consist on the simulation of 20 readers accessing
and interacting with existing Compendiums (i.e. successfully created
Compendia). The reading session will access to a compendium and execute
a job (see \#\#Job). For the test it is required to have at least 10
compendia. The time of start of the execution of each individual
examination session should be adjustable.

From the reader perspective the test simulates two main steps:

1.  Service authentication

2.  Compendium execution and bindings testing

Implementation
--------------

### Overview

The test plan will be scripted using R and is controlled via an R
Markdown notebook (this file). The test notebook is part of the API
documentation and is published at
<a href="https://o2r.info/api/evaluation" class="uri">https://o2r.info/api/evaluation</a>.

### Summary of functions

The test includes a series of functions to conduct the usage scenarios
including the required processes divided in 4 groups (1) Service
Authentication, (2) ERC / Workspace Upload, (3) Metadata editing (i.e.
[Candidate process](http://o2r.info/api/compendium/candidate/)) and (4)
Compendium execution.

### Required libraries

    library(RSelenium)
    library(binman)
    library(httr)
    library(rjson)
    library(stringr)

### 1. Service Authentication

#### Remote service

In case of a remote service
[o2r.uni-muenster.de](http://o2r.uni-muenster.de) this chunck access to
the demo webpage and find the cookie `connec.sid` after a succesfull
login. It is required a `.Renviron` file on your local machine next to
this file defining USERNAME and PASSWORD variables corresponding to the
login information of [orcid](orcidorcid.org) **personal account**.

    #Function to assign in the local environment the Cookie 'connec.sid' and the endpoint corresponding to the type of test (local or remote)

    getCookieRemote<-function(){
      
      #Remote Test
      o2rRemote<-"https://o2r.uni-muenster.de/#/"
      
      # Read startup file  / login information
      readRenviron(".Renviron")

      available.versions<-list_versions("chromedriver")
      r<-rsDriver(chromever=available.versions[[1]][1])
      remDr<-r[["client"]]  
      
      # o2r webpage
      remDr$navigate(o2rRemote)
      webElem<-remDr$findElement(using = "xpath", "//a[@href='api/v1/auth/login']")
      webElem$clickElement()
      Sys.sleep(1)
      # orcid.org login webpage - Personal login
      
      webElemUsername<-remDr$findElement(using="id",value='userId')
      Sys.sleep(1)
      webElemPass<-remDr$findElement(using="id",value='password')
      Sys.sleep(1)
      webElemUsername$sendKeysToElement(list(Sys.getenv("USERNAME")))
      Sys.sleep(1)
      webElemPass$sendKeysToElement(list(Sys.getenv("PASSWORD"),key="enter"))
      Sys.sleep(1)
      
      # Get cookie
      cookie<-URLdecode(remDr$getAllCookies()[[1]]$value)
      Sys.sleep(1)
      Sys.setenv(COOKIE=cookie)
      Sys.setenv(ENDPOINT="https://o2r.uni-muenster.de/api/v1/")
      print(cookie)
      #Close
      remDr$close()
      rm(r)
    }

#### Local service

The following code chunk retrieves the cookie `connec.sid`from the local
reference implementation, which is exposed via [o2r-guestlister](). This
is a “security hole” which of course does not work when uploading
workspaces to a remote reference implementation deployment. It is
required a `.Renviron` file on your local machine next to this file
defining `IP` corresponding to the o2r ip address of your Docker
environment inplementation. To find the ip (Usually but not always
`localhost`) you have to use the `$docker-machine ip` command.

    getCookieLocal<-function(){
      
      # LocalTest
      o2rlocal<-Sys.getenv("IP")
      
      # Starting Selenium session
      available.versions<-list_versions("chromedriver")
      r<-rsDriver(port=1234L,chromever=available.versions[[1]][1])
      remDr<-r[["client"]]  
      
      # Navigating to o2r local implementation page
      
      remDr$navigate(o2rlocal)
      
      # Click on Login
      webElem<-remDr$findElement(using = "xpath","//a[@href='api/v1/auth/login']")
      webElem$clickElement()
      Sys.sleep(1)
      
      # o2r Admin/ Editor / User
      
      # Click on 'Admin'
      webElem$findElement(using="xpath","/html/body/div/div[2]/form[3]/button")
      webElem$clickElement()
      
      # Get cookie and decoding
      cookie<-URLdecode(webElem$getAllCookies()[[1]]$value)
      Sys.sleep(1)
      Sys.setenv(COOKIE=cookie)
      Sys.setenv(ENDPOINT="https://o2r.uni-muenster.de/api/v1/")
      
      # Closing Selenium session
      remDr$close()
      rm(r)
    }

### 2. ERC / Workspace Upload

The test differentiates between two types of uploads (either workspace
or a complete ERC) and 3 origins (Direct, Zenodo and Sciebo). The
following 3 functions (one for each origin) upload the workspaces and
the complete ERC for either a `localtest` or a `remotetest`. The
function *requires a previous Service authentication* to define
`ENDPOINT` and `COOKIE`.

#### [Direct Upload](http://o2r.info/api/compendium/upload/)

Upload a research workspace or full compendium as a compressed `.zip`.

    # DirectApi upload
    # compendium -> The archive file
    # content_type -> Form of the archive ('compendium' or 'workspace')

    DirectApi<-function(compendium,content_type){
      file<-upload_file(compendium)
      endpoint<-Sys.getenv("ENDPOINT")
      cookie<-Sys.getenv("COOKIE")
      response<-POST(url=paste0(endpoint,"compendium"),
                     body=list(
                       compendium=file,
                       content_type=content_type),
                     accept_json(),
                     set_cookies(connect.sid=cookie),
                     enconde="multipart"
      )
      return(response)
    }  

#### [Public Share - Sciebo](http://o2r.info/api/compendium/public_share/#sciebo)

Upload a research workspace or full compendium as a compressed `.zip`
from a public share on [Sciebo](https://sciebo.de/).

    # PublicShare Sciebo
    # share_url -> The Sciebo link to the public share
    # content_type -> Form of archive ('compendium' or 'workspace')
    # path -> Path to a subdirectory or a zip file in the public share

    PublicShare_Sciebo<-function(share_url,path,content_type){

      endpoint<-Sys.getenv("ENDPOINT")
      cookie<-Sys.getenv("COOKIE")
      
      response<-POST(url=paste0(endpoint,"compendium"),
                     body=list(
                       share_url=share_url,
                       content_type=content_type,
                       path=path),
                     accept_json(),
                     set_cookies(connect.sid=cookie),
                     enconde="multipart"
      )
      return(response)
    }

#### [Public Share - Zenodo](http://o2r.info/api/compendium/public_share/#zenodo)

Upload a research workspace or full compendium as a compressed `.zip`
from a public share on [Zenodo](https://zenodo.org/) using the
`Zenodo Record ID`.

    # PublicShare Zenodo
    # zenodo_record_id -> The Sciebo link to the public share
    # content_type -> Form of archive ('compendium' or 'workspace')

    PublicShare_Zenodo<-function(zenodo_record_id,content_type){

      endpoint<-Sys.getenv("ENDPOINT")
      cookie<-Sys.getenv("COOKIE")
      
      response<-POST(url=paste0(endpoint,"compendium"),
                     body=list(
                       content_type=content_type,
                       zenodo_record_id=zenodo_record_id),
                     accept_json(),
                     set_cookies(connect.sid=cookie),
                     enconde="multipart"
      )
      return(response)
    }

### 3. Metadata editing / Publish compendium [(Candidate Process)](http://o2r.info/api/compendium/candidate/#candidate-process)

After uploading a compendium a [succesful metadata
update](http://o2r.info/api/compendium/metadata/#update-metadata) is
required to make it publicly available. The following code reproduce the
metadata extracting and metadata update required to publish the
compendium.

    # publish_compendium
    # id -> compendium id

    publish_compendium <- function(id){
      
      endpoint<-Sys.getenv("ENDPOINT")
      cookie<-Sys.getenv("COOKIE")
      
      url_metadata<-paste0(endpoint,"compendium/",id,"/metadata")
      print(url_metadata)
      print("Extracting metadata...")
     
      # Extract metadata
      response <- GET(url=url_metadata,
                      accept_json(),
                      set_cookies(connect.sid = cookie))
      print("Printing metadata")
      print(response)
      
      metadata <-  content(response, as = "text")
      metadata <- str_sub(string = metadata,start = str_locate(string = metadata, pattern = "\\{\"o2r\"")[[1]],end = str_length(metadata) - 1)
      
      print("printing... metadata")
      printing(metadata)
      
      # Update metadata "Candidate process"
      response_update <- PUT(url=url_metadata,
                             body = metadata,
                             content_type_json(),
                             accept_json(),
                             set_cookies(connect.sid = cookie))
      return(response_update)
    }
