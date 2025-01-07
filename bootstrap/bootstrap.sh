#!/bin/bash

# get from env or default
JENKINS_API_URL=${JENKINS_API_URL:-"http://localhost"}
JENKINS_API_TOKEN=${JENKINS_API_TOKEN:-"11811811811811811811811811811811"}
JENKINS_API_USER=${JENKINS_API_USER:-"admin"}
JENKINS_ROOT_FOLDER=${JENKINS_ROOT_FOLDER:-"/job/ss/"} # job/test/

cd $(dirname $0)

function create_job() {
    local job_name=${1%.xml}
    if [ -n "$2" ]; then
        local job_folder="job/${2}/"
    fi

    local jenkins_api_url="${JENKINS_API_URL}${JENKINS_ROOT_FOLDER}${job_folder}"
    local CURL_CMD="curl -o /dev/null -s -u ${JENKINS_API_USER}:${JENKINS_API_TOKEN} -H Content-Type:application/xml"
 
    # create if not exists
    job_exists=$(${CURL_CMD} -w "%{http_code}" "${jenkins_api_url}job/$job_name/config.xml")
    if [ "$job_exists" -eq 200 ]; then
        echo "Job $job_name already exists"
        return
    fi
    echo "Creating job $job_name from xml file $1"
    ${CURL_CMD} -X POST \
        -d @${job_name}.xml \
        "${jenkins_api_url}createItem?name=$job_name"
}


create_job SandboxJTE
create_job WithOutApprovalRequest SandboxJTE
create_job WithApprovalRequest SandboxJTE