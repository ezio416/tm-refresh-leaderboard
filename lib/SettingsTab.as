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
