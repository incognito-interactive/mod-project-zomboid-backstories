-- This function returns the total amount of days passed since the apocalypse started.
-- Note that this is NOT determined by any sandbox settings but instead based on the lore-based start date of July 9th 1993.
-- So for example if you start on the 16th of July 1993 then it will return 7 days.
-- https://pzwiki.net/wiki/Knox_Event
function getDaysSinceApocalypse(year, month, day)
    -- Set the start date of the apocalypse.
    local apocalypseDate = os.date("*t", os.time{year = 1993, month = 7, day = 9, hour = 0});

    -- Get the current calender date.
    local calender = getGameTime():getCalender();

    -- Calculate the amount of millisecodns at the start of the apocalypse.
    local apocalypseMillis = os.time(apocalypseDate) * 1000;

    -- Get the current calender time in milliseconds.
    local calenderMillis = calender:getTimeInMillis();

    -- Calculate the amount of milliseconds in a single day.
    local dayMillis = 24 * 60 * 60 * 1000;

    -- Calculate the amount of milliseconds since the start of the apocalypse.
    local apocalypseMillis = calenderMillis - apocalypseMillis;

    -- Calculate the amount of days the apocalypse has lasted.
    local days = math.ceil(apocalypseMillis / dayMillis);

    -- Return the total amount of days since the start of the apocalypse.
    return days;
end