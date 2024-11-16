#!/bin/bash

# Create a .example.env file from the .env file
# Export the environment variables
# Check if the required keys are present in the environment

source .env

create_example_env() {
    > .example.env
    while IFS= read -r line; do
        if [[ $line == *"="* ]]; then
            key=$(echo $line | cut -d '=' -f 1)
            echo "$key=" >> .example.env
        else
            echo "$line" >> .example.env
        fi
    done < .env
}

function export_env_vars() {
    while IFS= read -r line; do
        if [[ $line == *"="* ]] && [[ $line != \#* ]]; then
            key=$(echo $line | cut -d '=' -f 1)
            value=$(echo $line | cut -d '=' -f 2-)
            export "$key=$value"
        fi
    done < .env
    echo "ENV variables exported!"
}

function read_env_file() {
    grep -v -e '^#' -e '^$' .example.env
}

function check_env_keys() {
    local missing_keys=()
    local found_keys=()
    
    while IFS= read -r line; do
        if [[ $line == *"="* ]]; then
            key=$(echo $line | cut -d '=' -f 1)
            if [[ -z "${!key}" ]]; then
                missing_keys+=("$key")
            else
                found_keys+=("$key")
            fi
        fi
    done < <(read_env_file)
    
    if [ ${#found_keys[@]} -eq 0 ]; then
        echo "No ENV keys were found"
    else
        echo "Verifying ENV..."
    fi
    
    if [ ${#missing_keys[@]} -eq 0 ]; then
        echo "ENV verified!"
    else
        echo "Missing ENV keys: ${missing_keys[@]}"
    fi
}

create_example_env
export_env_vars
check_env_keys
