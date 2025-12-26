# Скрипт для компиляции LaTeX отчета Task3
# Использует XeLaTeX для поддержки русского языка

if (requireNamespace("tinytex", quietly = TRUE)) {
  cat("Компиляция отчета Task3...\n")
  cat("Используется XeLaTeX для report.tex (polyglossia)\n")
  
  # Компиляция с XeLaTeX
  tryCatch({
    tinytex::xelatex("Task3/report.tex")
    tinytex::xelatex("Task3/report.tex")  # Дважды для правильных ссылок
    cat("✓ Отчет успешно скомпилирован: Task3/report.pdf\n")
  }, error = function(e) {
    cat("✗ Ошибка при компиляции:", e$message, "\n")
    cat("Убедитесь, что:\n")
    cat("  1. Запущен R скрипт task3.1.r для генерации графиков\n")
    cat("  2. Все необходимые пакеты установлены\n")
  })
  
} else {
  cat("Пакет tinytex не установлен. Установите его командой:\n")
  cat("install.packages('tinytex')\n")
  cat("tinytex::install_tinytex()\n")
}

