Scriptname _FPP_Quest extends Quest Conditional


float Property CurrentVersion = 1.0200 AutoReadonly
float previousVersion

bool DawnguardLoaded
bool DragonbornLoaded

ReferenceAlias[] Property AllFollowers  Auto
bool Property NoMoreRoom Auto Conditional

ObjectReference Property PlayerRef  Auto  

string Property C_SCHOOL_ALTERATION = "Alteration" Autoreadonly
string Property C_SCHOOL_CONJURATION = "Conjuration" Autoreadonly
string Property C_SCHOOL_DESTRUCTION = "Destruction" Autoreadonly
string Property C_SCHOOL_ILLUSION = "Illusion" Autoreadonly
string Property C_SCHOOL_RESTORATION = "Restoration" Autoreadonly

int Property C_IDENTIFY_RESTORE = 1 Autoreadonly
int Property C_IDENTIFY_FORTIFY = 2 Autoreadonly
int Property C_IDENTIFY_RESIST = 4 Autoreadonly
int Property C_IDENTIFY_FIRST = 8 Autoreadonly
int Property C_IDENTIFY_SECOND = 16 Autoreadonly
int Property C_IDENTIFY_THIRD = 32 Autoreadonly

int Property C_ITEM_HAND = 0 Autoreadonly
int Property C_ITEM_1H_SWORD = 1 Autoreadonly
int Property C_ITEM_1H_DAGGER = 2 Autoreadonly
int Property C_ITEM_1H_AXE = 3 Autoreadonly
int Property C_ITEM_1H_MACE = 4 Autoreadonly
int Property C_ITEM_2H_SWORD = 5 Autoreadonly
int Property C_ITEM_2H_AXE_MACE = 6 Autoreadonly
int Property C_ITEM_BOW = 7 Autoreadonly
int Property C_ITEM_STAFF = 8 Autoreadonly
int Property C_ITEM_SPELL = 9 Autoreadonly
int Property C_ITEM_SHIELD = 10 Autoreadonly
int Property C_ITEM_TORCH = 11 Autoreadonly
int Property C_ITEM_CROSSBOW = 12 Autoreadonly

int Property EFFECT_RESTOREHEALTH = 0 Autoreadonly
int Property EFFECT_RESTORESTAMINA = 1 Autoreadonly
int Property EFFECT_RESTOREMAGICKA = 2 Autoreadonly

int Property EFFECT_FORTIFYHEALTH = 3 Autoreadonly
int Property EFFECT_FORTIFYHEALRATE = 4 Autoreadonly
int Property EFFECT_FORTIFYSTAMINA = 5 Autoreadonly
int Property EFFECT_FORTIFYSTAMINARATE = 6 Autoreadonly
int Property EFFECT_FORTIFYMAGICKA = 7 Autoreadonly
int Property EFFECT_FORTIFYMAGICKARATE = 8 Autoreadonly

int Property EFFECT_FORTIFYBLOCK = 9 Autoreadonly
int Property EFFECT_FORTIFYHEAVYARMOR = 10 Autoreadonly
int Property EFFECT_FORTIFYLIGHTARMOR = 11 Autoreadonly
int Property EFFECT_FORTIFYMARKSMAN = 12 Autoreadonly
int Property EFFECT_FORTIFYONEHANDED = 13 Autoreadonly
int Property EFFECT_FORTIFYTWOHANDED = 14 Autoreadonly

int Property EFFECT_FORTIFYALTERATION = 15 Autoreadonly
int Property EFFECT_FORTIFYCONJURATION = 16 Autoreadonly
int Property EFFECT_FORTIFYDESTRUCTION = 17 Autoreadonly
int Property EFFECT_FORTIFYILLUSION = 18 Autoreadonly
int Property EFFECT_FORTIFYRESTORATION = 19 Autoreadonly

int Property EFFECT_RESISTFIRE = 20 Autoreadonly
int Property EFFECT_RESISTFROST = 21 Autoreadonly
int Property EFFECT_RESISTSHOCK = 22 Autoreadonly
int Property EFFECT_RESISTMAGIC = 23 Autoreadonly
int Property EFFECT_RESISTPOISON = 24 Autoreadonly

int Property EFFECT_DAMAGEHEALTH = 25 Autoreadonly
int Property EFFECT_DAMAGEMAGICKA = 26 Autoreadonly
int Property EFFECT_DAMAGESTAMINA = 27 Autoreadonly

int Property EFFECT_WEAKNESSFIRE = 28 Autoreadonly
int Property EFFECT_WEAKNESSFROST = 29 Autoreadonly
int Property EFFECT_WEAKNESSSHOCK = 30 Autoreadonly
int Property EFFECT_WEAKNESSMAGIC = 31 Autoreadonly

int Property EFFECT_FORTIFYALCHEMY = 32 Autoreadonly
int Property EFFECT_FORTIFYENCHANTING = 33 Autoreadonly

int Property EFFECT_FORTIFYSNEAK = 34 Autoreadonly
int Property EFFECT_FORTIFYLOCKPICKING = 35 Autoreadonly
int Property EFFECT_FORTIFYPICKPOCKET = 36 Autoreadonly
int Property EFFECT_FORTIFYSMITHING = 37 Autoreadonly
int Property EFFECT_FORTIFYSPEECHCRAFT = 38 Autoreadonly

int Property EFFECT_FORTIFYMASS = 39 Autoreadonly
int Property EFFECT_FORTIFYCARRYWEIGHT = 40 Autoreadonly

int Property EFFECT_BENEFICIAL = 41 Autoreadonly
int Property EFFECT_DURATIONBASED = 42 Autoreadonly
int Property EFFECT_HARMFUL = 43 Autoreadonly

int Property XFL_PLUGIN_EVENT_CLEAR_ALL = -1 Autoreadonly
int Property XFL_PLUGIN_EVENT_WAIT = 0x04 Autoreadonly
int Property XFL_PLUGIN_EVENT_SANDBOX = 0x05 Autoreadonly
int Property XFL_PLUGIN_EVENT_FOLLOW = 0x03 Autoreadonly
int Property XFL_PLUGIN_EVENT_ADD_FOLLOWER = 0x00 Autoreadonly
int Property XFL_PLUGIN_EVENT_REMOVE_FOLLOWER = 0x01 Autoreadonly
int Property XFL_PLUGIN_EVENT_REMOVE_DEAD_FOLLOWER = 0x02 Autoreadonly


Keyword[] Property EffectKeywords Auto
Keyword Property MagicAlchBeneficial Auto
Keyword Property MagicAlchDamageHealth Auto
Keyword Property MagicAlchDamageMagicka Auto
Keyword Property MagicAlchDamageStamina Auto
Keyword Property MagicAlchDurationBased Auto
Keyword Property MagicAlchFortifyAlchemy Auto
Keyword Property MagicAlchFortifyAlteration Auto
Keyword Property MagicAlchFortifyBlock Auto
Keyword Property MagicAlchFortifyCarryWeight Auto
Keyword Property MagicAlchFortifyConjuration Auto
Keyword Property MagicAlchFortifyDestruction Auto
Keyword Property MagicAlchFortifyEnchanting Auto
Keyword Property MagicAlchFortifyHealRate Auto
Keyword Property MagicAlchFortifyHealth Auto
Keyword Property MagicAlchFortifyHeavyArmor Auto
Keyword Property MagicAlchFortifyIllusion Auto
Keyword Property MagicAlchFortifyLightArmor Auto
Keyword Property MagicAlchFortifyLockpicking Auto
Keyword Property MagicAlchFortifyMagicka Auto
Keyword Property MagicAlchFortifyMagickaRate Auto
Keyword Property MagicAlchFortifyMarksman Auto
Keyword Property MagicAlchFortifyMass Auto
Keyword Property MagicAlchFortifyOneHanded Auto
Keyword Property MagicAlchFortifyPickPocket Auto
Keyword Property MagicAlchFortifyRestoration Auto
Keyword Property MagicAlchFortifySmithing Auto
Keyword Property MagicAlchFortifySneak Auto
Keyword Property MagicAlchFortifySpeechcraft Auto
Keyword Property MagicAlchFortifyStamina Auto
Keyword Property MagicAlchFortifyStaminaRate Auto
Keyword Property MagicAlchFortifyTwoHanded Auto
Keyword Property MagicAlchHarmful Auto
Keyword Property MagicAlchResistFire Auto
Keyword Property MagicAlchResistFrost Auto
Keyword Property MagicAlchResistMagic Auto
Keyword Property MagicAlchResistPoison Auto
Keyword Property MagicAlchResistShock Auto
Keyword Property MagicAlchRestoreHealth Auto
Keyword Property MagicAlchRestoreMagicka Auto
Keyword Property MagicAlchRestoreStamina Auto
Keyword Property MagicAlchWeaknessFire Auto
Keyword Property MagicAlchWeaknessFrost Auto
Keyword Property MagicAlchWeaknessMagic Auto
Keyword Property MagicAlchWeaknessShock Auto

Keyword Property VendorItemPotion Auto

Keyword Property ArmorHeavy Auto
Keyword Property ArmorLight Auto

Keyword Property MagicDamageFire Auto
Keyword Property MagicDamageFrost Auto
Keyword Property MagicDamageShock Auto

LocationRefType Property LocRefTypeBoss Auto

Race[] Property AvailableTriggerRaces Auto
int[] Property TriggerRaceMappings Auto


string[] Property EffectNames Auto

int[] Property RestoreEffects Auto
int[] Property FortifyEffectsStats Auto
int[] Property FortifyEffectsWarrior Auto
int[] Property FortifyEffectsMage Auto
int[] Property ResistEffects Auto

float Property DefaultUpdateIntervalInCombat Auto
float Property DefaultUpdateIntervalNonCombat Auto
float Property DefaultUpdateIntervalNoPotions Auto

bool[] Property DefaultEnableWarnings Auto
float[] Property DefaultWarningIntervals Auto

float[] Property DefaultStatLimitsInCombat Auto
float[] Property DefaultStatLimitsNonCombat Auto

float Property DefaultLvlDiffTrigger Auto
bool[] Property DefaultTriggerRaces Auto

bool[] Property DefaultUsePotionOfType Auto

int Property DefaultIdentifyPotionEffects Auto

Message Property _FPP_InfoMessage Auto

Potion Property PotionHealth1 Auto
Potion Property PotionHealth2 Auto
Potion Property PotionHealth3 Auto
Potion Property PotionStamina1 Auto  
Potion Property PotionStamina2 Auto  
Potion Property PotionStamina3 Auto  
Potion Property PotionMagicka1 Auto
Potion Property PotionMagicka2 Auto
Potion Property PotionMagicka3 Auto

bool Property XflAddOnFollow Auto
GlobalVariable Property _FPP_ShowDebugOptions  Auto

bool fileDebug
bool Property DebugToFile
	bool function get()
		return fileDebug
	endFunction
	function set(bool value)
		fileDebug = value
		int i = AllFollowers.Length
		while (i)
			i -= 1
			(AllFollowers[i] as _FPP_FollowerScript).DebugToFile = fileDebug
		endWhile
	endFunction
endProperty

int followerCount

event OnInit()

	EffectKeywords = new Keyword[44]
	EffectNames = new string[44]

	SetDefaults()

	DebugStuff("Follower Potions is started")

	Update()

endEvent

function Update()

	; floating-point math is hard..  let's go shopping!
	int iPreviousVersion = (PreviousVersion * 10000) as int
	int iCurrentVersion = (CurrentVersion * 10000) as int
	
	if (iCurrentVersion != iPreviousVersion)

		;;;;;;;;;;;;;;;;;;;;;;;;;;
		; version-specific updates
		;;;;;;;;;;;;;;;;;;;;;;;;;;
		if (iPreviousVersion < 00201)
		
			; set DefaultWarningIntervals
			SetDefaultWarningIntervals()
			
			; set WarningIntervalInCombat for all current followers
			int i = 0
			int iMax = AllFollowers.Length
			ReferenceAlias thisFollowerRef
			while (i < iMax)
				thisFollowerRef = AllFollowers[i]
				if (thisFollowerRef && (thisFollowerRef.GetReference() as Actor))
					(thisFollowerRef as _FPP_FollowerScript).WarningIntervals = GetDefaultWarningIntervals()
					(thisFollowerRef as _FPP_FollowerScript).ResetPotionWarningTriggers()
				endIf
				i += 1
			endWhile
			
		endIf
		
		if (iPreviousVersion < 00300)
		
			; set DefaultIdentifyPotionEffects (to identify everything, which is previous standard behaviour)
			DefaultIdentifyPotionEffects = C_IDENTIFY_RESTORE + C_IDENTIFY_FORTIFY + C_IDENTIFY_RESIST
			
			; set UsePotionOfType for all current followers
			int i = 0
			int iMax = AllFollowers.Length
			ReferenceAlias thisFollowerRef
			while (i < iMax)
				thisFollowerRef = AllFollowers[i]
				if (thisFollowerRef && (thisFollowerRef.GetReference() as Actor))
					(thisFollowerRef as _FPP_FollowerScript).IdentifyPotionEffects = DefaultIdentifyPotionEffects
				endIf
				i += 1
			endWhile
		
		endIf
		
		if (iPreviousVersion < 10100)
		
			; set AvailableTriggerRaces
			SetAvailableTriggerRaces()
			
			; set DefaultTriggerRaces
			SetDefaultTriggerRaces()
			
			; set TriggerRaces for all current followers
			int i = 0
			int iMax = AllFollowers.Length
			ReferenceAlias thisFollowerRef
			while (i < iMax)
				thisFollowerRef = AllFollowers[i]
				if (thisFollowerRef && (thisFollowerRef.GetReference() as Actor))
					(thisFollowerRef as _FPP_FollowerScript).TriggerRaces = GetDefaultTriggerRaces()
				endIf
				i += 1
			endWhile
		
		endIf
		
		if (iPreviousVersion < 10200)
		
			; set DefaultEnableWarnings
			SetDefaultEnableWarnings()
			
			; set EnableWarnings for all current followers
			int i = 0
			int iMax = AllFollowers.Length
			ReferenceAlias thisFollowerRef
			while (i < iMax)
				thisFollowerRef = AllFollowers[i]
				if (thisFollowerRef && (thisFollowerRef.GetReference() as Actor))
					(thisFollowerRef as _FPP_FollowerScript).EnableWarnings = GetDefaultEnableWarnings()
				endIf
				i += 1
			endWhile
		
		endIf
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		; end version-specific updates
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		; notify current version
		string msg = "Follower Potions"
		if (PreviousVersion > 0)
			msg += " updated from v" + GetVersionAsString(PreviousVersion) + " to "
		else
			msg += " running "
		endIf
		msg += "v" + GetVersionAsString(CurrentVersion)
		DebugStuff(msg, msg, true)

		PreviousVersion = CurrentVersion
	endIf

	Maintenance()

endFunction

function Maintenance()
;/
	DebugStuff("=============================== Follower Potions ===============================")
	DebugStuff("===== The usual blurb about compatibility checks, any errors are harmless. =====")
	DebugStuff("================================================================================")
	DebugStuff("=============================== Follower Potions ===============================")
	DebugStuff("=========== Compatibility checks complete, any errors are bad again. ===========")
	DebugStuff("================================================================================")
/;

	Debug.OpenUserLog("FollowerPotions")

	SetProperties()

	; used by the Thread Manager which extends Quest
    RegisterForModEvent("_FPP_Trigger_IdentifyPotion", "OnIdentifyPotion")
	
	; used by this script
	RegisterForModEvent("XFL_System_PluginEvent", "OnXflPluginEvent")

	; Check for new DLC
	int dlc1 = Game.GetModByName("Dawnguard.esm")
	if (!DawnguardLoaded && dlc1 > 0 && dlc1 < 255)
		AddDawnguardTriggerRaces()
		DebugStuff("Adding Dawnguard races to triggers")
		DawnguardLoaded = true
	endIf

	int dlc2 = Game.GetModByName("Dragonborn.esm")
	if (!DragonbornLoaded && dlc2 > 0 && dlc2 < 255)
		AddDragonbornTriggerRaces()
		DebugStuff("Adding Dragonborn races to triggers")
		DragonbornLoaded = true
	endIf

	; Maintenance for registered followers
	Actor followerActor
	int i = 0
	int iMax = AllFollowers.Length
	followerCount = 0
	ReferenceAlias thisFollowerRef
	DebugStuff("Follower maintenance - up to " + iMax + " followers")
	while (i < iMax)
		thisFollowerRef = AllFollowers[i]
		if (thisFollowerRef)
			followerActor = thisFollowerRef.GetReference() as Actor
			if (followerActor != None)
				followerCount += 1
				(thisFollowerRef as _FPP_FollowerScript).Maintenance()
			endIf
		endIf
		i += 1
	endWhile

	UpdateNoMoreRoom()

	DebugStuff("Maintenance complete")

endFunction

Event OnXflPluginEvent(int eventId, Form akRef1 = None, Form akRef2 = None, int aiValue1 = 0, int aiValue2 = 0)
	Actor FollowerActor = akRef1 as Actor
	string msg = "EFF event " + eventId + " - "
	If (!FollowerActor)
		DebugStuff(msg + "Error; FollowerActor form")
		return
	else
		if (eventId == XFL_PLUGIN_EVENT_CLEAR_ALL)
			; no parameters sent
			RemoveAllFollowers()
			DebugStuff(msg + "Clear all")
		elseif (eventId == XFL_PLUGIN_EVENT_WAIT)
			DebugStuff(msg + "Follower wait")
		elseif (eventId == XFL_PLUGIN_EVENT_SANDBOX)
			DebugStuff(msg + "Follower sandbox")
		elseif (eventId == XFL_PLUGIN_EVENT_FOLLOW)
			DebugStuff(msg + "Follower follow")
			if (XflAddOnFollow)
				bool success = AddFollower(FollowerActor)
			endIf
		elseif (eventId == XFL_PLUGIN_EVENT_ADD_FOLLOWER)
			DebugStuff(msg + "Add follower")
			bool success = AddFollower(FollowerActor)
		elseif (eventId == XFL_PLUGIN_EVENT_REMOVE_FOLLOWER)
			DebugStuff(msg + "Remove follower")
			bool success = RemoveFollower(FollowerActor)
		elseif (eventId == XFL_PLUGIN_EVENT_REMOVE_DEAD_FOLLOWER)
			DebugStuff(msg + "Remove dead follower")
		endIf
	Endif
endEvent

function UpdateNoMoreRoom()
	NoMoreRoom = followerCount == AllFollowers.Length
endFunction

bool function AddFollower(Actor akFollower)

	if (akFollower == None)
		return false
	endIf

	int i = 0
	int iMax = AllFollowers.Length
	ReferenceAlias thisFollowerRef
	while (i < iMax)
		thisFollowerRef = AllFollowers[i]
		if (thisFollowerRef)
			if ((thisFollowerRef.GetReference() as Actor) != akFollower)
				if (thisFollowerRef.ForceRefIfEmpty(akFollower))
					DebugStuff("AddFollower - add at index " + i)
					(thisFollowerRef as _FPP_FollowerScript).Init()
					followerCount += 1
					UpdateNoMoreRoom()
					return true
				else
					DebugStuff("AddFollower - can't add at index " + i + " (not empty?)")
				endIf
			else
				DebugStuff("AddFollower - already in at pos " + i)
				return false
			endIf
		else
			DebugStuff("AddFollower - pos " + i + " doesn't exist")
		endIf
		i += 1
	endWhile

	DebugStuff("AddFollower - failed to add", "couldn't add new follower", true)
	return false

endFunction

function ResetFollower(Actor akFollower)

	if (akFollower == None)
		return
	endIf
	
	int i = 0
	int iMax = AllFollowers.Length
	ReferenceAlias thisFollowerRef
	while (i < iMax)
		thisFollowerRef = AllFollowers[i]
		if (thisFollowerRef && (thisFollowerRef.GetReference() as Actor) == akFollower)
			_FPP_FollowerScript thisFollower = thisFollowerRef as _FPP_FollowerScript
			
			thisFollower.UpdateIntervalInCombat = DefaultUpdateIntervalInCombat
			thisFollower.UpdateIntervalNonCombat = DefaultUpdateIntervalNonCombat
			thisFollower.UpdateIntervalNoPotions = DefaultUpdateIntervalNoPotions
			thisFollower.WarningIntervals = GetDefaultWarningIntervals()
			thisFollower.StatLimitsInCombat[0] = DefaultStatLimitsInCombat[0]
			thisFollower.StatLimitsInCombat[1] = DefaultStatLimitsInCombat[1]
			thisFollower.StatLimitsInCombat[2] = DefaultStatLimitsInCombat[2]
			thisFollower.StatLimitsNonCombat[0] = DefaultStatLimitsNonCombat[0]
			thisFollower.StatLimitsNonCombat[1] = DefaultStatLimitsNonCombat[1]
			thisFollower.StatLimitsNonCombat[2] = DefaultStatLimitsNonCombat[2]
			thisFollower.LvlDiffTrigger = DefaultLvlDiffTrigger as int
			thisFollower.TriggerRaces = GetDefaultTriggerRaces()
			
			int p = RestoreEffects.Length
			while (p)
				p -= 1
				thisFollower.UsePotionOfType[RestoreEffects[p]] = DefaultUsePotionOfType[RestoreEffects[p]]
			endWhile
			p = FortifyEffectsStats.Length
			while (p)
				p -= 1
				thisFollower.UsePotionOfType[FortifyEffectsStats[p]] = DefaultUsePotionOfType[FortifyEffectsStats[p]]
			endWhile
			p = FortifyEffectsWarrior.Length
			while (p)
				p -= 1
				thisFollower.UsePotionOfType[FortifyEffectsWarrior[p]] = DefaultUsePotionOfType[FortifyEffectsWarrior[p]]
			endWhile
			p = FortifyEffectsMage.Length
			while (p)
				p -= 1
				thisFollower.UsePotionOfType[FortifyEffectsMage[p]] = DefaultUsePotionOfType[FortifyEffectsMage[p]]
			endWhile
			p = ResistEffects.Length
			while (p)
				p -= 1
				thisFollower.UsePotionOfType[ResistEffects[p]] = DefaultUsePotionOfType[ResistEffects[p]]
			endWhile

			DebugStuff("Reset " + thisFollower.ActorName + " to defaults")
			
		endIf
		i += 1
	endWhile

endFunction

function RefreshFollowerPotions(Actor akFollower)

	if (akFollower == None)
		return
	endIf
	
	int i = 0
	int iMax = AllFollowers.Length
	ReferenceAlias thisFollowerRef
	while (i < iMax)
		thisFollowerRef = AllFollowers[i]
		if (thisFollowerRef && (thisFollowerRef.GetReference() as Actor) == akFollower)
			(thisFollowerRef as _FPP_FollowerScript).RefreshPotions()
		endIf
		i += 1
	endWhile

endFunction

function RemoveAllFollowers()

	int i = 0
	int iMax = AllFollowers.Length
	ReferenceAlias thisFollowerRef
	while (i < iMax)
		thisFollowerRef = AllFollowers[i]
		if (thisFollowerRef && (thisFollowerRef.GetReference() as Actor))
			(thisFollowerRef as _FPP_FollowerScript).DeInit()
			if (thisFollowerRef.TryToClear())
				DebugStuff("RemoveAllFollowers - cleared index " + i)
				followerCount -= 1
			else
				DebugStuff("RemoveAllFollowers - can't remove from index " + i)
			endIf
		endIf
		i += 1
	endWhile
	
	UpdateNoMoreRoom()
	DebugStuff("RemoveAllFollowers - complete", "All followers removed", true)

endFunction

bool function RemoveFollower(Actor akFollower)

	if (akFollower == None)
		return false
	endIf
	
	int i = 0
	int iMax = AllFollowers.Length
	ReferenceAlias thisFollowerRef
	while (i < iMax)
		thisFollowerRef = AllFollowers[i]
		if (thisFollowerRef && (thisFollowerRef.GetReference() as Actor) == akFollower)
			(thisFollowerRef as _FPP_FollowerScript).DeInit()
			if (thisFollowerRef.TryToClear())
				DebugStuff("RemoveFollower - cleared index " + i)
				followerCount -= 1
				UpdateNoMoreRoom()
				return true
			else
				DebugStuff("RemoveFollower - can't remove from index " + i)
				return false
			endIf
		endIf
		i += 1
	endWhile

	DebugStuff("RemoveFollower - failed to remove", "couldn't remove follower", true)
	return false

endFunction

function AddPotionsToFollower(Actor akFollower)

	; have to add to player, then remove from player to follower, or EFF intercepts it..
	PlayerRef.AddItem(PotionHealth1, 10, true)
	PlayerRef.RemoveItem(PotionHealth1, 10, true, akFollower)
	PlayerRef.AddItem(PotionHealth2, 10, true)
	PlayerRef.RemoveItem(PotionHealth2, 10, true, akFollower)
	PlayerRef.AddItem(PotionHealth3, 10, true)
	PlayerRef.RemoveItem(PotionHealth3, 10, true, akFollower)
	Utility.WaitMenuMode(0.5)
	PlayerRef.AddItem(PotionStamina1, 10, true)
	PlayerRef.RemoveItem(PotionStamina1, 10, true, akFollower)
	PlayerRef.AddItem(PotionStamina2, 10, true)
	PlayerRef.RemoveItem(PotionStamina2, 10, true, akFollower)
	PlayerRef.AddItem(PotionStamina3, 10, true)
	PlayerRef.RemoveItem(PotionStamina3, 10, true, akFollower)
	Utility.WaitMenuMode(0.5)
	PlayerRef.AddItem(PotionMagicka1, 10, true)
	PlayerRef.RemoveItem(PotionMagicka1, 10, true, akFollower)
	PlayerRef.AddItem(PotionMagicka2, 10, true)
	PlayerRef.RemoveItem(PotionMagicka2, 10, true, akFollower)
	PlayerRef.AddItem(PotionMagicka3, 10, true)
	PlayerRef.RemoveItem(PotionMagicka3, 10, true, akFollower)
	
	DebugStuff("Potions added to follower")

endFunction


bool[] function CreateBoolArray(int aiLength, bool abValue)
	{looks like SKSE's implementation of this is bugged when setting initial val to false :( }
	bool[] array = Utility.CreateBoolArray(aiLength, abValue)
	if (abValue)
		return array
	endIf
	int i = array.Length
	while (i)
		i -= 1
		array[i] = abValue
	endWhile
	return array
endFunction

string function GetVersionAsString(float afVersion)
	string raw = afVersion as string
	int dotPos = StringUtil.Find(raw, ".")
	string major = StringUtil.SubString(raw, 0, dotPos)
	string minor = StringUtil.SubString(raw, dotPos + 1, 2)
	string revsn = StringUtil.SubString(raw, dotPos + 3, 2)
	return major + "." + minor + "." + revsn
endFunction

function DebugStuff(string asLogMsg, string asScreenMsg = "", bool abFpPrefix = false)

	if (DebugToFile)
		Debug.TraceUser("FollowerPotions", asLogMsg)
	endIf
	if (asScreenMsg != "")
		if (abFpPrefix)
			asScreenMsg = "Follower Potions - " + asScreenMsg
		endIf
		Debug.Notification(asScreenMsg)
	endIf

endFunction

Function SetProperties()
	EffectKeywords[EFFECT_RESTOREHEALTH] = MagicAlchRestoreHealth
	EffectKeywords[EFFECT_RESTORESTAMINA] = MagicAlchRestoreStamina
	EffectKeywords[EFFECT_RESTOREMAGICKA] = MagicAlchRestoreMagicka
	EffectKeywords[EFFECT_BENEFICIAL] = MagicAlchBeneficial
	EffectKeywords[EFFECT_DAMAGEHEALTH] = MagicAlchDamageHealth
	EffectKeywords[EFFECT_DAMAGEMAGICKA] = MagicAlchDamageMagicka
	EffectKeywords[EFFECT_DAMAGESTAMINA] = MagicAlchDamageStamina
	EffectKeywords[EFFECT_DURATIONBASED] = MagicAlchDurationBased
	EffectKeywords[EFFECT_FORTIFYALCHEMY] = MagicAlchFortifyAlchemy
	EffectKeywords[EFFECT_FORTIFYALTERATION] = MagicAlchFortifyAlteration
	EffectKeywords[EFFECT_FORTIFYBLOCK] = MagicAlchFortifyBlock
	EffectKeywords[EFFECT_FORTIFYCARRYWEIGHT] = MagicAlchFortifyCarryWeight
	EffectKeywords[EFFECT_FORTIFYCONJURATION] = MagicAlchFortifyConjuration
	EffectKeywords[EFFECT_FORTIFYDESTRUCTION] = MagicAlchFortifyDestruction
	EffectKeywords[EFFECT_FORTIFYENCHANTING] = MagicAlchFortifyEnchanting
	EffectKeywords[EFFECT_FORTIFYHEALRATE] = MagicAlchFortifyHealRate
	EffectKeywords[EFFECT_FORTIFYHEALTH] = MagicAlchFortifyHealth
	EffectKeywords[EFFECT_FORTIFYHEAVYARMOR] = MagicAlchFortifyHeavyArmor
	EffectKeywords[EFFECT_FORTIFYILLUSION] = MagicAlchFortifyIllusion
	EffectKeywords[EFFECT_FORTIFYLIGHTARMOR] = MagicAlchFortifyLightArmor
	EffectKeywords[EFFECT_FORTIFYLOCKPICKING] = MagicAlchFortifyLockpicking
	EffectKeywords[EFFECT_FORTIFYMAGICKA] = MagicAlchFortifyMagicka
	EffectKeywords[EFFECT_FORTIFYMAGICKARATE] = MagicAlchFortifyMagickaRate
	EffectKeywords[EFFECT_FORTIFYMARKSMAN] = MagicAlchFortifyMarksman
	EffectKeywords[EFFECT_FORTIFYMASS] = MagicAlchFortifyMass
	EffectKeywords[EFFECT_FORTIFYONEHANDED] = MagicAlchFortifyOneHanded
	EffectKeywords[EFFECT_FORTIFYPICKPOCKET] = MagicAlchFortifyPickPocket
	EffectKeywords[EFFECT_FORTIFYRESTORATION] = MagicAlchFortifyRestoration
	EffectKeywords[EFFECT_FORTIFYSMITHING] = MagicAlchFortifySmithing
	EffectKeywords[EFFECT_FORTIFYSNEAK] = MagicAlchFortifySneak
	EffectKeywords[EFFECT_FORTIFYSPEECHCRAFT] = MagicAlchFortifySpeechcraft
	EffectKeywords[EFFECT_FORTIFYSTAMINA] = MagicAlchFortifyStamina
	EffectKeywords[EFFECT_FORTIFYSTAMINARATE] = MagicAlchFortifyStaminaRate
	EffectKeywords[EFFECT_FORTIFYTWOHANDED] = MagicAlchFortifyTwoHanded
	EffectKeywords[EFFECT_HARMFUL] = MagicAlchHarmful
	EffectKeywords[EFFECT_RESISTFIRE] = MagicAlchResistFire
	EffectKeywords[EFFECT_RESISTFROST] = MagicAlchResistFrost
	EffectKeywords[EFFECT_RESISTMAGIC] = MagicAlchResistMagic
	EffectKeywords[EFFECT_RESISTPOISON] = MagicAlchResistPoison
	EffectKeywords[EFFECT_RESISTSHOCK] = MagicAlchResistShock
	EffectKeywords[EFFECT_WEAKNESSFIRE] = MagicAlchWeaknessFire
	EffectKeywords[EFFECT_WEAKNESSFROST] = MagicAlchWeaknessFrost
	EffectKeywords[EFFECT_WEAKNESSMAGIC] = MagicAlchWeaknessMagic
	EffectKeywords[EFFECT_WEAKNESSSHOCK] = MagicAlchWeaknessShock
	
	EffectNames[EFFECT_RESTOREHEALTH] = "Restore Health"
	EffectNames[EFFECT_RESTORESTAMINA] = "Restore Stamina"
	EffectNames[EFFECT_RESTOREMAGICKA] = "Restore Magicka"
	EffectNames[EFFECT_BENEFICIAL] = "Beneficial"
	EffectNames[EFFECT_DAMAGEHEALTH] = "Damage Health"
	EffectNames[EFFECT_DAMAGEMAGICKA] = "Damage Magicka"
	EffectNames[EFFECT_DAMAGESTAMINA] = "Damage Stamina"
	EffectNames[EFFECT_DURATIONBASED] = "Duration Based"
	EffectNames[EFFECT_FORTIFYALCHEMY] = "Fortify Alchemy"
	EffectNames[EFFECT_FORTIFYALTERATION] = "Fortify Alteration"
	EffectNames[EFFECT_FORTIFYBLOCK] = "Fortify Block"
	EffectNames[EFFECT_FORTIFYCARRYWEIGHT] = "Fortify Carry Weight"
	EffectNames[EFFECT_FORTIFYCONJURATION] = "Fortify Conjuration"
	EffectNames[EFFECT_FORTIFYDESTRUCTION] = "Fortify Destruction"
	EffectNames[EFFECT_FORTIFYENCHANTING] = "Fortify Enchanting"
	EffectNames[EFFECT_FORTIFYHEALRATE] = "Fortify Heal Rate"
	EffectNames[EFFECT_FORTIFYHEALTH] = "Fortify Health"
	EffectNames[EFFECT_FORTIFYHEAVYARMOR] = "Fortify Heavy Armor"
	EffectNames[EFFECT_FORTIFYILLUSION] = "Fortify Illusion"
	EffectNames[EFFECT_FORTIFYLIGHTARMOR] = "Fortify Light Armor"
	EffectNames[EFFECT_FORTIFYLOCKPICKING] = "Fortify Lockpicking"
	EffectNames[EFFECT_FORTIFYMAGICKA] = "Fortify Magicka"
	EffectNames[EFFECT_FORTIFYMAGICKARATE] = "Fortify Magicka Rate"
	EffectNames[EFFECT_FORTIFYMARKSMAN] = "Fortify Marksman"
	EffectNames[EFFECT_FORTIFYMASS] = "Fortify Mass"
	EffectNames[EFFECT_FORTIFYONEHANDED] = "Fortify One-Handed"
	EffectNames[EFFECT_FORTIFYPICKPOCKET] = "Fortify Pickpocket"
	EffectNames[EFFECT_FORTIFYRESTORATION] = "Fortify Restoration"
	EffectNames[EFFECT_FORTIFYSMITHING] = "Fortify Smithing"
	EffectNames[EFFECT_FORTIFYSNEAK] = "Fortify Sneak"
	EffectNames[EFFECT_FORTIFYSPEECHCRAFT] = "Fortify Speechcraft"
	EffectNames[EFFECT_FORTIFYSTAMINA] = "Fortify Stamina"
	EffectNames[EFFECT_FORTIFYSTAMINARATE] = "Fortify Stamina Rate"
	EffectNames[EFFECT_FORTIFYTWOHANDED] = "Fortify Two-Handed"
	EffectNames[EFFECT_HARMFUL] = "Harmful"
	EffectNames[EFFECT_RESISTFIRE] = "Resist Fire"
	EffectNames[EFFECT_RESISTFROST] = "Resist Frost"
	EffectNames[EFFECT_RESISTMAGIC] = "Resist Magic"
	EffectNames[EFFECT_RESISTPOISON] = "Resist Poison"
	EffectNames[EFFECT_RESISTSHOCK] = "Resist Shock"
	EffectNames[EFFECT_WEAKNESSFIRE] = "Weakness to Fire"
	EffectNames[EFFECT_WEAKNESSFROST] = "Weakness to Frost"
	EffectNames[EFFECT_WEAKNESSMAGIC] = "Weakness to Magic"
	EffectNames[EFFECT_WEAKNESSSHOCK] = "Weakness to Shock"
	
	RestoreEffects = new int[3]
	RestoreEffects[0] = EFFECT_RESTOREHEALTH
	RestoreEffects[1] = EFFECT_RESTORESTAMINA
	RestoreEffects[2] = EFFECT_RESTOREMAGICKA
	
	FortifyEffectsStats = new int[6]
	FortifyEffectsStats[0] = EFFECT_FORTIFYHEALTH
	FortifyEffectsStats[1] = EFFECT_FORTIFYHEALRATE
	FortifyEffectsStats[2] = EFFECT_FORTIFYSTAMINA
	FortifyEffectsStats[3] = EFFECT_FORTIFYSTAMINARATE
	FortifyEffectsStats[4] = EFFECT_FORTIFYMAGICKA
	FortifyEffectsStats[5] = EFFECT_FORTIFYMAGICKARATE
	
	FortifyEffectsWarrior = new int[6]
	FortifyEffectsWarrior[0] = EFFECT_FORTIFYBLOCK
	FortifyEffectsWarrior[1] = EFFECT_FORTIFYHEAVYARMOR
	FortifyEffectsWarrior[2] = EFFECT_FORTIFYLIGHTARMOR
	FortifyEffectsWarrior[3] = EFFECT_FORTIFYMARKSMAN
	FortifyEffectsWarrior[4] = EFFECT_FORTIFYONEHANDED
	FortifyEffectsWarrior[5] = EFFECT_FORTIFYTWOHANDED
	
	FortifyEffectsMage = new int[5]
	FortifyEffectsMage[0] = EFFECT_FORTIFYALTERATION
	FortifyEffectsMage[1] = EFFECT_FORTIFYCONJURATION
	FortifyEffectsMage[2] = EFFECT_FORTIFYDESTRUCTION
	FortifyEffectsMage[3] = EFFECT_FORTIFYILLUSION
	FortifyEffectsMage[4] = EFFECT_FORTIFYRESTORATION
	
	ResistEffects = new int[5]
	ResistEffects[0] = EFFECT_RESISTFIRE
	ResistEffects[1] = EFFECT_RESISTFROST
	ResistEffects[2] = EFFECT_RESISTSHOCK
	ResistEffects[3] = EFFECT_RESISTMAGIC
	ResistEffects[4] = EFFECT_RESISTPOISON
endFunction

Function SetAvailableTriggerRaces()
	AvailableTriggerRaces = new Race[10]
	TriggerRaceMappings = new int[10]
	
	AvailableTriggerRaces[00] = Game.GetFormFromFile(0x00012e82, "Skyrim.esm") as Race ; Dragon
	TriggerRaceMappings[00] = 0
	AvailableTriggerRaces[01] = Game.GetFormFromFile(0x001052a3, "Skyrim.esm") as Race ; Undead Dragon
	TriggerRaceMappings[01] = 0
	AvailableTriggerRaces[02] = Game.GetFormFromFile(0x000e7713, "Skyrim.esm") as Race ; Alduin
	TriggerRaceMappings[02] = 0
	
	AvailableTriggerRaces[03] = Game.GetFormFromFile(0x000131ef, "Skyrim.esm") as Race ; Dragon Priest
	TriggerRaceMappings[03] = 1
	
	AvailableTriggerRaces[04] = Game.GetFormFromFile(0x000131f9, "Skyrim.esm") as Race ; Giant
	TriggerRaceMappings[04] = 2
endFunction

Function AddDawnguardTriggerRaces()
	AvailableTriggerRaces[05] = Game.GetFormFromFile(0x000117de, "Dawnguard.esm") as Race ; Durnehviir
	TriggerRaceMappings[05] = 0
	
	AvailableTriggerRaces[06] = Game.GetFormFromFile(0x0000283a, "Dawnguard.esm") as Race ; Vampire Lord
	TriggerRaceMappings[06] = 3
	AvailableTriggerRaces[07] = Game.GetFormFromFile(0x0000377d, "Dawnguard.esm") as Race ; Snow Elf
	TriggerRaceMappings[07] = 3
endFunction

Function AddDragonbornTriggerRaces()
	AvailableTriggerRaces[08] = Game.GetFormFromFile(0x0001cad8, "Dragonborn.esm") as Race ; Karstaag
	TriggerRaceMappings[08] = 2
	
	AvailableTriggerRaces[09] = Game.GetFormFromFile(0x0003911a, "Dragonborn.esm") as Race ; Dragon Priests
	TriggerRaceMappings[09] = 1
endFunction

Function SetDefaults()
	DefaultUpdateIntervalInCombat = 1.0
	DefaultUpdateIntervalNonCombat = 10.0
	DefaultUpdateIntervalNoPotions = 180.0

	SetDefaultEnableWarnings()
	SetDefaultWarningIntervals()
	
	DefaultStatLimitsInCombat = new float[3]
	DefaultStatLimitsInCombat[EFFECT_RESTOREHEALTH] = 0.6
	DefaultStatLimitsInCombat[EFFECT_RESTORESTAMINA] = 0.6
	DefaultStatLimitsInCombat[EFFECT_RESTOREMAGICKA] = 0.6
	
	DefaultStatLimitsNonCombat = new float[3]
	DefaultStatLimitsNonCombat[EFFECT_RESTOREHEALTH] = 1.0
	DefaultStatLimitsNonCombat[EFFECT_RESTORESTAMINA] = 0.3
	DefaultStatLimitsNonCombat[EFFECT_RESTOREMAGICKA] = 0.3

	DefaultLvlDiffTrigger = 5.0
	SetDefaultTriggerRaces()

	DefaultUsePotionOfType = CreateBoolArray(EffectKeywords.Length, false)
	DefaultUsePotionOfType[EFFECT_RESTOREHEALTH] = true
	DefaultUsePotionOfType[EFFECT_RESTORESTAMINA] = true
	DefaultUsePotionOfType[EFFECT_RESTOREMAGICKA] = true

	DebugToFile = false
endFunction

; need to return a copy of this array, rather than ref to array itself
float[] function GetDefaultStatLimits(bool abForInCombat)
	float[] array = new float[3]
	if (abForInCombat)
		array[EFFECT_RESTOREHEALTH] = DefaultStatLimitsInCombat[EFFECT_RESTOREHEALTH]
		array[EFFECT_RESTORESTAMINA] = DefaultStatLimitsInCombat[EFFECT_RESTORESTAMINA]
		array[EFFECT_RESTOREMAGICKA] = DefaultStatLimitsInCombat[EFFECT_RESTOREMAGICKA]
	else
		array[EFFECT_RESTOREHEALTH] = DefaultStatLimitsNonCombat[EFFECT_RESTOREHEALTH]
		array[EFFECT_RESTORESTAMINA] = DefaultStatLimitsNonCombat[EFFECT_RESTORESTAMINA]
		array[EFFECT_RESTOREMAGICKA] = DefaultStatLimitsNonCombat[EFFECT_RESTOREMAGICKA]
	endIf
	return array
endFunction

; as per above, need to copy & return this
bool[] function GetDefaultUsePotionsOfTypes()
	bool[] array = CreateBoolArray(DefaultUsePotionOfType.Length, true)
	int i = array.Length
	while(i)
		i -= 1
		array[i] = DefaultUsePotionOfType[i]
	endWhile
	return array
endFunction

; as per above, need to copy & return this
float[] function GetDefaultWarningIntervals()
	float[] array = new float[5]
	array[EFFECT_RESTOREHEALTH] = DefaultWarningIntervals[EFFECT_RESTOREHEALTH]
	array[EFFECT_RESTORESTAMINA] = DefaultWarningIntervals[EFFECT_RESTORESTAMINA]
	array[EFFECT_RESTOREMAGICKA] = DefaultWarningIntervals[EFFECT_RESTOREMAGICKA]
	array[3] = DefaultWarningIntervals[3]
	array[4] = DefaultWarningIntervals[4]
	return array
endFunction

function SetDefaultWarningIntervals()
	DefaultWarningIntervals = new float[5]
	DefaultWarningIntervals[EFFECT_RESTOREHEALTH] = 30.0
	DefaultWarningIntervals[EFFECT_RESTORESTAMINA] = 30.0
	DefaultWarningIntervals[EFFECT_RESTOREMAGICKA] = 30.0
	DefaultWarningIntervals[3] = 180.0
	DefaultWarningIntervals[4] = 180.0
endFunction

; as per above, need to copy & return this
bool[] function GetDefaultTriggerRaces()
	bool[] array = CreateBoolArray(DefaultTriggerRaces.Length, true)
	int i = array.Length
	while(i)
		i -= 1
		array[i] = DefaultTriggerRaces[i]
	endWhile
	return array
endFunction

function SetDefaultTriggerRaces()
	DefaultTriggerRaces = CreateBoolArray(TriggerRaceMappings.Length, true)
endFunction

bool[] function GetDefaultEnableWarnings()
	bool[] array = CreateBoolArray(DefaultEnableWarnings.Length, true)
	int i = array.Length
	while(i)
		i -= 1
		array[i] = DefaultEnableWarnings[i]
	endWhile
	return array
endFunction

function SetDefaultEnableWarnings()
	DefaultEnableWarnings = CreateBoolArray(6, true)
endFunction
