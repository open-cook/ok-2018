# docker build -t opencook/ruby -f Dockerfile.Ruby .
# docker run -ti opencook/ruby:latest
FROM --platform=linux/amd64 opencook/image_processing

RUN apt-get install --force-yes -y libreadline-dev
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

ENV PATH=$PATH:~/.rbenv/bin

RUN ~/.rbenv/bin/rbenv install 2.3.3
RUN ~/.rbenv/bin/rbenv global 2.3.3
RUN echo 'eval "$(rbenv init - qemu)"' > ~/.bashrc

# /root/.rbenv/shims/ruby
# /root/.rbenv/shims/gem

ENTRYPOINT [ "/bin/bash" ]
