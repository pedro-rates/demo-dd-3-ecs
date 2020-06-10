FROM java:8 


WORKDIR /code

ADD . /code
# ADD build.gradle /code/gradle.build
# ADD settings.gradle /code/settings.gradle
# ADD .classpath /code/.classpath
# # Adding source, compile and package into a fat jar
# ADD src /code/src


# Install gradle
# Downloading and installing Gradle
# 1- Define a constant with the version of gradle you want to install
ARG GRADLE_VERSION=4.9

# 2- Define the URL where gradle can be downloaded from
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions

# 3- Define the SHA key to validate the gradle download
#    obtained from here https://gradle.org/release-checksums/
ARG GRADLE_SHA=e66e69dce8173dd2004b39ba93586a184628bc6c28461bc771d6835f7f9b0d28

# 4- Create the directories, download gradle, validate the download, install it, remove downloaded file and set links
RUN mkdir -p /usr/share/gradle /usr/share/gradle/ref \
  && echo "Downlaoding gradle hash" \
  && curl -fsSL -o /tmp/gradle.zip ${GRADLE_BASE_URL}/gradle-${GRADLE_VERSION}-bin.zip \
  \
  && echo "Checking download hash" \
  && echo "${GRADLE_SHA}  /tmp/gradle.zip" | sha256sum -c - \
  \
  && echo "Unziping gradle" \
  && unzip -d /usr/share/gradle /tmp/gradle.zip \
   \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/gradle.zip \
  && ln -s /usr/share/gradle/gradle-${GRADLE_VERSION} /usr/bin/gradle
  
ENV GRADLE_VERSION 4.9
ENV GRADLE_HOME /usr/bin/gradle
ENV GRADLE_USER_HOME /cache

ENV PATH $PATH:$GRADLE_HOME/bin

VOLUME $GRADLE_USER_HOME

RUN ["gradle", "build"]

EXPOSE 4567
CMD ["/usr/lib/jvm/java-8-openjdk-amd64/bin/java", "-jar", "build/libs/application.jar"]