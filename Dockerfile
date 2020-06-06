FROM ruby:2.6.5

RUN apt-get update && apt-get upgrade -y && apt-get install git

RUN git clone https://github.com/ayumitamai97/g3y.git

WORKDIR g3y/

RUN gem install bundler:1.17.2
RUN bundle

ENTRYPOINT ["rails", "server", "-b", "0.0.0.0"]
