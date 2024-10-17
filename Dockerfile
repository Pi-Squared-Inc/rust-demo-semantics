ARG Z3_VERSION
ARG K_COMMIT
ARG LLVM_VERSION

ARG Z3_VERSION=4.12.1
FROM runtimeverificationinc/z3:ubuntu-jammy-${Z3_VERSION} as Z3

ARG K_COMMIT
FROM runtimeverificationinc/kframework-k:ubuntu-jammy-${K_COMMIT}

COPY --from=Z3 /usr/bin/z3 /usr/bin/z3

RUN    apt-get update              \
    && apt-get upgrade --yes       \
    && apt-get install --yes       \
                      curl \
                      lsb-release \
                      software-properties-common \
                      wget

ARG LLVM_VERSION
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh ${LLVM_VERSION}
                      
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g $GROUP_ID user && useradd -m -u $USER_ID -s /bin/sh -g user user

USER user:user
WORKDIR /home/user

RUN curl -sSL https://install.python-poetry.org | python3 - --version 1.7.1

# RUN pip3 install --user  \
#            cytoolz       \
#            numpy

ENV PATH=/home/user/.local/bin:$PATH
