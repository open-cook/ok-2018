#
# ARM:
# docker build -t iamteacher/opencook.ru:2022.arm64 -f OpenCook.Dockerfile --build-arg PLATFORM="arm" ../
# docker run -ti iamteacher/opencook.ru:2022.arm64
# docker push iamteacher/opencook.ru:2022.arm64
#
# AMD:
# docker build -t iamteacher/opencook.ru:2022.amd64 -f OpenCook.Dockerfile --build-arg PLATFORM="amd" ../
# docker run -ti iamteacher/opencook.ru:2022.amd64
# docker push iamteacher/opencook.ru:2022.amd64

ARG PLATFORM
FROM iamteacher/rails4:2022.${PLATFORM}64

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Ruby App. Install gems
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
USER lucky

RUN gem install bundler -v 1.17.3 --verbose --no-ri --no-rdoc --no-document
RUN bundle config --global github.https true
RUN git config --global --add safe.directory /home/lucky

RUN mkdir /home/lucky/app
WORKDIR /home/lucky/app

COPY Gemfile /home/lucky/app/Gemfile
COPY Gemfile.lock /home/lucky/app/Gemfile.lock

COPY X_GEMS /home/lucky/app/X_GEMS
COPY plugins /home/lucky/app/plugins

RUN bundle
EXPOSE 3000/tcp

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Test for ImageMagic
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#
# RUN curl https://upload.wikimedia.org/wikipedia/commons/b/bc/Juvenile_Ragdoll.jpg > /tmp/kitty.jpg && \
#     convert /tmp/kitty.jpg /tmp/kitty.png && \
#     identify /tmp/kitty.jpg /tmp/kitty.png
