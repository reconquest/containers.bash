export _containers_count=${_containers_count:-2}

containers:set-count() {
    _containers_count=$1
}

containers:count() {
    echo "$_containers_count"
}

containers:spawn() {
    hastur -p $(hastur:get-packages) -kS "${@:-/bin/true}"
}

containers:destroy() {
    local container_name=$1

    hastur -f -D "$container_name"
}

containers:wipe() {
    :list-containers | while read container_name; do
        containers:destroy "$container_name"
    done
}

containers:run() {
    local container_name=$1
    shift

    containers:spawn -n "$container_name" "${@}"
}

containers:get-list() {
    local var_name="$1"

    eval "$var_name=()"
    while read "container_name"; do
        eval "$var_name+=($container_name)"
    done < <(hastur:list)
}

containers:get-ip-list() {
    local var_name="$1"

    local ip

    eval "$var_name=()"
    while read "container_name"; do
        containers:get-ip ip "$container_name"

        eval "$var_name+=($ip)"
    done < <(hastur:list)
}


containers:get-ip() {
    local var_name="$1"
    shift

    eval "$var_name=$(hastur:print-ip "${@}")"
}

containers:get-rootfs() {
    local var_name="$1"
    shift

    eval "$var_name=$(hastur:print-rootfs "${@}")"
}

containers:is-active() {
    set -x
    hastur:is-active "${@}"
    set +x
}
