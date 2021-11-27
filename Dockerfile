# Pip install some binary some source wheels over python base image.
FROM python:3.10 AS python
RUN apt-get -q -o=Dpkg::Use-Pty=0 update \
    && DEBIAN_FRONTEND=noninteractive DEBCONF_NOWARNINGS=yes \
       apt-get -q -o=Dpkg::Use-Pty=0 install --no-install-recommends --yes \
        libgirepository1.0-dev \
        gir1.2-poppler-0.18 \
    && rm -rf /var/lib/apt/lists \
    && adduser --disabled-password --gecos "" htmloverpdf
USER htmloverpdf
COPY --chown=htmloverpdf pyproject.toml setup.cfg /src/
COPY --chown=htmloverpdf htmloverpdf /src/htmloverpdf/
RUN SETUPTOOLS_SCM_PRETEND_VERSION=0.0.0 python3 -m pip \
        --disable-pip-version-check \
        --no-python-version-warning \
        --use-feature=in-tree-build \
        --no-cache-dir \
        install \
            --user \
            --no-warn-script-location \
            /src/
CMD ["python3", "-m", "htmloverpdf"]

FROM python as latest

# Install as pure python library with all dependencies from Alpine packages.
FROM alpine:3.15 AS alpine
RUN apk add --no-cache \
        font-croscore \
        weasyprint \
        py3-gobject3 \
        py3-cairo \
        poppler-dev
COPY htmloverpdf /usr/lib/python3.9/site-packages/htmloverpdf/
USER nobody
CMD ["python3", "-m", "htmloverpdf"]

# Install as pure python library with all dependencies from Debian packages.
FROM debian:bullseye AS debian
RUN apt-get -q -o=Dpkg::Use-Pty=0 update \
    && DEBIAN_FRONTEND=noninteractive DEBCONF_NOWARNINGS=yes \
       apt-get -q -o=Dpkg::Use-Pty=0 install --no-install-recommends --yes \
        ca-certificates \
        weasyprint \
        python3-gi-cairo \
        gir1.2-poppler-0.18 \
    && rm -rf /var/lib/apt/lists
COPY htmloverpdf /usr/local/lib/python3.9/dist-packages/htmloverpdf/
USER nobody
CMD ["python3", "-m", "htmloverpdf"]

# Build missing binary wheels, then install them on python-alpine base with no build tools.
FROM python:3.10-alpine as build-alpine
RUN apk add --no-cache \
        build-base \
        gobject-introspection-dev \
        jpeg-dev \
        zlib-dev \
        libxml2-dev \
        libxslt-dev
RUN SETUPTOOLS_SCM_PRETEND_VERSION=0.0.0 python3 -m pip \
        --disable-pip-version-check \
        --no-python-version-warning \
        --no-cache-dir \
        wheel \
            cairocffi \
            pycairo \
            pygobject \
            Pillow \
            lxml

FROM python:3.10-alpine as python-alpine
RUN apk add --no-cache \
        font-croscore \
        gobject-introspection \
        poppler-dev \
        pango \
    && adduser --disabled-password htmloverpdf
USER htmloverpdf
COPY --from=build-alpine --chown=htmloverpdf *.whl /src/
COPY --chown=htmloverpdf pyproject.toml setup.cfg /src/
COPY --chown=htmloverpdf htmloverpdf /src/htmloverpdf/
RUN SETUPTOOLS_SCM_PRETEND_VERSION=0.0.0 python3 -m pip \
        --disable-pip-version-check \
        --no-python-version-warning \
        --use-feature=in-tree-build \
        --no-cache-dir \
        install \
            --user \
            --no-warn-script-location \
            /src/*.whl \
            /src/
CMD ["python3", "-m", "htmloverpdf"]

# Build missing binary wheels, then install them on python-slim base with no build tools.
FROM python:3.10 as build-slim
RUN apt-get -q -o=Dpkg::Use-Pty=0 update \
    && DEBIAN_FRONTEND=noninteractive DEBCONF_NOWARNINGS=yes \
       apt-get -q -o=Dpkg::Use-Pty=0 install --no-install-recommends --yes \
        libgirepository1.0-dev \
    && rm -rf /var/lib/apt/lists
RUN SETUPTOOLS_SCM_PRETEND_VERSION=0.0.0 python3 -m pip \
        --disable-pip-version-check \
        --no-python-version-warning \
        --no-cache-dir \
        wheel \
            cairocffi \
            pycairo \
            pygobject

FROM python:3.10-slim AS python-slim
RUN apt-get -q -o=Dpkg::Use-Pty=0 update \
    && DEBIAN_FRONTEND=noninteractive DEBCONF_NOWARNINGS=yes \
       apt-get -q -o=Dpkg::Use-Pty=0 install --no-install-recommends --yes \
        libcairo-gobject2 \
        gir1.2-poppler-0.18 \
        gir1.2-pango-1.0 \
    && rm -rf /var/lib/apt/lists \
    && adduser --disabled-password --gecos "" htmloverpdf
USER htmloverpdf
COPY --from=build-slim --chown=htmloverpdf *.whl /src/
COPY --chown=htmloverpdf pyproject.toml setup.cfg /src/
COPY --chown=htmloverpdf htmloverpdf /src/htmloverpdf/
RUN SETUPTOOLS_SCM_PRETEND_VERSION=0.0.0 python3 -m pip \
        --disable-pip-version-check \
        --no-python-version-warning \
        --use-feature=in-tree-build \
        --no-cache-dir \
        install \
            --user \
            --no-warn-script-location \
            /src/*.whl \
            /src/
CMD ["python3", "-m", "htmloverpdf"]
