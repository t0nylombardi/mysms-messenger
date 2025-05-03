# MySMS Messenger

MySMS Messenger is a full-stack messaging web application that allows users to send and view SMS messages via Twilio.

Built with **Angular** on the frontend and **Ruby on Rails** (with **MongoDB**) on the backend, this monorepo supports basic messaging functionality, user authentication, and Twilio delivery tracking via webhooks.

---
## 📁 Project Structure

```plaintext
my-sms-messenger/
├── backend/ # Ruby on Rails API with MongoDB
├── frontend/ # Angular client (PNPM-managed)
```

---

## 🧰 Tech Stack

| Layer      | Technology           |
|------------|----------------------|
| Frontend   | Angular (latest)     |
| Backend    | Ruby on Rails 8      |
| Database   | MongoDB              |
| Messaging  | Twilio API           |
| Auth       | Devise + devise-jwt  |
| Hosting    | AWS EC2              |
---

## 🚀 Features

- ✅ Send SMS messages via Twilio
- ✅ View previously sent messages
- ✅ Session-based message isolation
- ✅ MongoDB persistence
- 🔒 User authentication (via Devise) *(Bonus 1)*
- 🌐 Deployed live version *(Bonus 2)*
---

## ⚙️ Setup Instructions

### Prerequisites

- Ruby 3.x
- Rails 8.x
- MongoDB (local or Atlas)
- Node.js + PNPM
- Twilio Account (free tier is OK)

---

### 🔧 Backend Setup (`backend/`)

```bash
cd backend

# Install dependencies
bundle install

# Create and migrate the MongoDB database
rails db:mongoid:create_collections
```

Create config/master/key
This is required for encrypted credentials

If you want to use the existing key, please reachout to [me](mailto:alombardi.331@gmail.com)
```bash
 touch config/master.key
```

Or create your own this will create a new key

```bash
 EDITOR="code/vi/vim... --wait" rails credentials:edit
```

Set your environment credentials in `credentials.yml.enc`

For simpilicity reasons, I made my credentials for all environments the same file. This is not a good practice, but for this project, it is fine.

```yaml
default: &default
  devise_jwt:
    secret_key:
  twilio:
    account_sid:
    auth_token:
    from_number:

production:
  <<: *default

development:
  <<: *default

test:
  <<: *default

secret_key_base:
```
Start the Rails server

```bash
rails s
```
This will start the server on `localhost:3000`

---

### 💻 Frontend Setup (frontend/)

```bash
cd frontend

# Install dependencies
pnpm install

# Start dev server
pnpm start
```

### 🔐 Authentication

Users can:
- Register with a username & password
- Authenticate via JWT
- See only their own messages

Powered by blood, sweat, cafiene..more cafiene, Devise and Devise-jwt, thoughts of what I am doing with my life, and a sprinkle of magic.

### 📎 License
MIT © 2025 Anthony Lombardi

---
