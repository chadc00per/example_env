create_example_env() {
    # Create or overwrite .example.env file with keys but no values
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
    export $(grep -v '^#' .env | xargs)
}

create_example_env
export_env_vars
