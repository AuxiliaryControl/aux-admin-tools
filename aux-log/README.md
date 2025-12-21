# 📝 aux-log

**aux-log** is a lightweight shell script for tracking your daily engineering workflow with minimal effort. It provides three simple commands for logging activities, managing questions, and tracking todos — all stored in version-controlled directories within this repo.

---

## 📦 Installation

Run the install script from this directory:

```bash
chmod +x install.sh
./install.sh
```

This will:
- Lock in the current repo location for storing all data
- Install the `log`, `question`, and `todo` commands to `/usr/local/bin`
- Allow you to run these commands from anywhere on your system

## 🗑️ Uninstallation

```bash
./uninstall.sh
```

Note: This removes the commands but preserves your data in `logs/`, `questions/`, and `todos/`.

---

## 📝 Usage

### Basic Logging
Log any activity, setting change, or task completion:

```bash
log "Fixed ingress redirect bug in staging"
log "Updated Kubernetes node pool to v1.28"
log "Changed database connection pool size to 50"
```

Logs are stored in `logs/YYYY-MM-DD.log` with timestamps.

### Question Tracking

Add a new question:
```bash
question "Why does CoreDNS restart on update?"
question "What's the difference between ClusterIP and NodePort?"
```

Answer questions interactively:
```bash
question
```

This will:
1. Show all open questions
2. Let you select one to answer
3. Move it to `questions/answered_questions.md` with your answer

### Todo Management

Add a new todo:
```bash
todo "Refactor Helm chart for observability"
todo "Write K8s node pool playbook"
```

Complete todos interactively:
```bash
todo
```

This will:
1. Show all open todos
2. Let you select one to complete
3. Move it to `todos/completed_todos.md` with completion timestamp

---

## 📂 Data Storage

All data is stored within this repo for version control:

```
.
├── logs/
│   ├── 2025-12-21.log
│   ├── 2025-12-22.log
│   └── ...
├── questions/
│   ├── open_questions.md
│   └── answered_questions.md
└── todos/
    ├── open_todos.md
    └── completed_todos.md
```

---

## 🧠 Why Use This?
- **Audit trail**: Track every change and decision
- **Version controlled**: All logs stored in git
- **Simple**: Just type `log "message"` from anywhere
- **Knowledge base**: Build a searchable history of your work
- **Context retention**: Never forget why you made a change


