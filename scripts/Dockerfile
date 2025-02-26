FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "1" > /tmp/test.txt
# Installing wxWidgets
RUN apt-get update
RUN apt-get install -y libssl-dev libjpeg-dev libpng-dev libtiff-dev zlib1g-dev libncurses5-dev libssh-dev unixodbc-dev libgmp3-dev libsctp-dev libgtk-3-dev libnotify-dev libsecret-1-dev catch mesa-common-dev libglu1-mesa-dev freeglut3-dev
RUN apt-get install -y git xxd curl g++ make libwebkit2gtk-4.0-dev unzip procps inotify-tools
# aib
RUN apt-get install -y xsltproc fop libxml2-utils
# openjdk-11-jdk

# ENV WXWIDGETS_REPO=https://github.com/vadz/wxWidgets.git
# ENV WXWIDGETS_REPO=https://github.com/TcT2k/wxWidgets.git
# ENV WXWIDGETS_REPO=https://github.com/dominicletz/wxWidgets.git
ARG WXWIDGETS_REPO
ENV WXWIDGETS_REPO=${WXWIDGETS_REPO:-https://github.com/wxWidgets/wxWidgets.git}
RUN mkdir ~/projects && cd ~/projects && \
    git clone ${WXWIDGETS_REPO} --branch ${WXWIDGETS_VERSION}

ARG CMAKE_VERSION
ENV CMAKE_VERSION=${CMAKE_VERSION:-3.27.4}
RUN curl -sSL https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh > cmake.sh && \
    sh cmake.sh --skip-license --prefix=/usr/local

# ENV WXWIDGETS_VERSION=v3.1.4
# ENV WXWIDGETS_VERSION=chromium
# ENV WXWIDGETS_VERSION=wide-init-fix
ARG WXWIDGETS_VERSION
ENV WXWIDGETS_VERSION=${WXWIDGETS_VERSION:-master}
RUN cd ~/projects/wxWidgets && \
    git fetch origin && \
    git reset --hard origin/${WXWIDGETS_VERSION} && \
    git submodule update --init

# ENV WXWIDGETS_DEBUG=--enable-debug
ARG WXWIDGETS_DEBUG
ENV WXWIDGETS_DEBUG=${WXWIDGETS_DEBUG:-}
RUN cd ~/projects/wxWidgets && \
    ./configure --prefix=/usr/local/wxWidgets ${WXWIDGETS_DEBUG} --enable-webview --enable-compat30 --disable-shared && \
    make -j16

# Installing Erlang

ARG OTP_VERSION
ENV OTP_VERSION=${OTP_VERSION:-master}
# Used by ASDF
# ENV OTP_GITHUB_URL=https://github.com/erlang/otp.git
ARG OTP_GITHUB_URL
ENV OTP_GITHUB_URL=${OTP_GITHUB_URL:-https://github.com/erlang/otp.git}

ENV KERL_CONFIGURE_OPTIONS="--with-wxdir=/root/projects/wxWidgets --without-odbc --without-javac --disable-debug"
ARG ELIXIR_VERSION
ENV ELIXIR_VERSION=${ELIXIR_VERSION:-1.13.4}
ARG ELIXIR_VARIANT
ENV ELIXIR_VARIANT=${ELIXIR_VARIANT:-"-otp-26"}

#ENV ASDF_DIR=/root/.asdf
#ENV ASDF_DATA_DIR="$HOME/.asdf"
#RUN git clone https://github.com/asdf-vm/asdf.git ${ASDF_DIR} && \
RUN curl  -O -L https://github.com/asdf-vm/asdf/releases/download/v0.16.4/asdf-v0.16.4-linux-amd64.tar.gz && \
    tar -xzf asdf-v0.16.4-linux-amd64.tar.gz && \
    mv asdf /usr/local/bin/asdf && \
    chmod +x /usr/local/bin/asdf && \
    rm asdf-v0.16.4-linux-amd64.tar.gz && \
    echo export PATH=\"\/usr/local/bin:$ASDF_DATA_DIR/shims:$PATH\" >> $HOME/.bashrc

# # RUN . $HOME/.bashrc

RUN asdf plugin list && \
    asdf plugin add elixir && \
    echo "elixir ${ELIXIR_VERSION}${ELIXIR_VARIANT}" >> .tool-versions && \
    asdf plugin add erlang && \
    echo "erlang ref:${OTP_VERSION}" >> .tool-versions && \
    asdf plugin add nodejs && \
    echo "nodejs v18.7.0" >> .tool-versions && \
    asdf plugin list

# RUN KERL_CONFIGURE_OPTIONS="$KERL_CONFIGURE_OPTIONS" asdf install erlang ref:${OTP_VERSION} && \
#     asdf global erlang ref:${OTP_VERSION}
# RUN asdf install elixir ${ELIXIR_VERSION}${ELIXIR_VARIANT} && \
#     asdf global elixir ${ELIXIR_VERSION}${ELIXIR_VARIANT}
# RUN asdf install nodejs v18.7.0 && \
#     asdf global nodejs v18.7.0


# Ensure that this file is sourced
SHELL ["/bin/bash", "-c"]

# Ensure the profile is sourced
RUN echo "source /etc/profile" >> /root/.bashrc

# Install Erlang with logging and error handling
RUN asdf plugin add erlang
RUN asdf install erlang ref:${OTP_VERSION} > asdf_erlang_install.log 2>&1 || (cat asdf_erlang_install.log && cat /root/.asdf/plugins/erlang/kerl-home/builds/asdf_${OTP_VERSION}/otp_build_git.log && exit 1)
# RUN source /etc/profile && \
#     if KERL_CONFIGURE_OPTIONS="$KERL_CONFIGURE_OPTIONS" asdf install erlang ref:${OTP_VERSION} > /tmp/asdf_erlang_install.log 2>&1; then \
#         source /etc/profile && asdf global erlang ref:${OTP_VERSION}; \
#         echo "Erlang installation succeeded"; \
#     else \
#         echo "Erlang installation failed"; \
#         exit_code=$?;  # Capture exit code \
#         cat /tmp/asdf_erlang_install.log; \
#         exit $exit_code; # Propagate error to Docker build. \
#     fi

RUN asdf plugin add elixir
RUN asdf install elixir ${ELIXIR_VERSION}${ELIXIR_VARIANT} > asdf_elixir_install.log 2>&1 || (cat asdf_elixir_install.log && exit 1)
# RUN if asdf install elixir ${{ inputs.elixir-version }}${{ inputs.elixir-variant }} > asdf_elixir_install.log 2>&1; then \
#         asdf global elixir ${{ inputs.elixir-version }}${{ inputs.elixir-variant }} \
#         echo "Elixir installation succeeded" \
#     else \
#         echo "Elixir installation failed" \
#         cat asdf_elixir_install.log \
#         exit 1 \
#     fi

# Install Node.js with logging and error handling
RUN asdf plugin add nodejs
RUN source /etc/profile && \
    if asdf install nodejs v18.7.0 > /tmp/asdf_nodejs_install.log 2>&1; then \
        source /etc/profile && asdf global nodejs v18.7.0; \
        echo "Node.js installation succeeded"; \
    else \
        echo "Node.js installation failed"; \
        exit_code=$?;  # Capture exit code \
    cat /tmp/asdf_nodejs_install.log; \
        exit $exit_code; # Propagate error to Docker build. \
    fi


# # Compile and lint
# COPY mix.exs mix.lock .formatter.exs /app/
# RUN cd /app && \
#     asdf install && \
#     cp /.tool-versions .tool-versions && \
#     mix local.hex --force && \
#     mix local.rebar --force && \
#     mix deps.get && \
#     mix deps.compile

# # NPM
# COPY assets/package.json assets/package-lock.json /app/assets/
# RUN cd /app/assets && \
#     asdf install && \
#     npm install

# # Build Release
# ENV LD_LIBRARY_PATH=/root/projects/wxWidgets/lib/
# COPY . /app/
# RUN cd /app && \
#     cp /.tool-versions .tool-versions && \
#     MIX_ENV=prod mix compile

# # Build Installer
# RUN cd /app && \
#     mix deps.update desktop && \
#     mix deps.update desktop_deployment  && \
#     mix assets.deploy && \
#     mix desktop.installer
