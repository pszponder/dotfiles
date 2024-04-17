# Updates System and Packages
function update
	sudo apt update && sudo apt upgrade -y
	brew update && brew upgrade
	mise upgrade
end
