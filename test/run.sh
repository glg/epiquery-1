#! /usr/bin/env bash
TEST_URL=http://localhost:`npm config get epiquery:http_port`
echo Using ${TEST_URL} for testing
function run_test() {
  PATH_NAME=`echo $1 | sed -e s[?.*[[g`
  curl -s "${TEST_URL}/test/$1" > tmp/$PATH_NAME.result 
  diff data/$PATH_NAME.expected tmp/$PATH_NAME.result
  DIFF_RESULT=$?
  printf "Test %s " ${PATH_NAME}
  if [ $DIFF_RESULT -eq 0 ]; then
    echo "success"
  else
    echo "failed"
  fi
}
run_test error
run_test sysobjects
run_test 'hello.mustache?name=Ian'
run_test servername
run_test echo.error
run_test no.such.file

# development query tests
curl -s http://localhost:8080 --data-urlencode '__template=select top 1 1 [column] from sysobjects' > tmp/dynamic1.result
diff data/dynamic1.expected tmp/dynamic1.result
DIFF_RESULT=$?
printf "dynamic1 "
if [ $DIFF_RESULT -eq 0 ]; then
  echo "success"
else
  echo "failed"
fi
