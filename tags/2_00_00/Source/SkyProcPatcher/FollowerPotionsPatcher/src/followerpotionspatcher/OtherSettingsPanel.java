/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package followerpotionspatcher;

import lev.gui.LCheckBox;
import lev.gui.LComboBox;
import skyproc.SPGlobal;
import skyproc.gui.SPMainMenuPanel;
import skyproc.gui.SPSettingPanel;
import skyproc.gui.SUMGUI;

/**
 *
 * @author Justin Swanson
 */
public class OtherSettingsPanel extends SPSettingPanel {

    LCheckBox importOnStartup;
    LCheckBox onlyAddFollowers;
    
    public OtherSettingsPanel(SPMainMenuPanel parent_) {
	super(parent_, "Other Settings", FollowerPotionsPatcher.headerColor);
    }

    @Override
    protected void initialize() {
	super.initialize();

        onlyAddFollowers = new LCheckBox("Only Add Followers", FollowerPotionsPatcher.settingsFont, FollowerPotionsPatcher.settingsColor);
        onlyAddFollowers.tie(YourSaveFile.Settings.ONLY_ADD_FOLLOWERS, FollowerPotionsPatcher.save, SUMGUI.helpPanel, true);
        onlyAddFollowers.setOffset(2);
	onlyAddFollowers.addShadow();
	setPlacement(onlyAddFollowers);
	AddSetting(onlyAddFollowers);
        
	importOnStartup = new LCheckBox("Import Mods on Startup", FollowerPotionsPatcher.settingsFont, FollowerPotionsPatcher.settingsColor);
	importOnStartup.tie(YourSaveFile.Settings.IMPORT_AT_START, FollowerPotionsPatcher.save, SUMGUI.helpPanel, true);
        importOnStartup.setOffset(4);
	importOnStartup.addShadow();
	setPlacement(importOnStartup);
	AddSetting(importOnStartup);

	alignRight();

    }
}
