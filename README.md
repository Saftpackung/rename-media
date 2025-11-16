# Media File Renamer

A bash script that automatically renames media files (photos and videos) based on their metadata timestamps, making it easy to organize your media chronologically.

## Features

- Renames files to `YYYY-MM-DD_HH-MM-SS.ext` format
- Automatically handles duplicate timestamps with incremental numbers
- Works with photos and videos
- Uses metadata timestamps (EXIF/creation date) for accurate naming
- Processes all files in a specified directory
- Optional recursive processing for subdirectories

## Prerequisites

### Linux

ExifTool must be installed on your system:

```bash
# Debian/Ubuntu
sudo apt-get install libimage-exiftool-perl

# Fedora/RHEL
sudo dnf install perl-Image-ExifTool

# Arch Linux
sudo pacman -S perl-image-exiftool
```

### Windows

1. **Install Git Bash** (recommended) or WSL (Windows Subsystem for Linux)
   - Git Bash: Download from [git-scm.com](https://git-scm.com/downloads)
   - WSL: Follow [Microsoft's WSL installation guide](https://docs.microsoft.com/en-us/windows/wsl/install)

2. **Install ExifTool**:
   - Download from [exiftool.org](https://exiftool.org/)
   - Extract `exiftool(-k).exe` and rename it to `exiftool.exe`
   - Place it in a directory that's in your PATH, or in the same folder as the script

## Installation

1. Clone or download this repository:
   ```bash
   git clone <your-repo-url>
   cd <repo-directory>
   ```

2. Make the script executable (Linux/Mac/WSL):
   ```bash
   chmod +x rename_media.sh
   ```

## Usage

### Basic Usage

Rename all media files in the current directory (non-recursive):
```bash
./rename_media.sh
```

### Specify a Directory

Rename all media files in a specific directory (non-recursive):
```bash
./rename_media.sh /path/to/your/media/folder
```

### Recursive Processing

To process subdirectories recursively, use the `-r` flag:

```bash
./rename_media.sh -r /path/to/your/media/folder
```

This will rename all media files in the specified directory **and all its subdirectories**.

**Examples:**

**Windows (Git Bash):**
```bash
# Single directory only
./rename_media.sh "C:/Users/YourName/Pictures/Vacation"

# Directory and all subdirectories
./rename_media.sh -r "C:/Users/YourName/Pictures/Vacation"
```

**Linux:**
```bash
# Single directory only
./rename_media.sh ~/Pictures/2024-vacation

# Directory and all subdirectories
./rename_media.sh -r ~/Pictures/2024-vacation
```

## How It Works

The script uses ExifTool to read metadata from your media files and renames them based on timestamps in this priority order:

1. **DateTimeOriginal** - The original capture date/time (photos)
2. **CreateDate** - The file creation date
3. **MediaCreateDate** - Media creation date (videos)
4. **FileModifyDate** - File modification date (fallback)

### Example Transformations

```
Before:              After:
IMG_1234.jpg    →    2024-07-15_14-30-25.jpg
DSC_5678.JPG    →    2024-07-15_14-30-26.jpg
VID_9012.mp4    →    2024-07-15_15-45-10.mp4
IMG_1234.jpg    →    2024-07-15_14-30-25-1.jpg  (duplicate timestamp)
```

## Supported File Types

The script works with any file format that contains EXIF or metadata, including:

- **Images**: JPG, JPEG, PNG, HEIC, TIFF, RAW formats
- **Videos**: MP4, MOV, AVI, MKV, M4V
- **Other**: Any file with embedded metadata

## Safety Notes

⚠️ **Important**: This script renames files in place without creating backups. Consider these precautions:

1. **Test first**: Run on a copy of your files before processing originals
2. **Backup**: Always maintain backups of important media
3. **Review**: Check a few files after processing to ensure expected results

## Troubleshooting

### "exiftool: command not found"
- Make sure ExifTool is installed (see Prerequisites)
- On Windows, ensure `exiftool.exe` is in your PATH

### "Permission denied"
- On Linux/Mac: Make sure the script is executable with `chmod +x rename_media.sh`

### Files not renamed
- The file may not contain metadata timestamps
- Check ExifTool output for warnings or errors
- Some files may fall back to using FileModifyDate

### Script doesn't run on Windows
- Use Git Bash or WSL, not Command Prompt or PowerShell
- Ensure line endings are Unix-style (LF, not CRLF)

## Advanced Options

To modify the date format, edit the `DATE_FORMAT` variable in the script:

```bash
DATE_FORMAT="%Y-%m-%d_%H-%M-%S.%%e%%-c"
```

Format options:
- `%Y` - Year (4 digits)
- `%m` - Month (01-12)
- `%d` - Day (01-31)
- `%H` - Hour (00-23)
- `%M` - Minute (00-59)
- `%S` - Second (00-59)
- `%%e` - File extension
- `%%-c` - Copy number for duplicates


## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Built using [ExifTool](https://exiftool.org/) by Phil Harvey

