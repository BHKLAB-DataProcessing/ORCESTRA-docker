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
    libgdal-dev \
    libudunits2-dev

ARG R_VERSION=4.1.3
RUN wget https://cdn.rstudio.com/r/debian-10/pkgs/r-${R_VERSION}_1_amd64.deb && \
  apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -f -y ./r-${R_VERSION}_1_amd64.deb
RUN ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R

RUN Rscript -e 'install.packages("BiocManager", repos = "http://cran.us.r-project.org")'
RUN Rscript -e 'BiocManager::install(c("Biobase", "CoreGx", "PharmacoGx", "RadioGx", "ToxicoGx"));'
RUN Rscript -e 'install.packages(c("gdata", "parallel", "abind", "xml2", "ggplot2", "devtools"), repos = "http://cran.us.r-project.org");'

RUN Rscript -e 'install.packages(c("data.table", "dplyr", "reshape2", "Hmisc"), repos = "http://cran.us.r-project.org");'
RUN Rscript -e 'install.packages(c("readxl", "stringr", "textshaping", "Cairo"), repos = "http://cran.us.r-project.org");'
RUN Rscript -e 'install.packages(c("units", "sf", "spdep", "terra"), repos = "http://cran.us.r-project.org");'

RUN Rscript -e 'BiocManager::install(c("MultiAssayExperiment", "illuminaHumanv4.db", "GEOquery"));'
RUN Rscript -e 'BiocManager::install(c("biomaRt", "GenomicRanges", "org.Hs.eg.db", "affy", "affyio"));'
RUN Rscript -e 'BiocManager::install(c("BiocGenerics", "DelayedArray", "DelayedMatrixStats", \
                    "limma", "lme4", "S4Vectors", "SingleCellExperiment", \
                    "batchelor", "Matrix.utils", "HDF5Array", "ggrastr"));'
RUN Rscript -e "BiocManager::install(c('tximport', 'rhdf5', 'RaggedExperiment'));"

RUN wget 'https://filesforpublic.blob.core.windows.net/toxicogx/hgu133plus2hsensgcdf_24.0.0.tar.gz'
RUN wget 'https://filesforpublic.blob.core.windows.net/toxicogx/rat2302rnensgcdf_24.0.0.tar.gz'
RUN Rscript -e "library(devtools); install.packages('hgu133plus2hsensgcdf_24.0.0.tar.gz', repos = NULL, type = 'source')"
RUN Rscript -e "library(devtools); install.packages('rat2302rnensgcdf_24.0.0.tar.gz', repos = NULL, type = 'source')"
RUN Rscript -e 'devtools::install_github("cole-trapnell-lab/monocle3")'

RUN Rscript -e "remove.packages('preprocessCore')"
RUN Rscript -e "BiocManager::install('preprocessCore', configure.args = '--disable-threading')"

RUN Rscript -e "install.packages(c('downloader', 'biocompute', 'matrixStats', 'curl', 'RCurl', 'openxlsx'), dependencies = TRUE, repos = 'http://cran.us.r-project.org')"
RUN Rscript -e "devtools::install_github('hadley/readr')"
RUN Rscript -e 'install.packages(c("qs", "purrr"), repos = "http://cran.us.r-project.org");'