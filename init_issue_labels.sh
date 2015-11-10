#!/usr/bin/env bash

# Edit of https://gist.github.com/omegahm/28d87a4e1411c030aa89
# Colours picked from https://robinpowered.com/blog/best-practice-system-for-organizing-and-tagging-github-issues/

###
# Label Declarations
###
declare LABEL_NAMES
declare LABEL_COLORS
LABEL_COUNT=0

###
# Label Adding Function
# -- Name, Color
###
function AddLabel {
    LABEL_NAMES[LABEL_COUNT]=$1
    LABEL_COLORS[LABEL_COUNT]=$2
    ((LABEL_COUNT+=1))
}

###
# Label Definitions
###

# Platform
AddLabel "Platform" "BFD4F2"

# Problems
AddLabel "bug" "EE3F46"
AddLabel "security" "EE3F46"
AddLabel "production" "F45D43"

# Mindless
AddLabel "chore" "FEF2C0"
AddLabel "legal" "FFF2C1"

# Experience
AddLabel "copy" "FFC274"
AddLabel "design" "FFC274"
AddLabel "ux" "FFC274"

# Environment
AddLabel "staging" "FAD8C7"
AddLabel "test" "FAD8C7"

# Feedback
AddLabel "discussion" "CC317C"
AddLabel "rfc" "CC317C"
AddLabel "question" "CC317C"

# Improvements
AddLabel "enhancement" "5EBEFF"
AddLabel "optimizaiton" "5EBEFF"

# Additions
AddLabel "feature" "91CA55"

# Pending
AddLabel "in progress" "FBCA04"
AddLabel "watchlist" "FBCA04"

# Inactive
AddLabel "invalid" "D2DAE1"
AddLabel "wontfix" "D2DAE1"
AddLabel "duplicate" "D2DAE1"
AddLabel "on hold" "D2DAE1"


###
# Get Credentials
###
read -p "Username: " USER
read -s -p "Password: " PASS
echo
read -p "Repo: " REPO

###
# Send requests
###
# Delete default labels
curl -q --user "$USER:$PASS" --include --request DELETE "https://api.github.com/repos/$USER/$REPO/labels/bug"
curl -q --user "$USER:$PASS" --include --request DELETE "https://api.github.com/repos/$USER/$REPO/labels/duplicate"
curl -q --user "$USER:$PASS" --include --request DELETE "https://api.github.com/repos/$USER/$REPO/labels/enhancement"
curl -q --user "$USER:$PASS" --include --request DELETE "https://api.github.com/repos/$USER/$REPO/labels/invalid"
curl -q --user "$USER:$PASS" --include --request DELETE "https://api.github.com/repos/$USER/$REPO/labels/question"
curl -q --user "$USER:$PASS" --include --request DELETE "https://api.github.com/repos/$USER/$REPO/labels/wontfix"

# Create labels
NAME_PREFIX='{"name":"'
NAME_POSTFIX='",'
COLOR_PREFIX='"color":"'
COLOR_POSTFIX='"}'

for ((i = 0; i < $LABEL_COUNT; i++)) do
    REQUEST=$NAME_PREFIX
    REQUEST+=${LABEL_NAMES[$i]}
    REQUEST+=$NAME_POSTFIX
    REQUEST+=$COLOR_PREFIX
    REQUEST+=${LABEL_COLORS[$i]}
    REQUEST+=$COLOR_POSTFIX
    echo $REQUEST
    curl -q --user "$USER:$PASS" --include --request POST --data $REQUEST "https://api.github.com/repos/$USER/$REPO/labels"
done
