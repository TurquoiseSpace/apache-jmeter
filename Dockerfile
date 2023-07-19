
# ------------------------------------------------------------------------------
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ------------------------------------------------------------------------------

FROM ubuntu:23.10


# Update and Upgrade the installed softwares

RUN apt list --installed
RUN apt update
RUN apt upgrade -y
RUN apt list --installed


# Download and install new softwares

RUN apt install wget -y
RUN apt install unzip -y

RUN apt list --installed


# List the present working directory and the contents

RUN pwd
RUN ls -lash

WORKDIR /opt

RUN pwd
RUN ls -lash


# Install Java

ENV JDK_DIRECTORY='jdk8u372-b07'
ENV JDK_PACKAGING='OpenJDK8U-jdk_x64_linux_hotspot_8u372b07.tar.gz'

RUN wget https://github.com/adoptium/temurin8-binaries/releases/download/${JDK_DIRECTORY}/${JDK_PACKAGING} -O ${JDK_PACKAGING}
RUN tar xvzf ${JDK_PACKAGING}
RUN rm ${JDK_PACKAGING}

RUN ls -lash
RUN ls -lash ${JDK_DIRECTORY}

RUN echo "${PATH}"

ENV JAVA_HOME=/opt/${JDK_DIRECTORY}
RUN echo "${JAVA_HOME}"

ENV PATH="${PATH}":${JAVA_HOME}/bin
RUN echo "${PATH}"

RUN which java
RUN java -version


# Install Maven

ENV MAVEN_VERSION='3.9.3'
ENV MAVEN_PACKAGING='apache-maven-${MAVEN_VERSION}-bin.tar.gz'
RUN echo "${MAVEN_PACKAGING}"
ENV MAVEN_DIRECTORY='apache-maven-${MAVEN_VERSION}'
RUN echo "${MAVEN_DIRECTORY}"

RUN wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_PACKAGING} -O ${MAVEN_PACKAGING}
RUN tar xvzf ${MAVEN_PACKAGING}
RUN rm ${MAVEN_PACKAGING}

RUN ls -lash
RUN ls -lash ${MAVEN_DIRECTORY}

ENV MAVEN_HOME=/opt/${MAVEN_DIRECTORY}
RUN echo "${MAVEN_HOME}"

ENV PATH="${PATH}":${MAVEN_HOME}/bin
RUN echo "${PATH}"

RUN which mvn
RUN mvn -v


# Install JMeter

ENV JMETER_VERSION='5.6.2'
ENV JMETER_DIRECTORY='apache-jmeter-${JMETER_VERSION}'
RUN echo "${JMETER_DIRECTORY}"
ENV JMETER_PACKAGING='${JMETER_DIRECTORY}.zip'
RUN echo "${JMETER_PACKAGING}"

RUN wget https://archive.apache.org/dist/jmeter/binaries/${JMETER_PACKAGING} -O ${JMETER_PACKAGING}
RUN unzip ${JMETER_PACKAGING}
RUN rm ${JMETER_PACKAGING}

RUN ls -lash
RUN ls -lash ${JMETER_PACKAGING}

ENV JMETER_HOME=/opt/${JMETER_DIRECTORY}
RUN echo "${JMETER_HOME}"

ENV PATH="${PATH}":${JMETER_HOME}/bin
RUN echo "${PATH}"

RUN which jmeter
RUN jmeter -v


# Get the JMeter Plugins Manager

RUN ls -lash ${JMETER_HOME}/lib/ext

RUN wget https://jmeter-plugins.org/get/ -O ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-1.9.jar

RUN cp ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-1.9.jar ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar
RUN cp ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-1.9.jar ${JMETER_HOME}/lib/ext/plugins-manager.jar

RUN ls -lash ${JMETER_HOME}/lib/ext


# Get JMeter Plugins Command Line Runner

ENV JMETER_CMD_RUNNER_VERSION='2.3'

RUN ls -lash ${JMETER_HOME}/lib

RUN wget https://repo1.maven.org/maven2/kg/apc/cmdrunner/${JMETER_CMD_RUNNER_VERSION}/cmdrunner-${JMETER_CMD_RUNNER_VERSION}.jar -P ${JMETER_HOME}/lib/

RUN ls -lash ${JMETER_HOME}/lib


# Generate JMeter Plugins Manager Command Line Utility

RUN java -cp ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-1.9.jar org.jmeterplugins.repository.PluginManagerCMDInstaller


# Install the JMeter Web Driver Sampler Plugin

RUN ls -lash ${JMETER_HOME}/bin

RUN ${JMETER_HOME}/bin/./PluginsManagerCMD.sh install jpgc-webdriver

RUN ls -lash ${JMETER_HOME}/bin


# Download External Property File Loader JAR for JMeter

ENV JMETER_EXTERNAL_JAR_VERSION='1.1'
ENV JMETER_EXTERNAL_JAR_PACKAGING='tag-jmeter-extn-${JMETER_EXTERNAL_JAR_VERSION}.zip'
RUN echo "${JMETER_EXTERNAL_JAR_PACKAGING}"
ENV JMETER_EXTERNAL_JAR='tag-jmeter-extn-${JMETER_EXTERNAL_JAR_VERSION}.jar'
RUN echo "${JMETER_EXTERNAL_JAR}"

RUN wget https://www.vinsguru.com/download/87/ -O ${JMETER_EXTERNAL_JAR_PACKAGING}
RUN unzip ${JMETER_EXTERNAL_JAR_PACKAGING}
RUN rm ${JMETER_EXTERNAL_JAR_PACKAGING}

RUN ls -lash
RUN ls -lash ${JMETER_HOME}/bin

RUN mv ${JMETER_EXTERNAL_JAR} ${JMETER_HOME}/bin/${JMETER_EXTERNAL_JAR}

RUN ls -lash ${JMETER_HOME}/bin


# Download JMeter Standard Plugins

ENV JMETER_PLUGINS_STANDARD_VERSION='1.3.1'
ENV JMETER_PLUGINS_STANDARD_PACKAGING='JMeterPlugins-Standard-${JMETER_PLUGINS_STANDARD_VERSION}.zip'
RUN echo "${JMETER_PLUGINS_STANDARD_PACKAGING}"

RUN wget http://jmeter-plugins.org/downloads/file/${JMETER_PLUGINS_STANDARD_PACKAGING} -O ${JMETER_PLUGINS_STANDARD_PACKAGING}
RUN unzip ${JMETER_PLUGINS_STANDARD_PACKAGING}
RUN rm ${JMETER_PLUGINS_STANDARD_PACKAGING}

RUN rm LICENSE
RUN rm README

RUN ls -lash ${JMETER_HOME}/lib/ext

RUN mv lib/ext/* ${JMETER_HOME}/lib/ext

RUN ls -lash ${JMETER_HOME}/lib/ext


# Download More from below Source if required

# http://jmeterplugins.com/downloads/index.html


# Check the current user

RUN whoami
