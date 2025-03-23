@echo off
setlocal enabledelayedexpansion

REM 定义目标文件夹
set folder_path=.

REM 遍历文件夹及其子文件夹中的所有文件
for /r "%folder_path%" %%f in (*_py) do (
    set "file_name=%%~nxf"
    set "new_file_name=!file_name:_py=.py!"
    set "full_path=%%f"
    set "new_full_path=%%~dpf!new_file_name!"
    
    REM 重命名文件
    ren "!full_path!" "!new_file_name!"
    echo 已将 "!file_name!" 改回 "!new_file_name!"
)

endlocal
pause