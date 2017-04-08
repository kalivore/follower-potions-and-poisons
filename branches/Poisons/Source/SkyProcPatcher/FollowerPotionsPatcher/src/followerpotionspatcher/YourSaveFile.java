/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package followerpotionspatcher;

import skyproc.SkyProcSave;

/**
 *
 * @author Justin Swanson
 */
public class YourSaveFile extends SkyProcSave {

    @Override
    protected void initSettings() {
	//  The Setting,	    The default value,	    Whether or not it changing means a new patch should be made
	Add(Settings.IMPORT_AT_START,		true,	    false);
	Add(Settings.ONLY_ADD_FOLLOWERS,	false,	    true);
    }

    @Override
    protected void initHelp() {

	helpInfo.put(Settings.IMPORT_AT_START,
		"If enabled, the program will begin importing your mods when the program starts.\n\n"
		+ "If turned off, the program will wait until it is necessary before importing.\n\n"
		+ "NOTE: This setting will not take effect until the next time the program is run.\n\n"
		+ "Benefits:\n"
		+ "- Faster patching when you close the program.\n"
		+ "- More information displayed in GUI, as it will have access to the records from your mods."
		+ "\n\n"
		+ "Downsides:\n"
		+ "- Having this on might make the GUI respond sluggishly while it processes in the "
		+ "background.");

	helpInfo.put(Settings.ONLY_ADD_FOLLOWERS,
		"If enabled, then only NPCs in CurrentFollowerFaction and/or PotentialFollowerFaction\n"
                + "(ie those likely to become followers) will have perks added.");
        
	helpInfo.put(Settings.OTHER_SETTINGS,
		"Other handy options.");
    }

    // Note that some settings just have help info, and no actual values in
    // initSettings().
    public enum Settings {
	IMPORT_AT_START,
        ONLY_ADD_FOLLOWERS,
	OTHER_SETTINGS;
    }
}
