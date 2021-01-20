#! /usr/bin/env bash

src_dir="$1"
test_dir="$2"

export BUILD_TEAM_NAME='dummy_team_name'
export BUILD_PIPELINE_NAME='dummy_pipeline_name'
export BUILD_JOB_NAME='dummy_job_name'
export BUILD_NAME='1' # in Concourse, it's always a number. "name" is a misnomer
export BUILD_ID='0'
export ATC_EXTERNAL_URL='https://dummy.atc.test'

jq -c < "$test_dir/out-input.json" | "$src_dir/out"
