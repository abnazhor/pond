# pond

An ActivityPub-powered federated platform for aggregating links, discovering ideas, and gathering inspiration.

<img width="3204" height="2416" alt="image" src="https://github.com/user-attachments/assets/c0accedc-24e0-4b2d-907e-e27c29194b53" />

## Getting started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites

- ruby 3.4.5
- sqlite
- (optional) docker - for running `browserless/chromium`

### Installing

A step by step series of examples that help you get a development env running.

#### Setup / first run

If this is the first time that you are installing the app, start with installing dependencies:

    $ bundle install

Setup database

    $ bundle exec rails db:setup

#### Development

If the app has been set up already and you want to continue working on it:

    $ bundle exec rails db:migrate
    $ bin/dev

#### Browserless

It you want to run browserless/chromium locally for screenshots grabbing, run:

    $ docker compose up
