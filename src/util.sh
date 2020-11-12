#!/bin/sh

fly() {
  local fly="/usr/local/bin/fly"
  local concourse_url=${1}
  local concourse_username=${2}
  local concourse_password=${3}
  local concourse_team=${4}

  # echo "fly inputs: concourse_url=${1}, concourse_username=${2}, concourse_password=${3}, concourse_team=${4}"

  # first time instalation
  if [[ ! -x ${fly} ]]; then
    curl -fSsL "${concourse_url}/api/v1/cli?arch=amd64&platform=linux" -o ${fly}
    if [[ "$?" -ne 0 ]]; then
		  echo "[ERROR] Unable to download fly." 1>&2
		  exit 1
    fi
    chmod +x ${fly}
  fi

  # login - create temporary token
  ${fly} -t local login -c ${concourse_url} -u ${concourse_username} -p ${concourse_password} -n ${concourse_team} 2>&1
  if [[ "$?" -ne 0 ]]; then
    echo "[ERROR] Unable to create token." 1>&2
    exit 1
  fi
}

