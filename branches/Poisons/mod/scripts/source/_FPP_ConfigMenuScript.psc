ScriptName _FPP_ConfigMenuScript extends SKI_ConfigBase

; SCRIPT VERSION ----------------------------------------------------------------------------------
;
; History
;
; 1 - Initial version
; 2 - Added Warning Intervals for when No Potion
; 3 - Added options for how to identify potions
; 4 - Added Trigger Races for when to use potions
; 5 - Added toggle options for Warning Intervals
; 6 - Added Poisons functionality

int function GetVersion()
	return 6
endFunction


; string constants
string Property C_LOGO_PATH = "FollowerPotions/mcm_logo.dds" Autoreadonly
; Image size 768x384
; X offset = 376 - (width / 2) = -8
int offsetX = -8
; Y offset = 223 - (height / 2) = 31
int offsetY = 31

string Property C_STRING_EMPTY = "" Autoreadonly
string Property C_STRING_FORMAT_PLACEHOLDER_ZERO = "{0}" Autoreadonly
string Property C_STRING_INDEX_NAME_SEPARATOR = ": " Autoreadonly

; Translatables
string Property C_PAGE_MISC = "$FPPPageMisc"																Autoreadonly
string Property C_PAGE_DEFAULTS = "$FPPPageDefaults"														Autoreadonly
string Property C_PAGE_NOT_SET = "$FPPPageEmpty"															Autoreadonly
string Property C_FORMAT_PLACEHOLDER_SECONDS = "$FPPFormatPlaceholderSeconds"								Autoreadonly
string Property C_FORMAT_PLACEHOLDER_PERCENT = "$FPPFormatPlaceholderPercent"								Autoreadonly
string Property C_FORMAT_PLACEHOLDER_LEVELS = "$FPPFormatPlaceholderLevels"									Autoreadonly
string Property C_HEADER_LABEL_UPDATE_INTERVALS = "$FPPHeaderLabelUpdateIntervals"							Autoreadonly
string Property C_HEADER_LABEL_RESTORE_POTIONS = "$FPPHeaderLabelRestorePotions"							Autoreadonly
string Property C_HEADER_LABEL_POISONS = "$FPPHeaderLabelPoisons"											Autoreadonly
string Property C_HEADER_LABEL_WARNING_INTERVALS = "$FPPHeaderLabelWarningIntervals"						Autoreadonly
string Property C_HEADER_LABEL_FORTIFY_RESIST_POTIONS = "$FPPHeaderLabelFortifyResistPotions"				Autoreadonly
string Property C_HEADER_LABEL_ACTIONS = "$FPPHeaderLabelActions"											Autoreadonly
string Property C_HEADER_LABEL_POTION_IDENT = "$FPPHeaderLabelPotionIdent"									Autoreadonly
string Property C_MENU_OPTION_CANCEL = "$FPPMenuOptionCancel"												Autoreadonly
string Property C_MENU_OPTION_RESET = "$FPPMenuOptionReset"													Autoreadonly
string Property C_MENU_OPTION_REFRESH = "$FPPMenuOptionRefresh"												Autoreadonly
string Property C_MENU_OPTION_REMOVE = "$FPPMenuOptionRemove"												Autoreadonly
string Property C_MENU_OPTION_ADD_POTIONS = "$FPPMenuOptionAddPotions"										Autoreadonly
string Property C_MENU_OPTION_EFFECTS_ALL = "$FPPMenuOptionEffectsAll"										Autoreadonly
string Property C_MENU_OPTION_EFFECTS_RESTORE = "$FPPMenuOptionEffectsRestore"								Autoreadonly
string Property C_MENU_OPTION_EFFECTS_FORTIFY = "$FPPMenuOptionEffectsFortify"								Autoreadonly
string Property C_MENU_OPTION_EFFECTS_RESIST = "$FPPMenuOptionEffectsResist"								Autoreadonly
string Property C_MENU_OPTION_EFFECTS_FIRST = "$FPPMenuOptionEffectsFirst"									Autoreadonly
string Property C_MENU_OPTION_EFFECTS_SECOND = "$FPPMenuOptionEffectsSecond"								Autoreadonly
string Property C_MENU_OPTION_EFFECTS_THIRD = "$FPPMenuOptionEffectsThird"									Autoreadonly
string Property C_MENU_OPTION_POISON_ALWAYS = "$FPPMenuOptionPoisonAlways"									Autoreadonly
string Property C_MENU_OPTION_POISON_ON_ENGAGE = "$FPPMenuOptionPoisonOnEngage"								Autoreadonly
string Property C_MENU_OPTION_POISON_NEVER = "$FPPMenuOptionPoisonNever"									Autoreadonly
string Property C_OPTION_LABEL_NO_FOLLOWER = "$FPPOptionLabelNoFollower"									Autoreadonly
string Property C_OPTION_LABEL_DEBUG = "$FPPOptionLabelDebug"												Autoreadonly
string Property C_OPTION_LABEL_ADD_ON_FOLLOW = "$FPPOptionLabelAddOnFollow"									Autoreadonly
string Property C_OPTION_LABEL_CURRENT_VERSION = "$FPPOptionLabelCurrentVersion"							Autoreadonly
string Property C_OPTION_LABEL_ACTIONS_ALL = "$FPPOptionLabelActionsAll"									Autoreadonly
string Property C_OPTION_LABEL_USE_POTIONS = "$FPPOptionLabelUsePotions{0}"									Autoreadonly
string Property C_OPTION_LABEL_POISON_MAIN = "$FPPOptionLabelPoisonMain"									Autoreadonly
string Property C_OPTION_LABEL_POISON_BOW = "$FPPOptionLabelPoisonBow"										Autoreadonly
string Property C_OPTION_LABEL_POISON_OFFHAND = "$FPPOptionLabelPoisonOffhand"								Autoreadonly
string Property C_OPTION_LABEL_UPDATE_IN_COMBAT = "$FPPOptionLabelUpdateInCombat"							Autoreadonly
string Property C_OPTION_LABEL_UPDATE_NON_COMBAT = "$FPPOptionLabelUpdateNonCombat"							Autoreadonly
string Property C_OPTION_LABEL_ENABLE_WARNING_NO_POTIONS = "$FPPOptionLabelEnableWarningNoPotions"			Autoreadonly
string Property C_OPTION_LABEL_UPDATE_NO_POTIONS = "$FPPOptionLabelUpdateNoPotions"							Autoreadonly
string Property C_OPTION_LABEL_ENABLE_WARNING_RESTORE = "$FPPOptionLabelEnableWarningRestore"				Autoreadonly
string Property C_OPTION_LABEL_WARNING_RESTORE = "$FPPOptionLabelWarningRestore"							Autoreadonly
string Property C_OPTION_LABEL_ENABLE_WARNING_FORTIFY_RESIST = "$FPPOptionLabelEnableWarningFortifyResist"	Autoreadonly
string Property C_OPTION_LABEL_WARNING_FORTIFY_RESIST = "$FPPOptionLabelWarningFortifyResist"				Autoreadonly
string Property C_OPTION_LABEL_ENABLE_WARNING_POISONS = "$FPPOptionLabelEnableWarningPoisons"				Autoreadonly
string Property C_OPTION_LABEL_WARNING_POISONS = "$FPPOptionLabelWarningPoisons"							Autoreadonly
string Property C_OPTION_LABEL_HEALTH_IN_COMBAT = "$FPPOptionLabelHealthInCombat"							Autoreadonly
string Property C_OPTION_LABEL_HEALTH_NON_COMBAT = "$FPPOptionLabelHealthNonCombat"							Autoreadonly
string Property C_OPTION_LABEL_STAMINA_IN_COMBAT = "$FPPOptionLabelStaminaInCombat"							Autoreadonly
string Property C_OPTION_LABEL_STAMINA_NON_COMBAT = "$FPPOptionLabelStaminaNonCombat"						Autoreadonly
string Property C_OPTION_LABEL_MAGICKA_IN_COMBAT = "$FPPOptionLabelMagickaInCombat"							Autoreadonly
string Property C_OPTION_LABEL_MAGICKA_NON_COMBAT = "$FPPOptionLabelMagickaNonCombat"						Autoreadonly
string Property C_OPTION_LABEL_ENEMY_OVER = "$FPPOptionLabelEnemyOver"										Autoreadonly
string Property C_OPTION_LABEL_POTION_IDENT = "$FPPOptionLabelPotionIdent"									Autoreadonly
string Property C_OPTION_LABEL_DUMMY_TRIGGER_RACES = "$FPPOptionLabelDummyTriggerRaces"						Autoreadonly
string Property C_OPTION_LABEL_TRIGGER_RACE_DRAGON = "$FPPOptionLabelTriggerRaceDragon"						Autoreadonly
string Property C_OPTION_LABEL_TRIGGER_RACE_DRAGON_PRIEST = "$FPPOptionLabelTriggerRaceDragonPriest"		Autoreadonly
string Property C_OPTION_LABEL_TRIGGER_RACE_GIANT = "$FPPOptionLabelTriggerRaceGiant"						Autoreadonly
string Property C_OPTION_LABEL_TRIGGER_RACE_VAMPIRE_LORD = "$FPPOptionLabelTriggerRaceVampireLord"			Autoreadonly
string Property C_OPTION_VALUE_SELECT_ACTION = "$FPPOptionValueSelectAction"								Autoreadonly
string Property C_INFO_TEXT_DEBUG = "$FPPInfoTextDebug"														Autoreadonly
string Property C_INFO_TEXT_ADD_ON_FOLLOW = "$FPPInfoTextAddOnFollow"										Autoreadonly
string Property C_INFO_TEXT_STATUS_PREFIX = "$FPPInfoText"													Autoreadonly
string Property C_INFO_TEXT_ACTION_SINGLE = "$FPPInfoTextActionSingle"										Autoreadonly
string Property C_INFO_TEXT_ACTION_ALL = "$FPPInfoTextActionAll"											Autoreadonly
string Property C_INFO_TEXT_ACTION_ALL_ADD_POTIONS = "$FPPInfoTextActionAllWithAddPotions"					Autoreadonly
string Property C_INFO_TEXT_POISON = "$FPPInfoTextPoison"													Autoreadonly
string Property C_INFO_TEXT_UPDATE_IN_COMBAT = "$FPPInfoTextUpdateInCombat"									Autoreadonly
string Property C_INFO_TEXT_UPDATE_NON_COMBAT = "$FPPInfoTextUpdateNonCombat"								Autoreadonly
string Property C_INFO_TEXT_UPDATE_NO_POTIONS = "$FPPInfoTextUpdateNoPotions"								Autoreadonly
string Property C_INFO_TEXT_WARNING_RESTORE = "$FPPInfoTextWarningRestore"									Autoreadonly
string Property C_INFO_TEXT_WARNING_FORTIFY_RESIST = "$FPPInfoTextWarningFortifyResist"						Autoreadonly
string Property C_INFO_TEXT_WARNING_POISON = "$FPPInfoTextWarningPoison"									Autoreadonly
string Property C_INFO_TEXT_HEALTH_IN_COMBAT = "$FPPInfoTextHealthInCombat"									Autoreadonly
string Property C_INFO_TEXT_HEALTH_NON_COMBAT = "$FPPInfoTextHealthNonCombat"								Autoreadonly
string Property C_INFO_TEXT_STAMINA_IN_COMBAT = "$FPPInfoTextStaminaInCombat"								Autoreadonly
string Property C_INFO_TEXT_STAMINA_NON_COMBAT = "$FPPInfoTextStaminaNonCombat"								Autoreadonly
string Property C_INFO_TEXT_MAGICKA_IN_COMBAT = "$FPPInfoTextMagickaInCombat"								Autoreadonly
string Property C_INFO_TEXT_MAGICKA_NON_COMBAT = "$FPPInfoTextMagickaNonCombat"								Autoreadonly
string Property C_INFO_TEXT_ENEMY_OVER = "$FPPInfoTextEnemyOver"											Autoreadonly
string Property C_INFO_TEXT_ENEMY_OVER_POISON = "$FPPInfoTextEnemyOverPoison"								Autoreadonly
string Property C_INFO_TEXT_POTION_IDENT = "$FPPInfoTextPotionIdent"										Autoreadonly
string Property C_CONFIRM_RESET_SINGLE = "$FPPConfirmResetSingle"											Autoreadonly
string Property C_CONFIRM_RESET_ALL = "$FPPConfirmResetAll"													Autoreadonly
string Property C_CONFIRM_REMOVE_SINGLE = "$FPPConfirmRemoveSingle"											Autoreadonly
string Property C_CONFIRM_REMOVE_ALL = "$FPPConfirmRemoveAll"												Autoreadonly
string Property C_CONFIRM_REFRESH_SINGLE = "$FPPConfirmRefreshSingle"										Autoreadonly
string Property C_CONFIRM_REFRESH_ALL = "$FPPConfirmRefreshAll"												Autoreadonly
string Property C_CONFIRM_ADD_POTIONS_SINGLE = "$FPPConfirmAddPotionsSingle"								Autoreadonly
string Property C_CONFIRM_ADD_POTIONS_ALL = "$FPPConfirmAddPotionsAll"										Autoreadonly

; PRIVATE VARIABLES -------------------------------------------------------------------------------
; OIDs (T:Text B:Toggle S:Slider M:Menu, C:Color, K:Key)
int			_debugOID_B
int			_recruitXflOID_B
int			_currentVersionOID_T

int			_actionAllOID_M
int[]		_followerOID_M

int			_usePotionRestoreHealthOID_B
int			_usePotionRestoreStaminaOID_B
int			_usePotionRestoreMagickaOID_B
int			_usePotionFortifyHealthOID_B
int			_usePotionFortifyHealthRegenOID_B
int			_usePotionFortifyStaminaOID_B
int			_usePotionFortifyStaminaRegenOID_B
int			_usePotionFortifyMagickaOID_B
int			_usePotionFortifyMagickaRegenOID_B
int			_usePotionFortifyBlockOID_B
int			_usePotionFortifyHvArmOID_B
int			_usePotionFortifyLtArmOID_B
int			_usePotionFortifyMarksmanOID_B
int			_usePotionFortify1hOID_B
int			_usePotionFortify2hOID_B
int			_usePotionFortifyAlterationOID_B
int			_usePotionFortifyConjurationOID_B
int			_usePotionFortifyDestructionOID_B
int			_usePotionFortifyIllusionOID_B
int			_usePotionFortifyRestorationOID_B
int			_usePotionResistFireOID_B
int			_usePotionResistFrostOID_B
int			_usePotionResistShockOID_B
int			_usePotionResistMagicOID_B
int			_usePotionResistPoisonOID_B

int			_usePoisonsMainOID_M
int			_usePoisonsBowOID_M
int			_usePoisonsOffHandOID_M

int			_updateIntervalInCombatOID_S
int			_updateIntervalNonCombatOID_S
int			_enableWarningNoPotionsOID_B
int			_updateIntervalNoPotionsOID_S
int			_enableWarningIntervalRestoreOID_B
int			_warningIntervalRestoreOID_S
int			_enableWarningIntervalFortifyResistOID_B
int			_warningIntervalFortifyResistOID_S
int			_enableWarningIntervalPoisonOID_B
int			_warningIntervalPoisonOID_S
int			_healthLimitInCombatOID_S
int			_healthLimitNonCombatOID_S
int			_staminaLimitInCombatOID_S
int			_staminaLimitNonCombatOID_S
int			_magickaLimitInCombatOID_S
int			_magickaLimitNonCombatOID_S
int			_lvlDiffTriggerOID_S
int			_triggerRaceDragonOID_B
int			_triggerRaceDragonPriestOID_B
int			_triggerRaceGiantOID_B
int			_triggerRaceVampLordOID_B
int			_lvlDiffTriggerPoisonOID_S
int			_potionIdentOID_M


; State
bool modDebug
bool xflAddOnFollow
bool updatingFollowerPotions


; Internal
float Property _defaultUpdateIntervalInCombat = 1.0			Autoreadonly
float Property _defaultUpdateIntervalNonCombat = 10.0		Autoreadonly
float Property _defaultUpdateIntervalNoPotions = 180.0		Autoreadonly
float Property _defaultWarningIntervalRestore = 30.0		Autoreadonly
float Property _defaultWarningIntervalFortifyResist = 180.0	Autoreadonly
float Property _defaultWarningIntervalPoison = 30.0			Autoreadonly
float Property _defaultHealthLimitInCombat = 0.6			Autoreadonly
float Property _defaultHealthLimitNonCombat = 1.0			Autoreadonly
float Property _defaultStaminaLimitInCombat = 0.6			Autoreadonly
float Property _defaultStaminaLimitNonCombat = 0.3			Autoreadonly
float Property _defaultMagickaLimitInCombat = 0.6			Autoreadonly
float Property _defaultMagickaLimitNonCombat = 0.3			Autoreadonly
float Property _defaultLvlDiffTrigger = 5.0					Autoreadonly
float Property _defaultLvlDiffTriggerPoison = 0.0			Autoreadonly
int   Property _defaultPotionIdent = 0						Autoreadonly

_FPP_Quest Property FPPQuest Auto

float[] sliderVals
bool[] boolVals
bool[] enableWarningsBoolVals
bool[] triggerRaceVals
int[] poisonOptionVals
int potionIdentIndex

string[] actionOptions
string[] potionIdentOptions
string[] poisonOptions

_FPP_FollowerScript follower


; INITIALIZATION ----------------------------------------------------------------------------------

; @implements SKI_QuestBase
event OnVersionUpdate(int a_version)
	if (a_version > 1)
		OnConfigInit()
	endIf
endEvent

; @overrides SKI_ConfigBase
event OnConfigInit()
	
	sliderVals = new float[14]
	boolVals = new bool[25]
	enableWarningsBoolVals = new bool[4]

	_followerOID_M = new int[15]
	
	triggerRaceVals = new bool[4]

	poisonOptionVals = new int[3]

	RedrawFollowerPages()
endEvent


; EVENTS ------------------------------------------------------------------------------------------

Event OnConfigOpen()
	;FPPQuest.DebugStuff("MCM::OnConfigOpen")
	RegisterForModEvent("_FPP_Event_FollowerPotionRefreshCountUpdated", "OnPotionCountUpdated")
	RegisterForModEvent("_FPP_Event_FollowerPotionRefreshComplete", "OnPotionRefreshComplete")
EndEvent

Event OnConfigClose()
	follower = None
	UnregisterForModEvent("_FPP_Event_FollowerPotionRefreshCountUpdated")
	UnregisterForModEvent("_FPP_Event_FollowerPotionRefreshComplete")
	;FPPQuest.DebugStuff("MCM::OnConfigClose")
EndEvent

; @implements SKI_ConfigBase
event OnPageReset(string a_page)
	{Called when a new page is selected, including the initial empty page}

	updatingFollowerPotions = false
	follower = None

	RedrawFollowerPages()

	; Load custom logo in DDS format
	if (a_page == C_STRING_EMPTY)
		LoadCustomContent(C_LOGO_PATH, offsetX, offsetY)
		return
	else
		UnloadCustomContent()
	endIf

	SetCursorFillMode(TOP_TO_BOTTOM)
	
	;FPPQuest.DebugStuff("MCM::OnPageReset - " + a_page)
	
	; get values to use on page
	if (a_page == C_PAGE_MISC)
	
		follower = None
		_debugOID_B	= AddToggleOption(C_OPTION_LABEL_DEBUG, FPPQuest.DebugToFile)
		_recruitXflOID_B = AddToggleOption(C_OPTION_LABEL_ADD_ON_FOLLOW, FPPQuest.XflAddOnFollow)
		
		AddEmptyOption()
		
		AddHeaderOption(C_HEADER_LABEL_POTION_IDENT)
		
		_potionIdentOID_M = AddMenuOption(C_OPTION_LABEL_POTION_IDENT, potionIdentOptions[potionIdentIndex])
		
		; enough empty options to put Version at the bottom of the left-hand pane (can't be bothered to figure out the SetCursorPosition!)
		AddEmptyOption()
		AddEmptyOption()
		AddEmptyOption()
		AddEmptyOption()
		AddEmptyOption()
		AddEmptyOption()
		
		_currentVersionOID_T = AddTextOption(C_OPTION_LABEL_CURRENT_VERSION, FPPQuest.GetVersionAsString(FPPQuest.CurrentVersion), OPTION_FLAG_DISABLED)
		
		
		SetCursorPosition(1) ; Move to the top of the right-hand pane
		
		AddHeaderOption(C_HEADER_LABEL_ACTIONS)
		
		_actionAllOID_M = AddMenuOption(C_OPTION_LABEL_ACTIONS_ALL, C_OPTION_VALUE_SELECT_ACTION)
		
		AddEmptyOption()
		
		int maxFollowerCount = FPPQuest.AllFollowers.Length
		int followerIndex = 0
		while (followerIndex < maxFollowerCount)
			if (FPPQuest.AllFollowers[followerIndex] && FPPQuest.AllFollowers[followerIndex].GetReference() as Actor)
				_FPP_FollowerScript thisFollower = FPPQuest.AllFollowers[followerIndex] as _FPP_FollowerScript
				string followerState = thisFollower.GetState()
				_followerOID_M[followerIndex] = AddMenuOption(thisFollower.ActorName, "$FPPStatusText" + followerState)
				updatingFollowerPotions = followerState == "RefreshingPotions"
			else
				_followerOID_M[followerIndex] = AddTextOption(C_PAGE_NOT_SET, C_STRING_EMPTY, OPTION_FLAG_DISABLED)
			endIf
			followerIndex += 1
		endWhile

		if (updatingFollowerPotions)
			DisableFollowerOptions()
		endIf
		
		return

	elseIf (a_page == C_PAGE_DEFAULTS)
	
		follower = None
		SetOptions(FPPQuest.DefaultUpdateIntervalInCombat, FPPQuest.DefaultUpdateIntervalNonCombat, FPPQuest.DefaultUpdateIntervalNoPotions, \
					FPPQuest.DefaultEnableWarnings, FPPQuest.DefaultWarningIntervals, FPPQuest.DefaultStatLimitsInCombat, FPPQuest.DefaultStatLimitsNonCombat, FPPQuest.DefaultLvlDiffTrigger, FPPQuest.DefaultTriggerRaces, \
					FPPQuest.DefaultUsePotionOfType, FPPQuest.DefaultLvlDiffTriggerPoison, FPPQuest.DefaultGlobalUsePoisons, FPPQuest.DefaultUsePoisonOfType, false)
		
	elseIf (a_page != C_PAGE_NOT_SET)
	
		int followerIndex = GetFollowerIndex(a_page)
		if (followerIndex < 0)
			follower = None
			AddTextOption(C_OPTION_LABEL_NO_FOLLOWER, C_STRING_EMPTY, OPTION_FLAG_DISABLED)
			return
		endIf
		
		follower = FPPQuest.AllFollowers[followerIndex] as _FPP_FollowerScript
		SetOptions(follower.UpdateIntervalInCombat, follower.UpdateIntervalNonCombat, follower.UpdateIntervalNoPotions, \
					follower.EnableWarnings, follower.WarningIntervals, follower.StatLimitsInCombat, follower.StatLimitsNonCombat, follower.LvlDiffTrigger, follower.TriggerRaces, \
					follower.UsePotionOfType, follower.LvlDiffTriggerPoison, follower.GlobalUsePoisons, follower.UsePoisonOfType, true)
		
	else
	
		follower = None
		AddTextOption(C_OPTION_LABEL_NO_FOLLOWER, C_STRING_EMPTY, OPTION_FLAG_DISABLED)
		return

	endIf
	
	; paint page
	AddHeaderOption(C_HEADER_LABEL_RESTORE_POTIONS)
	
	_usePotionRestoreHealthOID_B		= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[0]), boolVals[0])
	if (boolVals[0])
		_healthLimitInCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_HEALTH_IN_COMBAT, sliderVals[3] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_NONE)
		_healthLimitNonCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_HEALTH_NON_COMBAT, sliderVals[4] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_NONE)
	else
		_healthLimitInCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_HEALTH_IN_COMBAT, sliderVals[3] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_DISABLED)
		_healthLimitNonCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_HEALTH_NON_COMBAT, sliderVals[4] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_DISABLED)
	endIf

	_usePotionRestoreStaminaOID_B		= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[1]), boolVals[1])
	if (boolVals[1])
		_staminaLimitInCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_STAMINA_IN_COMBAT, sliderVals[5] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_NONE)
		_staminaLimitNonCombatOID_S 	= AddSliderOption(C_OPTION_LABEL_STAMINA_NON_COMBAT, sliderVals[6] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_NONE)
	else
		_staminaLimitInCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_STAMINA_IN_COMBAT, sliderVals[5] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_DISABLED)
		_staminaLimitNonCombatOID_S 	= AddSliderOption(C_OPTION_LABEL_STAMINA_NON_COMBAT, sliderVals[6] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_DISABLED)
	endIf

	_usePotionRestoreMagickaOID_B		= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[2]), boolVals[2])
	if (boolVals[2])
		_magickaLimitInCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_MAGICKA_IN_COMBAT, sliderVals[7] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_NONE)
		_magickaLimitNonCombatOID_S 	= AddSliderOption(C_OPTION_LABEL_MAGICKA_NON_COMBAT, sliderVals[8] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_NONE)
	else
		_magickaLimitInCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_MAGICKA_IN_COMBAT, sliderVals[7] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_DISABLED)
		_magickaLimitNonCombatOID_S 	= AddSliderOption(C_OPTION_LABEL_MAGICKA_NON_COMBAT, sliderVals[8] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_DISABLED)
	endIf
	
	AddEmptyOption()
	
	AddHeaderOption(C_HEADER_LABEL_POISONS)
	
	_lvlDiffTriggerPoisonOID_S 	= AddSliderOption(C_OPTION_LABEL_ENEMY_OVER, sliderVals[13], C_FORMAT_PLACEHOLDER_LEVELS)
	_usePoisonsMainOID_M		= AddMenuOption(C_OPTION_LABEL_POISON_MAIN, poisonOptions[poisonOptionVals[0]])
	_usePoisonsBowOID_M			= AddMenuOption(C_OPTION_LABEL_POISON_BOW, poisonOptions[poisonOptionVals[1]])
	_usePoisonsOffHandOID_M		= AddMenuOption(C_OPTION_LABEL_POISON_OFFHAND, poisonOptions[poisonOptionVals[2]])
	
	AddEmptyOption()
	
	AddHeaderOption(C_HEADER_LABEL_UPDATE_INTERVALS)
	
	_updateIntervalInCombatOID_S = AddSliderOption(C_OPTION_LABEL_UPDATE_IN_COMBAT, sliderVals[0], C_FORMAT_PLACEHOLDER_SECONDS)
	_updateIntervalNonCombatOID_S = AddSliderOption(C_OPTION_LABEL_UPDATE_NON_COMBAT, sliderVals[1], C_FORMAT_PLACEHOLDER_SECONDS)

	AddEmptyOption()
	
	AddHeaderOption(C_HEADER_LABEL_WARNING_INTERVALS)
	
	_enableWarningIntervalRestoreOID_B = AddToggleOption(C_OPTION_LABEL_ENABLE_WARNING_RESTORE, enableWarningsBoolVals[0])
	if (enableWarningsBoolVals[0])
		_warningIntervalRestoreOID_S = AddSliderOption(C_OPTION_LABEL_WARNING_RESTORE, sliderVals[10], C_FORMAT_PLACEHOLDER_SECONDS, OPTION_FLAG_NONE)
	else
		_warningIntervalRestoreOID_S = AddSliderOption(C_OPTION_LABEL_WARNING_RESTORE, sliderVals[10], C_FORMAT_PLACEHOLDER_SECONDS, OPTION_FLAG_DISABLED)
	endIf
	
	_enableWarningIntervalFortifyResistOID_B = AddToggleOption(C_OPTION_LABEL_ENABLE_WARNING_FORTIFY_RESIST, enableWarningsBoolVals[1])
	if (enableWarningsBoolVals[1])
		_warningIntervalFortifyResistOID_S = AddSliderOption(C_OPTION_LABEL_WARNING_FORTIFY_RESIST, sliderVals[11], C_FORMAT_PLACEHOLDER_SECONDS, OPTION_FLAG_NONE)
	else
		_warningIntervalFortifyResistOID_S = AddSliderOption(C_OPTION_LABEL_WARNING_FORTIFY_RESIST, sliderVals[11], C_FORMAT_PLACEHOLDER_SECONDS, OPTION_FLAG_DISABLED)
	endIf

	_enableWarningIntervalPoisonOID_B = AddToggleOption(C_OPTION_LABEL_ENABLE_WARNING_POISONS, enableWarningsBoolVals[3])
	if (enableWarningsBoolVals[3])
		_warningIntervalPoisonOID_S = AddSliderOption(C_OPTION_LABEL_WARNING_POISONS, sliderVals[12], C_FORMAT_PLACEHOLDER_SECONDS, OPTION_FLAG_NONE)
	else
		_warningIntervalPoisonOID_S = AddSliderOption(C_OPTION_LABEL_WARNING_POISONS, sliderVals[12], C_FORMAT_PLACEHOLDER_SECONDS, OPTION_FLAG_DISABLED)
	endIf

	_enableWarningNoPotionsOID_B = AddToggleOption(C_OPTION_LABEL_ENABLE_WARNING_NO_POTIONS, enableWarningsBoolVals[2])
	if (enableWarningsBoolVals[2])
		_updateIntervalNoPotionsOID_S = AddSliderOption(C_OPTION_LABEL_UPDATE_NO_POTIONS, sliderVals[2], C_FORMAT_PLACEHOLDER_SECONDS, OPTION_FLAG_NONE)
	else
		_updateIntervalNoPotionsOID_S = AddSliderOption(C_OPTION_LABEL_UPDATE_NO_POTIONS, sliderVals[2], C_FORMAT_PLACEHOLDER_SECONDS, OPTION_FLAG_DISABLED)
	endIf
	
	; Move to the top of the right-hand pane
	SetCursorPosition(1)

	AddHeaderOption(C_HEADER_LABEL_FORTIFY_RESIST_POTIONS)
	
	_lvlDiffTriggerOID_S = AddSliderOption(C_OPTION_LABEL_ENEMY_OVER, sliderVals[9], C_FORMAT_PLACEHOLDER_LEVELS)
	
	AddTextOption(C_OPTION_LABEL_DUMMY_TRIGGER_RACES, C_STRING_EMPTY, OPTION_FLAG_DISABLED)
	_triggerRaceDragonOID_B = AddToggleOption(C_OPTION_LABEL_TRIGGER_RACE_DRAGON, triggerRaceVals[0])
	_triggerRaceDragonPriestOID_B = AddToggleOption(C_OPTION_LABEL_TRIGGER_RACE_DRAGON_PRIEST, triggerRaceVals[1])
	_triggerRaceGiantOID_B = AddToggleOption(C_OPTION_LABEL_TRIGGER_RACE_GIANT, triggerRaceVals[2])
	_triggerRaceVampLordOID_B = AddToggleOption(C_OPTION_LABEL_TRIGGER_RACE_VAMPIRE_LORD, triggerRaceVals[3])
	
	AddEmptyOption()

	_usePotionFortifyHealthOID_B		= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[3]), boolVals[3])
	_usePotionFortifyHealthRegenOID_B	= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[4]), boolVals[4])
	_usePotionFortifyStaminaOID_B		= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[5]), boolVals[5])
	_usePotionFortifyStaminaRegenOID_B	= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[6]), boolVals[6])
	_usePotionFortifyMagickaOID_B		= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[7]), boolVals[7])
	_usePotionFortifyMagickaRegenOID_B	= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[8]), boolVals[8])
	
	AddEmptyOption()
	
	_usePotionFortifyBlockOID_B			= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[9]), boolVals[9])
	_usePotionFortifyHvArmOID_B			= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[10]), boolVals[10])
	_usePotionFortifyLtArmOID_B			= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[11]), boolVals[11])
	_usePotionFortifyMarksmanOID_B		= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[12]), boolVals[12])
	_usePotionFortify1hOID_B			= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[13]), boolVals[13])
	_usePotionFortify2hOID_B			= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[14]), boolVals[14])
	
	AddEmptyOption()
	
	_usePotionFortifyAlterationOID_B	= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[15]), boolVals[15])
	_usePotionFortifyConjurationOID_B	= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[16]), boolVals[16])
	_usePotionFortifyDestructionOID_B	= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[17]), boolVals[17])
	_usePotionFortifyIllusionOID_B		= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[18]), boolVals[18])
	_usePotionFortifyRestorationOID_B	= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[19]), boolVals[19])
	
	AddEmptyOption()
	
	_usePotionResistFireOID_B			= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[20]), boolVals[20])
	_usePotionResistFrostOID_B			= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[21]), boolVals[21])
	_usePotionResistShockOID_B			= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[22]), boolVals[22])
	_usePotionResistMagicOID_B			= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[23]), boolVals[23])
	_usePotionResistPoisonOID_B			= AddToggleOption(FormatString(C_OPTION_LABEL_USE_POTIONS, FPPQuest.EffectNames[24]), boolVals[24])

endEvent

; @implements SKI_ConfigBase
event OnOptionHighlight(int a_option)
	{Called when highlighting an option}

	if (a_option == _debugOID_B)
		SetInfoText(C_INFO_TEXT_DEBUG)
	elseIf (a_option == _recruitXflOID_B)
		SetInfoText(C_INFO_TEXT_ADD_ON_FOLLOW)
	elseIf (a_option == _actionAllOID_M)
		if (FPPQuest._FPP_ShowDebugOptions.GetValue() > 0)
			SetInfoText(C_INFO_TEXT_ACTION_ALL_ADD_POTIONS)
		else
			SetInfoText(C_INFO_TEXT_ACTION_ALL)
		endIf
	elseIf (_followerOID_M.Find(a_option) > -1)
		_FPP_FollowerScript thisFollower = FPPQuest.AllFollowers[_followerOID_M.Find(a_option)] as _FPP_FollowerScript
		SetInfoText(C_INFO_TEXT_STATUS_PREFIX + thisFollower.GetState())
	elseIf (a_option == _updateIntervalInCombatOID_S)
		SetInfoText(C_INFO_TEXT_UPDATE_IN_COMBAT)
	elseIf (a_option == _updateIntervalNonCombatOID_S)
		SetInfoText(C_INFO_TEXT_UPDATE_NON_COMBAT)
	elseIf (a_option == _updateIntervalNoPotionsOID_S)
		SetInfoText(C_INFO_TEXT_UPDATE_NO_POTIONS)
	elseIf (a_option == _healthLimitInCombatOID_S)
		SetInfoText(C_INFO_TEXT_HEALTH_IN_COMBAT)
	elseIf (a_option == _healthLimitNonCombatOID_S)
		SetInfoText(C_INFO_TEXT_HEALTH_NON_COMBAT)
	elseIf (a_option == _staminaLimitInCombatOID_S)
		SetInfoText(C_INFO_TEXT_STAMINA_IN_COMBAT)
	elseIf (a_option == _staminaLimitNonCombatOID_S)
		SetInfoText(C_INFO_TEXT_STAMINA_NON_COMBAT)
	elseIf (a_option == _magickaLimitInCombatOID_S)
		SetInfoText(C_INFO_TEXT_MAGICKA_IN_COMBAT)
	elseIf (a_option == _magickaLimitNonCombatOID_S)
		SetInfoText(C_INFO_TEXT_MAGICKA_NON_COMBAT)
	elseIf (a_option == _warningIntervalRestoreOID_S)
		SetInfoText(C_INFO_TEXT_WARNING_RESTORE)
	elseIf (a_option == _warningIntervalFortifyResistOID_S)
		SetInfoText(C_INFO_TEXT_WARNING_FORTIFY_RESIST)
	elseIf (a_option == _warningIntervalPoisonOID_S)
		SetInfoText(C_INFO_TEXT_WARNING_POISON)
	elseIf (a_option == _lvlDiffTriggerOID_S)
		SetInfoText(C_INFO_TEXT_ENEMY_OVER)
	elseIf (a_option == _lvlDiffTriggerPoisonOID_S)
		SetInfoText(C_INFO_TEXT_ENEMY_OVER_POISON)
	elseIf (a_option == _usePoisonsMainOID_M)
		SetInfoText(C_INFO_TEXT_POISON)
	elseIf (a_option == _usePoisonsBowOID_M)
		SetInfoText(C_INFO_TEXT_POISON)
	elseIf (a_option == _usePoisonsOffHandOID_M)
		SetInfoText(C_INFO_TEXT_POISON)
	elseIf (a_option == _potionIdentOID_M)
		SetInfoText(C_INFO_TEXT_POTION_IDENT)
	endIf
endEvent

; @implements SKI_ConfigBase
event OnOptionMenuOpen(int a_option)
	{Called when the user selects a menu option}
	if (a_option == _potionIdentOID_M)
		SetMenuDialogStartIndex(potionIdentIndex)
		SetMenuDialogDefaultIndex(_defaultPotionIdent)
		SetMenuDialogOptions(potionIdentOptions)

	elseIf (a_option == _usePoisonsMainOID_M)
		SetMenuDialogStartIndex(poisonOptionVals[0])
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(poisonOptions)

	elseIf (a_option == _usePoisonsBowOID_M)
		SetMenuDialogStartIndex(poisonOptionVals[1])
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(poisonOptions)

	elseIf (a_option == _usePoisonsOffHandOID_M)
		SetMenuDialogStartIndex(poisonOptionVals[2])
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(poisonOptions)

	elseIf (a_option == _actionAllOID_M || _followerOID_M.Find(a_option) > -1)
		SetMenuDialogStartIndex(0)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(actionOptions)
	endIf
endEvent

; @implements SKI_ConfigBase
event OnOptionMenuAccept(int a_option, int a_index)
	{Called when the user accepts a new menu entry}
	if (a_option == _potionIdentOID_M)
		potionIdentIndex = a_index
		SetMenuOptionValue(_potionIdentOID_M, potionIdentOptions[potionIdentIndex])
		SetPotionIdentMethod(potionIdentIndex)

	elseIf (a_option == _usePoisonsMainOID_M)
		poisonOptionVals[0] = a_index
		SetMenuOptionValue(_usePoisonsMainOID_M, poisonOptions[a_index])
		if (follower)
			follower.GlobalUsePoisons[1] = 2 + (a_index * -1)
		else
			FPPQuest.DefaultGlobalUsePoisons[1] = 2 + (a_index * -1)
		endIf
		SetGlobalUsePoisons()

	elseIf (a_option == _usePoisonsBowOID_M)
		poisonOptionVals[1] = a_index
		SetMenuOptionValue(_usePoisonsBowOID_M, poisonOptions[a_index])
		if (follower)
			follower.GlobalUsePoisons[2] = 2 + (a_index * -1)
		else
			FPPQuest.DefaultGlobalUsePoisons[2] = 2 + (a_index * -1)
		endIf
		SetGlobalUsePoisons()

	elseIf (a_option == _usePoisonsOffHandOID_M)
		poisonOptionVals[2] = a_index
		SetMenuOptionValue(_usePoisonsOffHandOID_M, poisonOptions[a_index])
		if (follower)
			follower.GlobalUsePoisons[3] = 2 + (a_index * -1)
		else
			FPPQuest.DefaultGlobalUsePoisons[3] = 2 + (a_index * -1)
		endIf
		SetGlobalUsePoisons()

	elseIf (a_option == _actionAllOID_M)
		if (a_index == 0)
			return
		elseIf (a_index == 1)
			if ShowMessage(C_CONFIRM_RESET_ALL)
				ResetAllFollowers()
			endIf
		elseIf (a_index == 2)
			if ShowMessage(C_CONFIRM_REFRESH_ALL)
				RefreshAllFollowerPotions()
			endIf	
		elseIf (a_index == 3)
			if ShowMessage(C_CONFIRM_REMOVE_ALL)
				RemoveAllFollowers()
			endIf	
		elseIf (a_index == 4 && FPPQuest._FPP_ShowDebugOptions.GetValue() > 0)
			if ShowMessage(C_CONFIRM_ADD_POTIONS_ALL)
				AddPotionsToAllFollowers()
			endIf	
		endIf
	else
		int followerIndex = _followerOID_M.Find(a_option)
		if (followerIndex < 0)
			return
		endIf
		if (FPPQuest.AllFollowers[followerIndex].GetReference() as Actor == None)
			return
		endIf
		_FPP_FollowerScript thisFollower = FPPQuest.AllFollowers[followerIndex] as _FPP_FollowerScript
		if (a_index == 0)
			return
		elseIf (a_index == 1)
			if ShowMessage(C_CONFIRM_RESET_SINGLE)
				ResetFollower(thisFollower)
			endIf
		elseIf (a_index == 2)
			if ShowMessage(C_CONFIRM_REFRESH_SINGLE)
				RefreshFollowerPotions(thisFollower)
			endIf	
		elseIf (a_index == 3)
			if ShowMessage(C_CONFIRM_REMOVE_SINGLE)
				RemoveFollower(thisFollower)
			endIf	
		elseIf (a_index == 4 && FPPQuest._FPP_ShowDebugOptions.GetValue() > 0)
			if ShowMessage(C_CONFIRM_ADD_POTIONS_SINGLE)
				AddPotionsToFollower(thisFollower)
			endIf	
		endIf
	endIf	

endEvent

; @implements SKI_ConfigBase
event OnOptionSelect(int a_option)
	{Called when a non-interactive option has been selected}

	if (a_option == _debugOID_B)
		modDebug = !modDebug
		SetToggleOptionValue(a_option, modDebug)
		FPPQuest.DebugToFile = modDebug

	elseIf (a_option == _recruitXflOID_B)
		xflAddOnFollow = !xflAddOnFollow
		SetToggleOptionValue(a_option, xflAddOnFollow)
		FPPQuest.XflAddOnFollow = xflAddOnFollow

	elseIf (a_option == _usePotionRestoreHealthOID_B)
		boolVals[0] = !boolVals[0]
		SetToggleOptionValue(a_option, boolVals[0])
		if (boolVals[0])
			SetOptionFlags(_healthLimitInCombatOID_S, OPTION_FLAG_NONE)
			SetOptionFlags(_healthLimitNonCombatOID_S, OPTION_FLAG_NONE)
		else
			SetOptionFlags(_healthLimitInCombatOID_S, OPTION_FLAG_DISABLED)
			SetOptionFlags(_healthLimitNonCombatOID_S, OPTION_FLAG_DISABLED)
		endIf
		if (follower)
			follower.UsePotionOfType[0] = boolVals[0]
		else
			FPPQuest.DefaultUsePotionOfType[0] = boolVals[0]
		endIf

	elseIf (a_option == _usePotionRestoreStaminaOID_B)
		boolVals[1] = !boolVals[1]
		SetToggleOptionValue(a_option, boolVals[1])
		if (boolVals[1])
			SetOptionFlags(_staminaLimitInCombatOID_S, OPTION_FLAG_NONE)
			SetOptionFlags(_staminaLimitNonCombatOID_S, OPTION_FLAG_NONE)
		else
			SetOptionFlags(_staminaLimitInCombatOID_S, OPTION_FLAG_DISABLED)
			SetOptionFlags(_staminaLimitNonCombatOID_S, OPTION_FLAG_DISABLED)
		endIf
		if (follower)
			follower.UsePotionOfType[1] = boolVals[1]
		else
			FPPQuest.DefaultUsePotionOfType[1] = boolVals[1]
		endIf

	elseIf (a_option == _usePotionRestoreMagickaOID_B)
		boolVals[2] = !boolVals[2]
		SetToggleOptionValue(a_option, boolVals[2])
		if (boolVals[2])
			SetOptionFlags(_magickaLimitInCombatOID_S, OPTION_FLAG_NONE)
			SetOptionFlags(_magickaLimitNonCombatOID_S, OPTION_FLAG_NONE)
		else
			SetOptionFlags(_magickaLimitInCombatOID_S, OPTION_FLAG_DISABLED)
			SetOptionFlags(_magickaLimitNonCombatOID_S, OPTION_FLAG_DISABLED)
		endIf
		if (follower)
			follower.UsePotionOfType[2] = boolVals[2]
		else
			FPPQuest.DefaultUsePotionOfType[2] = boolVals[2]
		endIf

	elseIf (a_option == _usePotionFortifyHealthOID_B)
		boolVals[3] = !boolVals[3]
		SetToggleOptionValue(a_option, boolVals[3])
		if (follower)
			follower.UsePotionOfType[3] = boolVals[3]
		else
			FPPQuest.DefaultUsePotionOfType[3] = boolVals[3]
		endIf

	elseIf (a_option == _usePotionFortifyHealthRegenOID_B)
		boolVals[4] = !boolVals[4]
		SetToggleOptionValue(a_option, boolVals[4])
		if (follower)
			follower.UsePotionOfType[4] = boolVals[4]
		else
			FPPQuest.DefaultUsePotionOfType[4] = boolVals[4]
		endIf

	elseIf (a_option == _usePotionFortifyStaminaOID_B)
		boolVals[5] = !boolVals[5]
		SetToggleOptionValue(a_option, boolVals[5])
		if (follower)
			follower.UsePotionOfType[5] = boolVals[5]
		else
			FPPQuest.DefaultUsePotionOfType[5] = boolVals[5]
		endIf

	elseIf (a_option == _usePotionFortifyStaminaRegenOID_B)
		boolVals[6] = !boolVals[6]
		SetToggleOptionValue(a_option, boolVals[6])
		if (follower)
			follower.UsePotionOfType[6] = boolVals[6]
		else
			FPPQuest.DefaultUsePotionOfType[6] = boolVals[6]
		endIf

	elseIf (a_option == _usePotionFortifyMagickaOID_B)
		boolVals[7] = !boolVals[7]
		SetToggleOptionValue(a_option, boolVals[7])
		if (follower)
			follower.UsePotionOfType[7] = boolVals[7]
		else
			FPPQuest.DefaultUsePotionOfType[7] = boolVals[7]
		endIf

	elseIf (a_option == _usePotionFortifyMagickaRegenOID_B)
		boolVals[8] = !boolVals[8]
		SetToggleOptionValue(a_option, boolVals[8])
		if (follower)
			follower.UsePotionOfType[8] = boolVals[8]
		else
			FPPQuest.DefaultUsePotionOfType[8] = boolVals[8]
		endIf

	elseIf (a_option == _usePotionFortifyBlockOID_B)
		boolVals[9] = !boolVals[9]
		SetToggleOptionValue(a_option, boolVals[9])
		if (follower)
			follower.UsePotionOfType[9] = boolVals[9]
		else
			FPPQuest.DefaultUsePotionOfType[9] = boolVals[9]
		endIf

	elseIf (a_option == _usePotionFortifyHvArmOID_B)
		boolVals[10] = !boolVals[10]
		SetToggleOptionValue(a_option, boolVals[10])
		if (follower)
			follower.UsePotionOfType[10] = boolVals[10]
		else
			FPPQuest.DefaultUsePotionOfType[10] = boolVals[10]
		endIf

	elseIf (a_option == _usePotionFortifyLtArmOID_B)
		boolVals[11] = !boolVals[11]
		SetToggleOptionValue(a_option, boolVals[11])
		if (follower)
			follower.UsePotionOfType[11] = boolVals[11]
		else
			FPPQuest.DefaultUsePotionOfType[11] = boolVals[11]
		endIf

	elseIf (a_option == _usePotionFortifyMarksmanOID_B)
		boolVals[12] = !boolVals[12]
		SetToggleOptionValue(a_option, boolVals[12])
		if (follower)
			follower.UsePotionOfType[12] = boolVals[12]
		else
			FPPQuest.DefaultUsePotionOfType[12] = boolVals[12]
		endIf

	elseIf (a_option == _usePotionFortify1hOID_B)
		boolVals[13] = !boolVals[13]
		SetToggleOptionValue(a_option, boolVals[13])
		if (follower)
			follower.UsePotionOfType[13] = boolVals[13]
		else
			FPPQuest.DefaultUsePotionOfType[13] = boolVals[13]
		endIf

	elseIf (a_option == _usePotionFortify2hOID_B)
		boolVals[14] = !boolVals[14]
		SetToggleOptionValue(a_option, boolVals[14])
		if (follower)
			follower.UsePotionOfType[14] = boolVals[14]
		else
			FPPQuest.DefaultUsePotionOfType[14] = boolVals[14]
		endIf

	elseIf (a_option == _usePotionFortifyAlterationOID_B)
		boolVals[15] = !boolVals[15]
		SetToggleOptionValue(a_option, boolVals[15])
		if (follower)
			follower.UsePotionOfType[15] = boolVals[15]
		else
			FPPQuest.DefaultUsePotionOfType[15] = boolVals[15]
		endIf

	elseIf (a_option == _usePotionFortifyConjurationOID_B)
		boolVals[16] = !boolVals[16]
		SetToggleOptionValue(a_option, boolVals[16])
		if (follower)
			follower.UsePotionOfType[16] = boolVals[16]
		else
			FPPQuest.DefaultUsePotionOfType[16] = boolVals[16]
		endIf

	elseIf (a_option == _usePotionFortifyDestructionOID_B)
		boolVals[17] = !boolVals[17]
		SetToggleOptionValue(a_option, boolVals[17])
		if (follower)
			follower.UsePotionOfType[17] = boolVals[17]
		else
			FPPQuest.DefaultUsePotionOfType[17] = boolVals[17]
		endIf

	elseIf (a_option == _usePotionFortifyIllusionOID_B)
		boolVals[18] = !boolVals[18]
		SetToggleOptionValue(a_option, boolVals[18])
		if (follower)
			follower.UsePotionOfType[18] = boolVals[18]
		else
			FPPQuest.DefaultUsePotionOfType[18] = boolVals[18]
		endIf

	elseIf (a_option == _usePotionFortifyRestorationOID_B)
		boolVals[19] = !boolVals[19]
		SetToggleOptionValue(a_option, boolVals[19])
		if (follower)
			follower.UsePotionOfType[19] = boolVals[19]
		else
			FPPQuest.DefaultUsePotionOfType[19] = boolVals[19]
		endIf

	elseIf (a_option == _usePotionResistFireOID_B)
		boolVals[20] = !boolVals[20]
		SetToggleOptionValue(a_option, boolVals[20])
		if (follower)
			follower.UsePotionOfType[20] = boolVals[20]
		else
			FPPQuest.DefaultUsePotionOfType[20] = boolVals[20]
		endIf

	elseIf (a_option == _usePotionResistFrostOID_B)
		boolVals[21] = !boolVals[21]
		SetToggleOptionValue(a_option, boolVals[21])
		if (follower)
			follower.UsePotionOfType[21] = boolVals[21]
		else
			FPPQuest.DefaultUsePotionOfType[21] = boolVals[21]
		endIf

	elseIf (a_option == _usePotionResistShockOID_B)
		boolVals[22] = !boolVals[22]
		SetToggleOptionValue(a_option, boolVals[22])
		if (follower)
			follower.UsePotionOfType[22] = boolVals[22]
		else
			FPPQuest.DefaultUsePotionOfType[22] = boolVals[22]
		endIf

	elseIf (a_option == _usePotionResistMagicOID_B)
		boolVals[23] = !boolVals[23]
		SetToggleOptionValue(a_option, boolVals[23])
		if (follower)
			follower.UsePotionOfType[23] = boolVals[23]
		else
			FPPQuest.DefaultUsePotionOfType[23] = boolVals[23]
		endIf

	elseIf (a_option == _usePotionResistPoisonOID_B)
		boolVals[24] = !boolVals[24]
		SetToggleOptionValue(a_option, boolVals[24])
		if (follower)
			follower.UsePotionOfType[24] = boolVals[24]
		else
			FPPQuest.DefaultUsePotionOfType[24] = boolVals[24]
		endIf

	elseIf (a_option == _triggerRaceDragonOID_B)
		triggerRaceVals[0] = !triggerRaceVals[0]
		SetToggleOptionValue(a_option, triggerRaceVals[0])
		if (follower)
			follower.TriggerRaces[0] = triggerRaceVals[0]
		else
			FPPQuest.DefaultTriggerRaces[0] = triggerRaceVals[0]
		endIf

	elseIf (a_option == _triggerRaceDragonPriestOID_B)
		triggerRaceVals[1] = !triggerRaceVals[1]
		SetToggleOptionValue(a_option, triggerRaceVals[1])
		if (follower)
			follower.TriggerRaces[1] = triggerRaceVals[1]
		else
			FPPQuest.DefaultTriggerRaces[1] = triggerRaceVals[1]
		endIf

	elseIf (a_option == _triggerRaceGiantOID_B)
		triggerRaceVals[2] = !triggerRaceVals[2]
		SetToggleOptionValue(a_option, triggerRaceVals[2])
		if (follower)
			follower.TriggerRaces[2] = triggerRaceVals[2]
		else
			FPPQuest.DefaultTriggerRaces[2] = triggerRaceVals[2]
		endIf

	elseIf (a_option == _triggerRaceVampLordOID_B)
		triggerRaceVals[3] = !triggerRaceVals[3]
		SetToggleOptionValue(a_option, triggerRaceVals[3])
		if (follower)
			follower.TriggerRaces[3] = triggerRaceVals[3]
		else
			FPPQuest.DefaultTriggerRaces[3] = triggerRaceVals[3]
		endIf

	elseIf (a_option == _enableWarningIntervalRestoreOID_B)
		enableWarningsBoolVals[0] = !enableWarningsBoolVals[0]
		SetToggleOptionValue(a_option, enableWarningsBoolVals[0])
		if (enableWarningsBoolVals[0])
			SetOptionFlags(_warningIntervalRestoreOID_S, OPTION_FLAG_NONE)
		else
			SetOptionFlags(_warningIntervalRestoreOID_S, OPTION_FLAG_DISABLED)
		endIf
		if (follower)
			follower.EnableWarnings[0] = enableWarningsBoolVals[0]
			follower.EnableWarnings[1] = enableWarningsBoolVals[0]
			follower.EnableWarnings[2] = enableWarningsBoolVals[0]
		else
			FPPQuest.DefaultEnableWarnings[0] = enableWarningsBoolVals[0]
			FPPQuest.DefaultEnableWarnings[1] = enableWarningsBoolVals[0]
			FPPQuest.DefaultEnableWarnings[2] = enableWarningsBoolVals[0]
		endIf

	elseIf (a_option == _enableWarningIntervalFortifyResistOID_B)
		enableWarningsBoolVals[1] = !enableWarningsBoolVals[1]
		SetToggleOptionValue(a_option, enableWarningsBoolVals[1])
		if (enableWarningsBoolVals[1])
			SetOptionFlags(_warningIntervalFortifyResistOID_S, OPTION_FLAG_NONE)
		else
			SetOptionFlags(_warningIntervalFortifyResistOID_S, OPTION_FLAG_DISABLED)
		endIf
		if (follower)
			follower.EnableWarnings[3] = enableWarningsBoolVals[1]
			follower.EnableWarnings[4] = enableWarningsBoolVals[1]
		else
			FPPQuest.DefaultEnableWarnings[3] = enableWarningsBoolVals[1]
			FPPQuest.DefaultEnableWarnings[4] = enableWarningsBoolVals[1]
		endIf

	elseIf (a_option == _enableWarningIntervalPoisonOID_B)
		enableWarningsBoolVals[3] = !enableWarningsBoolVals[3]
		SetToggleOptionValue(a_option, enableWarningsBoolVals[3])
		if (enableWarningsBoolVals[3])
			SetOptionFlags(_warningIntervalPoisonOID_S, OPTION_FLAG_NONE)
		else
			SetOptionFlags(_warningIntervalPoisonOID_S, OPTION_FLAG_DISABLED)
		endIf
		if (follower)
			follower.EnableWarnings[6] = enableWarningsBoolVals[3]
		else
			FPPQuest.DefaultEnableWarnings[6] = enableWarningsBoolVals[3]
		endIf

	elseIf (a_option == _enableWarningNoPotionsOID_B)
		enableWarningsBoolVals[2] = !enableWarningsBoolVals[2]
		SetToggleOptionValue(a_option, enableWarningsBoolVals[2])
		if (enableWarningsBoolVals[2])
			SetOptionFlags(_updateIntervalNoPotionsOID_S, OPTION_FLAG_NONE)
		else
			SetOptionFlags(_updateIntervalNoPotionsOID_S, OPTION_FLAG_DISABLED)
		endIf
		if (follower)
			follower.EnableWarnings[5] = enableWarningsBoolVals[2]
		else
			FPPQuest.DefaultEnableWarnings[5] = enableWarningsBoolVals[2]
		endIf

	endIf
endEvent

; @implements SKI_ConfigBase
event OnOptionDefault(int a_option)
	{Called when resetting an option to its default value}

	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionSliderOpen(int a_option)
	{Called when a slider option has been selected}

	if a_option == _updateIntervalInCombatOID_S
		SetSliderDialogStartValue(sliderVals[0])
		SetSliderDialogDefaultValue(_defaultUpdateIntervalInCombat)
		SetSliderDialogRange(1, 20)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _updateIntervalNonCombatOID_S
		SetSliderDialogStartValue(sliderVals[1])
		SetSliderDialogDefaultValue(_defaultUpdateIntervalNonCombat)
		SetSliderDialogRange(1, 20)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _healthLimitInCombatOID_S
		SetSliderDialogStartValue(sliderVals[3] * 100)
		SetSliderDialogDefaultValue(_defaultHealthLimitInCombat * 100)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _healthLimitNonCombatOID_S
		SetSliderDialogStartValue(sliderVals[4] * 100)
		SetSliderDialogDefaultValue(_defaultHealthLimitNonCombat * 100)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _staminaLimitInCombatOID_S
		SetSliderDialogStartValue(sliderVals[5] * 100)
		SetSliderDialogDefaultValue(_defaultStaminaLimitInCombat * 100)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _staminaLimitNonCombatOID_S
		SetSliderDialogStartValue(sliderVals[6] * 100)
		SetSliderDialogDefaultValue(_defaultStaminaLimitNonCombat * 100)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _magickaLimitInCombatOID_S
		SetSliderDialogStartValue(sliderVals[7] * 100)
		SetSliderDialogDefaultValue(_defaultMagickaLimitInCombat * 100)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _magickaLimitNonCombatOID_S
		SetSliderDialogStartValue(sliderVals[8] * 100)
		SetSliderDialogDefaultValue(_defaultMagickaLimitNonCombat * 100)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _warningIntervalRestoreOID_S
		SetSliderDialogStartValue(sliderVals[10])
		SetSliderDialogDefaultValue(_defaultWarningIntervalRestore)
		SetSliderDialogRange(10, 900)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _warningIntervalFortifyResistOID_S
		SetSliderDialogStartValue(sliderVals[11])
		SetSliderDialogDefaultValue(_defaultWarningIntervalFortifyResist)
		SetSliderDialogRange(10, 900)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _warningIntervalPoisonOID_S
		SetSliderDialogStartValue(sliderVals[12])
		SetSliderDialogDefaultValue(_defaultWarningIntervalPoison)
		SetSliderDialogRange(10, 900)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _updateIntervalNoPotionsOID_S
		SetSliderDialogStartValue(sliderVals[2])
		SetSliderDialogDefaultValue(_defaultUpdateIntervalNoPotions)
		SetSliderDialogRange(10, 900)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _lvlDiffTriggerOID_S
		SetSliderDialogStartValue(sliderVals[9])
		SetSliderDialogDefaultValue(_defaultLvlDiffTrigger)
		SetSliderDialogRange(-20, 20)
		SetSliderDialogInterval(1)
		
	elseIf a_option == _lvlDiffTriggerPoisonOID_S
		SetSliderDialogStartValue(sliderVals[13])
		SetSliderDialogDefaultValue(_defaultLvlDiffTriggerPoison)
		SetSliderDialogRange(-20, 20)
		SetSliderDialogInterval(1)
	endIf

endEvent

; @implements SKI_ConfigBase
event OnOptionSliderAccept(int a_option, float a_value)
	{Called when a new slider value has been accepted}

	if a_option == _updateIntervalInCombatOID_S
		sliderVals[0] = a_value
		SetSliderOptionValue(a_option, sliderVals[0], C_FORMAT_PLACEHOLDER_SECONDS)
		if (follower)
			follower.UpdateIntervalInCombat = sliderVals[0]
		else
			FPPQuest.DefaultUpdateIntervalInCombat = sliderVals[0]
		endIf
		
	elseIf a_option == _updateIntervalNonCombatOID_S
		sliderVals[1] = a_value
		SetSliderOptionValue(a_option, sliderVals[1], C_FORMAT_PLACEHOLDER_SECONDS)
		if (follower)
			follower.UpdateIntervalNonCombat = sliderVals[1]
		else
			FPPQuest.DefaultUpdateIntervalNonCombat = sliderVals[1]
		endIf
		
	elseIf a_option == _updateIntervalNoPotionsOID_S
		sliderVals[2] = a_value
		SetSliderOptionValue(a_option, sliderVals[2], C_FORMAT_PLACEHOLDER_SECONDS)
		if (follower)
			follower.UpdateIntervalNoPotions = sliderVals[2]
		else
			FPPQuest.DefaultUpdateIntervalNoPotions = sliderVals[2]
		endIf
		
	elseIf a_option == _healthLimitInCombatOID_S
		sliderVals[3] = a_value / 100
		SetSliderOptionValue(a_option, sliderVals[3] * 100, C_FORMAT_PLACEHOLDER_PERCENT)
		if (follower)
			follower.StatLimitsInCombat[0] = sliderVals[3]
		else
			FPPQuest.DefaultStatLimitsInCombat[0] = sliderVals[3]
		endIf
		
	elseIf a_option == _healthLimitNonCombatOID_S
		sliderVals[4] = a_value / 100
		SetSliderOptionValue(a_option, sliderVals[4] * 100, C_FORMAT_PLACEHOLDER_PERCENT)
		if (follower)
			follower.StatLimitsNonCombat[0] = sliderVals[4]
		else
			FPPQuest.DefaultStatLimitsNonCombat[0] = sliderVals[4]
		endIf
		
	elseIf a_option == _staminaLimitInCombatOID_S
		sliderVals[5] = a_value / 100
		SetSliderOptionValue(a_option, sliderVals[5] * 100, C_FORMAT_PLACEHOLDER_PERCENT)
		if (follower)
			follower.StatLimitsInCombat[1] = sliderVals[5]
		else
			FPPQuest.DefaultStatLimitsInCombat[1] = sliderVals[5]
		endIf
		
	elseIf a_option == _staminaLimitNonCombatOID_S
		sliderVals[6] = a_value / 100
		SetSliderOptionValue(a_option, sliderVals[6] * 100, C_FORMAT_PLACEHOLDER_PERCENT)
		if (follower)
			follower.StatLimitsNonCombat[1] = sliderVals[6]
		else
			FPPQuest.DefaultStatLimitsNonCombat[1] = sliderVals[6]
		endIf
		
	elseIf a_option == _magickaLimitInCombatOID_S
		sliderVals[7] = a_value / 100
		SetSliderOptionValue(a_option, sliderVals[7] * 100, C_FORMAT_PLACEHOLDER_PERCENT)
		if (follower)
			follower.StatLimitsInCombat[2] = sliderVals[7]
		else
			FPPQuest.DefaultStatLimitsInCombat[2] = sliderVals[7]
		endIf
		
	elseIf a_option == _magickaLimitNonCombatOID_S
		sliderVals[8] = a_value / 100
		SetSliderOptionValue(a_option, sliderVals[8] * 100, C_FORMAT_PLACEHOLDER_PERCENT)
		if (follower)
			follower.StatLimitsNonCombat[2] = sliderVals[8]
		else
			FPPQuest.DefaultStatLimitsNonCombat[2] = sliderVals[8]
		endIf
		
	elseIf a_option == _lvlDiffTriggerOID_S
		sliderVals[9] = a_value
		SetSliderOptionValue(a_option, sliderVals[9], C_FORMAT_PLACEHOLDER_LEVELS)
		if (follower)
			follower.LvlDiffTrigger = sliderVals[9] as int
		else
			FPPQuest.DefaultLvlDiffTrigger = sliderVals[9] as int
		endIf
		
	elseIf a_option == _lvlDiffTriggerPoisonOID_S
		sliderVals[13] = a_value
		SetSliderOptionValue(a_option, sliderVals[13], C_FORMAT_PLACEHOLDER_LEVELS)
		if (follower)
			follower.LvlDiffTriggerPoison = sliderVals[13] as int
		else
			FPPQuest.DefaultLvlDiffTriggerPoison = sliderVals[13] as int
		endIf
		
	elseIf a_option == _warningIntervalRestoreOID_S
		sliderVals[10] = a_value
		SetSliderOptionValue(a_option, sliderVals[10], C_FORMAT_PLACEHOLDER_SECONDS)
		if (follower)
			follower.WarningIntervals[0] = sliderVals[10]
			follower.WarningIntervals[1] = sliderVals[10]
			follower.WarningIntervals[2] = sliderVals[10]
		else
			FPPQuest.DefaultWarningIntervals[0] = sliderVals[10]
			FPPQuest.DefaultWarningIntervals[1] = sliderVals[10]
			FPPQuest.DefaultWarningIntervals[2] = sliderVals[10]
		endIf
		
	elseIf a_option == _warningIntervalFortifyResistOID_S
		sliderVals[11] = a_value
		SetSliderOptionValue(a_option, sliderVals[11], C_FORMAT_PLACEHOLDER_SECONDS)
		if (follower)
			follower.WarningIntervals[3] = sliderVals[11]
			follower.WarningIntervals[4] = sliderVals[11]
		else
			FPPQuest.DefaultWarningIntervals[3] = sliderVals[11]
			FPPQuest.DefaultWarningIntervals[4] = sliderVals[11]
		endIf
		
	elseIf a_option == _warningIntervalPoisonOID_S
		sliderVals[12] = a_value
		SetSliderOptionValue(a_option, sliderVals[12], C_FORMAT_PLACEHOLDER_SECONDS)
		if (follower)
			follower.WarningIntervals[6] = sliderVals[12]
		else
			FPPQuest.DefaultWarningIntervals[6] = sliderVals[12]
		endIf
		
	endIf
endEvent

Event OnPotionCountUpdated(string asActorName, int aiIndex, int aiRefreshedPotionCount, int aiTotalPotionCount)
	if (!updatingFollowerPotions)
		return
	endIf
	string progress = ((aiRefreshedPotionCount * 100.0 / aiTotalPotionCount) as int) + "%"
	SetMenuOptionValue(_followerOID_M[aiIndex], progress)
	;FPPQuest.DebugStuff("MCM::OnPotionCountUpdated (" + asActorName + ") - " + aiRefreshedPotionCount + " of " + aiTotalPotionCount + " (" + progress + ")")
endEvent

Event OnPotionRefreshComplete(string asActorName, int aiIndex)
	updatingFollowerPotions = false
	SetMenuOptionValue(_followerOID_M[aiIndex], "100%")
	EnableFollowerOptions()
	;FPPQuest.DebugStuff("MCM::OnPotionRefreshComplete (" + asActorName + ")")
endEvent



Function ResetAllFollowers()

	int followerIndex = 0
	while (followerIndex < FPPQuest.AllFollowers.Length)
		if (FPPQuest.AllFollowers[followerIndex])
			ResetFollower(FPPQuest.AllFollowers[followerIndex] as _FPP_FollowerScript)
			followerIndex += 1
		endIf
	endWhile

endFunction

Function ResetFollower(_FPP_FollowerScript akFppFollower)

	Actor followerActor = (akFppFollower as ReferenceAlias).GetReference() as Actor
	if (followerActor)
		FPPQuest.ResetFollower(followerActor)
	endIf

endFunction

Function RefreshAllFollowerPotions()

	int followerIndex = 0
	while (followerIndex < FPPQuest.AllFollowers.Length)
		if (FPPQuest.AllFollowers[followerIndex])
			RefreshFollowerPotions(FPPQuest.AllFollowers[followerIndex] as _FPP_FollowerScript)
			Utility.WaitMenuMode(0.5)
		endIf
		followerIndex += 1
	endWhile

endFunction

Function RefreshFollowerPotions(_FPP_FollowerScript akFppFollower)

	Actor followerActor = (akFppFollower as ReferenceAlias).GetReference() as Actor
	if (followerActor)
		updatingFollowerPotions = true
		DisableFollowerOptions()
		FPPQuest.RefreshFollowerPotions(followerActor)
	endIf

endFunction

Function RemoveAllFollowers()

	FPPQuest.RemoveAllFollowers()

endFunction

Function RemoveFollower(_FPP_FollowerScript akFppFollower)

	FPPQuest.RemoveFollower((akFppFollower as ReferenceAlias).GetReference() as Actor)

endFunction

Function AddPotionsToAllFollowers()

	int followerIndex = 0
	while (followerIndex < FPPQuest.AllFollowers.Length)
		if (FPPQuest.AllFollowers[followerIndex])
			AddPotionsToFollower(FPPQuest.AllFollowers[followerIndex] as _FPP_FollowerScript)
			followerIndex += 1
			Utility.WaitMenuMode(1.0)
		endIf
	endWhile

endFunction

Function AddPotionsToFollower(_FPP_FollowerScript akFppFollower)

	Actor followerActor = (akFppFollower as ReferenceAlias).GetReference() as Actor
	if (followerActor)
		FPPQuest.AddPotionsToFollower(followerActor)
	endIf

endFunction

Function SetPotionIdentMethod(int aiSelectedIndex)
	
	int potionIdent = Math.Pow(2.0, (aiSelectedIndex - 1) as float) as int
	if (aiSelectedIndex == 0)
		; special case - identify all
		potionIdent = FPPQuest.C_IDENTIFY_RESTORE + FPPQuest.C_IDENTIFY_FORTIFY + FPPQuest.C_IDENTIFY_RESIST
	endIf
	
	;FPPQuest.DebugStuff("MCM::SetPotionIdentMethod - set to " + potionIdent)
	
	FPPQuest.DefaultIdentifyPotionEffects = potionIdent
	
	int followerIndex = FPPQuest.AllFollowers.Length
	while (followerIndex)
		followerIndex -= 1
		if (FPPQuest.AllFollowers[followerIndex] && FPPQuest.AllFollowers[followerIndex].GetReference() as Actor != None)
			(FPPQuest.AllFollowers[followerIndex] as _FPP_FollowerScript).IdentifyPotionEffects = potionIdent
		endIf
	endWhile
	
endFunction

function SetGlobalUsePoisons()
	int useAny = 2 + (poisonOptionVals[0] * -1) + 2 + (poisonOptionVals[1] * -1) + 2 + (poisonOptionVals[2] * -1)
	if (follower)
		follower.GlobalUsePoisons[0] = useAny
	else
		FPPQuest.DefaultGlobalUsePoisons[0] = useAny
	endIf
endFunction

Function EnableFollowerOptions()
	SetOptionFlags(_actionAllOID_M, OPTION_FLAG_NONE)
	int followerOptionsCount = _followerOID_M.Length
	while (followerOptionsCount)
		followerOptionsCount -= 1
		SetOptionFlags(_followerOID_M[followerOptionsCount], OPTION_FLAG_NONE)
	endWhile
endFunction

Function DisableFollowerOptions()
	SetOptionFlags(_actionAllOID_M, OPTION_FLAG_DISABLED)
	int followerOptionsCount = _followerOID_M.Length
	while (followerOptionsCount)
		followerOptionsCount -= 1
		SetOptionFlags(_followerOID_M[followerOptionsCount], OPTION_FLAG_DISABLED)
	endWhile
endFunction

Function RedrawFollowerPages()

	int maxFollowerCount = FPPQuest.AllFollowers.Length
	Pages = Utility.CreateStringArray(maxFollowerCount + 2)
	Pages[0] = C_PAGE_DEFAULTS
	
	int i = 1
	int followerIndex = 0
	while (followerIndex < maxFollowerCount)
		if (FPPQuest.AllFollowers[followerIndex] && FPPQuest.AllFollowers[followerIndex].GetReference() as Actor)
			Pages[i] = FormatFollowerName(followerIndex + 1, (FPPQuest.AllFollowers[followerIndex] as _FPP_FollowerScript).ActorName)
		else
			Pages[i] = C_PAGE_NOT_SET
		endIf
		i += 1
		followerIndex += 1
	endWhile
	
	Pages[i] = C_PAGE_MISC
	
	; only show Add Potions option if enabled
	if (FPPQuest._FPP_ShowDebugOptions.GetValue() > 0)
		actionOptions = new string[5]
		actionOptions[0] = C_MENU_OPTION_CANCEL
		actionOptions[1] = C_MENU_OPTION_RESET
		actionOptions[2] = C_MENU_OPTION_REFRESH
		actionOptions[3] = C_MENU_OPTION_REMOVE
		actionOptions[4] = C_MENU_OPTION_ADD_POTIONS
	else
		actionOptions = new string[4]
		actionOptions[0] = C_MENU_OPTION_CANCEL
		actionOptions[1] = C_MENU_OPTION_RESET
		actionOptions[2] = C_MENU_OPTION_REFRESH
		actionOptions[3] = C_MENU_OPTION_REMOVE
	endIf
	
	potionIdentOptions = new string[7]
	potionIdentOptions[0] = C_MENU_OPTION_EFFECTS_ALL
	potionIdentOptions[1] = C_MENU_OPTION_EFFECTS_RESTORE
	potionIdentOptions[2] = C_MENU_OPTION_EFFECTS_FORTIFY
	potionIdentOptions[3] = C_MENU_OPTION_EFFECTS_RESIST
	potionIdentOptions[4] = C_MENU_OPTION_EFFECTS_FIRST
	potionIdentOptions[5] = C_MENU_OPTION_EFFECTS_SECOND
	potionIdentOptions[6] = C_MENU_OPTION_EFFECTS_THIRD

	poisonOptions = new string[3]
	poisonOptions[0] = C_MENU_OPTION_POISON_ALWAYS
	poisonOptions[1] = C_MENU_OPTION_POISON_ON_ENGAGE
	poisonOptions[2] = C_MENU_OPTION_POISON_NEVER
	
endFunction

int Function GetFollowerIndex(string asActorPageName)
	int followerIndex = Pages.Find(asActorPageName) - 1
	if (FPPQuest.AllFollowers[followerIndex] && FPPQuest.AllFollowers[followerIndex].GetReference() as Actor \
		&& FormatFollowerName(followerIndex + 1, (FPPQuest.AllFollowers[followerIndex] as _FPP_FollowerScript).ActorName) == asActorPageName)
		return followerIndex
	endIf
	return -1
endFunction

string Function FormatFollowerName(int aiPos, string asName)
	return aiPos + C_STRING_INDEX_NAME_SEPARATOR + asName
endFunction

string Function FormatString(string asTemplate, string asEffectName)
	int subPos = StringUtil.Find(asTemplate, C_STRING_FORMAT_PLACEHOLDER_ZERO)
	return StringUtil.Substring(asTemplate, 0, subPos + 1) \
			+ asEffectName \
			+ StringUtil.Substring(asTemplate, subPos + StringUtil.GetLength(C_STRING_FORMAT_PLACEHOLDER_ZERO) - 1)
endFunction

Function SetOptions(float UpdateIntervalInCombat, float UpdateIntervalNonCombat, float UpdateIntervalNoPotions, \
					bool[] EnableWarningIntervals, float[] WarningIntervals, float[] StatLimitsInCombat, float[] StatLimitsNonCombat, int LvlDiffTrigger, bool[] TriggerRaces, \
					bool[] UsePotionOfType, int LvlDiffTriggerPoison, int[] globalUsePoisons, bool[] usePoisonOfType, bool isFollower)

	sliderVals[0] = UpdateIntervalInCombat
	sliderVals[1] = UpdateIntervalNonCombat
	sliderVals[2] = UpdateIntervalNoPotions
	sliderVals[3] = StatLimitsInCombat[0]
	sliderVals[4] = StatLimitsNonCombat[0]
	sliderVals[5] = StatLimitsInCombat[1]
	sliderVals[6] = StatLimitsNonCombat[1]
	sliderVals[7] = StatLimitsInCombat[2]
	sliderVals[8] = StatLimitsNonCombat[2]
	sliderVals[9] = LvlDiffTrigger
	sliderVals[10] = WarningIntervals[0]
	sliderVals[11] = WarningIntervals[3]
	sliderVals[12] = WarningIntervals[6]
	sliderVals[13] = LvlDiffTriggerPoison
	
	enableWarningsBoolVals[0] = EnableWarningIntervals[0]
	enableWarningsBoolVals[1] = EnableWarningIntervals[3]
	enableWarningsBoolVals[2] = EnableWarningIntervals[5]
	enableWarningsBoolVals[3] = EnableWarningIntervals[6]
	
	triggerRaceVals[0] = TriggerRaces[0]
	triggerRaceVals[1] = TriggerRaces[1]
	triggerRaceVals[2] = TriggerRaces[2]
	triggerRaceVals[3] = TriggerRaces[3]
	
	int p = FPPQuest.RestoreEffects.Length
	while (p)
		p -= 1
		boolVals[FPPQuest.RestoreEffects[p]] = UsePotionOfType[FPPQuest.RestoreEffects[p]]
	endWhile
	p = FPPQuest.FortifyEffectsStats.Length
	while (p)
		p -= 1
		boolVals[FPPQuest.FortifyEffectsStats[p]] = UsePotionOfType[FPPQuest.FortifyEffectsStats[p]]
	endWhile
	p = FPPQuest.FortifyEffectsWarrior.Length
	while (p)
		p -= 1
		boolVals[FPPQuest.FortifyEffectsWarrior[p]] = UsePotionOfType[FPPQuest.FortifyEffectsWarrior[p]]
	endWhile
	p = FPPQuest.FortifyEffectsMage.Length
	while (p)
		p -= 1
		boolVals[FPPQuest.FortifyEffectsMage[p]] = UsePotionOfType[FPPQuest.FortifyEffectsMage[p]]
	endWhile
	p = FPPQuest.ResistEffects.Length
	while (p)
		p -= 1
		boolVals[FPPQuest.ResistEffects[p]] = UsePotionOfType[FPPQuest.ResistEffects[p]]
	endWhile
	
	poisonOptionVals[0] = 2 + (globalUsePoisons[1] * -1)
	poisonOptionVals[1] = 2 + (globalUsePoisons[2] * -1)
	poisonOptionVals[2] = 2 + (globalUsePoisons[3] * -1)
	
	;p = usePoisonOfType.Length
	;while (p)
		;p -= 1
		;boolVals[p] = usePoisonOfType[p]
	;endWhile
	
endFunction

