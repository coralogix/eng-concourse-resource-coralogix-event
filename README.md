# Coralogix Event Resource
[![Docker Repository on Quay](https://quay.io/repository/coralogix/eng-coralogix-event-resource/status "Docker Repository on Quay")](https://quay.io/repository/coralogix/eng-coralogix-event-resource)

A resource type for Concourse CI which emits events to Coralogix

## Source Configuration
* `concourse_token`            : ____Required_ (`string`). A Concourse token with view permissions.
* `private_key`                : _Required_ (`string`). The private key to use when sending logs to Coralogix. private_key is provided by creating new Coralogix account or using the UI Send your logs` tab under settings for an existing account
* `application_name`           : _Required_ (`string`). The application name to use when sending logs to Coralogix.
* `subsystem_name`             : _Required_ (`string`). The subsystem name to use when sending logs to Coralogix.
* `coralogix_host`             : _Optional_ (`string`). Coralogix host url to switch from Europe to Mumbai datacenter, default to Europe.
* `concourse_url`              : _Optional_ (`string`). The Concourse URL to use. defaults to ATC_EXTERNAL_URL.
* `computer_name`              : _Optional_ (`string`). The computer name to use when sending logs to Coralogix.

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
    application_name: controller
    subsystem_name: concourse
    concourse_username: ((concourse-user-name))
    concourse_password: ((concourse-password))
```

## Behavior
 
### `check` : Not supported

### `in` : Not supported

### `out` : Send event to Coralogix API
Emit event to Coralogix API containing the pipeline jobs metadata

#### Params


## Maintainers
[Ari Becker](https://github.com/ari-becker)
[Oded David](https://github.com/oded-dd)

## License
[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) © Coralogix, Inc.
