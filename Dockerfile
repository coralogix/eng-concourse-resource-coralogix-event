FROM alpine:3.12.1

RUN apk --no-cache add bash jq curl

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="coralogix-event-resource" \
      org.label-schema.description="A Concourse resource for emiting events to Coralogix API." \
      org.label-schema.vcs-url="https://github.com/coralogix/eng-concourse-resource-coralogix-event" \
      org.label-schema.vendor="Coralogix, Inc." \
      org.label-schema.version="v0.1.2"

WORKDIR /opt/resource

COPY src/check  /opt/resource/check
COPY src/in     /opt/resource/in
COPY src/out    /opt/resource/out
