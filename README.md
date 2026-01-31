# MiniGit - A Lightweight Version Control System

![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash&logoColor=white)
![C](https://img.shields.io/badge/C-Language-A8B9CC?logo=c&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Unix%2FLinux-FCC624?logo=linux&logoColor=black)

MiniGit is a simplified version control system inspired by Git, built entirely using **Bash shell scripts** and **C**. It provides essential version control features like initialization, staging, committing, logging, checkout, and diff viewing - all implemented from scratch for educational purposes and lightweight use cases.

---

## Table of Contents

- [Features](#features)
- [How It Works](#how-it-works)
- [Installation](#installation)
- [Usage](#usage)
- [File Structure](#file-structure)
- [Commands Reference](#commands-reference)
- [Examples](#examples)
- [Technical Details](#technical-details)
- [Limitations](#limitations)
- [Contributing](#contributing)
- [License](#license)

---

## Features

| Feature | Description |
|---------|-------------|
| **Repository Initialization** | Create a new `.minigit` repository in your project directory |
| **File Staging** | Add files to the index for tracking |
| **Commit System** | Save snapshots of your project with timestamps and messages |
| **Commit History** | View complete log of all commits with IDs, messages, and timestamps |
| **Checkout** | Restore your project to any previous commit state |
| **Diff Viewer** | Compare current working files with the last committed version (with color-coded output) |
| **Compression** | All committed files are automatically gzip compressed to save space |
| **File Hashing** | Simple checksum utility for file integrity verification |

---

## How It Works

MiniGit follows a simplified version control architecture:

```
Project Directory
├── .minigit/              # Repository metadata (hidden folder)
│   ├── objects/           # Stores compressed file snapshots
│   │   └── <commit_id>/   # Each commit gets its own folder
│   │       └── <file>.gz  # Compressed versions of tracked files
│   ├── logs/              # Commit metadata
│   │   └── <commit_id>.log
│   ├── index              # List of tracked files
│   └── HEAD               # Pointer to latest commit
├── minigit.sh             # Main VCS script
├── restore.sh             # Checkout helper
├── diff_viewer.sh         # Diff display helper
└── file_hash.c            # File hashing utility
```

### Workflow

1. **Initialize** → Creates the `.minigit` directory structure
2. **Add** → Files are registered in the `index` (staging area)
3. **Commit** → Files are copied, compressed, and stored in `objects/<commit_id>/`
4. **Log** → View all commit history from `logs/`
5. **Checkout** → Decompress and restore files from a specific commit
6. **Diff** → Compare working files with the latest committed version

---

## Installation

### Prerequisites

- Unix/Linux operating system (Ubuntu, macOS, WSL, etc.)
- Bash shell (version 4.0+)
- GCC compiler (for the hashing utility)
- Standard Unix utilities: `gzip`, `diff`, `awk`, `date`

### Clone the Repository

```bash
# Clone using HTTPS
git clone https://github.com/Chitransh-Panwar/MINIGIT_UNIX.git

# Or clone using SSH
git clone git@github.com:Chitransh-Panwar/MINIGIT_UNIX.git

# Navigate to the project directory
cd MINIGIT_UNIX
```

### Make Scripts Executable

```bash
chmod +x minigit.sh restore.sh diff_viewer.sh
```

### Compile the Hash Utility (Optional)

```bash
gcc file_hash.c -o file_hash
```

---

## Usage

### Quick Start

```bash
# 1. Initialize a new repository
./minigit.sh init

# 2. Create some files
echo "Hello World" > hello.txt
echo "MiniGit VCS" > readme.txt

# 3. Add files to staging
./minigit.sh add hello.txt readme.txt

# 4. Commit your changes
./minigit.sh commit "Initial commit"

# 5. View commit history
./minigit.sh log
```

---

## Commands Reference

### `init` - Initialize Repository

Creates a new MiniGit repository in the current directory.

```bash
./minigit.sh init
```

**Output:**
```
Repository initialized successfully.
```

---

### `add` - Stage Files

Adds one or more files to the staging area (index).

```bash
./minigit.sh add <file1> [file2] [file3] ...
```

**Examples:**
```bash
./minigit.sh add myfile.txt
./minigit.sh add file1.txt file2.txt file3.txt
```

---

### `commit` - Save Changes

Creates a new commit with all staged files.

```bash
./minigit.sh commit "Your commit message here"
```

**Output:**
```
Committed as 20250131123045
```

**Note:** Commit IDs are generated using timestamps (`YYYYMMDDHHMMSS` format).

---

### `log` - View Commit History

Displays all commits in reverse chronological order.

```bash
./minigit.sh log
```

**Output:**
```
Commit ID: 20250131123045
Message: Initial commit
Date: Fri Jan 31 12:30:45 UTC 2025
----------------
Commit ID: 20250131122510
Message: Added new features
Date: Fri Jan 31 12:25:10 UTC 2025
----------------
```

---

### `checkout` - Restore Previous Version

Restores all tracked files to a specific commit state.

```bash
./minigit.sh checkout <commit_id>
```

**Example:**
```bash
./minigit.sh checkout 20250131123045
```

**Output:**
```
Checked out commit 20250131123045
```

---

### `diff` - Compare Files

Shows differences between the current working file and the last committed version.

```bash
./minigit.sh diff <file>
```

**Example:**
```bash
./minigit.sh diff hello.txt
```

**Output:**
```
Showing diff for hello.txt (working vs last commit):
--- /tmp/hello.txt.commit       2025-01-31 12:35:00.000000000 +0000
+++ hello.txt   2025-01-31 12:40:00.000000000 +0000
@@ -1 +1 @@
-Hello World
+Hello MiniGit World
```

**Color coding:**
- **Green (+)** - Lines added
- **Red (-)** - Lines removed

---

## Examples

### Complete Workflow Example

```bash
# Initialize repository
./minigit.sh init

# Create and edit files
echo "Version 1" > document.txt
echo "Config file" > config.ini

# Stage files
./minigit.sh add document.txt config.ini

# First commit
./minigit.sh commit "First version"

# Make changes
echo "Version 2 - Updated content" > document.txt

# Check differences
./minigit.sh diff document.txt

# Stage and commit changes
./minigit.sh add document.txt
./minigit.sh commit "Updated document"

# View history
./minigit.sh log

# Go back to first version
./minigit.sh checkout 20250131120000  # Use your actual commit ID
```

---

## File Structure

| File | Description | Language |
|------|-------------|----------|
| `minigit.sh` | Main VCS script with all core commands | Bash |
| `restore.sh` | Helper script for checkout operations | Bash |
| `diff_viewer.sh` | Helper script for displaying colored diffs | Bash |
| `file_hash.c` | Simple file hashing utility using checksum | C |

### minigit.sh Components

- **`init_repo()`** - Creates `.minigit` directory structure
- **`add_files()`** - Adds files to the index
- **`commit_changes()`** - Creates commits with compressed snapshots
- **`view_logs()`** - Displays commit history
- **`checkout_commit()`** - Restores files from a commit
- **`show_diff()`** - Shows file differences

---

## Technical Details

### Commit Storage

Each commit is stored as:
- **Directory:** `.minigit/objects/<commit_id>/`
- **Files:** Original files are compressed using `gzip`
- **Metadata:** Stored in `.minigit/logs/<commit_id>.log`

### Index Format

The index file (`.minigit/index`) contains one filename per line:
```
file1.txt
file2.txt
config.ini
```

### Log Format

Log files use pipe-delimited format:
```
<commit_id>|<message>|<timestamp>
```

### Compression

All committed files are automatically gzip compressed:
```bash
gzip "$OBJECTS/$COMMIT_ID/$file"
```

This saves disk space while maintaining full file integrity.

---

## Limitations

MiniGit is a simplified educational project with the following limitations:

| Limitation | Description |
|------------|-------------|
| **No Branching** | Single linear history only |
| **No Merging** | Cannot merge different branches |
| **No Remote Support** | Local repository only |
| **No .minigitignore** | All staged files are tracked |
| **No Binary Diff** | Diff works best with text files |
| **Timestamp-based IDs** | Commit IDs may collide if commits happen within the same second |
| **No File Renaming** | Renamed files are treated as new files |
| **No Partial Checkout** | Checkout restores all tracked files |

---

## Contributing

Contributions are welcome! Here are some ways you can improve MiniGit:

1. **Add Branching Support** - Implement lightweight branching
2. **Improve Hashing** - Replace timestamp IDs with SHA-like hashes
3. **Add .minigitignore** - Support for ignore patterns
4. **Optimize Storage** - Implement delta compression
5. **Add Status Command** - Show working directory status
6. **Better Diff** - Support for word-level diff

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

This project is open source and available under the [MIT License](LICENSE).

---

## Acknowledgments

- Inspired by [Git](https://git-scm.com/) - the distributed version control system
- Built for educational purposes to understand VCS internals
- Created as a Unix/Linux shell scripting exercise

---

## Author

**Chitransh Panwar**

- GitHub: [@Chitransh-Panwar](https://github.com/Chitransh-Panwar)

---

<p align="center">
  <i>Happy Version Controlling with MiniGit!</i>
</p>
