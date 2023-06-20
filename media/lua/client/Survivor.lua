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