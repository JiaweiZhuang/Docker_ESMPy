FROM condaforge/linux-anvil

ENV PATH /opt/conda/bin:${PATH}

#RUN conda create -y -n dev-esmf gcc nose esmpy
RUN conda install -y gcc nose esmpy

# for xESMF development
RUN conda install -y jupyter scipy xarray dask matplotlib cartopy

#ENV PATH /opt/conda/envs/dev-esmf/bin:${PATH}
#ENV CONDA_DEFAULT_ENV dev-esmf
#ENV CONDA_PREFIX /opt/conda/envs/dev-esmf

RUN conda remove -y esmf esmpy

WORKDIR /opt
RUN git clone https://git.code.sf.net/p/esmf/esmf esmf
WORKDIR esmf
RUN echo "cache bust 1"
RUN git checkout merge-esmpy-inmemweights
#RUN git pull

#ENV PREFIX=/opt/conda/envs/dev-esmf
ENV PREFIX=/opt/conda
ENV ESMF_DIR=/opt/esmf
ENV ESMF_COMM=mpich3
ENV ESMF_NETCDF="split"
ENV ESMF_NETCDF_INCLUDE=${PREFIX}/include
ENV ESMF_NETCDF_LIBPATH=${PREFIX}/lib
ENV ESMF_INSTALL_PREFIX=${PREFIX}
ENV ESMF_INSTALL_BINDIR=${PREFIX}/bin
ENV ESMF_INSTALL_DOCDIR=${PREFIX}/doc
ENV ESMF_INSTALL_HEADERDIR=${PREFIX}/include
ENV ESMF_INSTALL_LIBDIR=${PREFIX}/lib
ENV ESMF_INSTALL_MODDIR=${PREFIX}/mod

RUN make info 2>&1 | tee esmf-make-info.out
RUN make 2>&1 | tee esmf-make.out
#RUN make check 2>&1 | tee esmf-make-check.out
RUN make install 2>&1 | tee esmf-make-install.out

RUN echo "cache bust 1"
#ENV ESMFMKFILE=/opt/esmf/lib/libO/Linux.gfortran.64.mpich3.default/esmf.mk
WORKDIR ${ESMF_DIR}/src/addon/ESMPy
RUN ESMFMKFILE="$(find /opt/esmf/lib -name '*esmf.mk')" && echo "ESMFMKFILE=${ESMFMKFILE}" && \
    python setup.py build --ESMFMKFILE=${ESMFMKFILE}
RUN python setup.py test
RUN python setup.py install
RUN python -c "import ESMF; print(ESMF.__file__)"