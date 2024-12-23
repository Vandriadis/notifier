#!/bin/bash

# Configuration
WATCH_DIR="/Users/pupkin/Downloads"                                                               # Directory to monitor
LOG_FILE="/Users/pupkin/Desktop/work/bash_scripts/dir_changes_notification/directory_watcher.log" # Log file to record changes
TELEGRAM_BOT_TOKEN="815505xxxx:xxxxxxxxxxxxuN14G6IiPanKgKb54"
TELEGRAM_CHAT_ID="36xxxxx24"
EMAIL_RECIPIENT="pupkin@gmail.com"
EMAIL_SENDER="pupkin@gmail.com"
SMTP_SERVER="smtp.gmail.com"
SMTP_PORT="587"
SMTP_USER="pupkin@gmail.com"
SMTP_PASS="cnxx xxxx xxxx xxbz"

# Ensure dependencies are installed
check_dependencies() {
    local deps=("fswatch" "curl" "mail")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null; then
            printf "Error: %s is not installed.\n" "$dep" >&2
            return 1
        fi
    done
    return 0
}

# Initialize log file
init_log_file() {
    if [[ ! -f "$LOG_FILE" ]]; then
        touch "$LOG_FILE" || {
            printf "Error: Cannot create log file at %s\n" "$LOG_FILE" >&2
            return 1
        }
    fi
    return 0
}

# Send notification to Telegram
notify_telegram() {
    local message="$1"
    if ! curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=$message" >/dev/null; then
        printf "Error: Failed to send Telegram notification.\n" >&2
    fi
}

# Send notification via email
notify_email() {
    local subject="$1"
    local body="$2"
    sendemail -f "$EMAIL_SENDER" -t "$EMAIL_RECIPIENT" -u "$subject" -m "$body" \
        -s "$SMTP_SERVER:$SMTP_PORT" -xu "$SMTP_USER" -xp "$SMTP_PASS" -o tls=yes
    if [ $? -eq 0 ]; then
        echo "Email sent successfully"
    else
        echo "Failed to send email"
    fi
}

# Monitor directory and handle changes
monitor_directory() {
    fswatch -r "$WATCH_DIR" | while read -r event; do
        local timestamp
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")

        # Event description based on detected change
        local event_type
        if [[ -f "$event" && ! -e "$event.bak" ]]; then
            event_type="File Created"
        elif [[ ! -e "$event" ]]; then
            event_type="File Deleted"
        elif [[ -f "$event" ]]; then
            event_type="File Modified"
        else
            event_type="File Moved or Renamed"
        fi

        # Log the change
        local log_entry
        log_entry="[$timestamp] $event_type: $event"
        printf "%s\n" "$log_entry" >>"$LOG_FILE"

        # Construct notification message
        local notification="Directory Watcher Notification
        Change detected:
        Type: $event_type
        File: $event
        Timestamp: $timestamp"

        # Send Telegram notification
        notify_telegram "$notification"
        echo "Sending email notification..."
        notify_email "Directory Change Notification" "$notification"
    
    done
}

# Main function
main() {
    if ! check_dependencies; then
        return 1
    fi

    if ! init_log_file; then
        return 1
    fi

    printf "Monitoring directory: %s\n" "$WATCH_DIR"
    monitor_directory
}

main "$@"
