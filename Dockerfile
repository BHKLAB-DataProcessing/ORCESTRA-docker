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
# Install R libraries
RUN Rscript -e \
    'install.packages("pak", dependencies=TRUE, ask=FALSE);'
RUN Rscript -e \
    'pak::pkg_install("BiocManager");'
RUN Rscript -e \
    'pkgs <- c("data.table", "dplyr", "reshape2", "Hmisc"); \
    pak::pkg_install(pkgs);'
RUN Rscript -e \
    'pkgs <- c("CoreGx", "PharmacoGx", "Biobase", "SummarizedExperiment", \
    "illuminaHumanv4.db"); \
    pak::pkg_install(pkgs);'
