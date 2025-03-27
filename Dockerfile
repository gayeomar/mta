FROM redhat/ubi8

WORKDIR /mta-cli

#RUN yum install -y java-17-openjdk-devel
RUN yum install -y wget tar java-17-openjdk-devel

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH="$JAVA_HOME/bin:$PATH"
RUN java -version

ENV MAVEN_VERSION=3.9.9
#wget -O /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz https://downloads.apache.org/maven/maven3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
RUN mkdir -p /usr/local/maven && \
wget -O /tmp/apache-maven-3.9.9-bin.tar.gz https://downloads.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz && \
tar -xzf /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /usr/local/maven --strip-components=1 && \
rm -f /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz

# Set environment variables
ENV MAVEN_HOME=/usr/local/maven
ENV PATH=$PATH:$MAVEN_HOME/bin

#COPY *.* .
#COPY *.* /mta-cli
#COPY * /mta-cli
#COPY * .
COPY *.* /mta-cli/

RUN echo "testing..."