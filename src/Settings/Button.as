// m 2025-02-27

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
