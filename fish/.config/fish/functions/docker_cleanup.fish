# Cleans up unused Docker resources
function docker_cleanup
	docker system prune --all --volumes
end