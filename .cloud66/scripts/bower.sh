cd $STACK_PATH
if ! type "bower" > /dev/null; then
  npm install -g bower --silent
fi
bower install
