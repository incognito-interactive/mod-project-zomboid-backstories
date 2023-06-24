-- Require the other script(s).
require("World");
require("Survivor")

-- Run backstories when a new game or character is created.
Events.OnNewGame.Add(function(player, square)
    -- Simulate the survival hours of the player.
    simulateSurvivalHours(player, getDaysSinceApocalypse());

    -- Simulate the kills of the player.
    simulateKills(player);

    -- Simulate the gear of the player.
    simulateGear(player);
end)