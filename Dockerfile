FROM ubuntu:16.04
MAINTAINER Dmitry Mozzherin

ENV LAST_FULL_REBUILD 2016-10-24

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get install -y ruby2.3 ruby2.3-dev build-essential git vim \
    qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base \
    gstreamer1.0-tools gstreamer1.0-x npm nodejs nodejs-legacy\
    libmysqlclient-dev  mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN echo 'gem: --no-rdoc --no-ri >> "$HOME/.gemrc"'

RUN gem install bundler && mkdir /app && mkdir /var/run/sshd
WORKDIR /app
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

COPY . /app

CMD ["unicorn", "-c", "/app/config/docker/unicorn.rb"]
