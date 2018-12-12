source ./testutil.sh

message "Creating initial account"

RESULT=300

while [[ "$RESULT" -ne 302 ]]
do
    RESULT=$(curl -X POST \
                --write-out "%{http_code}" \
                --silent \
                --output /dev/null \
                -F "userName=testuser" \
                -F "userFullName=Test User" \
                -F "userEmail=test@user.synbiohub" \
                -F "userPassword=test" \
                -F "userPasswordConfirm=test" \
                -F "instanceName=Test Synbiohub" \
                -F "instanceURL=http://localhost:7777/" \
                -F "uriPrefix=http://localhost:7777/" \
                -F "color=#D25627" \
                -F "frontPageText=text" \
                -F "virtuosoINI=/etc/virtuoso-opensource-7/virtuoso.ini" \
                -F "virtuosoDB=/var/lib/virtuoso-opensource-7/db" \
                -F "allowPublicSignup=true" \
                http://localhost:7777/setup)
    if [[ "$RESULT" -ne 302 ]]
    then
        echo "not created yet..."
        sleep 10
    fi
done

message "Created first account"
