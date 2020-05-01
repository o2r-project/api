This documet contais some script that opens an ERC (see
<a href="https://o2r.uni-muenster.de/#/" class="uri">https://o2r.uni-muenster.de/#/</a>)
and measures how long it takes until the HTML-page has fininished
[rendering](https://en.wikipedia.org/wiki/Front_end_and_back_end).

Required libraries
------------------

    library(RSelenium)
    library(parallel)
    library(binman)

Function
--------

The `visitERC` function opens an ERC and returns information about the
backend performance and frontend performance. For a similar approach
ussing python visit this
[repository](https://github.com/chewitt-swts/GeicoAutoTest/blob/master/PageLoadTimeClass.py)

    #Function to visit an ERC (web) and extract information about rendering time

    visitERC<-function(erc,portNumber){
      
      #Starting Selenium server
      available.versions<-list_versions("chromedriver")
      r<-rsDriver(port=portNumber,chromever=available.versions[[1]][1])
      remDr<-r[["client"]]
      
      # Navigating to webpage
      
      remDr$navigate(erc)
      
      # Extracting information
      navigationStart<-remDr$executeScript("return window.performance.timing.navigationStart")
      responseStart<-remDr$executeScript("return window.performance.timing.responseStart")
      domComplete<-remDr$executeScript("return window.performance.timing.domComplete")
      
      # Stoping server
      
      remDr$close()
      r[["server"]]$stop()
      result<-list(x=navigationStart,y=responseStart,z=domComplete)
      return(result)
    }

Test
----

For this test it is required to define the `ERC` link that is going to
be rendered and the number of visits (`num_visits`) to perform. The
number of simultaneous visits is limited to the number of CPU cores of
your machine. This means that a machine with 2 cores would make at most
2 simultaneous visits. For a test with `N` visits (and 2 avaiblable
cores) the test will perform `N/2` consecutive series of visits (2
simultaneous) until reaching that number. Visit this
[link](https://nceas.github.io/oss-lessons/parallel-computing-in-r/parallel-computing-in-r.html)
for more information about parallel computing in R.

The test information is recorded on the dataframe `df`.

    # Defining parameters
    num_visits<-10
    ERC<-"https://o2r.uni-muenster.de/ui/#/erc/BR5vo"

    # Creating dataframe with link and port number (to avoid Selenium Server errors)

    links<-replicate(num_visits,ERC)
    df<-data.frame(Links=links)
    df$port<-((4567:(4567+nrow(df)-1)))

    # Applying function

    results<-mcmapply(visitERC,df$Links,df$port)

    # Adding information to dataframe

    df$NavigationStart<-unlist(results[1,])
    df$responseStart<-unlist(results[2,])
    df$domComplete<-unlist(results[3,])

    # Calculations
    df['backendPerformance_calc']<- df$responseStar-df$NavigationStart
    df['frontendPerformance_cal']<- df$domComplete-df$responseStart

    print(df)

    ##                                         Links port NavigationStart
    ## 1  https://o2r.uni-muenster.de/ui/#/erc/BR5vo 4567    1.588345e+12
    ## 2  https://o2r.uni-muenster.de/ui/#/erc/BR5vo 4568    1.588345e+12
    ## 3  https://o2r.uni-muenster.de/ui/#/erc/BR5vo 4569    1.588345e+12
    ## 4  https://o2r.uni-muenster.de/ui/#/erc/BR5vo 4570    1.588345e+12
    ## 5  https://o2r.uni-muenster.de/ui/#/erc/BR5vo 4571    1.588345e+12
    ## 6  https://o2r.uni-muenster.de/ui/#/erc/BR5vo 4572    1.588345e+12
    ## 7  https://o2r.uni-muenster.de/ui/#/erc/BR5vo 4573    1.588345e+12
    ## 8  https://o2r.uni-muenster.de/ui/#/erc/BR5vo 4574    1.588345e+12
    ## 9  https://o2r.uni-muenster.de/ui/#/erc/BR5vo 4575    1.588345e+12
    ## 10 https://o2r.uni-muenster.de/ui/#/erc/BR5vo 4576    1.588345e+12
    ##    responseStart  domComplete backendPerformance_calc frontendPerformance_cal
    ## 1   1.588345e+12 1.588345e+12                     842                   13445
    ## 2   1.588345e+12 1.588345e+12                    1085                   13421
    ## 3   1.588345e+12 1.588345e+12                     728                    7792
    ## 4   1.588345e+12 1.588345e+12                     475                    8488
    ## 5   1.588345e+12 1.588345e+12                     566                   10048
    ## 6   1.588345e+12 1.588345e+12                     573                    9335
    ## 7   1.588345e+12 1.588345e+12                     709                    8975
    ## 8   1.588345e+12 1.588345e+12                     741                    8767
    ## 9   1.588345e+12 1.588345e+12                     467                    9031
    ## 10  1.588345e+12 1.588345e+12                     733                    8986

TO DO
=====

Add statistics / analysis (?)
