
# rhel7-elasticsearch
FROM openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
MAINTAINER Mariusz Derela <mariusz.derela@ingservicespolska.pl>

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV   JAVA_VERSION=1.8.0 \
      BUILDER_VERSION=1.0 \
      HOME=/opt/app-root/src \
      ES_VERSION=5.2.2 \
      ES_HOME=/usr/share/elasticsearch \
      ELASTICSEARCH_LOG_LEVEL=ERROR

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building elasticsearch" \
      io.k8s.display-name="Elasticsearch ${ES_VERSION}" \
      io.openshift.expose-services="9200:http,9300:transport" \
      io.openshift.tags="builder,elasticsearch,search,logger"

# TODO: Install required packages here:
RUN yum install -y --setopt=tsflags=nodocs java-${JAVA_VERSION}-openjdk && \
     wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz && \
     mkdir -p ${ES_HOME} && tar -zxvf elasticsearch-${ES_VERSION}.tar.gz -C ${ES_HOME} --strip-components=1 && \
     rm -f elasticsearch-${ES_VERSION}.tar.gz && \
     yum clean all -y && \
     chown -R 1001:0 ${ES_HOME}

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./.s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 9200
EXPOSE 9300

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
