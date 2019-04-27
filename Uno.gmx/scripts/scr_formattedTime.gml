///scr_formattedTime(seconds)
var seconds = argument[0];

return string_interp("{0}:{1}{2}", seconds div 60, (seconds div 10) mod 6, seconds % 10);
