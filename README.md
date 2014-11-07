# heroku-buildpack-gdal

I am a Heroku buildpack that installs [GDAL](http://www.gdal.org/) and its
dependencies ([proj](https://trac.osgeo.org/proj/)).

When used by myself, I will install GDAL and proj libraries, headers, and
binaries. *Note:* this does *not* currently include the Python bindings.

When used with
[heroku-buildpack-multi](https://github.com/ddollar/heroku-buildpack-multi),
I enable subsequent buildpacks / steps to link to these libraries.

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
heroku apps:create -b https://github.com/ddollar/heroku-buildpack-multi.git

cat << EOF > .buildpacks
https://github.com/mojodna/heroku-buildpack-gdal.git
https://github.com/heroku/heroku-buildpack-nodejs.git
EOF

git push heroku master
```

When modifying an existing Heroku app:

```bash
heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git

cat << EOF > .buildpacks
https://github.com/mojodna/heroku-buildpack-gdal.git
https://github.com/heroku/heroku-buildpack-nodejs.git
EOF

git push heroku master
```

## Building

This uses Docker to build against Heroku
[stack-image](https://github.com/heroku/stack-images)-like images.

```bash
make
```

Artifacts will be dropped in `dist/`.  See `Dockerfile`s for build options.
