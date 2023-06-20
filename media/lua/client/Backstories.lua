-- Require the other script(s).
require("World");
require("Survivor")

-- Run backstories when a new game or character is created.
Events.OnNewGame.Add(function(player, square)
    simulateSurvivalHours(player, getDaysSinceApocalypse());
end)