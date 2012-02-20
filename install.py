#!/usr/bin/python

# This script is used to install the packages used by Pylons in the directory
# specified.

import sys, os, subprocess, time

# Install the python package specified in the location specified.
def install_pkg(prefix, site_dir, pkg_name):
    os.chdir('pkg')
    subprocess.check_call(['tar', '-zxvf', pkg_name + ".tar.gz"])
    os.chdir(pkg_name)
    env = dict(os.environ)
    env['PYTHONPATH'] = site_dir
    sub = subprocess.Popen(['python', 'setup.py', 'install', '--prefix=' + prefix,
                            '--record=ignored', '--single-version-externally-managed', '--no-compile'],
                           stdout=sys.stdout, stderr=sys.stderr, env=env)
    if sub.wait() != 0: raise Exception("setup.py for package %s failed" % (pkg_name))
    os.chdir('..')
    subprocess.check_call(['rm', '-rf', pkg_name])
    os.chdir('..')

# Install the Pylons environment.
def install(prefix):
    
    # Setup the paths and environment.
    vi = sys.version_info
    site_dir = prefix + "/lib/python%i.%i/site-packages/" % (vi[0], vi[1])
    subprocess.check_call(['mkdir', '-p', site_dir])
    
    # List of packages to install, in order.
    pkg_list = [ "setuptools-0.6c9", "Pygments-1.0", "Beaker-1.3", "Paste-1.7.2", "PasteDeploy-1.3.3",
                 "SQLAlchemy-0.5.5", "decorator-3.0.0", "simplejson-2.0.8", "Mako-0.2.4",
                 "Tempita-0.2", "Elixir-0.6.1", "PasteScript-1.7.3", "WebError-0.10.1",
                 "FormEncode-1.2.1", "WebHelpers-0.6.4", "gp.fileupload-0.8",
                 "Routes-1.10.3", "WebOb-0.9.6.1", "Pylons-0.9.7", "Shabti-0.3.2b",
                 "WebTest-1.1", "nose-0.10.4" ]
    
    # Install the packages.
    for f in pkg_list: install_pkg(prefix, site_dir, f)

def main(): 
    if len(sys.argv) != 2: raise Exception("usage: install.py <prefix>")
    prefix = sys.argv[1]
    
    # Adjust the prefix.
    if prefix.endswith('/') and prefix != '/': prefix = prefix[:-1]
    prefix = os.path.abspath(prefix)
    
    # Install Pylons.
    install(prefix)

main()

