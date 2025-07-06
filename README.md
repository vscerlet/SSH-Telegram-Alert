**🔐 SSH Telegram Alerts**

A lightweight and secure bash script for real-time SSH login monitoring through Telegram notifications. Get instant alerts whenever someone connects to your server with detailed information about who, when, and from where.

**Why this solution:**

- **Secure PAM integration** - Unlike scripts in `/etc/profile.d/`, this approach cannot be bypassed by attackers using direct shell access
- **Zero dependencies** - Only requires bash and curl, no additional packages needed
- **Instant notifications** - Real-time alerts with server hostname, username, source IP, and timestamp
- **Production-ready** - Graceful error handling ensures SSH functionality remains unaffected even if notification delivery fails

Perfect for system administrators, DevOps engineers, and security-conscious users who want to monitor server access without complex monitoring solutions. Simple setup, robust security, maximum reliability.

## Requirements

- `curl` - for sending HTTP requests to Telegram API
- `bash` - script interpreter

Most Linux distributions include these utilities by default.


# 🛠️ Installation instructions

## 1. Setting up the Telegram bot

### Creating a bot

1. Write [@BotFather](https://t.me/BotFather) in Telegram
2. Send the command `/newbot`
3. Follow the instructions to create a bot
4. Save the **TOKEN** you receive

### Obtaining Chat ID

1. Write any message to your bot
2. Run the command to receive updates:
```bash
curl “https://api.telegram.org/bot{TOKEN}/getUpdates”
```

3. In the response, find the value `chat.id` — this is your **CHAT_ID**

## 2. Configuring the script

Edit the file `ssh-tg-alert.sh`, replacing the empty values with your own:

```bash
TOKEN="your_bot_token"
CHAT_ID="your_chat_id"
```


## 3. Installing on the system

Move the script to the system directory:

```bash
sudo mv ssh-tg-alert.sh /usr/local/sbin/ssh-tg-alert.sh
```


## 4. Security settings

Set the correct access rights:

```bash
sudo chown root:root /usr/local/sbin/ssh-tg-alert.sh
sudo chmod 500 /usr/local/sbin/ssh-tg-alert.sh
```


## 5. PAM settings

Add the following line to the `/etc/pam.d/sshd` file:

```bash
session optional pam_exec.so type=open_session seteuid /usr/local/sbin/ssh-tg-alert.sh
```

**Recommendation:** Add the line to the end of the file, after the other `session` directives.

## 6. Restarting the SSH server

### For systems with systemctl:

```bash
sudo systemctl restart sshd
# or
sudo systemctl restart ssh
```


### For older Ubuntu/Debian systems:

```bash
sudo service ssh restart
# or
sudo /etc/init.d/ssh restart
```


## 7. Checking the configuration

Connect to the server via SSH from another terminal — you should receive a notification in Telegram.

⚠️ **Important:** Test the configuration without closing the current SSH session so that you don't block your access to the server in case of a configuration error.
