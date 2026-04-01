local cfg = {}

cfg.noMakeup = true
-- no makeup? set to false to keep makeup, and set to true to remove makeup

cfg.micellar = true
-- NO FUTURE-PROOFING | if false: only destroy MakeupDescriptions
-- FUTURE-PROOF| if true: also destroy their related objects:
-- Composite / empty Decals, WrapTextureTransfers, WrapTargets, and WrapLayers

cfg.applyPlayers = true
-- should this no-makeup rule apply to players?

cfg.applyOtherHumanoids = true
-- should makeup be removed from non-playable humanoids?

cfg.accessoryTaboo = {'eyebrow', 'eyelash'} -- delete accessories with these words in them (if micellar is true)

cfg.deleteAnyModernJunk = false -- delete not only eyebrows and eyelashes but also layered clothes (needs micellar)
-- set to true if you want all the modern junk gone
-- set to false of you want only the eyebrows and eyelashes gone


-- the nerdy stuff:
cfg.applyOtherHumanoidsDepth = 4
-- the depth at which we traverse the workspace for non-playable humanoids.
-- this can be nil to go through EVERYTHING.

cfg.instancesToTraverseForHumanoid = {'Model', 'Folder'}
-- we traverse through all the models and folders from workspace to find a non-playable humanoid.
-- you can set this to nil to traverse through everything in workspace!

return cfg