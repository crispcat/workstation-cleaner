@echo on
xcopy ".\*" "C:\workstation-cleaner\" /i /c /e /y
start C:\workstation-cleaner\cleaner.bat