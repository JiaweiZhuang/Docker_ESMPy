FROM ubuntu:18.04
LABEL maintainer="Jiawei Zhuang <jiaweizhuang@g.harvard.edu>"

ARG ESMF_TAG="ESMF_8_0_0_beta_snapshot_40"
ARG NETCDF_PREFIX=/usr

# get library dependencies
RUN apt-get update \
    && apt-get install -y \
    git vim wget bc gcc gfortran g++ mpich \
    libnetcdf-dev libnetcdff-dev netcdf-bin \
    && rm -rf /var/lib/apt/lists/*

# get ESMF source code
WORKDIR /opt/esmf_build
RUN git archive --remote=git://git.code.sf.net/p/esmf/esmf --format=tar --prefix=esmf_source/ $ESMF_TAG | tar xf -
WORKDIR /opt/esmf_build/esmf_source

# environment variables
ENV ESMF_DIR=/opt/esmf_build/esmf_source
ENV ESMF_INSTALL_PREFIX=/opt/esmf_build/esmf_install
ENV ESMF_NETCDF="split"
ENV ESMF_NETCDF_INCLUDE=$NETCDF_PREFIX/include
ENV ESMF_NETCDF_LIBPATH=$NETCDF_PREFIX/lib
ENV ESMF_COMM=mpich3
ENV ESMF_COMPILER=gfortran

RUN make info 2>&1 | tee esmf-make-info.out
RUN make 2>&1 | tee esmf-make.out
#RUN make check 2>&1 | tee esmf-make-check.out
RUN make install 2>&1 | tee esmf-make-install.out
