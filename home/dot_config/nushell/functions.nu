def lt [level = 2] {
  eza --tree --level $level --long --icons --git
}

def please [] {
  let last = history | last | get command;
  sudo $last
}

def extract [archives: list<string>] {
  for archive in $archives {
    if not ($archive | path exists) {
      print "'$archive' is not a valid file!"
    } else if ($archive | path type) == 'file' {
      match $archive {
        *.tar.bz2 => tar xvjf $archive,
        *.tar.gz => tar xvzf $archive,
        *.bz2 => bunzip2 $archive,
        *.rar => rar x $archive,
        *.gz => gunzip $archive,
        *.tar => tar xvf $archive,
        *.tbz2 => tar xvjf $archive,
        *.tgz => tar xvzf $archive,
        *.zip => unzip $archive,
        *.Z => uncompress $archive,
        *.7z => 7z x $archive,
        _ => print "don't know how to extract '$archive'..."
      }
    }
  }
}

def ftext [text: string] {
  grep -iIHrn --color=always $text . | less -r
}

def cpp [source: string, destination: string] {
  let size = (stat $source | get size);
  mut count = 0;
  strace -q -ewrite cp -- $source $destination | lines | each {|line|
    let bytes = ($line | parse "write\((?P<count>\d+)" | get count.0 | into int);
    count += $bytes;
    let percent = ($count * 100 / $size);
    print (format "{percent}%")
  }
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