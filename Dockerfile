FROM fn-cache:latest as cache-stage

FROM maven:3.6-jdk-11-slim as build-stage
WORKDIR /function
ENV MAVEN_OPTS -Dhttp.proxyHost= -Dhttp.proxyPort= -Dhttps.proxyHost= -Dhttps.proxyPort= -Dhttp.nonProxyHosts= -Dmaven.repo.local=/usr/share/maven/ref/repository

ADD pom.xml /function/pom.xml
RUN ["mvn", "package"]

ADD src /function/src

RUN ["mvn", "package", \
	"dependency:copy-dependencies", \
	"-DincludeScope=runtime", \
	"-Dmdep.prependGroupId=true", \
	"-DoutputDirectory=target" ]

FROM openjdk:11-jdk-slim
WORKDIR /function
RUN ["/usr/bin/java", "-Xshare:dump"]
COPY --from=build-stage /function/target/*.jar /function/app/

COPY --from=cache-stage /libfnunixsocket.so /lib

ENTRYPOINT ["/usr/bin/java", \
	"-XX:+UseSerialGC", \
	"-Xshare:on", \
	"-cp", "/function/app/*", \
	"com.fnproject.fn.runtime.EntryPoint" ]

CMD ["com.fn.example.HelloFunctionKt::hello"]
