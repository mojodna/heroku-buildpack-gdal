# heroku-buildpack-gdal

I am a Heroku buildpack that installs [GDAL](http://www.gdal.org/) and its
dependencies ([proj](https://trac.osgeo.org/proj/)).

When used by myself, I will install GDAL and proj libraries, headers, and
binaries. *Note:* it does *not* currently include the Python bindings.

When used with
[heroku-buildpack-multi](https://github.com/ddollar/heroku-buildpack-multi),
I enable subsequent buildpacks / steps to link to these libraries.  (You'll
need to use the `build-env` branch of [@mojodna's
fork](https://github.com/mojodna/heroku-buildpack-multi/tree/build-env) for the
build environment (`CPATH`, `LIBRARY_PATH`, etc.) to be set correctly.)

## Using

### Standalone

When creating a new Heroku app:

```bash
heroku apps:create -b https://github.com/mojodna/heroku-buildpack-gdal.git

git push heroku master
```

When modifying an existing Heroku app:

```bash
heroku config:set BUILDPACK_URL=https://github.com/mojodna/heroku-buildpack-gdal.git

git push heroku master
```

### Composed

When creating a new Heroku app:

```bash
heroku apps:create -b https://github.com/mojodna/heroku-buildpack-multi.git#build-env

cat << EOF > .buildpacks
https://github.com/mojodna/heroku-buildpack-gdal.git
https://github.com/heroku/heroku-buildpack-nodejs.git
EOF

git push heroku master
```

When modifying an existing Heroku app:

```bash
heroku config:set BUILDPACK_URL=https://github.com/mojodna/heroku-buildpack-multi.git#build-env

cat << EOF > .buildpacks
https://github.com/mojodna/heroku-buildpack-gdal.git
https://github.com/heroku/heroku-buildpack-nodejs.git
EOF

git push heroku master
```

## Building

GDAL and proj were built in an Ubuntu 10.04 chroot / VM with the following
options.  (See [heroku/stack-images](https://github.com/heroku/stack-images)
for package listings and post-installation.)

proj:

```bash
mkdir -p /app/vendor
curl -LO http://download.osgeo.org/proj/proj-datumgrid-1.5.tar.gz \
     -LO http://download.osgeo.org/proj/proj-4.8.0.tar.gz
tar xf proj-4.8.0.tar.gz
cd proj-4.8.0/nad/
tar xf ../../proj-datumgrid-1.5.tar.gz
cd ..
./configure --without-mutex --prefix=/app/vendor/proj
make -j4
make install
cd /app/vendor/proj
tar zcf /tmp/proj-4.8.0-1.tar.gz .
```

GDAL:

```bash
mkdir -p /app/vendor
curl -LO http://download.osgeo.org/gdal/gdal-1.9.1.tar.gz
tar xf gdal-1.10.0.tar.gz
cd gdal-1.10.0
./configure --prefix=/app/vendor/gdal \
            --with-static-proj4=/app/vendor/proj \
            --with-pcraster=no \
            --with-jasper=no \
            --with-grib=no \
            --with-vfk=no \
            --with-hide-internal-symbols
make -j4
make install
cd /app/vendor/gdal
tar zcf /tmp/gdal-1.10.0-1.tar.gz .
```

GDAL's post-configuration output:

```
GDAL is now configured for x86_64-unknown-linux-gnu
 
  Installation directory:    /app/vendor/gdal
  C compiler:                gcc -g -O2 -fvisibility=hidden
  C++ compiler:              g++ -g -O2 -fvisibility=hidden
 
  LIBTOOL support:           yes
 
  LIBZ support:              external
  LIBLZMA support:           no
  GRASS support:             no
  CFITSIO support:           no
  PCRaster support:          no
  LIBPNG support:            external
  GTA support:               no
  LIBTIFF support:           internal (BigTIFF=yes)
  LIBGEOTIFF support:        internal
  LIBJPEG support:           external
  8/12 bit JPEG TIFF:        no
  LIBGIF support:            internal
  OGDI support:              no
  HDF4 support:              no
  HDF5 support:              no
  NetCDF support:            no
  Kakadu support:            no
  JasPer support:            no
  OpenJPEG support:          no
  ECW support:               no
  MrSID support:             no
  MrSID/MG4 Lidar support:   no
  MSG support:               no
  GRIB support:              no
  EPSILON support:           no
  WebP support:              no
  cURL support (wms/wcs/...):yes
  PostgreSQL support:        yes
  MySQL support:             no
  Ingres support:            no
  Xerces-C support:          no
  NAS support:               no
  Expat support:             yes
  Google libkml support:     no
  ODBC support:              no
  PGeo support:              no
  FGDB support:
  MDB support:               no
  PCIDSK support:            internal
  OCI support:               no
  GEORASTER support:         no
  SDE support:               no
  Rasdaman support:          no
  DODS support:              no
  SQLite support:            no
  SpatiaLite support:        no
  DWGdirect support          no
  INFORMIX DataBlade support:no
  GEOS support:              no
  VFK support:               no
  Poppler support:           no
  Podofo support:            no
  OpenCL support:            no
  Armadillo support:         no
  FreeXL support:            no
 
 
  SWIG Bindings:          no
 
  Statically link PROJ.4:    yes
  enable OGR building:       yes
  enable pthread support:    yes
  enable POSIX iconv support:yes
  hide internal symbols:     yes
```
