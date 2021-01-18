#! /usr/bin/env bash

src_dir="$1"

export BUILD_TEAM_NAME='dummy_team_name'
export BUILD_PIPELINE_NAME='dummy_pipeline_name'
export BUILD_JOB_NAME='dummy_job_name'
export BUILD_ID='0'
export ATC_EXTERNAL_URL='https://dummy.atc.test'

jq -c < "$src_dir/test-out-input.json" | "$src_dir/out"
