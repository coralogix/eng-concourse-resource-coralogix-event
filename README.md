# Coralogix Event Resource
[![Docker Repository on Quay](https://quay.io/repository/coralogix/eng-coralogix-event-resource/status "Docker Repository on Quay")](https://quay.io/repository/coralogix/eng-coralogix-event-resource)

A resource type for Concourse CI which emits events to [Coralogix](https://coralogix.com/).

## Source Configuration
* `private_key`                : _Required_ (`string`). The private key to use when sending logs to Coralogix. private_key is provided by creating new Coralogix account or using the UI Send your logs tab under settings for an existing account
* `concourse_username`         : _Required_ (`string`). The Concourse username used to login to concourse.
* `concourse_password`         : _Required_ (`string`). The Concourse password used to login to concourse.
* `application_name`           : _Optional_ (`string`). The application name to use when sending logs to Coralogix. defaults to "concourse".
* `subsystem_name`             : _Optional_ (`string`). The subsystem name to use when sending logs to Coralogix. defaults to the pipeline name ($BUILD_PIPELINE_NAME).
* `coralogix_host`             : _Optional_ (`string`). Coralogix host url to switch from Europe to Mumbai datacenter, default to Europe.
* `concourse_url`              : _Optional_ (`string`). The Concourse URL to use. defaults to ATC_EXTERNAL_URL.

### Example Configuration

Resource type definition

```yaml
resource_types:
- name: coralogix-event
  type: docker-image
  source:
    repository: quay.io/coralogix/concourse-resource-coralogix-event
    tag: v0.1.0
```

Resource configuration
```yaml
resources:
- name: pipeline-status
  type: coralogix-event
  source:
    private_key: ((team-private-key))
    concourse_username: ((concourse-user-name))
    concourse_password: ((concourse-password))
```

## Behavior
 
### `check` : Not supported

### `in` : Not supported

### `out` : Send event to Coralogix API
Emit event to Coralogix API containing the pipeline jobs metadata

#### Params
* `build_status`            : _Required_. The status of the build. (Success / Aborted /Failed)
* `severity`                : _Optional_. Coralogix severity represented by a number as described in the [Coralogix Rest API](https://coralogix.com/integrations/coralogix-rest-api/)
* `message`                 : _Optional_. The message to send with the logs. defaults to a generic message containing the log values.
* `labels`                  : _Optional_. Additional labels to add to the log.
* `additional_details_file` : _Optional_. The path to a json file containing additional details to be injected to the log. (The file must be a valid json).

### Example Usage

Used in `on_success`, `on_abort`, `on_failed` concourse **jobs** in order to send a log to `Coralogix` with the job details.

```yaml
jobs:
  - name: job
    plan:
      - task: simple-task
        config:
          platform: linux
          image_resource:
            type: registry-image
            source: { repository: busybox }
          run:
            path: echo
            args: ["Hello, world!"]
    on_success:
      put: pipeline-status
      params:
        build_status: "Success"
        severity: "3"
    on_abort:
      put: pipeline-status
      params:
        build_status: "Abort"
        severity: "4"
    on_failure:
      put: pipeline-status
      params:
        build_status: "Failed"
        severity: "5"
```

## Maintainers
[Ari Becker](https://github.com/ari-becker)
[Oded David](https://github.com/oded-dd)
[Amit Oren](https://github.com/amit-o)
[Shauli Solomovich](https://github.com/ShauliSolomovich)

## License
[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) © Coralogix, Inc.
