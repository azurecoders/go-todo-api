#!/bin/zsh

# Load .env file
export $(grep -v '^#' .env | xargs)

command=$1
name=$2

case $command in
  up)
    migrate -path migrations -database "$DATABASE_URL" up
    ;;
  
  down)
    count=${name:-1}
    echo "Rolling back $count migration(s). Continue? [y/N]"
    read confirm
    if [[ "$confirm" == "y" ]]; then
      migrate -path migrations -database "$DATABASE_URL" down $count
    fi
    ;;
  
  create)
    migrate create -ext sql -dir migrations -seq $name
    ;;
  
  force)
    migrate -path migrations -database "$DATABASE_URL" force $name
    ;;
  
  *)
    echo "Usage: ./migrate.sh [up|down|create|force] [name/count]"
    ;;
esac