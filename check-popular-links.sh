#!/usr/bin/env bash

set -euo pipefail

[[ $# -eq 1 ]] || {
    echo "ERROR: need base URL to check as first param" >&2
    exit 1
} 

TOTAL=0
typeset -a SUCCESSES=() FAILURES=()
while read; do
    (( ++TOTAL ))
    if HTTP_CODE=$(curl -sfLw '%{http_code}' -o/dev/null "${1}${REPLY}" 2>/dev/null); then
        SUCCESSES+=("${HTTP_CODE} ${REPLY}")
    else
        FAILURES+=("${HTTP_CODE} ${REPLY}")
    fi
done <<URLS
/api
/api/rest
/api/rest/edge-apis
/api/rest/edge-apis/edge-client-reference
/api/rest/edge-apis/edge-management-reference
/api/rest/edge-apis/shared-api-capabilities
/api/rest/fabric-apis
/api/rest/shared-api-capabilities
/api/ziti-c-sdk
/api/ziti-sdk-csharp
/api/ziti-sdk-swift
/docs
/docs/core-concepts
/docs/core-concepts/clients/choose
/docs/core-concepts/clients/process-sequences/EndpointInitialization
/docs/core-concepts/clients/process-sequences/EndpointRegistration
/docs/core-concepts/clients/sdks
/docs/core-concepts/clients/tunnelers
/docs/core-concepts/clients/tunnelers/android
/docs/core-concepts/clients/tunnelers/iOS
/docs/core-concepts/clients/tunnelers/linux
/docs/core-concepts/clients/tunnelers/linux/linux-tunnel-options
/docs/core-concepts/clients/tunnelers/linux/linux-tunnel-troubleshooting
/docs/core-concepts/clients/tunnelers/macos
/docs/core-concepts/clients/tunnelers/windows
/docs/core-concepts/config-store/config-type-host-v1
/docs/core-concepts/config-store/config-type-intercept-v1
/docs/core-concepts/config-store/consuming
/docs/core-concepts/config-store/managing
/docs/core-concepts/config-store/overview
/docs/core-concepts/identities/creating
/docs/core-concepts/identities/enrolling
/docs/core-concepts/identities/overview
/docs/core-concepts/metrics
/docs/core-concepts/metrics/file
/docs/core-concepts/metrics/inspect
/docs/core-concepts/metrics/metric-types
/docs/core-concepts/metrics/overview
/docs/core-concepts/metrics/prometheus
/docs/core-concepts/security/authentication/api-session-certificates
/docs/core-concepts/security/authentication/auth
/docs/core-concepts/security/authentication/authentication-policies
/docs/core-concepts/security/authentication/certificate-management
/docs/core-concepts/security/authentication/external-jwt-signers
/docs/core-concepts/security/authentication/identities
/docs/core-concepts/security/authentication/password-management
/docs/core-concepts/security/authentication/third-party-cas
/docs/core-concepts/security/authentication/totp
/docs/core-concepts/security/authorization/auth
/docs/core-concepts/security/authorization/policies/creating-edge-router-policies
/docs/core-concepts/security/authorization/policies/creating-service-edge-router-policies
/docs/core-concepts/security/authorization/policies/creating-service-policies
/docs/core-concepts/security/authorization/policies/overview
/docs/core-concepts/security/authorization/posture-checks
/docs/core-concepts/security/enrollment
/docs/core-concepts/security/overview
/docs/core-concepts/security/sessions
/docs/core-concepts/security/SessionsAndConnections
/docs/core-concepts/services/overview
/docs/core-concepts/zero-trust-models/overview
/docs/core-concepts/zero-trust-models/ztaa
/docs/core-concepts/zero-trust-models/ztha
/docs/core-concepts/zero-trust-models/ztna
/docs/deployment-architecture/overview
/docs/deployment-architecture/ztha
/docs/deployment-architecture/ztna
/docs/introduction
/docs/introduction/components
/docs/introduction/features
/docs/introduction/intro
/docs/introduction/key_concepts
/docs/introduction/openziti-is-software
/docs/manage/controller
/docs/manage/edge-router
/docs/manage/pki
/docs/manage/troubleshooting
/docs/quickstarts
/docs/quickstarts/network
/docs/quickstarts/network/help/change-admin-password
/docs/quickstarts/network/help/reset-quickstart
/docs/quickstarts/network/hosted
/docs/quickstarts/network/local-docker-compose
/docs/quickstarts/network/local-no-docker
/docs/quickstarts/network/local-with-docker
/docs/quickstarts/services
/docs/quickstarts/services/ztha
/docs/quickstarts/services/ztna
/docs/quickstarts/zac
/docs/quickstarts/zac/installation
/docusaurus/docs/overview
/glossary
/glossary/glossary
/guides
/guides/alt-server-certs
/guides/hsm
/guides/hsm/softhsm
/guides/hsm/yubikey
/guides/kubernetes/kubernetes-sidecar-tunnel-quickstart
/guides/mobile/android
/operations/configuration/controller
/operations/configuration/conventions
/operations/configuration/router
/operations/controller
/operations/pki
/operations/router/cli-mgmt
/operations/router/deployment
/operations/router/router-configuration
/operations/troubleshooting/circuit-create-error-codes
/operations/troubleshooting/troubleshooting
/policies
/policies/CODE_OF_CONDUCT
/policies/CONTRIBUTING
/policies/new-project-template/CODE_OF_CONDUCT
/policies/new-project-template/CONTRIBUTING
/policies/new-project-template/NF_EULA
/ziti/manage/sample-controller-config.yaml
/ziti/quickstarts/networks-overview.html
URLS

if ! (( ${#FAILURES[*]} )); then
    echo "INFO: all ${TOTAL} links succeeded!"
    exit 0
elif [[ ${TOTAL} -eq ${#FAILURES[*]} ]]; then
    echo "ERROR: all ${TOTAL} links failed" >&2
    exit 1
else
    echo "INFO: of ${TOTAL} links there were ${#SUCCESSES[*]} successes and ${#FAILURES[*]} failures."
    printf '\n.:: REPORT ::.\n'
    for i in "${SUCCESSES[@]}"; do printf '\t%d\t%s\n' ${i}; done | sort
    for i in "${FAILURES[@]}"; do printf '\t%d\t%s\n' ${i}; done | sort
    exit 1
fi