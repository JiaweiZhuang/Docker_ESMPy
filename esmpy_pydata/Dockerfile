FROM zhuangjw/esmpy_core

# pydata stack
RUN . /opt/conda/etc/profile.d/conda.sh && conda activate base \
    && pip install --no-cache-dir \
    jupyterlab scipy xarray netcdf4 "dask[complete]" matplotlib pytest pytest-cov

RUN . /opt/conda/etc/profile.d/conda.sh && conda activate base \
    && conda install -c conda-forge cartopy \
    && conda clean -afy
