if [ ! -n "$WERCKER_CHECK_HEROKU_LOG_API_KEY" ]; then
  error 'Please specify api-key property'
  return 1
fi

if [ ! -n "$WERCKER_CHECK_HEROKU_LOG_APP_NAME" ]; then
  error 'Please specify app-name property'
  return 1
fi

cd $WERCKER_STEP_ROOT

export CHECK_STATUS_CODE=`curl -u :$WERCKER_CHECK_HEROKU_LOG_API_KEY https://api.heroku.com/apps --write-out %{http_code} --silent --output /dev/null`

if [[ $CHECK_STATUS_CODE -ne "200" ]]; then
  error 'Cannot connect to Heroku, please verify API key.'
  return 1
fi

curl -H "Accept: application/json" \
  -u :$WERCKER_CHECK_HEROKU_LOG_API_KEY \
  -X GET https://api.heroku.com/apps/$WERCKER_CHECK_HEROKU_LOG_APP_NAME/logs\?logplex\=true > logplex-url

export LOGPLEX_URL=`cat logplex-url`

curl $LOGPLEX_URL > logplex-result

cat logplex-result

grep "State changed from starting to crashed" logplex-result > logplex-filtered

export LOGPLEX_FILTERED="`cat logplex-filtered`"

if [[  -n $LOGPLEX_FILTERED ]]; then
  warn "Crashed message found"
  return 1
fi