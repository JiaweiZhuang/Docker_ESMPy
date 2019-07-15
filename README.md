# Use ESMPy base image

Build locally:

    docker build -t esmpy_core ./esmpy_core

Or pull from DockerHub:

    docker pull zhuangjw/esmpy_core
    docker tag zhuangjw/esmpy_core esmpy_core

Run:

    docker run --rm -it esmpy_core bash

# Use ESMPy + PyData image in notebooks

Build locally:

    docker build -t esmpy_pydata ./esmpy_pydata

Or pull from DockerHub:

    docker pull zhuangjw/esmpy_pydata
    docker tag zhuangjw/esmpy_pydata esmpy_pydata

Run:

    WORKDIR_NATIVE=$(pwd)
    WORKDIR_DOCKER=/opt/workdir
    
    docker run --rm -it -p 8888:8888 -v ${WORKDIR_NATIVE}:${WORKDIR_DOCKER} -w ${WORKDIR_DOCKER} esmpy_pydata /bin/bash

    # do something in bash such as pip-install new package
    # then optionally start Jupyter
    jupyter lab --ip='0.0.0.0' --port=8888 --NotebookApp.token='' --no-browser --allow-root

    # or, directly start Jupyter
    docker run --rm -it -p 8888:8888 -v ${WORKDIR_NATIVE}:${WORKDIR_DOCKER} esmpy_pydata /bin/bash -c ". /opt/conda/etc/profile.d/conda.sh && conda activate base && jupyter lab --notebook-dir=${WORKDIR_DOCKER} --ip='0.0.0.0' --port=8888 --NotebookApp.token='' --no-browser --allow-root"
