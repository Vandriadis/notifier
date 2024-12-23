# Directory Change Notification Script

A Bash script to monitor a specific directory for changes and notify the user via Telegram and email when changes occur. This is useful for tracking file additions, deletions, modifications, or movements in real-time.

## Features

- **Real-time Monitoring**: Uses `fswatch` to monitor a directory for changes.
- **Event Logging**: Logs detected changes with timestamps to a log file.
- **Telegram Notifications**: Sends detailed notifications via Telegram about detected changes.
- **Email Notifications**: Sends detailed notifications via email about detected changes.
- **Customizable**: Easily configure the directory to monitor, log file location, and notification details.

## Requirements

Ensure the following dependencies are installed on your system:

- [`fswatch`](https://emcrisostomo.github.io/fswatch/): For monitoring file system events.
- [`curl`](https://curl.se/): For sending notifications via Telegram.
- [`sendemail`](https://github.com/mogaal/sendemail): For sending email notifications.

## Installation

1. **Clone this repository**:
    ```bash
    git clone https://github.com/yourusername/directory-watcher.git
    cd directory-watcher
    ```

2. **Ensure dependencies are installed**:
    Install `fswatch`, `curl`, and `sendemail` using your package manager. For example:
    ```bash
    # macOS (Homebrew)
    brew install fswatch curl sendemail

    # Ubuntu/Debian
    sudo apt update
    sudo apt install fswatch curl sendemail
    ```

3. **Set up your environment**:
    - Update the `WATCH_DIR` variable in the script to specify the directory you want to monitor.
    - Update the `LOG_FILE` variable to set the location for the log file.
    - Provide your Telegram Bot Token and Chat ID in the `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` variables, respectively.
    - Provide your email address and SMTP server details in the `EMAIL_TO`, `SMTP_SERVER`, `SMTP_PORT`, `SMTP_USER`, and `SMTP_PASS` variables.

## Usage

1. **Make the script executable**:
    ```bash
    chmod +x directory_watcher.sh
    ```

2. **Run the script**:
    ```bash
    ./directory_watcher.sh
    ```

3. **View logs**:
    Changes are logged to the specified log file. By default:
    ```
    /Users/pupkin/Desktop/work/bash_scripts/dir_changes_notification/directory_watcher.log
    ```

4. **Telegram Notifications**:
    Receive real-time Telegram notifications about directory changes, including the type of change, the affected file, and a timestamp.

5. **Email Notifications**:
    Receive real-time email notifications about directory changes, including the type of change, the affected file, and a timestamp.

## Script Configuration

You can customize the following variables in the script:

- `WATCH_DIR`: The directory to monitor.
- `LOG_FILE`: Path to the log file where changes are recorded.
- `TELEGRAM_BOT_TOKEN`: Your Telegram bot token.
- `TELEGRAM_CHAT_ID`: Your Telegram chat ID.
- `EMAIL_TO`: The email address to send notifications to.
- `SMTP_SERVER`: The SMTP server address.
- `SMTP_PORT`: The SMTP server port.
- `SMTP_USER`: The SMTP username.
- `SMTP_PASS`: The SMTP password.

## Example Notification

Here’s an example of a Telegram notification you might receive:

Directory Watcher Notification Change detected: 
Type: File Created 
File: /Users/pupkin/Downloads/example.txt 
Timestamp: 2024-12-23 14:45:00

## Troubleshooting

- **Error: `fswatch`, `curl`, or `sendemail` not found**:
    Ensure that the required dependencies are installed and available in your system's PATH.

- **Telegram notifications not working**:
    - Verify the bot token and chat ID are correctly configured.
    - Check if the bot has permission to send messages to your chat.

- **Email notifications not working**:
    - Verify the email address and SMTP server details are correctly configured.
    - Ensure your system is configured to send emails.

- **Log file not created**:
    Ensure the script has permission to write to the specified log file path.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve the functionality or documentation.

## Acknowledgements

- Thanks to the developers of `fswatch`, `curl`, and `sendemail` for their powerful tools.
- Inspired by the need for simple, real-time directory monitoring.

---

Feel free to reach out with feedback or feature requests!