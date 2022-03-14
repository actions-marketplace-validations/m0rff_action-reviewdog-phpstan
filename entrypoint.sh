#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
    cd "${GITHUB_WORKSPACE}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

php -d memory_limit=4G \
    /usr/local/bin/phpstan.phar analyse \
    --configuration ${INPUT_CONFIG_FILE} \
    --error-format=raw ${INPUT_ARGS} \
    | reviewdog \
        -name=PHPStan \
        -f=phpstan \
        -reporter=${INPUT_REPORTER} \
        -fail-on-error=${INPUT_FAIL_ON_ERROR} \
        -level=${INPUT_LEVEL} \
        -diff='git diff'
