#!/bin/bash

# Трапы для очистки временных файлов
cleanup() {
    echo "Очистка временных файлов..."
    rm -f "$LOG_FILE"
}
trap cleanup EXIT

# Переменные
SEARCH_DIR=${1:-.}       # Директория для поиска (по умолчанию текущая)
OLD_TEXT="old_text"      # Текст для замены
NEW_TEXT="new_text"      # Текст, на который заменить
LOG_FILE=$(mktemp)       # Временный файл для логов

# Функция: Проверка наличия утилит
check_dependencies() {
    for cmd in sed find; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "Ошибка: Утилита '$cmd' не установлена."
            exit 1
        fi
    done
}

# Функция: Обработка найденных файлов
process_files() {
    local file=$1
    echo "Обработка файла: $file"

    # Редактирование файла с использованием sed
    sed -i "s/$OLD_TEXT/$NEW_TEXT/g" "$file"
    echo "Изменения внесены в файл: $file" >> "$LOG_FILE"
}

# Проверка зависимостей
check_dependencies

# Поиск и обработка файлов
echo "Поиск файлов в директории: $SEARCH_DIR"
find "$SEARCH_DIR" -type f -name "*.txt" | while read -r file; do
    process_files "$file"
done

# Вывод лога изменений
echo "Все изменения завершены. Лог изменений:"
cat "$LOG_FILE"