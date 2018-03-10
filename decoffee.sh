#!/bin/bash
echo 'DeCoffee'
DECOFFEE_PATH=$1
APP_PATH=`pwd`

echo $APP_PATH
echo $DECOFFEE_PATH

cd $DECOFFEE_PATH

echo 'Processing the folder:'
echo '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
$APP_PATH/node_modules/decaffeinate/bin/decaffeinate $DECOFFEE_PATH
echo '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

for file in *.js.coffee
do
  echo "Remove file:" $file
  rm $file
done

for file in *.js.js
do
  echo "Rename file:" $file
  mv "$file"  "${file%.js.js}.js"
done

cd $APP_PATH
