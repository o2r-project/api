FROM rocker/r-ver:3.4.3
LABEL maintainer="o2r"

ENV SECONDS 10
  
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
 && apt-get install -y git-core \
	pandoc \
	pandoc-citeproc
RUN ["install2.r", "backports", "digest", "evaluate", "htmltools", "knitr", "magrittr", "Rcpp", "rmarkdown", "rprojroot", "stringi", "stringr", "yaml"]
WORKDIR /erc/
CMD ["R", "--vanilla", "-e", "rmarkdown::render(input = \"/erc/main.Rmd\", output_format = rmarkdown::html_document(), output_dir = \"/erc\", output_file = \"display.html\")"]
