[Setting category="General" name="Show/hide with Openplanet UI"]
bool S_HideWithOP = false;

[Setting category="General" name="Show when leaderboard is collapsed"]
bool S_ShowCollapsed = false;

[Setting category="General" name="Place button manually"]
bool S_Manual = false;

[Setting category="General" name="Size" description="In pixels. Does not scale with resolution." if="S_Manual"]
vec2 S_Size = vec2(48.0f);

[Setting category="General" name="Position X" min=0.0f max=1.0f if="S_Manual"]
float S_PosX = 0.028125f;

[Setting category="General" name="Position Y" min=0.0f max=1.0f if="S_Manual"]
float S_PosY = 0.33333f;


[SettingsTab name="Debug" icon="Bug"]
void RenderSettingsDebug() {
    UI::SeparatorText("visibility");

    UI::Text((permViewRecords ? green : red) + "can view records");
    UI::Text((InMap() ? green : red) + "in map");
    UI::Text((UI::IsGameUIVisible() ? green : red) + "game UI visible");
    UI::Text((Leaderboard::visible ? green : red) + "leaderboard visible");

    string color = gray;

    try {
        color = Leaderboard::byPauseMenu() ? green : red;
    } catch { }
    UI::Text(color + "    pause menu");

    try {
        color = Leaderboard::bySettings() ? green : red;
    } catch {
        color = gray;
    }
    UI::Text(color + "    settings");

    try {
        color = Leaderboard::byStartTime() ? green : red;
    } catch {
        color = gray;
    }
    UI::Text(color + "    start time");

    try {
        color = Leaderboard::byUISequence() ? green : red;
    } catch {
        color = gray;
    }
    UI::Text(color + "    UI sequence");

    try {
        color = Leaderboard::byGameMode() ? green : red;
    } catch {
        color = gray;
    }
    UI::Text(color + "    game mode");

    try {
        color = Leaderboard::byPersonalBest() ? green : red;
    } catch {
        color = gray;
    }
    UI::Text(color + "    personal best");

    try {
        color = Leaderboard::byManiaLink() ? green : red;
    } catch {
        color = gray;
    }
    UI::Text(color + "    manialink");

    UI::SeparatorText("button");

    UI::Text((hovering ? green : red) + "hovering");
    UI::Text("size \\$F0F" + tostring(S_Size));
    UI::Text("pos \\$F0F" + tostring(pos));
}
