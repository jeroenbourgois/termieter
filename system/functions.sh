function dev-cardigle () {
  COMMANDS=( "clear;z frritt;clear;rails s thin" "clear;z frritt;mvim .;clear" "clear;z jules;clear" )
	LENGTH=${#COMMANDS[@]}
  COUNT=0
	
	for command in "${COMMANDS[@]}"
		do
			COUNT=$((COUNT+1))
			osascript <<-EOF
		 		tell application "Terminal"
					activate
					set window_id to id of first window whose frontmost is true

					do script "$command" in window id window_id of application "Terminal"
					 
					if $COUNT < $LENGTH then
						tell application "System Events"
							keystroke "t" using {command down}
						end tell
					end if
				end tell
			EOF
		done
}

# Create a new directory and enter it
md() {
  mkdir -p "$@" && cd "$@"
}

alias trash='mv "$@" ~/.Trash/'