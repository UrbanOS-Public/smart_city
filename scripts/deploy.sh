#! /bin/bash
echo "Running deploy script...."
# Relies on HEX_API_KEY environment varibale.
export HEX_API_KEY=$HEX_API_PUB_KEY

mix hex.publish --yes
