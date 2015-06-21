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

## Copyright

Coypright 2015 [Lukas Elmer](https://github.com/lukaselmer).

