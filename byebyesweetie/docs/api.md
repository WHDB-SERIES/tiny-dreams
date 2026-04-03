# Methods
### `main:ApplyTo(figure)`
applies the make-up remover to a given figure

### `main:ClearMakeupDescriptions(figure)`
clear makeup descriptions from figure

### `main:ClearAllEvil(figure)`
clear all makeup related stuff from figure (and layered clothes if micellar is active)

# Configurations

### `noMakeup: boolean`
disble makeup?

### `micellar: boolean`
ensure makeup is gone? this may lead to unintended behaviour, as it removes basewraps and empty decals

### `applyPlayers: boolean`
self-explanatory. apply this make-up remover to players automatically?

### `applyOtherHumanoids: boolean`
apply this make-up remover to non-players automatically?

#### `applyOtherHumanoidsDepth: number`
apply to other humanoids starting from workspace and going until this depth. set to `-1` if you want a behaviour equivalent to getdescendants (if it only got humanoids)

#### `instancesToTraverseForHumanoid: {string}`
what instances should be traversed when searching for non-player humanoids?

### `accessoryTaboo: {string}`
delete accessories with these words in them (only if micellar is active)

### `deleteAnyModernJunk: boolean`
delete accessories with any basewrap in them? this deletes layered clothing which is another disease


___

there is no version-checking for this module.