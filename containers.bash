export _containers_count=${_containers_count:-2}
export _containers_provider="hastur"

containers:set-count() {
    _containers_count=$1
}

containers:count() {
    echo "$_containers_count"
}

containers:spawn() {
    for (( i = $(containers:count); i > 0; i-- )); do
        containers:provider spawn "${@}"
    done
}

containers:destroy() {
    local container_name=$1

    containers:provider destroy-container "$container_name"
}

containers:wipe() {
    :list-containers | while read container_name; do
        containers:destroy "$container_name"
    done
}

containers:run() {
    local container_name=$1
    shift

    containers:provider run "$container_name" "${@}"
}

containers:get-list() {
    local var_name="$1"

    eval "$var_name=()"
    while read "container_name"; do
        eval "$var_name+=($container_name)"
    done < <(containers:provider list)
}

containers:get-ip-list() {
    local var_name="$1"

    local ip

    eval "$var_name=()"
    while read "container_name"; do
        containers:get-ip ip "$container_name"

        eval "$var_name+=($ip)"
    done < <(containers:provider list)
}

containers:get-ip() {
    local var_name="$1"
    shift

    eval "$var_name=$(containers:provider print-ip "${@}")"
}

containers:get-rootfs() {
    local var_name="$1"
    shift

    eval "$var_name=$(containers:provider print-rootfs "${@}")"
}

containers:is-active() {
    containers:provider is-active "${@}"
}

containers:register-provider() {
    _containers_provider="$1"
}

containers:provider() {
    local command="$1"
    shift

    eval $_containers_provider:$command \"\${@}\"
}
