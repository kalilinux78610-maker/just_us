@echo off
setlocal enabledelayedexpansion
set "p=%~1"
set "prefix=%~2"
set "i=1"
for %%f in ("%p%\*.webp") do (
    move /y "%%f" "s:\just app\assets\stickers\!prefix!_!i!.webp"
    set /a i+=1
)
