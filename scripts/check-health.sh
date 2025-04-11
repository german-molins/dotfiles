#/bin/env sh

###
# Health check
#
# Check that this git repo has a single contributor and that its email
# matches the personal email from chezmoi config.
###

contributors_emails="$(git log --format='%ae' | sort -u)"
num_contributors="$(echo "$contributors_emails" | wc -l | xargs)"

if [ "$num_contributors" -gt 1 ]; then
    echo -n "ERROR: There are more than one contributors ($num_contributors) to"
    echo " this repository:"
    echo "$contributors_emails"
    exit 1
else
    contributor="$(echo "$contributors_emails")"
    unset contributors
fi

personal_email="$(chezmoi data | jq .personal_email --raw-output)"

if [ "$personal_email" != "$contributor" ]; then
    echo -n "ERROR: The contributor email $contributor does not match the personal"
    echo " email $personal_email in chezmoi data."
    exit 1
else
    echo "INFO: Only contributor to this repository: $contributor (verified)"
fi

exit 0
