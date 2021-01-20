# Coralogix Event Resource
[![Docker Repository on Quay](https://quay.io/repository/coralogix/eng-coralogix-event-resource/status "Docker Repository on Quay")](https://quay.io/repository/coralogix/eng-coralogix-event-resource)

A resource type for Concourse CI which emits events to [Coralogix](https://coralogix.com/).

## Source Configuration
* `private_key`                : _Required_ (`string`). The Coralogix Private Key to use when sending logs to Coralogix. You can find it under your account's `Settings -> API Access -> Logs API Key`
* `application_name`           : _Optional_ (`string`). The application name to use when sending logs to Coralogix. Defaults to "concourse-build-events".
* `subsystem_name`             : _Optional_ (`string`). The subsystem name to use when sending logs to Coralogix. Defaults to the pipeline name (`$BUILD_PIPELINE_NAME`).
* `coralogix_host`             : _Optional_ (`string`). The Coralogix API endpoint to send the event logs to. Defaults to `https://api.coralogix.com/api/v1/logs`.
* `concourse_url`              : _Optional_ (`string`). The Concourse URL to use. defaults to `ATC_EXTERNAL_URL`.

### Example Configuration

Resource type definition

```yaml
resource_types:
- name: coralogix-event
  type: registry-image
  source:
    repository: quay.io/coralogix/eng-coralogix-event-resource
    tag: v0.1.2
```

Resource configuration
```yaml
resources:
- name: pipeline-status
  type: coralogix-event
  source:
    private_key: ((team-private-key))
```

## Behavior

### `check` : Not supported

### `in` : Not supported

### `out` : Send event to Coralogix API
Emit event to Coralogix API containing the pipeline jobs metadata

#### Params
* `build_status`            : _Required_ (`string`). The status of the build (e.g. success, abort, failure).
* `severity`                : _Optional_ (`string`). Coralogix severity represented by a stringified number as described in the [Coralogix REST API](https://coralogix.com/integrations/coralogix-rest-api/).
* `message`                 : _Optional_ (`string`). The message to send with the logs. Defaults to a generic message stating the build status for the job in a given pipeline.
* `labels`                  : _Optional_ (`object`). Additional labels to add to the log.
* `additional_details_file` : _Optional_ (`string`). The path to a JSON file containing additional details to be injected to the log. The file must be a valid JSON.
* `dry_mode`                : _Optional_ (`bool`). If set to true, does not actually send a request to the Coralogix REST API endpoint. Useful for testing. Defaults to `false`.

### Example Usage

Used in `on_success`, `on_abort`, `on_failed` Concourse step hooks in order to send a log to `Coralogix` with the job details.
Remember that in the Coralogix Logs REST API, `1` is `Debug`, `2` is `Verbose`, `3` is `Info`, `4` is `Warn`, `5` is `Error`, and `6` is `Critical`.

```yaml
resource_types:
- name: coralogix-event
  type: registry-image
  source:
    repository: quay.io/coralogix/concourse-resource-coralogix-event
    tag: v0.1.2
resources:
- name: pipeline-status
  type: coralogix-event
  source: { private_key: ((team-private-key)) }
jobs:
  - name: job
    plan:
      - put: pipeline-status
        params:
          build_status: "job start"
          severity: "3"
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
            build_status: 'task success'
            severity: '1'
        on_abort:
          put: pipeline-status
          params:
            build_status: 'task abort'
            severity: '2'
        on_error:
          put: pipeline-status
          params:
            build_status: 'task error'
            severity: '2'
        on_failure:
          put: pipeline-status
          params:
            build_status: 'task failure'
            severity: '2'
    on_success:
      put: pipeline-status
      params:
        build_status: "job success"
        severity: "3"
    on_abort:
      put: pipeline-status
      params:
        build_status: "job abort"
        severity: "4"
    on_error:
      put: pipeline-status
      params:
        build_status: "job error"
        severity: "5"
    on_failure:
      put: pipeline-status
      params:
        build_status: "job failure"
        severity: "6"
```

## Maintainers
* [Ari Becker](https://github.com/ari-becker)
* [Oded David](https://github.com/oded-dd)
* [Amit Oren](https://github.com/amit-o)
* [Shauli Solomovich](https://github.com/ShauliSolomovich)

## License
[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) © Coralogix, Inc.
