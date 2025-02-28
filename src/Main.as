// m 2025-02-27

vec2         AbsoluteButtonPosition;
UI::Texture@ ButtonIcon;
vec2         ButtonPosition;
vec2         ButtonSize;
const vec4   colorHovered            = vec4(vec3(0.15f), 0.8f);
const vec4   colorNormal             = vec4(vec3(), 0.85f);
bool         CurrentlyHoveringButton = false;
bool         CurrentlyInMap          = false;
bool         PermissionViewRecords   = false;
float        ScreenHeight;
float        ScreenWidth;
const float  sixteenNine = 16.0f / 9.0f;

void Main() {
    PermissionViewRecords = Permissions::ViewRecords();
    @ButtonIcon = UI::LoadTexture("assets/RefreshLB_icon.png");

    startnew(Leaderboard::Coroutine);
    startnew(Refresh::Loop);
}

void Render() {
    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    if (false
        || !PermissionViewRecords
        || !Leaderboard::isVisible
        || App.Editor !is null
        || App.RootMap is null
        || App.CurrentPlayground is null
        || !UI::IsGameUIVisible()
        || (InterfaceToggle && !UI::IsOverlayShown())
    )
        return;

    UI::DrawList@ DrawList = UI::GetBackgroundDrawList();

    DrawList.AddRectFilled(
        vec4(AbsoluteButtonPosition, ButtonSize),
        CurrentlyHoveringButton ? colorHovered : colorNormal
    );

    DrawList.AddImage(ButtonIcon, AbsoluteButtonPosition, ButtonSize, 0xEBEBEB40);
}

void Update(float) {
    ScreenHeight = Math::Max(1, Draw::GetHeight());
    ScreenWidth = Math::Max(1, Draw::GetWidth());

    if (AutoPlaceButton) {
        ButtonSizeX = ButtonSizeY = ScreenHeight / 22.5f;

        // Calculate the equivalent position for all resolutions; X = 0.028 on 16/9 display. >16/9 -> offset, <16/9 -> squish
        const float IdealWidth = Math::Min(ScreenWidth, ScreenHeight * sixteenNine);
        const float AspectDiff = Math::Max(0.0f, ScreenWidth / ScreenHeight - sixteenNine) / 2.0f;

#if DEPENDENCY_ULTRAWIDEUIFIX
        // We have a shift value from UltrawideUIFix, convert it to a fraction of a 16/9 display width and subtract it from the default position
        // PR by @dpeukert: https://github.com/nbeerten/tm-refresh-leaderboard/pull/6
        ButtonPosX = ((0.028125f - (UltrawideUIFix::GetUiShift() / 320)) * IdealWidth + ScreenHeight * AspectDiff) / ScreenWidth;
#else
        ButtonPosX = (0.028125f * IdealWidth + ScreenHeight * AspectDiff) / ScreenWidth;
#endif

        ButtonPosY = 0.333f;
    }

    // Revert size if they are invalid (Size of 0 or lower would hide the button)
    if (ButtonSizeX <= 0.0f || ButtonSizeY <= 0.0f)
        ButtonSizeX = ButtonSizeY = ScreenHeight / 22.5f;

    ButtonSize     = vec2(ButtonSizeX, ButtonSizeY);
    ButtonPosition = vec2(ButtonPosX, ButtonPosY);

    AbsoluteButtonPosition = ButtonPosition * vec2(ScreenWidth, ScreenHeight);

    CTrackMania@ App = cast<CTrackMania>(GetApp());
    CurrentlyInMap = App.CurrentPlayground !is null && App.RootMap !is null;
}

void OnMouseMove(int x, int y) {
    if (false
        || !Leaderboard::isVisible
        || !PermissionViewRecords
        || !UI::IsGameUIVisible()
    )
        return;

    CurrentlyHoveringButton = (true
        && x > AbsoluteButtonPosition.x
        && x < AbsoluteButtonPosition.x + ButtonSize.x
        && y > AbsoluteButtonPosition.y
        && y < AbsoluteButtonPosition.y + ButtonSize.y
    );
}

UI::InputBlocking OnMouseButton(bool down, int button, int x, int y) {
    if (!PermissionViewRecords || !UI::IsGameUIVisible())
        return UI::InputBlocking::DoNothing;

    if (true
        && Leaderboard::isVisible
        && down
        && button == 0
        && x > AbsoluteButtonPosition.x
        && x < AbsoluteButtonPosition.x + ButtonSize.x
        && y > AbsoluteButtonPosition.y
        && y < AbsoluteButtonPosition.y + ButtonSize.y
    ) {
        Refresh::Refresh();
        return UI::InputBlocking::Block;
    }

    return UI::InputBlocking::DoNothing;
}
