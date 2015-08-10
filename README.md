# Simple Job Runner

[![Build Status](https://travis-ci.org/lukaselmer/simple-job-runner.svg?branch=master)](https://travis-ci.org/lukaselmer/simple-job-runner) [![Code Climate](https://codeclimate.com/github/lukaselmer/simple-job-runner/badges/gpa.svg)](https://codeclimate.com/github/lukaselmer/simple-job-runner) [![Test Coverage](https://codeclimate.com/github/lukaselmer/simple-job-runner/badges/coverage.svg)](https://codeclimate.com/github/lukaselmer/simple-job-runner/coverage)

Job Scheduling and Result Storage

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
```

## Copyright

Coypright 2015 [Lukas Elmer](https://github.com/lukaselmer).

