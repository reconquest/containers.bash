export _containers_count=${_containers_count:-2}
export _containers_provider="hastur"
export _containers_spawner="hastur:spawn"

# @description Spawns amount of containers, uses specified provider.
#
# Containers count can be specified by `containers:count` function.
#
# By default, two containers will be used.
#
# @noargs
containers:spawn() {
    for (( i = $(containers:count); i > 0; i-- )); do
        $_containers_spawner "${@}"
    done
}

# @description Calls specified function once per running container. Function
# will be given container name and container IP args.
#
# @arg $* Function to call.
containers:do() {
    local containers=()
    local ips=()

    containers:get-list containers
    containers:get-ip-list ips

    for (( i = 0; i < $(containers:count); i++ )); do
        "${@}" "${containers[$i]}" "${ips[$i]}"
    done
}

# @description Calls specified function once per container. Container is not
# necessarry running.
#
# @arg $* Function to call.
containers:foreach() {
    local containers=()

    containers:get-list containers

    for (( i = 0; i < $(containers:count); i++ )); do
        "${@}" "${containers[$i]}"
    done
}

# @description Sets containers count for spawning.
#
# @arg $1 int Target containers count.
containers:set-count() {
    _containers_count=$1
}

# @description Returns how much containers will be spawned.
#
# @stdout Containers count.
containers:count() {
    echo "$_containers_count"
}

# @description Destroys specified container.
#
# @arg $1 string Container name.
containers:destroy() {
    local container_name=$1

    containers:provider destroy "$container_name"
}

# @description Wipes all created containers.
#
# @noargs
containers:wipe() {
    containers:provider list | while read container_name; do
        containers:destroy "$container_name"
    done
}

# @description Runs command in specified container.
#
# @arg $1 string Container name.
containers:run() {
    local container_name=$1
    shift

    containers:provider run "$container_name" "${@}"
}

# @description Gets containers names into variable.
#
# @arg $1 var Variable name.
containers:get-list() {
    local var_name="$1"

    eval "$var_name=()"
    while read "container_name"; do
        eval "$var_name+=($container_name)"
    done < <(containers:provider list)
}

# @description Gets containers IPs into variable.
#
# @arg $1 var Variable name.
containers:get-ip-list() {
    local var_name="$1"

    local ip

    eval "$var_name=()"
    while read "container_name"; do
        containers:get-ip ip "$container_name"

        eval "$var_name+=($ip)"
    done < <(containers:provider list)
}

# @description Gets container's IP into variable.
#
# @arg $1 var Variable name.
# @arg $2 string Container name.
containers:get-ip() {
    local var_name="$1"
    shift

    eval $var_name='$(containers:provider print-ip "${@}")'
}

# @description Gets container's root FS into variable.
#
# @arg $1 var Variable name.
# @arg $2 string Container name.
containers:get-rootfs() {
    local var_name="$1"
    shift

    eval $var_name='$(containers:provider print-rootfs "${@}")'
}

# @description Checks, that specified container is active (running).
#
# @arg $1 string Container name.
# @exitcode 0 Container is active.
# @exitcode 1 Container is stopped.
containers:is-active() {
    containers:provider is-active "${@}"
}

# @description Register backend provider, which will actually do the work.
#
# hastur will be used by default.
#
# Provider should provide following methods:
# * spawn
# * destroy
# * run
# * list
# * is-active
#
# @arg $1 string Provider name.
containers:register-provider() {
    _containers_provider="$1"
}

containers:register-spawner() {
    _containers_spawner="$1"
}

containers:provider() {
    local command="$1"
    shift

    eval $_containers_provider:$command \"\${@}\"
}
