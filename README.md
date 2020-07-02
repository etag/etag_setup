ETAG Setup Scripts
===

!!! This is not intended for production or running on a public server! All credentials contained in these files should be changed before running. !!!

These scripts will install dependencies (install_deps.sh - run this one first) and configure the underlying [cyberCommons' framework](https://cybercom-docs.readthedocs.io/en/latest/) (install.sh) for the ETAG gateway.
These have been tested on Ubuntu 18.04 Linux. The installation creates the following directories:
* /data/postgres
* /opt/etag


## Known Issues
1. Django migrations for postgress database are not performed - this will prevent the API container from loading.
2. This will not run on Windows operating systems.


## Contributing
We are accepting contributions to improve these scripts. If you are interested in contrbuting, please submit your Pull Request for consideration.


## Installation
1. Review files and change hard coded credentials.
2. Install docker, docker-compose, python, cookiecutter, and add current user to docker group
   ```bash
   ./install_deps.sh
   # log out and back in for group memberships to take effect
   ```
3. Install cybercommons and modify for ETAG
   ```bash
   ./install.sh
   ```


## TODO
1. Add Django database migrations to install script
2. Fetch [frontend](https://github.com/etag/portal_nuxt), build, and copy generated files under "dist/" to /opt/etag/data/static/
