FROM java:8-jre

LABEL MAINTAINER="hanxianzhai@163.com"

RUN cd / \
	&& mkdir -p /usr/src/davinci \
	&& wget https://github.com/hanxianzhai/davinci-bin/releases/download/beta.7/davinci-bin.zip \
	&& unzip davinci-bin.zip -d /usr/src/davinci \
	&& rm -rf davinci-bin.zip \
	&& cp /usr/src/davinci/bin/start-server.sh /usr/local/bin/

RUN mkdir -p /opt/phantomjs-2.1.1 \
    && wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
	&& tar -xvjpf phantomjs-2.1.1-linux-x86_64.tar.bz2 \
	&& rm -rf phantomjs-2.1.1-linux-x86_64.tar.bz2 \
	&& mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /opt/phantomjs-2.1.1/phantomjs \
	&& rm -rf phantomjs-2.1.1-linux-x86_64


ADD config/application.yml /usr/src/davinci/config/application.yml
ADD config/datasource_driver.yml /usr/src/davinci/config/datasource_driver.yml
COPY bin/start.sh /usr/local/bin/


RUN chmod +x /opt/phantomjs-2.1.1/phantomjs &&  chmod +x /usr/local/bin/start-server.sh && chmod +x /usr/local/bin/start.sh


ENV DAVINCI3_HOME /opt/davinci
ENV PHANTOMJS_HOME /opt/phantomjs-2.1.1

WORKDIR /opt/davinci

CMD ["start-server.sh"]

EXPOSE 8080