# ZO-style Combat Rojo Project

This repository contains a Rojo-ready Roblox experience that mirrors the movement and combat flow of ZO/Zen/Kaosu Samurai.

## Folder tree

- `default.project.json` — Rojo mapping
- `src/ReplicatedStorage/Modules` — shared configs/utilities
- `src/ReplicatedStorage/Remotes` — RemoteEvents created at runtime
- `src/ServerScriptService` — core services (data, weapons, combat, kill effects, admin commands)
- `src/StarterPlayer/StarterPlayerScripts` — input, client combat helpers, kill effect playback
- `src/StarterGui/Shop` — minimal shop UI generator

## Asset import checklist

Import assets into Roblox Studio before syncing:

1. **Weapons and holsters**
   - Place weapon models and skins under `ReplicatedStorage/Weapons/<WeaponType>/Skins/<SkinName>/Tool`.
   - Place holster models under `ReplicatedStorage/Weapons/<WeaponType>/HolsterModel`.
2. **Animations**
   - Add `ReplicatedStorage/Animations/<WeaponType>/Equip`, `Unequip`, `Attack1`..`Attack4`.
   - Add shared animations under `ReplicatedStorage/Animations/Shared/Block`, `PerfectBlock`, `Kick`, `Dash`, `Run`.
   - Use placeholder `AnimationId` values; update with your uploads.
3. **Kill effects**
   - Put particle/sound/model prefabs under `ReplicatedStorage/KillEffects/<EffectName>` (e.g., `DefaultSlash`, `RedSlash`, `Inferno`).
4. **Remotes**
   - Server creates the required RemoteEvents inside `ReplicatedStorage/Remotes` on start.

## Testing steps in Studio

1. Install Rojo plugin and serve this project (`rojo serve`).
2. Start a local test server with at least two players.
3. Verify default katana spawns and holster attaches.
4. Press **1** to equip/unequip, **Mouse1** for 4-hit combo, **RightClick** to block, **F** to kick, **LeftShift** to dash, **B** to open shop.
5. Test perfect block timing (~0.2s) and chip damage on standard block; ensure attacker stuns.
6. Confirm kill effects fire instantly on lethal hits and victim fades quickly.
7. Run admin commands (`-give`, `/givecustom`, `/crucible`) from server console or as creator; messages should appear as system messages only.