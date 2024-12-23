#!/bin/bash

# Configuration
WATCH_DIR="/Users/vandriadis/Downloads"     # Directory to monitor
LOG_FILE="/Users/vandriadis/Desktop/work/bash_scripts/dir_changes_notification/directory_watcher.log"   # Log file to record changes
TELEGRAM_BOT_TOKEN="8155056820:AAH5wQt2-6M61bzKtWuN14G6IiPanKgKb54"
TELEGRAM_CHAT_ID="365102824"

# Ensure dependencies are installed
check_dependencies() {
    local deps=("fswatch" "curl")
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
        touch "$LOG_FILE" || { printf "Error: Cannot create log file at %s\n" "$LOG_FILE" >&2; return 1; }
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
        printf "%s\n" "$log_entry" >> "$LOG_FILE"

        # Construct notification message
        local notification="Directory Watcher Notification
        Change detected:
        Type: $event_type
        File: $event
        Timestamp: $timestamp"

        # Send Telegram notification
        notify_telegram "$notification"
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
