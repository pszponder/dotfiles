# Create a new git-enabled directory and navigate into it
function newgit
  if test -z "$argv[1]"
    echo "Usage: newgit <directory_name>"
    return 1
  end

  mkdir -p "$argv[1]" && cd "$argv[1]"
  git init
end
