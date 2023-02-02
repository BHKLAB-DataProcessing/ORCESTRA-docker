FROM snakemake/snakemake:main
SHELL ["/bin/sh", "-c"]

# Make sure conda shared C libraries are used
ENV LD_LIBRARY_PATH=/opt/conda/lib:/opt/conda/envs/snakemake/lib

# -- R
# Install R system requirements
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
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
    libnlopt-dev
# Install R using apt
RUN apt-key adv \
    --keyserver keyserver.ubuntu.com \
    --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
RUN add-apt-repository \
    "deb https://cloud.r-project.org/bin/linux/debian \
    $(lsb_release -cs)-cran40/"
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y r-base

RUN apt-get install -y cmake

# Install R libraries
RUN Rscript -e \
    'install.packages("pak", dependencies=TRUE, ask=FALSE);'
RUN Rscript -e \
    'pak::pkg_install("BiocManager");'
RUN Rscript -e \
    'pkgs <- c("data.table", "dplyr", "reshape2", "Hmisc"); \
    install.packages(pkgs);'
RUN Rscript -e \
    'pkgs <- c("CoreGx", "PharmacoGx", "Biobase", "SummarizedExperiment", \
    "illuminaHumanv4.db", "GEOquery"); \
    BiocManager::install(pkgs);'
RUN Rscript -e \
    'pkgs <- c("readxl", "stringr"); \
    install.packages(pkgs);'
RUN Rscript -e \
    'pkgs <- c("MultiAssayExperiment", "Biobase"); \
    install.packages(pkgs);'
RUN Rscript -e 'BiocManager::install("biomaRt")'
RUN Rscript -e 'BiocManager::install(c("GenomicRanges", "org.Hs.eg.db"))'
RUN apt-get update -y
RUN apt-get install -y \
    libcairo2-dev \
    libxt-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libtiff-dev \
    libsqlite3-dev \
    libproj-dev \
    libgdal-dev
RUN Rscript -e 'pak::pkg_install(c("textshaping", "Cairo", "devtools"))'
RUN Rscript -e 'BiocManager::install(c("BiocGenerics", "DelayedArray", "DelayedMatrixStats", \
                    "limma", "lme4", "S4Vectors", "SingleCellExperiment", \
                    "SummarizedExperiment", "batchelor", "Matrix.utils", \
                    "HDF5Array", "ggrastr"))'
RUN Rscript -e 'install.packages("terra")'
RUN apt-get install -y libudunits2-dev
RUN Rscript -e 'install.packages(c("units", "sf", "spdep"))'
RUN Rscript -e 'devtools::install_github("cole-trapnell-lab/monocle3")'

# RadioGx, Xeva
RUN Rscript -e 'install.packages(c("gdata", "parallel", "abind", "xml2", "ggplot2"))'
RUN Rscript -e 'BiocManager::install(c("RadioGx", "Xeva", "ToxicoGX", "affy", "affyio"))'
RUN wget 'https://filesforpublic.blob.core.windows.net/toxicogx/hgu133plus2hsensgcdf_24.0.0.tar.gz'
RUN wget 'https://filesforpublic.blob.core.windows.net/toxicogx/rat2302rnensgcdf_24.0.0.tar.gz'
RUN Rscript -e "library(devtools); install.packages('hgu133plus2hsensgcdf_24.0.0.tar.gz', repos = NULL, type = 'source')"
RUN Rscript -e "library(devtools); install.packages('rat2302rnensgcdf_24.0.0.tar.gz', repos = NULL, type = 'source')"