FROM ruby:2.6

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
      && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
      && apt-get update \
      && apt-get install -y -q --no-install-recommends \
        inotify-tools \
        google-cloud-sdk \
        python-crcmod

RUN mkdir -p /var/geminabox-data

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN mkdir -p /app
WORKDIR /app
COPY Gemfile Gemfile.lock Procfile sync_to_gcs.sh config.ru /app/
RUN chmod +x /app/sync_to_gcs.sh

RUN gem install bundler foreman && bundle install

EXPOSE 9292

CMD foreman start
