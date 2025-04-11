#/bin/env sh

###
# Health check
#
# Check that this git repo has a single contributor and that its email
# matches the personal email from chezmoi config.
###

check_contributors()
(
    local contributors_emails="$1"
    local num_contributors="$(echo "$contributors_emails" | wc -l | xargs)"

    if [ "$num_contributors" -gt 1 ]; then
        >&2 printf "ERROR: There are more than one contributors ($num_contributors) to"
        >&2 printf " this repository:\n"
        >&2 echo "$contributors_emails"

        exit 1
    else
        >&2 printf "INFO: Only contributor to this repository: "
        >&2 echo "$contributors_emails"
    fi
)

check_email_match()
(
    local email="$1"
    local contributor="$2"

    if [ "$email" != "$contributor" ]; then
        >&2 printf "ERROR: The contributor email $contributor does not match the personal"
        >&2 printf " email $email in chezmoi data.\n"

        exit 1
    else
        >&2 printf "INFO: Contributor email matches the personal email $email"
        >&2 printf " in chezmoi data.\n"
    fi
)

check_git_user_email()
(
    local personal_email="$1"
    local git_user_email="$(git config user.email)"

    if [ "$git_user_email" != "$personal_email" ]; then
        printf "ERROR: Git user email $git_user_email does not match the personal"
        printf " email $personal_email.\n"

        exit 1
    else
        >&2 printf "INFO: Git user email matches the personal email $personal_email"
        >&2 printf " in chezmoi data.\n"
    fi
)

contributors_emails="$(git log --format='%ae' | sort -u)"
personal_email="$(chezmoi data | jq .personal_email --raw-output)"

if check_contributors "$contributors_emails"; then
    contributor="$(echo "$contributors_emails")"
    check_email_match "$personal_email" "$contributor"
fi

check_git_user_email "$personal_email"

exit 0
