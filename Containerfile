FROM debian:stable-slim

LABEL org.opencontainers.image.description \
      "Database Test 7: Fair Use TPC Benchmark(TM) DS; THE TPC SOFTWARE IS AVAILABLE WITHOUT CHARGE FROM TPC."
LABEL org.opencontainers.image.source \
      "https://github.com/osdldbt/dbt7"
LABEL org.opencontainers.image.documentation \
      "https://osdldbt.github.io/dbt7/"
LABEL org.opencontainers.image.licenses="Artistic-2.0"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8

RUN apt-get -qq -y update && \
    apt-get -qq -y install bison \
                           build-essential \
                           ca-certificates \
                           cmake \
                           curl \
                           flex \
                           git \
                           gnuplot \
                           locales \
                           pandoc \
                           patch \
                           python3-docutils \
                           sqlite3 \
                           texlive-latex-base \
                           texlive-latex-recommended && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 \
              -A /usr/share/locale/locale.alias \
              en_US.UTF-8

# Set up PostgreSQL PGDG repository via postgresql-common
# and install the client.
RUN apt-get -qq -y update && \
    apt-get -qq -y install postgresql-common && \
    /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh \
            -y && \
    apt-get -qq -y install postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Install DBT Tools.
ARG DBTTOOLSVER=0.5.1
RUN curl -o /tmp/v${DBTTOOLSVER}.tar.gz -SsL \
         https://github.com/osdldbt/dbttools/archive/\
refs/tags/v${DBTTOOLSVER}.tar.gz && \
    tar -C /usr/local/src \
        -xf /tmp/v${DBTTOOLSVER}.tar.gz && \
    cd /usr/local/src/dbttools-${DBTTOOLSVER} && \
    cmake -H. -Bbuilds/release \
          -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cd builds/release && make -s install && \
    rm -f /tmp/v${DBTTOOLSVER}.tar.gz

# Install Touchstone Tools.
RUN curl --proto '=https' --tlsv1.2 -sSf \
         https://sh.rustup.rs -o /tmp/sh.rustup.sh && \
    sh /tmp/sh.rustup.sh -y

ARG TSTOOLSVER=0.10.0
RUN curl -o /tmp/touchstone-tools-v${TSTOOLSVER}.tar.gz \
         -SsL https://gitlab.com/touchstone/\
touchstone-tools/-/archive/v${TSTOOLSVER}/\
touchstone-tools-v${TSTOOLSVER}.tar.gz && \
    mkdir -p \
          /usr/local/src/touchstone-tools-v${TSTOOLSVER} && \
    tar -C /usr/local/src/touchstone-tools-v${TSTOOLSVER} \
        --strip-components=1 \
        -xf /tmp/touchstone-tools-v${TSTOOLSVER}.tar.gz && \
    cd /usr/local/src/touchstone-tools-v${TSTOOLSVER} && \
    cmake -H. -Bbuilds/release \
          -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cd builds/release && make -s install && \
    cd /usr/local/src/touchstone-tools-v${TSTOOLSVER}/spar \
    && ${HOME}/.cargo/bin/cargo install \
       --root /usr/local --path . && \
    rm -f /tmp/touchstone-tools-v${TSTOOLSVER}.tar.gz

# Copy dbt7 source and build.
COPY . /usr/local/src/dbt7
WORKDIR /usr/local/src/dbt7

RUN cmake -H. -Bbuilds/release \
          -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cd builds/release && make -s install

# Build the TPC-DS Tools.
RUN dbt7-build-dsgen --patch-dir=patches \
        builds/release/_deps/dsgen-src

ENV DSHOME=/usr/local/src/dbt7/builds/release/_deps/dsgen-src
ENV DS_DATA=/scratch/dbt7data
ENV DBT7DBNAME=dbt7

# Create a non-root user to run tests.
RUN useradd -m -s /bin/bash dbt && \
    mkdir -p /scratch /results && \
    chown -R dbt:dbt /scratch /results

USER dbt

ENTRYPOINT ["dbt7"]
