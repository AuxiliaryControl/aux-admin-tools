#!/bin/bash

# Base directories within the repo
# This path will be replaced during installation
BASE_DIR="__INSTALL_PATH__"

LOGS_DIR="$BASE_DIR/logs"
QUESTIONS_DIR="$BASE_DIR/questions"
TODOS_DIR="$BASE_DIR/todos"

# Ensure directories exist
mkdir -p "$LOGS_DIR" "$QUESTIONS_DIR" "$TODOS_DIR"

# Current date
TODAY="$(date +'%Y-%m-%d')"
TIMESTAMP="$(date +'%H:%M:%S')"

# File paths
LOG_FILE="$LOGS_DIR/$TODAY.log"
OPEN_QUESTIONS_FILE="$QUESTIONS_DIR/open_questions.md"
ANSWERED_QUESTIONS_FILE="$QUESTIONS_DIR/answered_questions.md"
OPEN_TODOS_FILE="$TODOS_DIR/open_todos.md"
COMPLETED_TODOS_FILE="$TODOS_DIR/completed_todos.md"

# Initialize files if they don't exist
touch "$OPEN_QUESTIONS_FILE" "$ANSWERED_QUESTIONS_FILE" "$OPEN_TODOS_FILE" "$COMPLETED_TODOS_FILE"

# Determine which function was called
COMMAND_NAME="$(basename "$0")"

# =============================================================================
# LOG FUNCTION
# =============================================================================
log_message() {
  if [ -z "$1" ]; then
    echo "Usage: log \"your message\""
    exit 1
  fi
  echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
  echo "Logged to $LOG_FILE"
}

# =============================================================================
# QUESTION FUNCTION
# =============================================================================
add_question() {
  if [ -z "$1" ]; then
    echo "Usage: question \"your question\""
    exit 1
  fi
  echo "[$TODAY $TIMESTAMP] $1" >> "$OPEN_QUESTIONS_FILE"
  echo "Question added to $OPEN_QUESTIONS_FILE"
}

answer_question_interactive() {
  if [ ! -s "$OPEN_QUESTIONS_FILE" ]; then
    echo "No open questions."
    exit 0
  fi

  echo "Open Questions:"
  echo "---------------"
  i=1
  lines=()
  while IFS= read -r line; do
    echo "$i. $line"
    lines+=("$line")
    i=$((i+1))
  done < "$OPEN_QUESTIONS_FILE"

  echo ""
  echo -n "Select question to answer (or press Enter to cancel): "
  read qnum

  if [ -z "$qnum" ]; then
    echo "Cancelled."
    exit 0
  fi

  if [ "$qnum" -ge 1 ] && [ "$qnum" -le "${#lines[@]}" ]; then
    selected="${lines[$((qnum-1))]}"
    echo ""
    echo "Question: $selected"
    echo ""
    echo -n "Answer: "
    read answer

    if [ -z "$answer" ]; then
      echo "No answer provided. Cancelled."
      exit 0
    fi

    # Add to answered questions
    {
      echo ""
      echo "Q: $selected"
      echo "A: [$TODAY $TIMESTAMP] $answer"
    } >> "$ANSWERED_QUESTIONS_FILE"

    # Remove from open questions
    sed "${qnum}d" "$OPEN_QUESTIONS_FILE" > "$OPEN_QUESTIONS_FILE.tmp" && mv "$OPEN_QUESTIONS_FILE.tmp" "$OPEN_QUESTIONS_FILE"

    echo ""
    echo "Question answered and moved to $ANSWERED_QUESTIONS_FILE"
  else
    echo "Invalid selection."
    exit 1
  fi
}

# =============================================================================
# TODO FUNCTION
# =============================================================================
add_todo() {
  if [ -z "$1" ]; then
    echo "Usage: todo \"your task\""
    exit 1
  fi
  echo "[$TODAY $TIMESTAMP] $1" >> "$OPEN_TODOS_FILE"
  echo "Todo added to $OPEN_TODOS_FILE"
}

complete_todo_interactive() {
  if [ ! -s "$OPEN_TODOS_FILE" ]; then
    echo "No open todos."
    exit 0
  fi

  echo "Open Todos:"
  echo "-----------"
  i=1
  lines=()
  while IFS= read -r line; do
    echo "$i. $line"
    lines+=("$line")
    i=$((i+1))
  done < "$OPEN_TODOS_FILE"

  echo ""
  echo -n "Select todo to complete (or press Enter to cancel): "
  read tnum

  if [ -z "$tnum" ]; then
    echo "Cancelled."
    exit 0
  fi

  if [ "$tnum" -ge 1 ] && [ "$tnum" -le "${#lines[@]}" ]; then
    selected="${lines[$((tnum-1))]}"

    # Add to completed todos with completion timestamp
    {
      echo ""
      echo "$selected"
      echo "  Completed: [$TODAY $TIMESTAMP]"
    } >> "$COMPLETED_TODOS_FILE"

    # Remove from open todos
    sed "${tnum}d" "$OPEN_TODOS_FILE" > "$OPEN_TODOS_FILE.tmp" && mv "$OPEN_TODOS_FILE.tmp" "$OPEN_TODOS_FILE"

    echo ""
    echo "Todo completed and moved to $COMPLETED_TODOS_FILE"
  else
    echo "Invalid selection."
    exit 1
  fi
}

# =============================================================================
# MAIN DISPATCH
# =============================================================================
case "$COMMAND_NAME" in
  log)
    log_message "$1"
    ;;
  question)
    if [ -z "$1" ]; then
      answer_question_interactive
    else
      add_question "$1"
    fi
    ;;
  todo)
    if [ -z "$1" ]; then
      complete_todo_interactive
    else
      add_todo "$1"
    fi
    ;;
  *)
    echo "This script should be called as 'log', 'question', or 'todo'"
    exit 1
    ;;
esac
