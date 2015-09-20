# Simple Job Runner

[![Build Status](https://travis-ci.org/lukaselmer/simple-job-runner.svg?branch=master)](https://travis-ci.org/lukaselmer/simple-job-runner) [![Code Climate](https://codeclimate.com/github/lukaselmer/simple-job-runner/badges/gpa.svg)](https://codeclimate.com/github/lukaselmer/simple-job-runner) [![Test Coverage](https://codeclimate.com/github/lukaselmer/simple-job-runner/badges/coverage.svg)](https://codeclimate.com/github/lukaselmer/simple-job-runner/coverage)

Job Scheduling and Result Storage

## Deployment

* Create a Heroku account on https://heroku.com
* Install the Heroku toolbelt https://toolbelt.heroku.com/
* Login to heroku toolbelt: ```heroku login```

```sh
git clone git@github.com:lukaselmer/simple-job-runner.git
cd simple-job-runner
git fetch --all
git checkout master
heroku create
# heroku create prints the app APP_HOST
git push heroku master
# example for secret key base: d27b49b2db8304f2987dfef849b88e715f80665d597eb0ae2649538a46e6c77d6166b1da33f4737678eaa667ff58ed9b8512865cfd44f6bc5438af1932e029d0
heroku config set API_KEY=SECRET_RANDOM_API_KEY APP_HOST=myapp.herokuapp.com APP_PORT=443 SECRET_KEY_BASE=GENERATED_RANDOM_KEY
heroku run rake db:migrate
```

You should now be able to open the app at APP_HOST.

More info: https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction

## Domains

### Master

https://simple-job-runner-master.herokuapp.com

### Develop

https://simple-job-runner-develop.herokuapp.com

### Testing

https://simple-job-runner-testing.herokuapp.com

## Installation

```sh
git clone git@github.com:lukaselmer/simple-job-runner.git
cd simple-job-runner
ln -s ../../bin/check .git/hooks/pre-commit
bundle install
bin/check
```

## Configuration

```sh
cp config/database.example.yml config/database.yml
cp config/application.example.yml config/application.yml
```

## Database

Setup the database for development:

```sh
rake db:drop db:setup
```

## Tests

### Initialization

```sh
rake db:create:all
```

### Run Tests

```sh
rspec
```

## Run

```sh
rails s webrick
```

## Remarks

If something goes wrong with all the running tasks:

```
Run.started.each{|r| r.run_group.update(running: false); r.update(started_at: nil)}
rr=Run.includes(:run_group).where(created_at: 10.days.ago...Time.now).map(&:run_group).uniq.map{|x|x.update(host_name: '')}
Run.find(16179).run_group.update(host_name: 'Lukass-MacBook-Pro-2.local')
Run.find(16179).run_group.runs.map{|x| x.ended_at? ? x.score.nil? : false}
# restart failed runs from one run group
rr=Run.includes(:run_group).where(created_at: 10.days.ago...Time.now).to_a.select{|x| x.ended_at && x.score.nil?}.first.run_group.runs.to_a.reject(&:score).map{|x| x.update(started_at: nil, ended_at: nil)}
Run.includes(:run_group).where(created_at: 5.days.ago...Time.now).to_a.select{|x| x.ended_at && x.score.nil?}.first.run_group.runs.to_a.reject(&:score).map{|x| RunsService.new.restart(x)}
Run.includes(:run_group).where(created_at: 1.days.ago...Time.now).to_a.select{|x| x.ended_at && x.score.nil?}.map{|x| RunsService.new.restart(x)}
```

## Copyright

Coypright 2015 [Lukas Elmer](https://github.com/lukaselmer).

