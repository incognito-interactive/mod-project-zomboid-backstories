-- Require the food tables.
require("Tables.Foods");

-- Function which returns a random ID from a table.
function getRandomTableID(table)
    -- Retrieve the size of the table.
    local tableSize = #table;

    -- Return a random ID from the table.
    return table[ZombRand(1, tableSize)]
end

-- Function which add a specific amount of items from a table to a container.
function addRandomItemsFromTable(table, amount, container)
    -- Add the items to the inventory.
    for i = 0, amount do
        container:AddItem(getRandomTableID(table));
    end
end

-- Function which increases the level of a specific perk of the player.
function loopLevelPerk(perk, level, player)
    for i = 0, level do
        player:LevelPerk(perk);
        luautils.updatePerksXp(perk, player);
    end
end

-- Function which simulates the amount of player killed zombies based on traits and occupation.
function simulateZombieKills(days, player)
    -- Check if the apocalypse actually happened.
    if days == 0 then return end

    -- Get the occupation of the player.
    -- (Only god knows why this is called profession here but everywhere else it's called occupation)
    local occupation = player:getDescriptor():getProfession();

    -- The multiplier applied to future min and max daily kills.
    local killMultiplier = 1

    -- If the player has the weak trait then they kill less.
    if player:HasTrait("Weak") then killMultiplier = killMultiplier * 0.6 end

    -- If the player has the feeble trait then they kill less.
    if player:HasTrait("Feeble") then killMultiplier = killMultiplier * 0.8 end

    -- If the player has the cowardly trait then they kill less.
    if player:HasTrait("Cowardly") then killMultiplier = killMultiplier * 0.8 end

    -- If the player has the fear of blood trait then they kill less.
    if player:HasTrait("FearOfBlood") then killMultiplier = killMultiplier * 0.8 end

    -- If the player has the brave trait then they kill more.
    if player:HasTrait("Brave") then killMultiplier = killMultiplier * 1.2 end

    -- If the player has the brawler trait then they kill more.
    if player:HasTrait("Brawler") then killMultiplier = killMultiplier * 1.25 end

    -- If the player has the stout trait then they kill more.
    if player:HasTrait("Stout") then killMultiplier = killMultiplier * 1.25 end

    -- If the player has the strong trait then they kill more.
    if player:HasTrait("Strong") then killMultiplier = killMultiplier * 1.3 end

    -- If the player has the hunter trait then they kill more.
    if player:HasTrait("Hunter") then killMultiplier = killMultiplier * 1.3 end

    -- If the player has the police officer occupation then they kill more.
    if occupation == "policeofficer" then killMultiplier = killMultiplier * 1.65 end

    -- If the player has the burgler occupation then they kill more.
    if occupation == "burglar" then killMultiplier = killMultiplier * 1.75 end

    -- If the player has the veteran occupation then they kill more.
    if occupation == "veteran" then killMultiplier = killMultiplier * 2.0 end

    -- If the player has the pacifist trait then they don't kill anything.
    if player:HasTrait("Pacifist") then killMultiplier = 0 end

    -- The minimum amount of daily kills.
    local killMin = 2 * killMultiplier;

    -- The maximum amount of daily kills.
    local killMax = 8 * killMultiplier;

    -- The total amount of kills to be applied to the stats of the player.
    local kills = 0;

    -- Simulate the daily kills based on the min and max with the multiplier applied.
    for i = 0, days do
        kills = kills + ZombRand(killMin, killMax);
    end

    -- Set the kill count of the player.
    player:setZombieKills(kills);
end

-- Function which simulates the survivor's skills and kit based on their occupation.
function simulateSurvivor(player)
    -- Retrieve the profession of the player.
    local occupation = player:getDescriptor():getProfession();

    -- The bag which will holds the simulated kit items.
    local bag;

    -- The simulated weapon at the start.
    local weapon;

    -- Spawn the veteran kit.
    if occupation == "veteran" then
        -- Level the perks.
        loopLevelPerk(Perks.Strength, 2, player);
        loopLevelPerk(Perks.Fitness, 2, player);
        loopLevelPerk(Perks.Reloading, 3, player);
        loopLevelPerk(Perks.Aiming, 3, player);

        -- Give the player a military bag.
        bag = player:getInventory():AddItem("Base.Bag_ALICEpack_Army");

        -- Give the player a can opener.
        bag:getItemContainer():AddItem("Base.TinOpener");

        -- Give the player some extra ammo.
        bag:getItemContainer():AddItems("Base.556Box", ZombRand(0, 2));
        bag:getItemContainer():AddItem("Base.556Clip"):setCurrentAmmoCount(30);
        bag:getItemContainer():AddItem("Base.556Clip"):setCurrentAmmoCount(30);
        bag:getItemContainer():AddItem("Base.556Clip"):setCurrentAmmoCount(30);
        player:getInventory():AddItem("Base.556Clip"):setCurrentAmmoCount(30);
        player:getInventory():AddItem("Base.556Clip"):setCurrentAmmoCount(30);

        -- Add some canned items to the bag.
        addRandomItemsFromTable(CannedFoods, ZombRand(4, 8), bag:getItemContainer());

        -- Add a random bottle to the bag.
        addRandomItemsFromTable(DrinkBottles, ZombRand(0, 1), bag:getItemContainer());

        -- Wear the bag.
        player:setClothingItem_Back(bag);

        -- Give the player an assault rifle.
        weapon = player:getInventory():AddItem("Base.AssaultRifle");

        -- Fill the ammo.
		weapon:setCurrentAmmoCount(29);
		weapon:setContainsClip(true);
		weapon:setRoundChambered(true);

        -- Equip it.
		player:setPrimaryHandItem(weapon);
		player:setSecondaryHandItem(weapon);
        return;
    end
end