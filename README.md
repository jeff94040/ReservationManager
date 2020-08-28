## Reservation Manager

Reservation Manager is a bash script that periodically checks hotels for availability. In its current form, the script is hardcoded to ping The Ahwahnee Hotel in Yosemite Valley every five minutes for a change in availability during 7/8/19-7/11/19. When a change in availability is detected, a text and email notification is sent to the end user utilizing the mail server smtp.gmail.com.

### Prerequisites

1. Linux
2. Bash
3. jq (command line JSON parser)
4. Git

### Install the script

%> git clone <repo>

### Script Usage

%> ./reservation_manager.sh <from_email_address> <from_email_password> <to_email_address> <to_text_address>

