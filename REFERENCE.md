
* [containers:spawn()](#containersspawn)
* [containers:set-count()](#containerssetcount)
* [containers:count()](#containerscount)
* [containers:destroy()](#containersdestroy)
* [containers:wipe()](#containerswipe)
* [containers:run()](#containersrun)
* [containers:get-list()](#containersgetlist)
* [containers:get-ip-list()](#containersgetiplist)
* [containers:get-ip()](#containersgetip)
* [containers:get-rootfs()](#containersgetrootfs)
* [containers:is-active()](#containersisactive)
* [containers:register-provider()](#containersregisterprovider)


## containers:spawn()

Spawns amount of containers, uses specified provider.

Containers count can be specified by `containers:count` function.

By default, two containers will be used.

_Function has no arguments._

## containers:set-count()

Sets containers count for spawning.

### Arguments

* **$1** (int): Target containers count.

## containers:count()

Returns how much containers will be spawned.

### Output on stdout

* Containers count.

## containers:destroy()

Destroys specified container.

### Arguments

* **$1** (string): Container name.

## containers:wipe()

Wipes all created containers.

_Function has no arguments._

## containers:run()

Runs command in specified container.

### Arguments

* **$1** (string): Container name.

## containers:get-list()

Gets containers names into variable.

### Arguments

* **$1** (var): Variable name.

## containers:get-ip-list()

Gets containers IPs into variable.

### Arguments

* **$1** (var): Variable name.

## containers:get-ip()

Gets container's IP into variable.

### Arguments

* **$1** (var): Variable name.
* **$2** (string): Container name.

## containers:get-rootfs()

Gets container's root FS into variable.

### Arguments

* **$1** (var): Variable name.
* **$2** (string): Container name.

## containers:is-active()

Checks, that specified container is active (running).

### Arguments

* **$1** (string): Container name.

### Exit codes

* **0**: Container is active.
* **1**: Container is stopped.

## containers:register-provider()

Register backend provider, which will actually do the work.

hastur will be used by default.

Provider should provide following methods:
* spawn
* destroy
* run
* list
* is-active

### Arguments

* **$1** (string): Provider name.

