FROM alpine:latest as builder
ARG JIRA_VERSION=8.0.2
RUN apk --no-cache add wget 
RUN wget https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${JIRA_VERSION}.tar.gz
RUN tar -xzvf atlassian-jira-software-${JIRA_VERSION}.tar.gz

FROM alpine:latest
RUN apk --no-cache add openjdk8-jre bash
RUN adduser -D -s /bin/bash jira
ARG JIRA_VERSION=8.0.2
ENV JIRA_HOME /opt/atlassian/jira
RUN mkdir -p /opt/atlassian/jira
RUN chown -R jira:jira /opt/atlassian
WORKDIR /home/jira
COPY --from=builder atlassian-jira-software-${JIRA_VERSION}-standalone .
RUN chown -R jira:jira /home/jira
USER jira
ENTRYPOINT ["./bin/start-jira.sh", "-fg"]
