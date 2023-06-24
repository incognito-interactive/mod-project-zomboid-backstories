-- Require the other script(s).
require("World");

-- This table contains most of the edible canned foods.
CannedFoods = {
    "Base.TinnedBeans",
    "Base.CannedChili",
    "Base.CannedCorn",
    "Base.CannedCornedBeef",
    "Base.CannedFruitCocktail",
    "Base.CannedMushroomSoup",
    "Base.CannedPeaches",
    "Base.CannedPeas",
    "Base.CannedPineapple",
    "Base.CannedPotato2",
    "Base.CannedSardines",
    "Base.TinnedSoup",
    "Base.CannedBolognese",
    "Base.CannedTomato2",
    "Base.TunaTin"
}

-- This table contains the drinking bottles, empty or not.
DrinkingBottles = {
    "Base.WaterBottleEmpty",
    "Base.WaterBottleFull"
}

-- This function sets the hours survived based on the amount of days that have passed since the start of the apocalypse.
-- Note that this is based on the values you can find in the World.lua file.
function simulateSurvivalHours(player, days)
    -- Convert the days to hours.
    local survivedHours = days * 24;

    -- Set the hours survived for the game time itself.
    getGameTime():setHoursSurvived(survivedHours);

    -- Set the hours survived for the player.
    player:setHoursSurvived(survivedHours);
end

-- This function returns a kill multiplier based on the traits of the player.
function getKillMultiplier(player)
    -- Set the initial kill multiplier.
    local killMultiplier = 1.0;

    -- Strong kill multiplier traits.
    if player:HasTrait("Desensitized") then killMultiplier = killMultiplier * 2.5; end

    -- Average kill multiplier traits.
    if player:HasTrait("Brawler") then killMultiplier = killMultiplier * 1.75; end
    if player:HasTrait("AdrenalineJunkie") then killMultiplier = killMultiplier * 1.5; end
    if player:HasTrait("Brave") then killMultiplier = killMultiplier * 1.5; end
    if player:HasTrait("Hunter") then killMultiplier = killMultiplier * 1.5; end
    if player:HasTrait("Burglar") then killMultiplier = killMultiplier * 1.5; end

    -- Weak kill multiplier traits.
    if player:HasTrait("Clumsy") then killMultiplier = killMultiplier * 0.75; end
    if player:HasTrait("Inconspicuous") then killMultiplier = killMultiplier * 0.75; end
    if player:HasTrait("Cowardly") then killMultiplier = killMultiplier * 0.5; end
    if player:HasTrait("FearOfBlood") then killMultiplier = killMultiplier * 0.5; end
    if player:HasTrait("Weak") then killMultiplier = killMultiplier * 0.5; end
    if player:HasTrait("Unfit") then killMultiplier = killMultiplier * 0.5; end

    -- Pacifist.
    if player:HasTrait("Pacifist") then killMultiplier = killMultiplier * 0.5; end

    -- Return the kill multiplier with all trait boons applied.
    return killMultiplier;
end

-- This function simulates the kill count of the player based on the amount of days that have passed since the start of the apocalypse.
function simulateKills(player)
    -- Set the average minimum kills and maximum kills.
    local averageMinimumKills = 2;
    local averageMaximumKills = 20;

    -- Set the initial simulated kills.
    local simulatedKills = 0;
    local simulatedKillMultiplier = getKillMultiplier(player);

    -- Go over every day in the apocalypse.
    for i = 0, getDaysSinceApocalypse() do
        -- Simulate the amount of kills for this day.
        simulatedKills = simulatedKills + ZombRand(2, 20) * simulatedKillMultiplier;
    end

    -- Set the amount of zombie kills of the player.
    player:setZombieKills(simulatedKills);
end

-- This function returns a random item from a table.
function getRandomTableItem(table)
    -- Get the size of the table.
    local tableSize = #table;

    -- Return a random item from the table.
    return table[ZombRand(1, tableSize)];
end

-- This function adds a bunch of random items from a table into a container.
function addRandomItemsFromTable(table, amount, container)
    -- Add some random items to the container.
    for i = 0, amount do container:AddItem(getRandomTableItem(table)); end
end

-- This function simulates the gear of the player.
function simulateGear(player)
    -- Get the profession of the player.
    local profession = player:getDescriptor():getProfession();

    -- Check if the player is a veteran.
    if profession == "veteran" then
        -- Then give the player a military bag.
        local bag = player:getInventory():AddItem("Base.Bag_ALICEpack_Army");

        -- Give the player some extra mags.
        bag:getItemContainer():AddItem("Base.556Clip"):setCurrentAmmoCount(30);
        bag:getItemContainer():AddItem("Base.556Clip"):setCurrentAmmoCount(30);
        bag:getItemContainer():AddItem("Base.556Clip"):setCurrentAmmoCount(30);

        -- Always give the player one extra spare mag in the inventory.
        player:getInventory():AddItem("Base.556Clip"):setCurrentAmmoCount(30);

        -- Check whether looting should be simulated.
        if getDaysSinceApocalypse() > 14 then
            -- The player should have found a can opener by now.
            bag:getItemContainer():AddItem("Base.TinOpener");

            -- Give the player some extra mags but with a bunch of bullets fired.
            player:getInventory():AddItem("Base.556Clip"):setCurrentAmmoCount(ZombRand(16, 30));
            player:getInventory():AddItem("Base.556Clip"):setCurrentAmmoCount(ZombRand(16, 30));

            -- Give the player some canned foodies.
            addRandomItemsFromTable(CannedFoods, ZombRand(4, 8), bag:getItemContainer());

            -- Give the player an empty bottle or a water bottle.
            addRandomItemsFromTable(DrinkingBottles, ZombRand(0, 1), bag:getItemContainer());
        end

        -- Make the player wear the military bag.
        player:setClothingItem_Back(bag);

        -- Give the player an assault rifle.
        local weapon = player:getInventory():AddItem("Base.AssaultRifle");

        -- Reload the assault rifle.
        weapon:setCurrentAmmoCount(29);
        weapon:setContainsClip(true);
        weapon:setRoundChambered(true);

        -- Equip the assault rifle.
        player:setPrimaryHandItem(weapon);
        player:setSecondaryHandItem(weapon);
    end
end