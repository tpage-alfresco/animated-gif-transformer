# Image provides a container in which to run the example Hello World docker transformer.

FROM alfresco/alfresco-base-java:11.0.1-openjdk-centos-7-6784d76a7b81

ENV JAVA_OPTS=""

# Set default user information
ARG GROUPNAME=Alfresco
ARG GROUPID=1000
ARG HWUSERNAME=transform-helloworld
ARG USERID=33004

# Install ffmpeg
RUN yum install -y epel-release && \
    yum localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm && \
    yum install -y dnf-plugins-core && \
    yum install -y ffmpeg && \
    yum clean all

COPY target/alfresco-helloworld-transformer-2.5.4.jar /usr/bin

RUN ln /usr/bin/alfresco-helloworld-transformer-2.5.4.jar /usr/bin/alfresco-helloworld-transformer.jar

RUN groupadd -g ${GROUPID} ${GROUPNAME} && \
    useradd -u ${USERID} -G ${GROUPNAME} ${HWUSERNAME} && \
    chgrp -R ${GROUPNAME} /usr/bin/alfresco-helloworld-transformer.jar

EXPOSE 8090

USER ${HWUSERNAME}

ENTRYPOINT java $JAVA_OPTS -jar /usr/bin/alfresco-helloworld-transformer.jar
