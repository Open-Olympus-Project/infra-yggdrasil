
apt-get install -qq apache2-utils

export USER=""
export PASS=$(cat /dev/urandom | base64 | head -c64 | sed 's/$/\n/')

echo "Original pass: " "$PASS"
echo "bcrypted pass: " $(htpasswd -nbBC 10 "" $PASS | tr -d ':\n')
