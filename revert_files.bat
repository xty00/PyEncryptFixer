@echo off
setlocal enabledelayedexpansion

REM 定义目标文件夹
set "folder_path=."

REM 遍历文件夹及其子文件夹中的所有文件
for /r "%folder_path%" %%f in (*_py) do (
    set "file_name=%%~nxf"
    set "new_file_name=!file_name:_py=.py!"
    set "full_path=%%f"
    set "new_full_path=%%~dpf!new_file_name!"

    REM 检查目标文件是否已存在
    if exist "!new_full_path!" (
        echo 警告: 目标文件 "!new_full_path!" 已存在。
        set "response="
        set /p "response=是否要替换？(Y/N): "
        if /i "!response!"=="Y" (
            REM 使用强制覆盖模式
            move /Y "!full_path!" "!new_full_path!" >nul
            if !errorlevel! equ 0 (
                echo 已覆盖 "!file_name!" 到 "!new_file_name!"。
            ) else (
                echo 错误: 无法覆盖 "!file_name!" 到 "!new_file_name!"。
            )
        ) else (
            echo 跳过重命名 "!file_name!"。
        )
    ) else (
        REM 正常重命名文件
        move "!full_path!" "!new_full_path!" >nul
        if !errorlevel! equ 0 (
            echo 已将 "!file_name!" 改回 "!new_file_name!"。
        ) else (
            echo 错误: 无法将 "!file_name!" 改回 "!new_file_name!"。
        )
    ) 
)

endlocal
pause