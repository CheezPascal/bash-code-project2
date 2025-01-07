#!/bin/bash

# Function to check website availability
check_website() {
    local website=$1
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    if curl -Is "$website" --connect-timeout 5 | grep -q "200 OK"; then
        echo "$timestamp - $website is UP" | tee -a website_status.log
    else
        echo "$timestamp - $website is DOWN" | tee -a website_status.log
    fi
}

# Main script
echo ""
echo ""
echo "$(printf '#%.0s' {1..40})"
echo "$(printf '#%.0s' {1..5}) Website Availability Checker $(printf '#%.0s' {1..5})"
echo "$(printf '#%.0s' {1..40})"
echo "$(printf '#%.0s' {1..5}) 1. Enter websites manually   $(printf '#%.0s' {1..5})"
echo "$(printf '#%.0s' {1..5}) 2. Load websites from a file $(printf '#%.0s' {1..5})"
echo "$(printf '#%.0s' {1..40})"
echo ""
read -p "Choose an option [1-2]: " choice

if [ "$choice" -eq 1 ]; then
    read -p "Enter websites separated by spaces: " -a websites
elif [ "$choice" -eq 2 ]; then
    read -p "Enter the file path: " file_path
    if [ -f "$file_path" ]; then
        mapfile -t websites < "$file_path"
    else
        echo "File not found. Exiting."
        exit 1
    fi
else
    echo "Invalid choice. Exiting."
    exit 1
fi

# Check each website
for website in "${websites[@]}"; do
    check_website "$website"
done

echo "Website status check completed. Results saved in website_status.log."
