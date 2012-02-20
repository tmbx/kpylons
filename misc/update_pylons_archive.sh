#!/bin/sh

# Script used to obtain the Pylons dependencies with easy_install.

set -e -u

# Need python-virtualenv (apt-get install python-virtualenv)...

# Temporary directories.
TMP_PYTHON_ENV=/tmp/update_python_env
TMP_PYTHON_OUT=/tmp/update_python_packages.out

# Directory where python module archives will be put.
PYLONS_ARCHIVES=pylons_archives

# Pylons-specific packages.
PYLONS_SPECIFIC="Beaker==1.3 decorator==3.0.0 Elixir==0.6.1 FormEncode==1.2.1 gp.fileupload==0.8 Mako==0.2.4 nose==0.10.4 Paste==1.7.2 PasteDeploy==1.3.3 PasteScript==1.7.3 Pylons==0.9.7 Routes==1.10.3 Shabti==0.3.2b simplejson==2.0.8 SQLAlchemy==0.5.2 Tempita==0.2 WebError==0.10.1 WebHelpers==0.6.4 WebOb==0.9.6.1 WebTest==1.1"

# Misc. dependencies.
MISC_DEPS="egenix_mx_base==3.1.2 logging==0.4.9.6 psycopg2==2.0.11 Pygments==1.0 PyGreSQL==3.8.1 pyOpenSSL==0.9 pyPgSQL==2.5.1"

# All python packages.
PYTHON_PACKAGES=$MISC_DEPS" "$PYLONS_SPECIFIC

# Create virtual environment.
create_virtual_env()
{
    # Delete and recreate a fresh virtual environment.
    rm -rf $TMP_PYTHON_ENV
    mkdir -p $TMP_PYTHON_ENV

    # Create environment.
    virtualenv --no-site-packages $TMP_PYTHON_ENV
}

# Update local python archive.
update_archives()
{
    # Create a brand new virtual env.
    create_virtual_env

    # Delete output file from previous run.
    rm -rf $TMP_PYTHON_OUT

    # Create empty output file.
    touch $TMP_PYTHON_OUT

    # Install packages.
    for PACKAGE in $PYLONS_SPECIFIC; do
        echo "Installing package '$PACKAGE'..."
        
        # Install package using easy_install.
        $TMP_PYTHON_ENV/bin/easy_install "$PACKAGE" >>$TMP_PYTHON_OUT 2>&1 
    done

    # Get list of downloaded archives.
    URLS=`grep "^Downloading " $TMP_PYTHON_OUT | cut -d' ' -f2 | sort | uniq`
    echo "$URLS"
    rm -rf $TMP_PYTHON_OUT

    # Download archives
    rm -rf $PYLONS_ARCHIVES
    mkdir -p $PYLONS_ARCHIVES
    cd $PYLONS_ARCHIVES
    for url in $URLS; do
        wget "$url"
    done
}

update_archives

