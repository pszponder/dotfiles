# Cleans up unused Docker resources
function podman_cleanup
	podman system prune --all --volumes
end