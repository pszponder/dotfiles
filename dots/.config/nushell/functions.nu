def lt [level = 2] {
  eza --tree --level $level --long --icons --git
}

def please [] {
  let last = history | last | get command;
  sudo $last
}

def ftext [text: string] {
  grep -iIHrn --color=always $text . | less -r
}

def docker [...args] {
  if (which colima | is-empty) {
    print "Colima not found. Using Docker directly."
  } else {
    let status = (colima status | complete)
    if ($status.exit_code != 0) or (not ($status.stdout | str contains "Running")) {
      print "Starting Colima..."
      colima start
    }
  }

  ^docker $args
}

def cpg [source: string, destination: string] {
  cp $source $destination;
  if ($destination | path type) == 'dir' {
    cd $destination
  }
}

def mvg [source: string, destination: string] {
  mv $source $destination;
  if ($destination | path type) == 'dir' {
    cd $destination
  }
}

def mkdirg [path: string] {
  mkdir $path;
  cd $path
}

def newgit [dir: string] {
  if ($dir | is-empty) {
    print "Usage: newgit <directory_name>"
  } else {
    mkdir $dir;
    cd $dir;
    git init
  }
}

def backup [src: string] {
  if ($src | is-empty) {
    print "Usage: backup <file_or_directory>"
    return
  }

  if not ($src | path exists) {
    print "Error: '$src' does not exist."
    return
  }

  if ($src | path type) == 'file' {
    let dest = $"{src}.bak";
    cp $src $dest;
    print $"File backup created at: {dest}"
  } else if ($src | path type) == 'dir' {
    let timestamp = (date now | format date "%Y%m%d_%H%M%S");
    let dest = $"{src}_backup_{timestamp}";
    cp -r $src $dest;
    print $"Directory backup created at: {dest}"
  } else {
    print $"Error: '{src}' is neither a file nor a directory."
  }
}

def whatsmyip [] {
  if (which ip | is-empty) {
    print "Internal IP: "
    ifconfig wlan0 | grep "inet " | awk '{print $2}' | str trim
  } else {
    print "Internal IP: "
    ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1 | str trim
  }
  print "External IP: "
  curl -4 ifconfig.me
}

# Clone a git repository and cd into it
def clone [
  url: string,   # git url to clone
  dir?: string   # optional target directory name
] {
  if ($url | is-empty) {
    print "Usage: clone <git-url> [directory]"
    return
  }

  if ($dir != null) {
    ^git clone $url $dir
    cd $dir
  } else {
    let name = ($url | path basename | str replace -r '\\.git$' '')
    ^git clone $url
    if (path exists $name) {
      cd $name
    } else {
      print $"Could not cd into '{name}' (clone may have used a different folder name)."
    }
  }
}