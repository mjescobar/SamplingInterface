

function [refresh,height,width]=getData(screenID)

oldLevel = Screen('Preference', 'VisualDebugLevel', 1);
oldSkip = Screen('Preference', 'SkipSyncTests',0);

win=Screen('OpenWindow',screenID);
refresh = Screen('GetFlipInterval', win,0);
[width,height]=Screen('WindowSize',win);
Screen('closeAll');

Screen('Preference', 'SkipSyncTests',oldSkip);
Screen('Preference', 'VisualDebugLevel', oldLevel );

end
