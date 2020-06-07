FROM ruby:2.6.5

RUN apt-get update && apt-get upgrade -y && apt-get install git

ENV DOCKERIZE_VERSION v0.6.1

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN git clone https://github.com/ayumitamai97/g3y.git

WORKDIR g3y/

RUN gem install bundler:1.17.2

RUN bundle

ENV NODE_VERSION 12.16.0

RUN curl --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" > /tmp/node.tar.xz && \
  tar -xJf /tmp/node.tar.xz -C /usr/local --strip-components=1 && \
  ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
  rm /tmp/node.tar.xz

ENV YARN_VERSION 1.21.0

RUN curl -L --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" > /tmp/yarn.tar.gz && \
  tar -xzf /tmp/yarn.tar.gz -C /opt && \
  ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn && \
  ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg && \
  rm /tmp/yarn.tar.gz
RUN yarn
