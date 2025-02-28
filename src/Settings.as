// m 2025-02-27

namespace SettingsTab {
    namespace UI {
        void ResetButton(const string &in category, const string &in label = "Reset to default", const vec2 &in dummy_size = vec2(0.0f, 2.0f)) {
            if (UI::Button(label))
                SettingsTab::resetCategory(category);
            UI::Dummy(dummy_size);
        }
    }

    void resetCategory(const string &in category) {
        Meta::PluginSetting@[]@ Settings = Meta::ExecutingPlugin().GetSettings();

        for (uint i = 0; i < Settings.Length; i++)
            if (Settings[i].Category != category)
                Settings.RemoveAt(i);

        for (uint i = 0; i < Settings.Length; i++)
            Settings[i].Reset();
    }
}

[Setting category="General" name="Log more information"]
bool S_DebugLog = false;

[Setting hidden category="Button" name="Automatic placement of button"]
bool AutoPlaceButton = true;

[Setting hidden category="Button" name="Button Size X"]
float ButtonSizeX = 48;
[Setting hidden category="Button" name="Button Size Y"]
float ButtonSizeY = 48;
[Setting hidden category="Button" name="Button Position X"]
float ButtonPosX = 0.028125;
[Setting hidden category="Button" name="Button Position Y"]
float ButtonPosY = 0.333;

[Setting hidden category="Button" name="Show button if leaderboard is collapsed"]
bool ShowButtonWithCollapsedLeaderboard = false;

[Setting hidden category="Button" name="Hide when Openplanet overlay is hidden"]
bool InterfaceToggle = false;

[SettingsTab name="Button" icon="Square" order="0"]
void RenderSettingsButton() {
    SettingsTab::UI::ResetButton('Button');

    UI::TextWrapped("Disable Automatic placement of button to customize button size and position.");

    AutoPlaceButton = UI::Checkbox("Automatic placement of button", AutoPlaceButton);

    if (!AutoPlaceButton) {
        UI::Dummy(vec2(0.0f, 5.0f));
        UI::Separator();
        UI::Dummy(vec2(0.0f, 5.0f));

        UI::TextWrapped("Button size in pixels. Won't scale with resolution.");

        UI::Columns(2, "ButtonSize", false);
        ButtonSizeX = UI::SliderFloat("X##size", ButtonSizeX, 0.0f, ScreenWidth);
        UI::NextColumn();
        ButtonSizeY = UI::SliderFloat("Y##size", ButtonSizeY, 0.0f, ScreenHeight);
        UI::Columns(1);
        UI::Dummy(vec2(0.0f, 10.0f));
        UI::TextWrapped("Button position. Value between 0 and 1. Will scale with resolution.");
        UI::Columns(2, "ButtonPos", false);
        ButtonPosX = UI::SliderFloat("X##pos", ButtonPosX, 0.0f, 1.0f);
        UI::NextColumn();
        ButtonPosY = UI::SliderFloat("Y##pos", ButtonPosY, 0.0f, 1.0f);
        UI::Columns(1);
    }

    UI::Separator();
    UI::Markdown("Show the button if the leaderboard is collapsed, or when the leaderboard is hidden by other plugins (e.g. HUD Picker). **Might "
                 "improve performance slightly if turned on.** By default turned off.");
    ShowButtonWithCollapsedLeaderboard = UI::Checkbox("Show button if leaderboard is collapsed", ShowButtonWithCollapsedLeaderboard);
    InterfaceToggle                    = UI::Checkbox("Hide when Openplanet overlay is hidden", InterfaceToggle);
}

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
