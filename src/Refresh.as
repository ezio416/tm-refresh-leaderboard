// m 2025-02-27

namespace Refresh {
    bool refresh = false;

    void Loop() {
        while (true) {
            yield();

            if (refresh) {
                refresh = false;
                Toggle();

                if (S_DebugLog)
                    trace(Icons::Refresh + " Refreshed Leaderboard");
            }
        }
    }

    void Refresh() {
        refresh = true;
    }

    void Toggle() {
        CTrackMania@ App = cast<CTrackMania@>(GetApp());
        App.CurrentProfile.Interface_AlwaysDisplayRecords = !App.CurrentProfile.Interface_AlwaysDisplayRecords;
        yield();
        App.CurrentProfile.Interface_AlwaysDisplayRecords = !App.CurrentProfile.Interface_AlwaysDisplayRecords;
    }
}
