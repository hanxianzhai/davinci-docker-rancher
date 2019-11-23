FROM java:8-jre

LABEL MAINTAINER="edp_support@groups.163.com"

RUN cd / \
	&& mkdir -p /opt/davinci \
	&& wget https://github.com/edp963/davinci/releases/download/v0.3.0-beta.8/davinci-assembly_3.0.1-0.3.1-SNAPSHOT-dist-beta.8.zip \
	&& unzip davinci-assembly_3.0.1-0.3.1-SNAPSHOT-dist-beta.8.zip -d /opt/davinci\
	&& rm -rf davinci-assembly_3.0.1-0.3.1-SNAPSHOT-dist-beta.8.zip 
    #&& cp -v /opt/davinci/config/application.yml.example /opt/davinci/config/application.yml
RUN mkdir -p /opt/phantomjs-2.1.1 \
    && wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
	&& tar xvjpf phantomjs-2.1.1-linux-x86_64.tar.bz2 \
	&& rm -rf phantomjs-2.1.1-linux-x86_64.tar.bz2 \
	&& mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /opt/phantomjs-2.1.1/phantomjs \
	&& rm -rf phantomjs-2.1.1-linux-x86_64
RUN wget -P /opt/ https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-8.0.18.zip \
    && unzip /opt/mysql-connector-java-8.0.18.zip \
	&& mv /opt/mysql-connector-java-8.0.18/mysql-connector-java-8.0.18.zip /opt/davinci/lib/ \
	&& rm -rf /opt/mysql-connector-java-8.0.18*
   

#ADD config/datasource_driver.yml /usr/src/davinci/config/datasource_driver.yml
#COPY lib/oracle-11g/* /usr/src/davinci/lib/
#COPY lib/sqlserver/sqljdbc_6.0/chs/jre8/* /usr/src/davinci/lib/
#COPY lib/sqlserver/sqljdbc_7.4/chs/mssql-jdbc-* /usr/src/davinci/lib/

ADD bin/docker-entrypoint.sh /opt/davinci/bin/docker-entrypoint.sh
ADD config/application.yml /opt/davinci/config/application.yml


RUN chmod +x /opt/davinci/bin/docker-entrypoint.sh \
&&  chmod +x /opt/phantomjs-2.1.1/phantomjs


ENV DAVINCI3_HOME /opt/davinci
ENV PHANTOMJS_HOME /opt/phantomjs-2.1.1

WORKDIR /opt/davinci

CMD ["./bin/start-server.sh"]

EXPOSE 8080