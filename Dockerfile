FROM node:boron
MAINTAINER Elliot Wright <elliot@elliotwright.co>

ENV HUBOT_SLACK_TOKEN=""

# Hubot: hubot-maps
ENV HUBOT_GOOGLE_API_KEY=""

# Hubot: weather.coffee
ENV HUBOT_WEATHER_CELSIUS=true
ENV HUBOT_FORECAST_API_KEY=""

RUN set -x \
    && apt-get -q update \
    && apt-get -qy install git-core redis-server \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g yo generator-hubot coffee-script \
    && adduser --disabled-password --gecos "" yeoman \
    && echo "yeoman ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV HOME /home/yeoman

USER yeoman

WORKDIR /home/yeoman

RUN set -x \
    && git clone https://github.com/SeerUK/hubot-slack.git hubot \
    && cd hubot \
    && git fetch -a \
    && git reset origin/master --hard \
    && npm install

CMD cd hubot; bin/hubot --adapter slack
