# Extracts various compressed file formats. If no destination is specified, extracts to the current directory.
# Usage: extract [file] [destination]
# Example: extract archive.zip /path/to/destination
function extract
	if test -f $argv[1]
		set destination $argv[2]
		if test -z $destination
			set destination (pwd)
		end
		switch $argv[1]
			case *.tar.bz2
				tar xjf $argv[1] -C $destination
			case *.tar.gz
				tar xzf $argv[1] -C $destination
			case *.bz2
				bunzip2 -k $argv[1]; and mv ${argv[1]%.bz2} $destination
			case *.rar
				unrar x $argv[1] $destination
			case *.gz
				gunzip -k $argv[1]; and mv ${argv[1]%.gz} $destination
			case *.tar
				tar xf $argv[1] -C $destination
			case *.tbz2
				tar xjf $argv[1] -C $destination
			case *.tgz
				tar xzf $argv[1] -C $destination
			case *.zip
				unzip $argv[1] -d $destination
			case *.Z
				uncompress $argv[1]; and mv ${argv[1]%.Z} $destination
			case *.7z
				7z x $argv[1] -o$destination
			case '*'
				echo "'$argv[1]' cannot be extracted via extract()"
		end
	else
		echo "'$argv[1]' is not a valid file"
	end
end