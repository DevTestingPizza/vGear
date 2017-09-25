-- Name: vGear
-- Version: 1.0
-- Description: Gear up whenever you (re)spawn or press a button (configurable).
-- License: GNU Affero General Public License v3.0
-- Author: Vespura
-- GitHub Repo: https://github.com/TomGrobbe/vGear

--------------------------- LOCAL VARIABLES --------------------------------

local GiveLoadoutOnRespawn = false      -- should players receive the gear when they (re)spawn? (default: false)
local EnableManualButton = true         -- Should players be able to use the ManualLoadoutButton (default F7) to get the gear? (default: true)
local ManualLoadoutButton = 168         -- The button to be pressed to receive the loadout (default: 168 (F7))
local ClearPlayerClothes = true         -- Should the player's clothes be cleaned? (remove blood etc.) (default: true)
local HealPlayer = true                 -- Should the player be healed (max health) (default: true)
local GiveMaxArmour = true              -- Should the player receive full body armor? (default: true)
local ReceivedLoadoutMessage = '^1Gear equipped, enjoy!' -- the message the player receives after getting the gear.


-- https://wiki.fivem.net/wiki/Weapons
-- {weaponHash, amountOfAmmoToGive} Too much ammo might crash the game, be careful!
local spawnLoadoutList = {  
    {0x34A67B97, 1},    -- Jerry Can
    {0x8BB05FD7, 1},    -- Flashlight
    {0x678B81B1, 1},    -- Nightstick
    {0x060EC506, 1},    -- Fire Extinguisher
    {0x3656C8C1, 1},    -- Stun Gun
    {0x5EF9FEC4, 200},  -- Combat Pistol
    {0x83BF0278, 200},  -- Carbine Rifle
}

-- https://wiki.fivem.net/wiki/Weapon_Components
-- {weaponHashToApplyComponentTo, weaponComponentHash} Any extras/components that need to be attached to certain weapons? Enter them below
local spawnLoadoutExtrasList = {   
    {0x5EF9FEC4, 0x359B7AAE},   -- Combat Pistol Flashlight
    {0x5EF9FEC4, 0xD67B4F2D},   -- Combat Pistol Extended Clip
    {0x83BF0278, 0x7BC4CDDC},   -- Carbine Rifle Flashlight
    {0x83BF0278, 0x91109691},   -- Carbine Rifle Extended Clip
    {0x83BF0278, 0xC164F53},    -- Carbine Rifle Grip
    {0x83BF0278, 0xA0D89C42},   -- Carbine Rifle Scope
}




-------------------------- CODE, DON'T TOUCH -------------------------------
AddEventHandler("playerSpawned", function()
    if GiveLoadoutOnRespawn then
        GiveLoadout()
    end
end)

if EnableManualButton then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsControlJustReleased(0, ManualLoadoutButton) then
               GiveLoadout()
            end
        end
    end)
end

function GiveLoadout()
    local ped = GetPlayerPed(-1)
    for k, w in pairs(spawnLoadoutList) do
        GiveWeaponToPed(GetPlayerPed(-1), w[1], w[2], false, false)
    end
    for k, c in pairs(spawnLoadoutExtrasList) do
        GiveWeaponComponentToPed(ped, c[1], c[2])
    end
    if ClearPlayerClothes then
        ClearPedBloodDamage(ped)
    end
    if GiveMaxArmour then
        SetPedArmour(ped, 100)
    end
    if HealPlayer then
        SetEntityHealth(ped, 200)
    end
    TriggerEvent('chatMessage', '', {255,255,255}, ReceivedLoadoutMessage)
end


----------------------------------------------------------------------------


