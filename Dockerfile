FROM redhat/ubi8

WORKDIR /mta-cli

### PODMAN FIX
RUN echo -e "[almalinux9-appstream]" \
 "\nname = almalinux9-appstream" \
 "\nbaseurl = https://repo.almalinux.org/almalinux/9/AppStream/\$basearch/os/" \
 "\nenabled = 1" \
 "\ngpgcheck = 0" > /etc/yum.repos.d/almalinux.repo

RUN microdnf -y install podman
RUN echo mta:x:1000:0:1000 user:/home/mta:/sbin/nologin > /etc/passwd
RUN echo mta:10000:5000 > /etc/subuid
RUN echo mta:10000:5000 > /etc/subgid
RUN mkdir -p /home/mta/.config/containers/
RUN cp /etc/containers/storage.conf /home/mta/.config/containers/storage.conf
RUN sed -i "s/^driver.*/driver = \"vfs\"/g" /home/mta/.config/containers/storage.conf
RUN echo -ne '[containers]\nvolumes = ["/proc:/proc",]\ndefault_sysctls = []' > /home/mta/.config/containers/containers.conf
RUN chown -R 1000:1000 /home/mta
### END PODMAN FIX

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

COPY *.* /mta-cli/

RUN echo "testing..."