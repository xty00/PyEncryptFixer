# PyEncryptFixer

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


## 简介

**PyEncryptFixer** 是一个用于解决自动加密 .py 文件导致的执行错误的自动化脚本，可用于处理DGS加密的”.py“文件。由于某些加密工具可能会导致 .py 文件无法正常执行，PyEncryptFixer 通过模拟用户操作，将加密后的 .py 文件转换为可执行的 _py 文件格式，并提供恢复功能，将文件改回原始的 .py 格式。

被加密后的文件图标是这样的
![image](img/%E8%A2%AB%E5%8A%A0%E5%AF%86%E7%9A%84%E6%96%87%E4%BB%B6%E5%B7%A6%E4%B8%8B%E8%A7%92%E6%9C%89%E5%B0%8F%E9%94%81%E5%9B%BE%E6%A0%87%EF%BC%8C%E8%A7%A3%E5%AF%86%E5%90%8E%E8%AF%B7%E6%A3%80%E6%9F%A5%E5%B0%8F%E9%94%81%E5%9B%BE%E6%A0%87%E6%9C%89%E6%B2%A1%E6%9C%89%E6%B6%88%E5%A4%B1.png)
,左下角有小锁图标说明加密了。

在没有加密的电脑打开了是乱码

![image](img/%E5%8A%A0%E5%AF%86%E6%96%87%E4%BB%B6%E5%B1%95%E7%A4%BA%E6%95%88%E6%9E%9C.png)

## 功能

- **自动查找并点击 UI 元素**: 使用图像识别技术自动定位并点击 Notepad++ 中的特定 UI 元素。
- **文件格式转换**: 将加密后的 `.py` 文件另存为 `_py` 文件，确保文件能够正常执行。
- **删除原始文件**: 转换成功后，自动删除原始的加密 `.py` 文件。
- **恢复功能**: 提供恢复功能，将 `_py` 文件改回原始的 `.py` 文件格式。

## 前提条件

在开始使用 PyEncryptFixer 之前，请确保您的系统满足以下要求：

1. **操作系统**: Windows（由于使用了 Notepad++ 和 PyAutoGUI）
2. **安装的软件**:
   - [Notepad++](https://notepad-plus-plus.org/)（确保路径正确）
   - [Python](https://www.python.org/downloads/)（建议使用 Python 3.6 及以上版本）
3. **Python 依赖库**:
   - `opencv-python`
   - `pyautogui`
   - `numpy`（可选，用于图像处理）

## 安装

### 1. 克隆仓库

首先，克隆本仓库到您的本地计算机：

```bash
git clone https://github.com/xty00/PyEncryptFixer.git
cd PyEncryptFixer
```

### 2. 安装 Python 依赖

建议使用 [虚拟环境](https://docs.python.org/3/library/venv.html) 来管理项目的依赖：

```bash
# 创建虚拟环境（可选）
python -m venv venv

# 激活虚拟环境
# Windows:
venv\Scripts\activate


# 安装依赖
pip install -r requirements.txt
```

如果您没有使用虚拟环境，可以直接安装依赖：

```bash
pip install opencv-python pyautogui
```

### 3. 配置 Notepad++ 路径

确保在 `fixpyfile` 文件中，`notepadpp_path` 变量指向您的 Notepad++ 安装路径。例如：

```python
notepadpp_path = r"C:\Program Files\Notepad++\notepad++.exe"
```

如果您的 Notepad++ 安装在其他路径，请相应地修改。

### 4. 参照注释修改Notepad++快捷键定义

有的电脑在加密后特定快捷键存在冲突现象，我的就是这种情况，所以修改了 Notepad++ “另存为”的默认快捷键。请确保在 `fixpyfile` 文件中，“另存为”的快捷键定义与 Notepad++ 中一致，如不一致请修改 `fixpyfile` 文件相关定义，如将下列位置 

```python
    # 模拟按下 Ctrl + Shift + S 打开“另存为”对话框
    pyautogui.hotkey('ctrl', 'shift', 's')
    time.sleep(1)  # 等待对话框出现
```
替换为
```python
    # 模拟按下 Ctrl + Alt + S 打开“另存为”对话框
    pyautogui.hotkey('ctrl', 'alt', 's')
    time.sleep(1)  # 等待对话框出现
```

或者调整 Notepad++ 中快捷键的配置,修改位置如下：

在 Notepad++ 上方快捷菜单点击【运行(R)】,选择【管理快捷键...】,在【快捷键管理】弹出窗切换至【主菜单】标签页，双击【另存为(A)...】,在弹出窗勾选需要调整的快捷键如 CTRL + SHIFT + S，修改完毕后点击【确定】进行保存，当出现快捷键冲突时将冲突的快捷键调整成其他内容，如“全部保存(E)”存在冲突，则将其快捷键调整为 CTRL + ALT + S。

![image](img/%E4%BF%AE%E6%94%B9notepad%2B%2B%E5%BF%AB%E6%8D%B7%E9%94%AE%E5%AE%9A%E4%B9%89.png)


## 使用方法

### 1. 准备模板图片

PyEncryptFixer 使用图像识别来定位 UI 元素。您需要提供以下模板图片，并将其放在 `templates` 文件夹中：

- `file_type_dropdown.png`: 文件类型下拉菜单的截图。
- `all_types_template.png`: “所有文件类型”选项的截图。

确保这些图片与实际 UI 元素匹配，以提高识别精度。

### 2. 运行转换脚本
主文件名为 fixpyfile ，没有加 .py 后缀,不影响运行
在项目根目录下，运行以下命令启动转换过程：

```bash
python fixpyfile
```

脚本将执行以下操作：

1. 遍历当前文件夹中的所有 `.py` 文件。
2. 使用 Notepad++ 打开每个文件。
3. 按 `Ctrl + Shift + S` 打开“另存为”对话框。
4. 选择“所有文件类型”并保存为 `_py` 文件。
5. 删除原始的 `.py` 文件。
6. 关闭 Notepad++ 窗口。

### 3. 恢复文件（可选）

如果您需要将 `_py` 文件恢复为 `.py` 文件，可以取消注释 `revert_files()` 函数并运行脚本：

```python
if __name__ == "__main__":
    convert_files()
    revert_files()  # 取消注释以启用恢复功能
```

或者，您可以单独运行恢复功能：

```python
python fixpyfile
```

然后在代码中调用 `revert_files()` 函数。


### 项目文件结构示意

```
PyEncryptFixer/
│
├── fixpyfile          #主文件1，用于改名解密
├── revert_files.bat   #主文件2，用于恢复文件名.py
├── cklock.ps1         #主文件3，用于检查并反馈被查文件加密情况
├── requirements.txt   #虚拟环境依赖配置文件
├── test.py            #已被加密的测试文件
├── test.ps1           #加密情况预览脚本，用于评估当前文件夹中可识别的文件加密情况
├── templates/         #模板文件夹
│   ├── file_type_dropdown.png    #用于确认文件类型下拉菜单的位置,可以根据电脑的实际情况进行重新截屏及替换操作，文件名一致即可
│   └── all_types_template.png    #用于确认已选中文件类型“All Type(*.*)”,可以根据电脑的实际情况进行重新截屏及替换操作，文件名一致即可
|── img/                          #其他补充说明截屏文件夹
├── README.md          #此说明文件
└── LICENSE            #协议
```


## 注意事项

1. **备份文件**: 在运行脚本之前，建议备份您的 `.py` 文件，以防止意外的数据丢失。
2. **UI 元素匹配**: 图像识别依赖于模板图片的准确性。请确保提供的模板图片与实际 UI 元素完全匹配。
3. **权限**: 运行脚本时，请确保具有对目标文件夹和文件的读写权限。
4. **依赖库版本**: 使用与项目兼容的 Python 版本和依赖库版本，以避免潜在的兼容性问题。

## 示例

以下是一个简单的使用示例：

```bash
# 激活虚拟环境
venv\Scripts\activate

# 运行转换脚本
python fixpyfile
```
测试解密后的python脚本：

```bash
python test.py
```

## 贡献

欢迎提出问题（Issues）和拉取请求（Pull Requests）。如果您在使用过程中遇到任何问题或有任何改进建议，请随时在 [Issues](https://github.com/xty00/PyEncryptFixer/issues) 页面中提出。

## 许可证

该项目采用 [MIT 许可证](https://opensource.org/licenses/MIT)。详细信息请参见 [LICENSE](LICENSE) 文件。

---

### 补充说明

- **图像识别**: 由于脚本依赖于图像识别，确保在不同的操作系统和屏幕分辨率下，模板图片的匹配度足够高。如果匹配失败，可以尝试调整 `threshold` 参数或提供更高质量的模板图片。
- **日志记录**: 脚本中包含基本的打印语句，用于跟踪脚本的执行过程。您可以根据需要添加更详细的日志记录功能。
- **扩展功能**: 如果需要处理子文件夹中的文件，可以调整 `folder_path` 变量或修改 `os.walk` 的使用方式。
