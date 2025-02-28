// c 2025-02-27
// m 2025-02-27

UI::Texture@ icon;
const vec4   colorHovered    = vec4(vec3(0.15f), 0.8f);
const vec4   colorNormal     = vec4(vec3(), 0.85f);
const string gray            = "\\$888";
const string green           = "\\$0F0";
bool         hovering        = false;
bool         permViewRecords = false;
vec2         pos;
const string red             = "\\$F00";
bool         refresh         = false;
const float  sixteenNine     = 16.0f / 9.0f;

void Main() {
    if (!(permViewRecords = Permissions::ViewRecords()))
        return;

    @icon = UI::LoadTexture("assets/icon.png");

    startnew(Leaderboard::Loop);

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    while (true) {
        yield();

        if (refresh) {
            App.CurrentProfile.Interface_AlwaysDisplayRecords = !App.CurrentProfile.Interface_AlwaysDisplayRecords;
            yield();
            App.CurrentProfile.Interface_AlwaysDisplayRecords = !App.CurrentProfile.Interface_AlwaysDisplayRecords;

            trace(Icons::Refresh + " Refreshed Leaderboard");
            refresh = false;
        }
    }
}

UI::InputBlocking OnMouseButton(bool down, int button, int x, int y) {
    if (true
        && down
        && button == 0
        && ShouldRun()
        && x > pos.x
        && x < pos.x + S_Size.x
        && y > pos.y
        && y < pos.y + S_Size.y
    ) {
        refresh = true;
        return UI::InputBlocking::Block;
    }

    return UI::InputBlocking::DoNothing;
}

void OnMouseMove(int x, int y) {
    if (!ShouldRun())
        return;

    hovering = (true
        && x > pos.x
        && x < pos.x + S_Size.x
        && y > pos.y
        && y < pos.y + S_Size.y
    );
}

void Render() {
    if (!ShouldRun() || icon is null)
        return;

    UI::DrawList@ DrawList = UI::GetBackgroundDrawList();

    DrawList.AddRectFilled(
        vec4(pos, S_Size),
        hovering ? colorHovered : colorNormal
    );

    DrawList.AddImage(icon, pos, S_Size, 0xEBEBEB40);
}

void Update(float) {
    const vec2 resolution = vec2(
        Math::Max(1, Draw::GetWidth()),
        Math::Max(1, Draw::GetHeight())
    );

    if (S_Size.x <= 0.0f || S_Size.y <= 0.0f)
        S_Size = vec2(resolution.y / 22.5f);

    if (!S_Manual) {
        S_Size = vec2(resolution.y / 22.5f);

        // Calculate the equivalent position for all resolutions; X = 0.028 on 16/9 display. >16/9 -> offset, <16/9 -> squish
        const float idealWidth = Math::Min(resolution.x, resolution.y * sixteenNine);
        const float aspectDiff = Math::Max(0.0f, resolution.x / resolution.y - sixteenNine) / 2.0f;

#if DEPENDENCY_ULTRAWIDEUIFIX
        // We have a shift value from UltrawideUIFix, convert it to a fraction of a 16/9 display width and subtract it from the default position
        S_PosX = ((0.028125f - (UltrawideUIFix::GetUiShift() / 320)) * idealWidth + resolution.y * aspectDiff) / resolution.x;
#else
        S_PosX = (0.028125f * idealWidth + resolution.y * aspectDiff) / resolution.x;
#endif

        S_PosY = 0.33333f;
    }

    pos = vec2(resolution.x * S_PosX, resolution.y * S_PosY);
}

bool InMap() {
    CTrackMania@ App = cast<CTrackMania@>(GetApp());
    return true
        && App.Editor is null
        && App.RootMap !is null
        && App.CurrentPlayground !is null
    ;
}

bool ShouldRun() {
    return true
        && permViewRecords
        && Leaderboard::visible
        && InMap()
        && UI::IsGameUIVisible()
        && (!S_HideWithOP || UI::IsOverlayShown())
    ;
}
