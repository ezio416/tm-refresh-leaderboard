// m 2025-02-27

[Setting category="General" name="Log more information"]
bool S_DebugLog = false;

[SettingsTab name="Debug" icon="Bug" order=1]
void RenderSettingsDebug() {
    SettingsTab::UI::ResetButton("Debug");

    UI::Markdown("## Debug information");
    UI::Text("CurrentlyInMap" + (CurrentlyInMap ? Icons::Check : Icons::Times));
    bool AlwaysDisplayRecords = GetApp().CurrentProfile.Interface_AlwaysDisplayRecords;
    UI::Text("AlwaysDisplayRecords" + (AlwaysDisplayRecords ? Icons::Check : Icons::Times));
    UI::Separator();
    UI::Markdown("### Items below should all be checked for button to be visible");
    UI::Text("UI::IsGameUIVisible()" + (UI::IsGameUIVisible() ? Icons::Check : Icons::Times));
    UI::Text("Leaderboard::isVisible" + (Leaderboard::isVisible ? Icons::Check : Icons::Times));
    UI::Separator();
    UI::Markdown("### Button Information");
    UI::Text("CurrentlyHoveringButton" + (CurrentlyHoveringButton ? Icons::Check : Icons::Times));
    UI::Text("Size: " + tostring(ButtonSize) + " (X: " + ButtonSizeX + ", Y: " + ButtonSizeY + ")");
    UI::Text("Position: " + tostring(ButtonPosition));
    UI::Text("Absolute Position: " + tostring(AbsoluteButtonPosition));
}
