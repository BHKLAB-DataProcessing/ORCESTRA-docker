## Emacs, make this -*- mode: sh; -*-

FROM snakemake/snakemake:main
SHELL ["/bin/sh", "-c"]

# Make sure conda shared C libraries are used
ENV LD_LIBRARY_PATH=/opt/conda/lib:/opt/conda/envs/snakemake/lib

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
    dirmngr \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    gnupg2 \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    build-essential \
    libsodium-dev \
    libopenblas-dev \
    libnlopt-dev \
    cmake \
    libcairo2-dev \
    libxt-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libtiff-dev \
    libsqlite3-dev \
    libproj-dev \
    libgdal-dev

ARG R_VERSION=4.1.3
RUN wget https://cdn.rstudio.com/r/debian-10/pkgs/r-${R_VERSION}_1_amd64.deb && \
  apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -f -y ./r-${R_VERSION}_1_amd64.deb
RUN ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R

RUN Rscript -e 'install.packages("BiocManager", repos = "http://cran.us.r-project.org")'
RUN Rscript -e 'BiocManager::install(c("CoreGx", "PharmacoGx", "RadioGx", "ToxicoGx"));'
RUN Rscript -e 'install.packages(c("gdata", "parallel", "abind", "xml2", "ggplot2", "devtools"), repos = "http://cran.us.r-project.org");'

RUN Rscript -e \
    'pkgs <- c("data.table", "dplyr", "reshape2", "Hmisc"); \
    install.packages(pkgs, repos = "http://cran.us.r-project.org");'
RUN Rscript -e 'BiocManager::install("Biobase");'
RUN Rscript -e 'install.packages("readxl", repos = "http://cran.us.r-project.org");'