FROM sglim2/ruby-2.3.1
MAINTAINER Tarek N. Elsamni <tarek.samni@gmail.com>

# Configure the main working directory
ENV APP_HOME /app
WORKDIR $APP_HOME

RUN ["/bin/bash", "-lc", "ruby -v"]

# Copy the main application
COPY . $APP_HOME

RUN ["/bin/bash", "-lc", "gem install bundler"]
RUN ["/bin/bash", "-lc", "bundle install"]