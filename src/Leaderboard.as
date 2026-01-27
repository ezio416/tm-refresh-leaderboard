namespace Leaderboard {
    bool visible = false;

    const string[] validModes = {
        "TM_Campaign_Local",
        "TM_TimeAttack_Online",
        "TM_PlayMap_Local",
        "TM_Stunt_Local",  // no longer used?
        "TM_StuntMulti_Online",
        "TM_StuntSolo_Local"
    };
    const CGamePlaygroundUIConfig::EUISequence[] validSequences = {
        CGamePlaygroundUIConfig::EUISequence::Playing,
        CGamePlaygroundUIConfig::EUISequence::Finish
    };

    void Loop() {
        while (true) {
            yield();

            try {
                visible = true
                    && byPauseMenu()
                    && bySettings()
                    && byStartTime()
                    && byUISequence()
                    && byGameMode()
                    && byPersonalBest()
                    && byManiaLink()
                ;
            } catch {
                visible = false;
            }
        }
    }

    bool byGameMode() {
        const string mode = string(cast<CTrackManiaNetworkServerInfo@>(GetApp().Network.ServerInfo).CurGameModeStr).Trim();
        // The Archivist script name changes regularly to avoid caching, but this will reliably detect it.
        return mode.StartsWith("TM_Archivist_") || validModes.Find(mode) > -1;
    }

    bool byManiaLink() {
        if (S_ShowCollapsed)
            return true;

        CGameManiaAppPlayground@ CMAP = GetApp().Network.ClientManiaAppPlayground;
        if (CMAP.Playground is null || CMAP.UILayers.Length < 2)
            return false;

        for (uint i = 0; i < CMAP.UILayers.Length; i++) {
            CGameUILayer@ Layer = CMAP.UILayers[i];
            if (Layer is null)
                continue;

            const int start = Layer.ManialinkPageUtf8.IndexOf('<');
            const int end = Layer.ManialinkPageUtf8.IndexOf('>');
            if (false
                || start == -1
                || end == -1
                || !Layer.ManialinkPageUtf8.SubStr(start, end).Contains("UIModule_Race_Record")
            )
                continue;

            if (!Layer.IsVisible)
                return false;

            CGameManialinkQuad@ Button = cast<CGameManialinkQuad@>(Layer.LocalPage.GetFirstChild("quad-toggle-records-icon"));
            if (Button.ImageUrl == "file://Media/Manialinks/Nadeo/TMGame/Modes/Record/Icon_ArrowLeft.dds")
                return true;
            if (Button.ImageUrl == "file://Media/Manialinks/Nadeo/TMGame/Modes/Record/Icon_WorldRecords.dds")
                return false;
        }

        return false;
    }

    bool byPauseMenu() {
        return !GetApp().Network.PlaygroundClientScriptAPI.IsInGameMenuDisplayed;
    }

    bool byPersonalBest() {
        CTrackMania@ App = cast<CTrackMania@>(GetApp());

        if (App.CurrentProfile.Interface_AlwaysDisplayRecords)
            return true;

        CGameManiaAppPlayground@ CMAP = App.Network.ClientManiaAppPlayground;
        const uint pb = CMAP.ScoreMgr.Map_GetRecord_v2(CMAP.UserMgr.Users[0].Id, App.RootMap.EdChallengeId, "PersonalBest", "", "TimeAttack", "");

        return pb != uint(-1) && pb < App.RootMap.TMObjective_GoldTime;
    }

    bool bySettings() {
        return GetApp().CurrentProfile.Interface_DisplayRecords != CGameUserProfileWrapper::EDisplayRecords::Hide;
    }

    bool byStartTime() {
        CSmArenaRulesMode@ PlaygroundScript = cast<CSmArenaRulesMode@>(GetApp().PlaygroundScript);
        return PlaygroundScript is null || PlaygroundScript.StartTime <= 2147483000;
    }

    bool byUISequence() {
        return validSequences.Find(GetApp().Network.ClientManiaAppPlayground.UI.UISequence) > -1;
    }
}
