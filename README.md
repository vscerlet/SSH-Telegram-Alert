**🔐 SSH Telegram Alerts**

A lightweight and secure bash script for real-time SSH login monitoring through Telegram notifications. Get instant alerts whenever someone connects to your server with detailed information about who, when, and from where.

**Why this solution:**

- **Secure PAM integration** - Unlike scripts in `/etc/profile.d/`, this approach cannot be bypassed by attackers using direct shell access[^6_1]
- **Zero dependencies** - Only requires bash and curl, no additional packages needed
- **Instant notifications** - Real-time alerts with server hostname, username, source IP, and timestamp
- **Production-ready** - Graceful error handling ensures SSH functionality remains unaffected even if notification delivery fails

Perfect for system administrators, DevOps engineers, and security-conscious users who want to monitor server access without complex monitoring solutions. Simple setup, robust security, maximum reliability.

# 🛠️ Инструкция по установке

## 1. Настройка Telegram бота

### Создание бота

1. Напишите [@BotFather](https://t.me/BotFather) в Telegram
2. Отправьте команду `/newbot`
3. Следуйте инструкциям для создания бота
4. Сохраните полученный **TOKEN**

### Получение Chat ID

1. Напишите любое сообщение вашему боту
2. Выполните команду для получения обновлений:
```bash
curl "https://api.telegram.org/bot{TOKEN}/getUpdates"
```

3. В ответе найдите значение `chat.id` - это ваш **CHAT_ID**

## 2. Настройка скрипта

Отредактируйте файл `ssh-tg-alert.sh`, заменив пустые значения на ваши:

```bash
TOKEN="ваш_токен_бота"
CHAT_ID="ваш_chat_id"
```


## 3. Установка в систему

Переместите скрипт в системную директорию:

```bash
sudo mv ssh-tg-alert.sh /usr/local/sbin/ssh-tg-alert.sh
```


## 4. Настройка безопасности

Установите правильные права доступа:

```bash
sudo chown root:root /usr/local/sbin/ssh-tg-alert.sh
sudo chmod 500 /usr/local/sbin/ssh-tg-alert.sh
```


## 5. Настройка PAM

Добавьте следующую строку в файл `/etc/pam.d/sshd`:

```bash
session optional pam_exec.so type=open_session seteuid /usr/local/sbin/ssh-tg-alert.sh
```

**Рекомендация:** Добавьте строку в конец файла, после других `session` директив.

## 6. Перезапуск SSH сервера

### Для систем с systemctl:

```bash
sudo systemctl restart sshd
# или
sudo systemctl restart ssh
```


### Для старых систем Ubuntu/Debian:

```bash
sudo service ssh restart
# или
sudo /etc/init.d/ssh restart
```


## 7. Проверка работы

Подключитесь к серверу по SSH из другого терминала - вы должны получить уведомление в Telegram.

⚠️ **Важно:** Протестируйте настройку, не закрывая текущую SSH-сессию, чтобы не заблокировать себе доступ к серверу в случае ошибки конфигурации.
