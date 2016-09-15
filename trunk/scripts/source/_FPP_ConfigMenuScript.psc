ScriptName _FPP_ConfigMenuScript extends SKI_ConfigBase  

; SCRIPT VERSION ----------------------------------------------------------------------------------
;
; History
;
; 1 - Initial version

int function GetVersion()
	return 1
endFunction


; PRIVATE VARIABLES -------------------------------------------------------------------------------
; string constants
string C_LOGO_PATH = "FollowerPotions/mcm_logo.dds"
; Image size 768x384
; X offset = 376 - (width / 2) = -8
int offsetX = -8
; Y offset = 223 - (height / 2) = 31
int offsetY = 31

string C_STRING_EMPTY = ""
string C_STRING_FORMAT_PLACEHOLDER_ZERO = "{0}"
string C_STRING_INDEX_NAME_SEPARATOR = ": "
string C_TEMPLATED_STRING_USE_POTIONS = "Use {0} Potions"
string C_TEMPLATED_STRING_RESET_NAME_TO_DEFAULTS = "MCM - reset {0} to defaults"
; Translatables
string C_PAGE_MISC = "$FPPPageMisc"
string C_PAGE_DEFAULTS = "$FPPPageDefaults"
string C_PAGE_NOT_SET = "$FPPPageEmpty"
string C_FORMAT_PLACEHOLDER_SECONDS = "$FPPFormatPlaceholderSeconds"
string C_FORMAT_PLACEHOLDER_PERCENT = "$FPPFormatPlaceholderPercent"
string C_FORMAT_PLACEHOLDER_LEVELS = "$FPPFormatPlaceholderLevels"
string C_HEADER_LABEL_RESET_REMOVE = "$FPPHeaderLabelResetRemove"
string C_HEADER_LABEL_UPDATE_INTERVALS = "$FPPHeaderLabelUpdateIntervals"
string C_HEADER_LABEL_RESTORE_POTIONS = "$FPPHeaderLabelRestorePotions"
string C_HEADER_LABEL_FORTIFY_RESIST_POTIONS = "$FPPHeaderLabelFortifyResistPotions"
string C_OPTION_LABEL_DEBUG = "$FPPOptionLabelDebug"
string C_OPTION_LABEL_NO_FOLLOWER = "$FPPOptionLabelNoFollower"
string C_OPTION_LABEL_CURRENT_STATE = "$FPPOptionLabelCurrentState"
string C_OPTION_LABEL_ADD_ON_FOLLOW = "$FPPOptionLabelAddOnFollow"
string C_OPTION_LABEL_ADD_POTIONS = "$FPPOptionLabelAddPotions"
string C_OPTION_LABEL_RESET_SINGLE = "$FPPOptionLabelResetSingle"
string C_OPTION_LABEL_RESET_ALL = "$FPPOptionLabelResetAll"
string C_OPTION_LABEL_REMOVE_SINGLE = "$FPPOptionLabelRemoveSingle"
string C_OPTION_LABEL_REMOVE_ALL = "$FPPOptionLabelRemoveAll"
string C_OPTION_LABEL_REFRESH_SINGLE = "$FPPOptionLabelRefreshSingle"
string C_OPTION_LABEL_REFRESH_ALL = "$FPPOptionLabelRefreshAll"
string C_OPTION_LABEL_UPDATE_IN_COMBAT = "$FPPOptionLabelUpdateInCombat"
string C_OPTION_LABEL_UPDATE_NON_COMBAT = "$FPPOptionLabelUpdateNonCombat"
string C_OPTION_LABEL_UPDATE_NO_POTIONS = "$FPPOptionLabelUpdateNoPotions"
string C_OPTION_LABEL_HEALTH_IN_COMBAT = "$FPPOptionLabelHealthInCombat"
string C_OPTION_LABEL_HEALTH_NON_COMBAT = "$FPPOptionLabelHealthNonCombat"
string C_OPTION_LABEL_STAMINA_IN_COMBAT = "$FPPOptionLabelStaminaInCombat"
string C_OPTION_LABEL_STAMINA_NON_COMBAT = "$FPPOptionLabelStaminaNonCombat"
string C_OPTION_LABEL_MAGICKA_IN_COMBAT = "$FPPOptionLabelMagickaInCombat"
string C_OPTION_LABEL_MAGICKA_NON_COMBAT = "$FPPOptionLabelMagickaNonCombat"
string C_OPTION_LABEL_ENEMY_OVER = "$FPPOptionLabelEnemyOver"
string C_INFO_TEXT_DEBUG = "$FPPInfoTextDebug"
string C_INFO_TEXT_ADD_ON_FOLLOW = "$FPPInfoTextAddOnFollow"
string C_INFO_TEXT_RESET_SINGLE = "$FPPInfoTextResetSingle"
string C_INFO_TEXT_RESET_ALL = "$FPPInfoTextResetAll"
string C_INFO_TEXT_REMOVE_SINGLE = "$FPPInfoTextRemoveSingle"
string C_INFO_TEXT_REMOVE_ALL = "$FPPInfoTextRemoveAll"
string C_INFO_TEXT_REFRESH_SINGLE = "$FPPInfoTextRefreshSingle"
string C_INFO_TEXT_REFRESH_ALL = "$FPPInfoTextRefreshAll"
string C_INFO_TEXT_ADD_POTIONS_SINGLE = "$FPPInfoTextAddPotionsSingle"
string C_INFO_TEXT_ADD_POTIONS_ALL = "$FPPInfoTextAddPotionsAll"
string C_INFO_TEXT_UPDATE_IN_COMBAT = "$FPPInfoTextUpdateInCombat"
string C_INFO_TEXT_UPDATE_NON_COMBAT = "$FPPInfoTextUpdateNonCombat"
string C_INFO_TEXT_UPDATE_NO_POTIONS = "$FPPInfoTextUpdateNoPotions"
string C_INFO_TEXT_HEALTH_IN_COMBAT = "$FPPInfoTextHealthInCombat"
string C_INFO_TEXT_HEALTH_NON_COMBAT = "$FPPInfoTextHealthNonCombat"
string C_INFO_TEXT_STAMINA_IN_COMBAT = "$FPPInfoTextStaminaInCombat"
string C_INFO_TEXT_STAMINA_NON_COMBAT = "$FPPInfoTextStaminaNonCombat"
string C_INFO_TEXT_MAGICKA_IN_COMBAT = "$FPPInfoTextMagickaInCombat"
string C_INFO_TEXT_MAGICKA_NON_COMBAT = "$FPPInfoTextMagickaNonCombat"
string C_INFO_TEXT_ENEMY_OVER = "$FPPInfoTextEnemyOver"
string C_CONFIRM_RESET_SINGLE = "$FPPConfirmResetSingle"
string C_CONFIRM_RESET_ALL = "$FPPConfirmResetAll"
string C_CONFIRM_REMOVE_SINGLE = "$FPPConfirmRemoveSingle"
string C_CONFIRM_REMOVE_ALL = "$FPPConfirmRemoveAll"
string C_CONFIRM_REFRESH_SINGLE = "$FPPConfirmRefreshSingle"
string C_CONFIRM_REFRESH_ALL = "$FPPConfirmRefreshAll"
string C_CONFIRM_ADD_POTIONS_SINGLE = "$FPPConfirmAddPotionsSingle"
string C_CONFIRM_ADD_POTIONS_ALL = "$FPPConfirmAddPotionsAll"

; OIDs (T:Text B:Toggle S:Slider M:Menu, C:Color, K:Key)
int			_debugOID_B
int			_recruitXflOID_B
int			_addPotionsOID_T

int			_stateOID_T
int			_resetOID_T
int			_removeOID_T
int			_refreshOID_T

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

int			_updateIntervalInCombatOID_S
int			_updateIntervalNonCombatOID_S
int			_updateIntervalNoPotionsOID_S
int			_healthLimitInCombatOID_S
int			_healthLimitNonCombatOID_S
int			_staminaLimitInCombatOID_S
int			_staminaLimitNonCombatOID_S
int			_magickaLimitInCombatOID_S
int			_magickaLimitNonCombatOID_S
int			_lvlDiffTriggerOID_S


; State
bool modDebug
bool xflAddOnFollow
bool updatingFollowerPotions


; Internal
float _defaultUpdateIntervalInCombat = 1.0
float _defaultUpdateIntervalNonCombat = 10.0
float _defaultUpdateIntervalNoPotions = 180.0
float _defaultHealthLimitInCombat = 0.6
float _defaultHealthLimitNonCombat = 1.0
float _defaultStaminaLimitInCombat = 0.6
float _defaultStaminaLimitNonCombat = 0.3
float _defaultMagickaLimitInCombat = 0.6
float _defaultMagickaLimitNonCombat = 0.3
float _defaultLvlDiffTrigger = 5.0

_FPP_Quest Property FPPQuest Auto

float[] sliderVals
bool[] boolVals

_FPP_FollowerScript follower


; INITIALIZATION ----------------------------------------------------------------------------------

; @overrides SKI_ConfigBase
event OnConfigInit()
	
	sliderVals = new float[10]
	boolVals = new bool[25]

	RedrawFollowerPages()
endEvent

; @implements SKI_QuestBase
event OnVersionUpdate(int a_version)
	{Called when a version update of this script has been detected}
endEvent


; EVENTS ------------------------------------------------------------------------------------------

Event OnConfigOpen()
	;FPPQuest.DebugStuff("MCM::OnConfigOpen")
	RegisterForModEvent("_FPP_Event_FollowerPotionRefreshCountUpdated", "OnPotionCountUpdated")
	RegisterForModEvent("_FPP_Event_FollowerPotionRefreshComplete", "OnPotionRefreshComplete")
EndEvent

Event OnConfigClose()
	follower = None
	updatingFollowerPotions = false
	UnregisterForModEvent("_FPP_Event_FollowerPotionRefreshCountUpdated")
	UnregisterForModEvent("_FPP_Event_FollowerPotionRefreshComplete")
	;FPPQuest.DebugStuff("MCM::OnConfigClose")
EndEvent

; @implements SKI_ConfigBase
event OnPageReset(string a_page)
	{Called when a new page is selected, including the initial empty page}

	follower = None
	updatingFollowerPotions = false

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
		
		return

	elseIf (a_page == C_PAGE_DEFAULTS)
	
		follower = None
		SetOptions(FPPQuest.DefaultUpdateIntervalInCombat, FPPQuest.DefaultUpdateIntervalNonCombat, FPPQuest.DefaultUpdateIntervalNoPotions, \
					FPPQuest.DefaultStatLimitsInCombat, FPPQuest.DefaultStatLimitsNonCombat, FPPQuest.DefaultLvlDiffTrigger, \
					FPPQuest.DefaultUsePotionOfType, false)
		
	elseIf (a_page != C_PAGE_NOT_SET)
	
		int followerIndex = GetFollowerIndex(a_page)
		if (followerIndex < 0)
			follower = None
			AddTextOption(C_OPTION_LABEL_NO_FOLLOWER, C_STRING_EMPTY, OPTION_FLAG_DISABLED)
			return
		endIf
		
		follower = FPPQuest.AllFollowers[followerIndex] as _FPP_FollowerScript
		SetOptions(follower.UpdateIntervalInCombat, follower.UpdateIntervalNonCombat, follower.UpdateIntervalNoPotions, \
					follower.StatLimitsInCombat, follower.StatLimitsNonCombat, follower.LvlDiffTrigger, \
					follower.UsePotionOfType, true)
		
	else
	
		follower = None
		AddTextOption(C_OPTION_LABEL_NO_FOLLOWER, C_STRING_EMPTY, OPTION_FLAG_DISABLED)
		return

	endIf
	
	; paint page
	AddHeaderOption(C_HEADER_LABEL_RESTORE_POTIONS)
	
	_usePotionRestoreHealthOID_B		= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[0]), boolVals[0])
	if (boolVals[0])
		_healthLimitInCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_HEALTH_IN_COMBAT, sliderVals[3] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_NONE)
		_healthLimitNonCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_HEALTH_NON_COMBAT, sliderVals[4] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_NONE)
	else
		_healthLimitInCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_HEALTH_IN_COMBAT, sliderVals[3] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_DISABLED)
		_healthLimitNonCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_HEALTH_NON_COMBAT, sliderVals[4] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_DISABLED)
	endIf

	AddEmptyOption()

	_usePotionRestoreStaminaOID_B		= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[1]), boolVals[1])
	if (boolVals[1])
		_staminaLimitInCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_STAMINA_IN_COMBAT, sliderVals[5] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_NONE)
		_staminaLimitNonCombatOID_S 	= AddSliderOption(C_OPTION_LABEL_STAMINA_NON_COMBAT, sliderVals[6] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_NONE)
	else
		_staminaLimitInCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_STAMINA_IN_COMBAT, sliderVals[5] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_DISABLED)
		_staminaLimitNonCombatOID_S 	= AddSliderOption(C_OPTION_LABEL_STAMINA_NON_COMBAT, sliderVals[6] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_DISABLED)
	endIf

	AddEmptyOption()

	_usePotionRestoreMagickaOID_B		= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[2]), boolVals[2])
	if (boolVals[2])
		_magickaLimitInCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_MAGICKA_IN_COMBAT, sliderVals[7] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_NONE)
		_magickaLimitNonCombatOID_S 	= AddSliderOption(C_OPTION_LABEL_MAGICKA_NON_COMBAT, sliderVals[8] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_NONE)
	else
		_magickaLimitInCombatOID_S 		= AddSliderOption(C_OPTION_LABEL_MAGICKA_IN_COMBAT, sliderVals[7] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_DISABLED)
		_magickaLimitNonCombatOID_S 	= AddSliderOption(C_OPTION_LABEL_MAGICKA_NON_COMBAT, sliderVals[8] * 100, C_FORMAT_PLACEHOLDER_PERCENT, OPTION_FLAG_DISABLED)
	endIf
	
	AddEmptyOption()
	
	AddHeaderOption(C_HEADER_LABEL_UPDATE_INTERVALS)
	
	_updateIntervalInCombatOID_S = AddSliderOption(C_OPTION_LABEL_UPDATE_IN_COMBAT, sliderVals[0], C_FORMAT_PLACEHOLDER_SECONDS)
	_updateIntervalNonCombatOID_S = AddSliderOption(C_OPTION_LABEL_UPDATE_NON_COMBAT, sliderVals[1], C_FORMAT_PLACEHOLDER_SECONDS)
	_updateIntervalNoPotionsOID_S = AddSliderOption(C_OPTION_LABEL_UPDATE_NO_POTIONS, sliderVals[2], C_FORMAT_PLACEHOLDER_SECONDS)

	AddEmptyOption()
	
	AddHeaderOption(C_HEADER_LABEL_RESET_REMOVE)
	
	if (follower == None)
		_resetOID_T = AddTextOption(C_OPTION_LABEL_RESET_ALL, C_STRING_EMPTY)
		_removeOID_T = AddTextOption(C_OPTION_LABEL_REMOVE_ALL, C_STRING_EMPTY)
		_refreshOID_T = AddTextOption(C_OPTION_LABEL_REFRESH_ALL, C_STRING_EMPTY)
	else
		string currState = follower.GetState()
		_stateOID_T = AddTextOption(C_OPTION_LABEL_CURRENT_STATE, currState, OPTION_FLAG_DISABLED)
		_resetOID_T = AddTextOption(C_OPTION_LABEL_RESET_SINGLE, C_STRING_EMPTY)
		_removeOID_T = AddTextOption(C_OPTION_LABEL_REMOVE_SINGLE, C_STRING_EMPTY)
		if (currState == "RefreshingPotions")
			updatingFollowerPotions = true
			_refreshOID_T = AddTextOption(C_OPTION_LABEL_REFRESH_SINGLE, C_STRING_EMPTY, OPTION_FLAG_DISABLED)
		else
			updatingFollowerPotions = false
			_refreshOID_T = AddTextOption(C_OPTION_LABEL_REFRESH_SINGLE, C_STRING_EMPTY)
		endIf
	endIf
	
	if (FPPQuest._FPP_ShowDebugOptions.GetValue() > 0)
		_addPotionsOID_T = AddTextOption(C_OPTION_LABEL_ADD_POTIONS, C_STRING_EMPTY)
	endIf
	
	
	SetCursorPosition(1) ; Move to the top of the right-hand pane

	AddHeaderOption(C_HEADER_LABEL_FORTIFY_RESIST_POTIONS)
	
	_lvlDiffTriggerOID_S = AddSliderOption(C_OPTION_LABEL_ENEMY_OVER, sliderVals[9], C_FORMAT_PLACEHOLDER_LEVELS)
	
	AddEmptyOption()

	_usePotionFortifyHealthOID_B		= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[3]), boolVals[3])
	_usePotionFortifyHealthRegenOID_B	= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[4]), boolVals[4])
	_usePotionFortifyStaminaOID_B		= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[5]), boolVals[5])
	_usePotionFortifyStaminaRegenOID_B	= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[6]), boolVals[6])
	_usePotionFortifyMagickaOID_B		= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[7]), boolVals[7])
	_usePotionFortifyMagickaRegenOID_B	= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[8]), boolVals[8])
	
	AddEmptyOption()
	
	_usePotionFortifyBlockOID_B			= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[9]), boolVals[9])
	_usePotionFortifyHvArmOID_B			= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[10]), boolVals[10])
	_usePotionFortifyLtArmOID_B			= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[11]), boolVals[11])
	_usePotionFortifyMarksmanOID_B		= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[12]), boolVals[12])
	_usePotionFortify1hOID_B			= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[13]), boolVals[13])
	_usePotionFortify2hOID_B			= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[14]), boolVals[14])
	
	AddEmptyOption()
	
	_usePotionFortifyAlterationOID_B	= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[15]), boolVals[15])
	_usePotionFortifyConjurationOID_B	= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[16]), boolVals[16])
	_usePotionFortifyDestructionOID_B	= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[17]), boolVals[17])
	_usePotionFortifyIllusionOID_B		= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[18]), boolVals[18])
	_usePotionFortifyRestorationOID_B	= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[19]), boolVals[19])
	
	AddEmptyOption()
	
	_usePotionResistFireOID_B			= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[20]), boolVals[20])
	_usePotionResistFrostOID_B			= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[21]), boolVals[21])
	_usePotionResistShockOID_B			= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[22]), boolVals[22])
	_usePotionResistMagicOID_B			= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[23]), boolVals[23])
	_usePotionResistPoisonOID_B			= AddToggleOption(FormatString(C_TEMPLATED_STRING_USE_POTIONS, FPPQuest.EffectNames[24]), boolVals[24])

endEvent

; @implements SKI_ConfigBase
event OnOptionHighlight(int a_option)
	{Called when highlighting an option}

	if (a_option == _debugOID_B)
		SetInfoText(C_INFO_TEXT_DEBUG)
	elseIf (a_option == _recruitXflOID_B)
		SetInfoText(C_INFO_TEXT_ADD_ON_FOLLOW)
	elseIf (a_option == _resetOID_T)
		if (follower)
			SetInfoText(C_INFO_TEXT_RESET_SINGLE)
		else
			SetInfoText(C_INFO_TEXT_RESET_ALL)
		endIf
	elseIf (a_option == _removeOID_T)
		if (follower)
			SetInfoText(C_INFO_TEXT_REMOVE_SINGLE)
		else
			SetInfoText(C_INFO_TEXT_REMOVE_ALL)
		endIf
	elseIf (a_option == _refreshOID_T)
		if (follower)
			SetInfoText(C_INFO_TEXT_REFRESH_SINGLE)
		else
			SetInfoText(C_INFO_TEXT_REFRESH_ALL)
		endIf
	elseIf (a_option == _addPotionsOID_T)
		if (follower)
			SetInfoText(C_INFO_TEXT_ADD_POTIONS_SINGLE)
		else
			SetInfoText(C_INFO_TEXT_ADD_POTIONS_ALL)
		endIf
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
	elseIf (a_option == _lvlDiffTriggerOID_S)
		SetInfoText(C_INFO_TEXT_ENEMY_OVER)
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

	elseIf (a_option == _resetOID_T)
		if (follower)
			if ShowMessage(C_CONFIRM_RESET_SINGLE)
				ResetFollower(follower)
			endIf	
		else
			if ShowMessage(C_CONFIRM_RESET_ALL)
				ResetAllFollowers()
			endIf	
		endIf	

	elseIf (a_option == _removeOID_T)
		if (follower)
			if ShowMessage(C_CONFIRM_REMOVE_SINGLE)
				RemoveFollower(follower)
			endIf	
		else
			if ShowMessage(C_CONFIRM_REMOVE_ALL)
				RemoveAllFollowers()
			endIf	
		endIf	

	elseIf (a_option == _refreshOID_T)
		if (follower)
			if ShowMessage(C_CONFIRM_REFRESH_SINGLE)
				RefreshFollowerPotions(follower)
			endIf	
		else
			if ShowMessage(C_CONFIRM_REFRESH_ALL)
				RefreshAllFollowerPotions()
			endIf	
		endIf	

	elseIf (a_option == _addPotionsOID_T)
		if (follower)
			if ShowMessage(C_CONFIRM_ADD_POTIONS_SINGLE)
				AddPotionsToFollower(follower)
			endIf	
		else
			if ShowMessage(C_CONFIRM_ADD_POTIONS_ALL)
				AddPotionsToAllFollowers()
			endIf	
		endIf	

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
		
	elseIf a_option == _updateIntervalNoPotionsOID_S
		SetSliderDialogStartValue(sliderVals[2])
		SetSliderDialogDefaultValue(_defaultUpdateIntervalNoPotions)
		SetSliderDialogRange(30, 600)
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
		
	elseIf a_option == _lvlDiffTriggerOID_S
		SetSliderDialogStartValue(sliderVals[9])
		SetSliderDialogDefaultValue(_defaultLvlDiffTrigger)
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
			FPPQuest.DefaultLvlDiffTrigger = sliderVals[9]
		endIf
	endIf
endEvent

; @implements SKI_ConfigBase
event OnOptionMenuOpen(int a_option)
	{Called when the user selects a menu option}

endEvent

; @implements SKI_ConfigBase
event OnOptionMenuAccept(int a_option, int a_index)
	{Called when the user accepts a new menu entry}

endEvent

Event OnPotionCountUpdated(string asActorName, int aiRefreshedPotionCount)
	if (updatingFollowerPotions && follower && follower.ActorName == asActorName)
		string progress = ((aiRefreshedPotionCount * 100.0 / follower.PotionCountTotal) as int) + "%"
		;FPPQuest.DebugStuff("MCM::OnPotionCountUpdated (" + asActorName + ") - " + aiRefreshedPotionCount + " of " + follower.PotionCountTotal + " (" + progress + ")")
		SetTextOptionValue(_refreshOID_T, progress)
	endif
endEvent

Event OnPotionRefreshComplete(string asActorName)
	if (updatingFollowerPotions && follower && follower.ActorName == asActorName)
		updatingFollowerPotions = false
		;FPPQuest.DebugStuff("MCM::OnPotionRefreshComplete (" + asActorName + ")")
		SetOptionFlags(_refreshOID_T, OPTION_FLAG_NONE)
		SetTextOptionValue(_refreshOID_T, "100%")
	endif
endEvent



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

	Actor thisFollower = (akFppFollower as ReferenceAlias).GetReference() as Actor
	if (thisFollower == None)
		return
	endIf
	
	; have to add to player, then remove from player to follower, or EFF intercepts it..
	FPPQuest.PlayerRef.AddItem(FPPQuest.PotionHealth1, 10, true)
	FPPQuest.PlayerRef.RemoveItem(FPPQuest.PotionHealth1, 10, true, thisFollower)
	FPPQuest.PlayerRef.AddItem(FPPQuest.PotionHealth2, 10, true)
	FPPQuest.PlayerRef.RemoveItem(FPPQuest.PotionHealth2, 10, true, thisFollower)
	FPPQuest.PlayerRef.AddItem(FPPQuest.PotionHealth3, 10, true)
	FPPQuest.PlayerRef.RemoveItem(FPPQuest.PotionHealth3, 10, true, thisFollower)
	Utility.WaitMenuMode(0.5)
	FPPQuest.PlayerRef.AddItem(FPPQuest.PotionStamina1, 10, true)
	FPPQuest.PlayerRef.RemoveItem(FPPQuest.PotionStamina1, 10, true, thisFollower)
	FPPQuest.PlayerRef.AddItem(FPPQuest.PotionStamina2, 10, true)
	FPPQuest.PlayerRef.RemoveItem(FPPQuest.PotionStamina2, 10, true, thisFollower)
	FPPQuest.PlayerRef.AddItem(FPPQuest.PotionStamina3, 10, true)
	FPPQuest.PlayerRef.RemoveItem(FPPQuest.PotionStamina3, 10, true, thisFollower)
	Utility.WaitMenuMode(0.5)
	FPPQuest.PlayerRef.AddItem(FPPQuest.PotionMagicka1, 10, true)
	FPPQuest.PlayerRef.RemoveItem(FPPQuest.PotionMagicka1, 10, true, thisFollower)
	FPPQuest.PlayerRef.AddItem(FPPQuest.PotionMagicka2, 10, true)
	FPPQuest.PlayerRef.RemoveItem(FPPQuest.PotionMagicka2, 10, true, thisFollower)
	FPPQuest.PlayerRef.AddItem(FPPQuest.PotionMagicka3, 10, true)
	FPPQuest.PlayerRef.RemoveItem(FPPQuest.PotionMagicka3, 10, true, thisFollower)
	
	FPPQuest.DebugStuff("Potions added to " + akFppFollower.ActorName)

endFunction

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

	Actor thisFollower = (akFppFollower as ReferenceAlias).GetReference() as Actor
	if (thisFollower == None)
		return
	endIf
	
	akFppFollower.UpdateIntervalInCombat = FPPQuest.DefaultUpdateIntervalInCombat
	akFppFollower.UpdateIntervalNonCombat = FPPQuest.DefaultUpdateIntervalNonCombat
	akFppFollower.UpdateIntervalNoPotions = FPPQuest.DefaultUpdateIntervalNoPotions
	akFppFollower.StatLimitsInCombat[0] = FPPQuest.DefaultStatLimitsInCombat[0]
	akFppFollower.StatLimitsNonCombat[0] = FPPQuest.DefaultStatLimitsNonCombat[0]
	akFppFollower.StatLimitsInCombat[1] = FPPQuest.DefaultStatLimitsInCombat[1]
	akFppFollower.StatLimitsNonCombat[1] = FPPQuest.DefaultStatLimitsNonCombat[1]
	akFppFollower.StatLimitsInCombat[2] = FPPQuest.DefaultStatLimitsInCombat[2]
	akFppFollower.StatLimitsNonCombat[2] = FPPQuest.DefaultStatLimitsNonCombat[2]
	akFppFollower.LvlDiffTrigger = FPPQuest.DefaultLvlDiffTrigger as int
	
	int p = FPPQuest.RestoreEffects.Length
	while (p)
		p -= 1
		akFppFollower.UsePotionOfType[FPPQuest.RestoreEffects[p]] = FPPQuest.DefaultUsePotionOfType[FPPQuest.RestoreEffects[p]]
	endWhile
	p = FPPQuest.FortifyEffectsStats.Length
	while (p)
		p -= 1
		akFppFollower.UsePotionOfType[FPPQuest.FortifyEffectsStats[p]] = FPPQuest.DefaultUsePotionOfType[FPPQuest.FortifyEffectsStats[p]]
	endWhile
	p = FPPQuest.FortifyEffectsWarrior.Length
	while (p)
		p -= 1
		akFppFollower.UsePotionOfType[FPPQuest.FortifyEffectsWarrior[p]] = FPPQuest.DefaultUsePotionOfType[FPPQuest.FortifyEffectsWarrior[p]]
	endWhile
	p = FPPQuest.FortifyEffectsMage.Length
	while (p)
		p -= 1
		akFppFollower.UsePotionOfType[FPPQuest.FortifyEffectsMage[p]] = FPPQuest.DefaultUsePotionOfType[FPPQuest.FortifyEffectsMage[p]]
	endWhile
	p = FPPQuest.ResistEffects.Length
	while (p)
		p -= 1
		akFppFollower.UsePotionOfType[FPPQuest.ResistEffects[p]] = FPPQuest.DefaultUsePotionOfType[FPPQuest.ResistEffects[p]]
	endWhile

	FPPQuest.DebugStuff(FormatString(C_TEMPLATED_STRING_RESET_NAME_TO_DEFAULTS, akFppFollower.ActorName))

endFunction

Function RemoveAllFollowers()

	FPPQuest.RemoveAllFollowers()

endFunction

Function RemoveFollower(_FPP_FollowerScript akFppFollower)

	FPPQuest.RemoveFollower((akFppFollower as ReferenceAlias).GetReference() as Actor)

endFunction

Function RefreshAllFollowerPotions()

	FPPQuest.RefreshAllFollowerPotions()

endFunction

Function RefreshFollowerPotions(_FPP_FollowerScript akFppFollower)

	updatingFollowerPotions = true
	SetOptionFlags(_refreshOID_T, OPTION_FLAG_DISABLED)
	SetTextOptionValue(_stateOID_T, "RefreshingPotions")
	FPPQuest.RefreshFollowerPotions((akFppFollower as ReferenceAlias).GetReference() as Actor)

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
	return StringUtil.Substring(asTemplate, 0, subPos) \
			+ asEffectName \
			+ StringUtil.Substring(asTemplate, subPos + StringUtil.GetLength(C_STRING_FORMAT_PLACEHOLDER_ZERO))
endFunction

Function SetOptions(float UpdateIntervalInCombat, float UpdateIntervalNonCombat, float UpdateIntervalNoPotions, \
					float[] StatLimitsInCombat, float[] StatLimitsNonCombat, float LvlDiffTrigger, \
					bool[] UsePotionOfType, bool isFollower)

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
	
endFunction
