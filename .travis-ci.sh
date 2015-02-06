# OPAM packages needed to build tests.
OPAM_PACKAGES="mirage cow ssl cowabloga ipaddr lwt cstruct crunch travis-senv"

case "$OCAML_VERSION,$OPAM_VERSION" in
3.12.1,1.1.0) ppa=avsm/ocaml312+opam11 ;;
3.12.1,1.2.0) ppa=avsm/ocaml312+opam12 ;;
4.00.1,1.1.0) ppa=avsm/ocaml40+opam11 ;;
4.00.1,1.2.0) ppa=avsm/ocaml40+opam12 ;;
4.01.0,1.1.0) ppa=avsm/ocaml41+opam11 ;;
4.01.0,1.2.0) ppa=avsm/ocaml41+opam12 ;;
4.02.0,1.1.0) ppa=avsm/ocaml42+opam11 ;;
4.02.0,1.2.0) ppa=avsm/ocaml42+opam12 ;;
*) echo Unknown $OCAML_VERSION,$OPAM_VERSION; exit 1 ;;
esac

echo "yes" | sudo add-apt-repository ppa:$ppa
sudo apt-get update -qq
sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam aspcud
export OPAMYES=1
export OPAMJOBS=2
echo OCaml version
ocaml -version
echo OPAM versions
opam --version
opam --git-version

opam init 
# opam remote add mirage-dev git://github.com/mirage/mirage-dev
opam install ${OPAM_PACKAGES}
eval `opam config env`
mirage --version

cp .travis-decks.ml src/config.ml
cd src
mirage configure --$MIRAGE_BACKEND
make depend
make build
cd ..

if [ "$DEPLOY" = "1" -a "$TRAVIS_PULL_REQUEST" = "false" ]; then
  # get the secure key out for deployment
  mkdir -p ~/.ssh
  SSH_DEPLOY_KEY=~/.ssh/id_dsa
  travis-senv decrypt > $SSH_DEPLOY_KEY
  chmod 600 $SSH_DEPLOY_KEY
  echo "Host mirdeploy github.com" >> ~/.ssh/config
  echo "   Hostname github.com" >> ~/.ssh/config
  echo "   StrictHostKeyChecking no" >> ~/.ssh/config
  echo "   CheckHostIP no" >> ~/.ssh/config
  echo "   UserKnownHostsFile=/dev/null" >> ~/.ssh/config
  git config --global user.email "travis@openmirage.org"
  git config --global user.name "Travis the Build Bot"
  git clone git@mirdeploy:mirage/mirage-decks-deployment
  case "$MIRAGE_BACKEND" in
  xen)
    cd mirage-decks-deployment
    rm -rf xen/$TRAVIS_COMMIT
    mkdir -p xen/$TRAVIS_COMMIT
    cp ../src/mir-www.xen ../src/config.ml xen/$TRAVIS_COMMIT
    bzip2 -9 xen/$TRAVIS_COMMIT/mir-www.xen
    echo $TRAVIS_COMMIT > xen/latest
    git add xen/$TRAVIS_COMMIT xen/latest
    ;;
  *)
    echo unsupported deploy mode: $MIRAGE_BACKEND
    exit 1
    ;;
  esac
  git commit -m "adding $TRAVIS_COMMIT for $MIRAGE_BACKEND"
  git push
fi
