# Скрипт для компиляции LaTeX отчета
# Вариант 1: Использование XeLaTeX (рекомендуется для русского языка с polyglossia)
# Вариант 2: Использование pdflatex (требует установки babel-russian)

if (requireNamespace("tinytex", quietly = TRUE)) {
  cat("Компиляция отчета...\n")
  cat("Используется XeLaTeX для report.tex (polyglossia)\n")
  
  # Компиляция с XeLaTeX (для report.tex с polyglossia)
  tryCatch({
    tinytex::xelatex("Task1/report.tex")
    tinytex::xelatex("Task1/report.tex")  # Дважды для правильных ссылок
    cat("Отчет успешно скомпилирован: Task1/report.pdf\n")
  }, error = function(e) {
    cat("Ошибка при компиляции с XeLaTeX. Попробуйте альтернативный вариант:\n")
    cat("  tinytex::pdflatex('Task1/report_pdflatex.tex')\n")
    cat("  (требует установки: tinytex::tlmgr_install('babel-russian'))\n")
  })
  
} else {
  cat("Пакет tinytex не установлен. Установите его командой:\n")
  cat("install.packages('tinytex')\n")
  cat("tinytex::install_tinytex()\n")
}

