cd $STACK_BASE/cached-copy
if ! type "bower" > /dev/null; then
  npm install -g bower --silent
fi
bower install
