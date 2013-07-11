check-heroku-log
=============================


if you're using the heroku-deploy step (this step is injected if a Heroku deploy target is used)
you don't have to specify your api key and app name twice
just use the $HEROKU_KEY and $HEROKU_APP_NAME vars

Example from https://github.com/wwwouter/failing-getting-started-nodejs

```
box: wercker/nodejs
build:
  steps:
    - script:
        code: echo Building
deploy:
  steps:
    - heroku-deploy
  passed-steps:
    - script:
        name: waiting before checking heroku log
        code: sleep 60
    - wouter/check-heroku-log:
        api-key: $HEROKU_KEY
        app-name: $HEROKU_APP_NAME
```