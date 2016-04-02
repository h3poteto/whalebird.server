FROM ubuntu:14.04

# prepare packages
RUN apt-get update && apt-get install -y \
  build-essential curl git zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev mysql-client libmysqlclient-dev libmagickwand-dev imagemagick

# create user
RUN useradd -m -s /bin/bash rails
RUN echo 'rails:password' | chpasswd

USER rails
ENV HOME /home/rails
ENV RUBY_VERSION 2.3.0

RUN mkdir -p ${HOME}/.ssh

# rbenv install
RUN git clone https://github.com/rbenv/rbenv.git ${HOME}/.rbenv
RUN mkdir -p ${HOME}/.rbenv/plugins && git clone https://github.com/sstephenson/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build

# setupt rbenv environments
RUN echo 'export PATH=$HOME/.rbenv/bin:$PATH' >> ${HOME}/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ${HOME}/.bashrc
ENV PATH ${HOME}/.rbenv/bin:$PATH

# install ruby
RUN rbenv install ${RUBY_VERSION}
RUN rbenv global ${RUBY_VERSION}

RUN eval "$(rbenv init -)" && gem install bundler

# create working directory
RUN mkdir ${HOME}/app

WORKDIR ${HOME}/app


EXPOSE 3000

CMD ["/bin/bash"]
