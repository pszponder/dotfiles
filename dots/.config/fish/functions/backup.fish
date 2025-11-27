# Backup a file or directory
function backup
  if test -z "$argv[1]"
    echo "Usage: backup <file_or_directory>"
    return 1
  end

  set src "$argv[1]"

  if not test -e "$src"
    echo "Error: '$src' does not exist."
    return 1
  end

  if test -f "$src"
    # If it's a file, append .bak
    set dest "$src.bak"
    cp "$src" "$dest"
    echo "File backup created at: $dest"
  else if test -d "$src"
    # If it's a directory, create a timestamped backup
    set timestamp (date "+%Y%m%d_%H%M%S")
    set dest "$src"_backup_"$timestamp"
    cp -r "$src" "$dest"
    echo "Directory backup created at: $dest"
  else
    echo "Error: '$src' is neither a file nor a directory."
    return 1
  end
end