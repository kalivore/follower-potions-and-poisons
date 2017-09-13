package followerpotionspatcher;

import java.awt.Color;
import java.awt.Font;
import java.net.URL;
import java.util.ArrayList;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import lev.gui.LSaveFile;
import skyproc.*;
import skyproc.gui.SPMainMenuPanel;
import skyproc.gui.SUM;
import skyproc.gui.SUMGUI;
import followerpotionspatcher.YourSaveFile.Settings;

/**
 *
 * @author Your Name Here
 */
public class FollowerPotionsPatcher implements SUM {

    /*
     * The important functions to change are:
     * - getStandardMenu(), where you set up the GUI
     * - runChangesToPatch(), where you put all the processing code and add records to the output patch.
     */

    /*
     * The types of records you want your patcher to import. Change this to
     * customize the import to what you need.
     */
    GRUP_TYPE[] importRequests = new GRUP_TYPE[]{
	GRUP_TYPE.NPC_,
        GRUP_TYPE.MGEF,
        GRUP_TYPE.KYWD
    };
    public static String myPatchName = "Follower Potions Patcher";
    public static String authorName = "Kalivore";
    public static String version = "2.0";
    public static String welcomeText = "This patcher applies the PerkSkillBoosts and AlchemySkillBoosts Perks to all NPCs, allowing them to benefit from the effects of Fortify enchantments and potions."+
                "\n"+
                "Also adds vanilla (but unused) MagicAlchDamageHealth, MagicAlchDamageMagicka and MagicAlchDamageStamina keywords to relevant poison Magic Effects, so followers can identify and use them.";
    public static String descriptionToShowInSUM = "Applies the PerkSkillBoosts and AlchemySkillBoosts Perks to all NPCs, allowing them to benefit from the effects of Fortify enchantments and potions."+
                "\n"+
                "Also adds vanilla (but unused) MagicAlchDamageHealth, MagicAlchDamageMagicka and MagicAlchDamageStamina keywords to relevant poison Magic Effects, so followers can identify and use them.";
    public static Color headerColor = new Color(66, 181, 184);  // Teal
    public static Color settingsColor = new Color(72, 179, 58);  // Green
    public static Font settingsFont = new Font("Serif", Font.BOLD, 15);
    public static SkyProcSave save = new YourSaveFile();

    // Do not write the bulk of your program here
    // Instead, write your patch changes in the "runChangesToPatch" function
    // at the bottom
    public static void main(String[] args) {
	try {
	    SPGlobal.createGlobalLog();
            SPGlobal.logMain("SPGlobal", "Follower Potions Patcher is starting");
	    SUMGUI.open(new FollowerPotionsPatcher(), args);
	}
        catch (Exception e) {
	    // If a major error happens, print it everywhere and display a message box.
	    System.err.println(e.toString());
	    SPGlobal.logException(e);
	    JOptionPane.showMessageDialog(null, "There was an exception thrown during program execution: '" + e + "'  Check the debug logs or contact the author.");
	    SPGlobal.closeDebug();
	}
    }

    @Override
    public String getName() {
	return myPatchName;
    }

    // This function labels any record types that you "multiply".
    // For example, if you took all the armors in a mod list and made 3 copies,
    // you would put ARMO here.
    // This is to help monitor/prevent issues where multiple SkyProc patchers
    // multiply the same record type to yeild a huge number of records.
    @Override
    public GRUP_TYPE[] dangerousRecordReport() {
	// None
	return new GRUP_TYPE[0];
    }

    @Override
    public GRUP_TYPE[] importRequests() {
	return importRequests;
    }

    @Override
    public boolean importAtStart() {
	return false;
    }

    @Override
    public boolean hasStandardMenu() {
	return true;
    }

    // This is where you add panels to the main menu.
    // First create custom panel classes (as shown by YourFirstSettingsPanel),
    // Then add them here.
    @Override
    public SPMainMenuPanel getStandardMenu() {
	SPMainMenuPanel settingsMenu = new SPMainMenuPanel(getHeaderColor());

	settingsMenu.setWelcomePanel(new WelcomePanel(settingsMenu));
	settingsMenu.addMenu(new OtherSettingsPanel(settingsMenu), false, save, Settings.OTHER_SETTINGS);

	return settingsMenu;
    }

    // Usually false unless you want to make your own GUI
    @Override
    public boolean hasCustomMenu() {
	return false;
    }

    @Override
    public JFrame openCustomMenu() {
	throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean hasLogo() {
	return false;
    }

    @Override
    public URL getLogo() {
	throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean hasSave() {
	return true;
    }

    @Override
    public LSaveFile getSave() {
	return save;
    }

    @Override
    public String getVersion() {
	return version;
    }

    @Override
    public ModListing getListing() {
	return new ModListing(getName(), false);
    }

    @Override
    public Mod getExportPatch() {
	Mod out = new Mod(getListing());
	out.setAuthor(authorName);
	return out;
    }

    @Override
    public Color getHeaderColor() {
	return headerColor;
    }

    // Add any custom checks to determine if a patch is needed.
    // On Automatic Variants, this function would check if any new packages were
    // added or removed.
    @Override
    public boolean needsPatching() {
	return false;
    }

    // This function runs when the program opens to "set things up"
    // It runs right after the save file is loaded, and before the GUI is displayed
    @Override
    public void onStart() throws Exception {
    }

    // This function runs right as the program is about to close.
    @Override
    public void onExit(boolean patchWasGenerated) throws Exception {
    }

    // Add any mods that you REQUIRE to be present in order to patch.
    @Override
    public ArrayList<ModListing> requiredMods() {
	return new ArrayList<>(0);
    }

    @Override
    public String description() {
	return "Applies the PerkSkillBoosts and AlchemySkillBoosts Perks to all NPCs, allowing them to benefit from the effects of Fortify enchantments and potions."+
                "\n"+
                "Also adds vanilla (but unused) MagicAlchDamageHealth, MagicAlchDamageMagicka and MagicAlchDamageStamina keywords to relevant poison Magic Effects, so followers can identify and use them.";
    }

    // This is where you should write the bulk of your code.
    // Write the changes you would like to make to the patch,
    // but DO NOT export it.  Exporting is handled internally.
    @Override
    public void runChangesToPatch() throws Exception
    {
        Mod patch = SPGlobal.getGlobalPatch();

	Mod merger = new Mod(getName() + "Merger", false);
	merger.addAsOverrides(SPGlobal.getDB());

        // Write your changes to the patch here.
        
        FormID mgefFearFormId = new FormID("73F20", "Skyrim.esm");
        FormID mgefFrenzyFormId = new FormID("73F29", "Skyrim.esm");
        
        MGEF fear = (MGEF)merger.getMajor(mgefFearFormId, GRUP_TYPE.MGEF);
        MGEF frenzy = (MGEF)merger.getMajor(mgefFrenzyFormId, GRUP_TYPE.MGEF);
        
        // get the 'BasicNeedsSleepRested' keyword
        FormID cacoKeywordFormId = new FormID("5D2183", "Complete Alchemy & Cooking Overhaul.esp");
        KYWD cacoKeyword = (KYWD)merger.getMajor(cacoKeywordFormId, GRUP_TYPE.KYWD);
        if (cacoKeyword == null)
        {
            SPGlobal.logMain("SPGlobal", "CACO not present - adding MagicAlchDamage keywords to effects");

            FormID mgefDamageHealthFormId = new FormID("3EB42", "Skyrim.esm");
            FormID mgefDamageMagickaFormId = new FormID("3A2B6", "Skyrim.esm");
            FormID mgefDamageStaminaFormId = new FormID("3A2C6", "Skyrim.esm");
            
            FormID alchDamageHealthFormId = new FormID("10F9DD", "Skyrim.esm");
            FormID alchDamageMagickaFormId = new FormID("10F9DE", "Skyrim.esm");
            FormID alchDamageStaminaFormId = new FormID("10F9DC", "Skyrim.esm");
            FormID alchHarmfulFormId = new FormID("42509", "Skyrim.esm");

            MGEF damageHealth = (MGEF)merger.getMajor(mgefDamageHealthFormId, GRUP_TYPE.MGEF);
            damageHealth.getKeywordSet().addKeywordRef(alchDamageHealthFormId);
            patch.addRecord(damageHealth);

            MGEF damageMagicka = (MGEF)merger.getMajor(mgefDamageMagickaFormId, GRUP_TYPE.MGEF);
            damageMagicka.getKeywordSet().addKeywordRef(alchDamageMagickaFormId);
            patch.addRecord(damageMagicka);

            MGEF damageStamina = (MGEF)merger.getMajor(mgefDamageStaminaFormId, GRUP_TYPE.MGEF);
            damageStamina.getKeywordSet().addKeywordRef(alchDamageStaminaFormId);
            patch.addRecord(damageStamina);
            
            fear.getKeywordSet().addKeywordRef(alchHarmfulFormId);
            frenzy.getKeywordSet().addKeywordRef(alchHarmfulFormId);
        }
        else
        {
            SPGlobal.logMain("SPGlobal", "CACO present - MagicAlchDamage keywords already on effects");

//            FormID alchSilenceCacoFormId = new FormID("07A150", "Complete Alchemy & Cooking Overhaul.esp");
//            FormID alchFatigueCacoFormId = new FormID("07A153", "Complete Alchemy & Cooking Overhaul.esp");
//            FormID alchDrainIntCacoFormId = new FormID("25B701", "Complete Alchemy & Cooking Overhaul.esp");
//                
        }

        FormID fppMagicFearFormId = new FormID("01256F", "FollowerPotions.esp");
        KYWD kywdFear = (KYWD)merger.getMajor(fppMagicFearFormId, GRUP_TYPE.KYWD);
        if (kywdFear != null)
        {
            SPGlobal.logMain("SPGlobal", "Adding FPP MagicFear keyword");
            fear.getKeywordSet().addKeywordRef(fppMagicFearFormId);
            patch.addRecord(fear);
        }
        else if (cacoKeyword == null)
        {
            patch.addRecord(fear);
        }
        
        FormID fppMagicFrenzyFormId = new FormID("012570", "FollowerPotions.esp");
        KYWD kywdFrenzy = (KYWD)merger.getMajor(fppMagicFrenzyFormId, GRUP_TYPE.KYWD);
        if (kywdFrenzy != null)
        {
            SPGlobal.logMain("SPGlobal", "Adding FPP MagicFrenzy keyword");
            frenzy.getKeywordSet().addKeywordRef(fppMagicFrenzyFormId);
            patch.addRecord(frenzy);
        }
        else if (cacoKeyword == null)
        {
            patch.addRecord(frenzy);
        }
        
        
        // add perks for NPCs
        FormID enchPerkID = new FormID("cf788", "Skyrim.esm");
        FormID alchPerkID = new FormID("a725c", "Skyrim.esm");

        for (NPC_ n : merger.getNPCs())
        {
            ArrayList<SubFormInt> npcPerks = n.getPerks();
            ArrayList<FormID> npcPerkForms = new ArrayList<>(npcPerks.size());
            npcPerks.forEach((s) -> npcPerkForms.add(s.getForm()));
            
            if (!save.getBool(Settings.ONLY_ADD_FOLLOWERS))
            {
                if (needsPerks(npcPerkForms, enchPerkID, alchPerkID, n)) {
                    patch.addRecord(n);
                    SPGlobal.logMain("SPGlobal", "NPC " + n.getName() + " added as we're adding all NPCs");
                }
                continue;
            }
            
            ArrayList<SubFormInt> factions = n.getFactions();
            for (SubFormInt f : factions)
            {
                boolean potFollower = "0005C84D".equals(f.getFormStr());
                boolean curFollower = "0005C84E".equals(f.getFormStr());
                
                if (!potFollower && !curFollower)
                {
                    continue;
                }
                
                if (potFollower)
                {
                    SPGlobal.logMain("SPGlobal", "NPC " + n.getName() + " is in Pot Follower faction");
                }
                else if (curFollower)
                {
                    SPGlobal.logMain("SPGlobal", "NPC " + n.getName() + " is in Cur Follower faction");
                }
                
                if (needsPerks(npcPerkForms, enchPerkID, alchPerkID, n)) {
                    patch.addRecord(n);
                }
                break;
            }
        }
    }
    
    private boolean needsPerks(ArrayList<FormID> npcPerkForms, FormID enchPerkID, FormID alchPerkID, NPC_ n) {
        
        boolean altered = false;
        
        if (!npcPerkForms.contains(enchPerkID)) {
            n.addPerk(enchPerkID, 1);
            altered = true;
        }
        
        if (!npcPerkForms.contains(enchPerkID)) {
            n.addPerk(alchPerkID, 1);
            altered = true;
        }
        
        return altered;
    }

}
