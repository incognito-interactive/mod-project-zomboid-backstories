-- Function which returns a random ID from a table.
function getRandomTableID(table)
    -- Retrieve the size of the table.
    local tableSize = #table;

    -- Return a random ID from the table.
    return table[ZombRand(1, tableSize)]
end

-- Function which add a specific amount of items from a table to the inventory of the player.
function addRandomItemsFromTable(table, amount, player)
    -- Add the items to the inventory.
    for i = 1, amount do
        player:getInventory():AddItem(getRandomTableID(table));
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

    -- If the player has the feeble trait then they kill more.
    if player:HasTrait("Feeble") then killMultiplier = killMultiplier * 0.8 end

    -- If the player has the cowardly trait then they kill more.
    if player:HasTrait("Cowardly") then killMultiplier = killMultiplier * 0.8 end

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
    for i = 1, days do
        kills = kills + ZombRand(killMin, killMax);
    end

    -- Set the kill count of the player.
    player:setZombieKills(kills);
end