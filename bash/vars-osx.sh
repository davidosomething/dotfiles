# boot2docker
export DOCKER_HOST=tcp://localhost:4243

# needed for fontforge
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

# CURL SSL cert file
# installed with `brew install curl-ca-bundle`
export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt

##
# NPM
export NODE_PATH=$NODE_PATH:/usr/local/share/npm/lib/node_modules
