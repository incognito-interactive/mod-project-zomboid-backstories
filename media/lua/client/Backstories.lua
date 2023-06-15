-- Require the tables.
require("Tables.Foods");

-- Require the functions lua file.
require("Functions");

-- Apply the mod on the new game event.
Events.OnNewGame.Add(function(player, square)
    -- Get the day count since the start of the apocalypse.
    local days = getZomboidRadio():getDaysSinceStart();

    -- Simulate the player zombie kills.
    simulateZombieKills(days, player);
end)