ARG Z3_VERSION
ARG K_COMMIT
ARG LLVM_VERSION

ARG K_COMMIT
FROM runtimeverificationinc/kframework-k:ubuntu-noble-${K_COMMIT}

RUN    apt-get update              \
    && apt-get upgrade --yes       \
    && apt-get install --yes       \
                       curl

ARG USER_ID=1001
ARG GROUP_ID=1001
RUN groupadd -g $GROUP_ID user && useradd -m -u $USER_ID -s /bin/sh -g user user

USER user:user
WORKDIR /home/user

RUN curl -sSL https://install.python-poetry.org | python3 - --version 1.7.1

ENV PATH=/home/user/.local/bin:$PATH
