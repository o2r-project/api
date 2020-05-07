o2r Reproducibility Service Load Testing
========================================

In order to evaluate the performance of the o2r reproducibility service
we conduct a suite of load tests for expected usage scenarios: an **ERC
creation scenario**, an **ERC examination scenario**, and a **combined
scenario**. The data collected during these load tests allows operators
of the reproducibility service to estimate required infrastructure and
helps developers to improve the performance. Each section of the
document contains the functions required to test the o2r service both in
a `local` implementation and in the `remote`
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

TODO: what is load testing? (how is not ) add some links/literature here

Creation scenario
-----------------

### Overview

From the Author perspective the test simulates three main steps:

1.  upload of either a workspace or an ERC via either direct file upload
    or from one of two supported public shares
2.  metadata editing
3.  compendium execution and bindings testing

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

The test includes 3 types of **upload origins**:

1.  Direct file upload, see
    <a href="http://o2r.info/api/compendium/upload/" class="uri">http://o2r.info/api/compendium/upload/</a>
2.  Public Share from Zenodo, see
    <a href="http://o2r.info/api/compendium/public_share/#zenodo" class="uri">http://o2r.info/api/compendium/public_share/#zenodo</a>
3.  Public Share from Sciebo,
    <a href="http://o2r.info/api/compendium/public_share/#sciebo" class="uri">http://o2r.info/api/compendium/public_share/#sciebo</a>

It is of interest if any of these sources perform better or worse than
others. For the Zenodo option, only the DOI-based identification is
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

TODO: distinguish between UI performance and API performance, the latter
is the main thing, the former can be a little standalone “sub-scenario”

Implementation
--------------

### Overview

The test plan will be scripted using R and is controlled via an R
Markdown notebook (this file). The test notebook is part of the API
documentation and is published at
<a href="https://o2r.info/api/evaluation" class="uri">https://o2r.info/api/evaluation</a>.

### Required libraries

    library(RSelenium)
    library(binman)
    library(loadtest)

    ##  __         ______     ______     _____     ______   ______     ______     ______
    ## /\ \       /\  __ \   /\  __ \   /\  __-.  /\__  _\ /\  ___\   /\  ___\   /\__  _\
    ## \ \ \____  \ \ \/\ \  \ \  __ \  \ \ \/\ \ \/_/\ \/ \ \  __\   \ \___  \  \/_/\ \/
    ##  \ \_____\  \ \_____\  \ \_\ \_\  \ \____-    \ \_\  \ \_____\  \/\_____\    \ \_\
    ##   \/_____/   \/_____/   \/_/\/_/   \/____/     \/_/   \/_____/   \/_____/     \/_/
    ##                   :: loadtest - an R load testing framework ::

    library(httr)
    library(rjson)
    library(stringr)

### Service Authentication

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
reference implementation, which is exposed via [o2r-guestlister]().This
is a “security hole” which of course does not work when uploading
workspaces to a remote reference implementation deployment. It is
required a `.Renviron` file on your local machine next to this file
defining `IP` corresponding to the o2r ip address of your Docker
environment. To find the ip you have to use the `$docker-machine ip`
command.

    getCookieLocal<-function(){
      
      #LocalTest
      o2rlocal<-Sys.getenv("IP")
      available.versions<-list_versions("chromedriver")
      r<-rsDriver(port=1234L,chromever=available.versions[[1]][1])
      remDr<-r[["client"]]  
      
      #### with localhost working
      
      #o2r webpage
      
      remDr$navigate(o2rlocal)
      
      webElem<-remDr$findElement(using = "xpath","//a[@href='api/v1/auth/login']")
      webElem$clickElement()
      Sys.sleep(1)
      
      # o2r Admin/ Editor / User
      
      webElem$findElement(using="xpath","/html/body/div/div[2]/form[3]/button")
      webElem$clickElement()
      
      # Get cookie
      cookie<-URLdecode(webElem$getAllCookies()[[1]]$value)
      Sys.sleep(1)
      Sys.setenv(COOKIE=cookie)
      Sys.setenv(ENDPOINT="https://o2r.uni-muenster.de/api/v1/")
      
      #Close
      remDr$close()
      rm(r)
    }
