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

# set environment variables for ESMF
ENV ESMF_DIR=/opt/esmf_build/esmf_source
ENV ESMF_INSTALL_PREFIX=/opt/esmf_build/esmf_install
ENV ESMF_NETCDF="split"
ENV ESMF_NETCDF_INCLUDE=$NETCDF_PREFIX/include
ENV ESMF_NETCDF_LIBPATH=$NETCDF_PREFIX/lib
ENV ESMF_COMM=mpich3
ENV ESMF_COMPILER=gfortran

# build ESMF
RUN make info 2>&1 | tee esmf-make-info.out
RUN make 2>&1 | tee esmf-make.out
#RUN make check 2>&1 | tee esmf-make-check.out
RUN make install 2>&1 | tee esmf-make-install.out

# install miniconda
WORKDIR /root
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && bash miniconda.sh -b -p /opt/conda \
    && rm miniconda.sh \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "conda activate base" >> ~/.bashrc

# build ESMPy
WORKDIR $ESMF_DIR/src/addon/ESMPy
RUN ESMFMKFILE="$(find $ESMF_INSTALL_PREFIX -name '*esmf.mk')" \
    && echo "ESMFMKFILE=$ESMFMKFILE"

RUN source ~/.bashrc \
    && pip install numpy nose \
    && python setup.py build --ESMFMKFILE=${ESMFMKFILE} \
    && python setup.py test \
    && python setup.py install \
    && python -c "import ESMF; print(ESMF.__file__, ESMF.__version__)"
