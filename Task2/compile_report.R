# Скрипт для компиляции LaTeX отчета Task2
# Использует XeLaTeX для поддержки русского языка

if (requireNamespace("tinytex", quietly = TRUE)) {
  cat("Компиляция отчета Task2...\n")
  cat("Используется XeLaTeX для report.tex (polyglossia)\n")
  
  # Компиляция с XeLaTeX
  tryCatch({
    tinytex::xelatex("Task2/report.tex")
    tinytex::xelatex("Task2/report.tex")  # Дважды для правильных ссылок
    cat("✓ Отчет успешно скомпилирован: Task2/report.pdf\n")
  }, error = function(e) {
    cat("✗ Ошибка при компиляции:", e$message, "\n")
    cat("Убедитесь, что:\n")
    cat("  1. Запущен R скрипт task2.1.r для генерации графиков\n")
    cat("  2. Все необходимые пакеты установлены\n")
  })
  
} else {
  cat("Пакет tinytex не установлен. Установите его командой:\n")
  cat("install.packages('tinytex')\n")
  cat("tinytex::install_tinytex()\n")
}

