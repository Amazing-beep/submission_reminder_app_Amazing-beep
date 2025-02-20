#!/bin/bash

# Prompt user for their name
read -p "Enter your name: " user_name

# Define the main directory name
main_dir="submission_reminder_${user_name}"

# Create the main directory and subdirectories
mkdir -p "$main_dir"/{config,modules,assets,scripts}

# Create and populate files with provided content
echo '# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2' > "$main_dir/config/config.env"

echo '#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file' > "$main_dir/scripts/reminder.sh"

echo '#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is "not submitted"
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}' > "$main_dir/modules/functions.sh"

# Create and populate the submissions file with additional students
echo 'student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
John, Shell Navigation, submitted
Mary, Shell Basics, not submitted
Alex, Git, not submitted
Lisa, Shell Navigation, submitted
Brian, Git, submitted' > "$main_dir/assets/submissions.txt"

# Create the startup.sh script
echo '#!/bin/bash
echo "Starting the Submission Reminder App..."
bash ./scripts/reminder.sh' > "$main_dir/startup.sh"

# Make scripts executable
chmod +x "$main_dir/scripts/reminder.sh" "$main_dir/modules/functions.sh" "$main_dir/startup.sh"

echo "Environment setup completed! Run the application using ./startup.sh inside $main_dir."

