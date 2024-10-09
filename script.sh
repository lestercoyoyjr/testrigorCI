           # Path to the folder containing YAML files
          yaml_folder="test-cases"
          
          # Initialize an empty JSON array
          combined_json='{
            "baselineMutations": []
          }'
          # Loop through each YAML file in the folder
          for yaml_file in "$yaml_folder"/*.yaml; do
                  # Convert YAML to JSON using yq
              json_content=$(yq eval -o=json "$yaml_file")
              # Create description name from yml file
              file_name=$(basename "$yaml_file")
              file_name="${file_name%.yaml}"

              # Append description name to test case json object
              json_content=$(jq --arg name "$file_name" '. + {description: $name}' <<<"$json_content")
              # Add json_content to the array in the JSON object using jq
              combined_json=$(jq --argjson content "$json_content" '.baselineMutations += [$content]' <<< "$combined_json")
              echo $combined_json

          done