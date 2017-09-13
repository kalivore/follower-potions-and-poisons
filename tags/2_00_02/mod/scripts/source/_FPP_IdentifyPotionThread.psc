Scriptname _FPP_IdentifyPotionThread extends Quest

_FPP_Quest property FPPQuest auto
{quest which holds useful thread properties}

; Thread variables
bool threadQueued = false
bool threadBusy = false
int effectsFound = 0
bool isPoisonItem = false
int effectTypesRestore = 0
int effectTypesFortifyStats = 0
int effectTypesFortifyWarrior = 0
int effectTypesFortifyMage = 0
int effectTypesResist = 0
int effectTypesSpecial = 0
int effectTypesDamageStats = 0
int effectTypesWeakness = 0
int effectTypesGenericHarmful = 0

; Variables you need to get things done go here
string ActorName
Potion ThisPotion
int PotionCount
int IdentifyPotionEffects
bool DebugToFile

; Thread queuing and set-up
function GetAsync(string asActorName, Potion akPotion, int aiPotionCount, int aiIdentifyPotionEffects, bool abDebugToFile)
 
    ; Let the Thread Manager know that this thread is busy
    threadQueued = true

    ; Store our passed-in parameters to member variables
	ActorName = asActorName
	ThisPotion = akPotion
	PotionCount = aiPotionCount
	IdentifyPotionEffects = aiIdentifyPotionEffects
	DebugToFile = abDebugToFile

    ; re-set our internal props (just in case)
	effectsFound = 0
	isPoisonItem = false
	effectTypesRestore = 0
	effectTypesFortifyStats = 0
	effectTypesFortifyWarrior = 0
	effectTypesFortifyMage = 0
	effectTypesResist = 0
	effectTypesSpecial = 0
	effectTypesDamageStats = 0
	effectTypesWeakness = 0
	effectTypesGenericHarmful = 0

endFunction
 
; Allows the Thread Manager to determine if this thread is available
bool function Queued()
	return threadQueued
endFunction
 
; For Thread Manager troubleshooting.  I should probably use this somewhere..
bool function ForceUnlock()
    ClearThreadVars()
    threadBusy = false
    threadQueued = false
    return true
endFunction
 
; The actual set of code we want to multithread.
Event OnIdentifyPotion()
	;Debug.TraceUser("FollowerPotions", ActorName + ": IdentifyPotionThread - OnIdentifyPotion: queued: " + threadQueued + ", busy: " + threadBusy)
	if (!threadQueued)
		return
	endif
	if (threadBusy)
		return
	endif
	
	threadBusy = true
	
	; OK, let's get some work done!
	IdentifyPotion()

	; all finished - raise event to indicate completion
	RaiseEvent_IdentifyPotionCallback()

	; Set all variables back to default
	ClearThreadVars()

	; Make the thread available to the Thread Manager again
	threadBusy = false
	threadQueued = false
endEvent
 
; Called from Event OnIdentifyPotion
Function IdentifyPotion()

	isPoisonItem = ThisPotion.IsPoison()
	if (ThisPotion == None || ThisPotion.IsFood() || (!isPoisonItem && ThisPotion.IsHostile()))
		return
	endIf

	Keyword[] EffectKeywords = FPPQuest.EffectKeywords
	int[] RestoreEffects = FPPQuest.RestoreEffects
	int[] FortifyEffectsStats = FPPQuest.FortifyEffectsStats
	int[] FortifyEffectsWarrior = FPPQuest.FortifyEffectsWarrior
	int[] FortifyEffectsMage = FPPQuest.FortifyEffectsMage
	int[] ResistEffects = FPPQuest.ResistEffects
	int[] PoisonEffectsSpecial = FPPQuest.PoisonEffectsSpecial
	int[] PoisonEffectsStats = FPPQuest.PoisonEffectsStats
	int[] PoisonEffectsWeakness = FPPQuest.PoisonEffectsWeakness
	int[] PoisonEffectsGeneric = FPPQuest.PoisonEffectsGeneric
	int C_IDENTIFY_RESTORE = FPPQuest.C_IDENTIFY_RESTORE
	int C_IDENTIFY_FORTIFY = FPPQuest.C_IDENTIFY_FORTIFY
	int C_IDENTIFY_RESIST = FPPQuest.C_IDENTIFY_RESIST
	int C_IDENTIFY_FIRST = FPPQuest.C_IDENTIFY_FIRST
	int C_IDENTIFY_SECOND = FPPQuest.C_IDENTIFY_SECOND
	int C_IDENTIFY_THIRD = FPPQuest.C_IDENTIFY_THIRD

	bool playerMade = Math.RightShift(ThisPotion.GetFormId(), 24) >= 255
	bool identByEffectType = IdentifyPotionEffects < C_IDENTIFY_FIRST
	MagicEffect[] effects = ThisPotion.GetMagicEffects()
	int numEffects = effects.Length
	string msg = ""
	
	if (isPoisonItem)
		if (DebugToFile)
			msg += ActorName + ": IdentifyPotion " + ThisPotion.GetFormId() + " (poison) - find " + numEffects + " effect(s) by relevant effect types (player-made: " + playerMade + ", method " + IdentifyPotionEffects + ")"
		endIf
		effectTypesSpecial = CheckFormEffects(PoisonEffectsSpecial, ThisPotion, EffectKeywords, false)
		effectTypesDamageStats = CheckFormEffects(PoisonEffectsStats, ThisPotion, EffectKeywords, false)
		effectTypesWeakness = CheckFormEffects(PoisonEffectsWeakness, ThisPotion, EffectKeywords, false)
		if (effectsFound == 0)
			if (DebugToFile)
				msg += "; no specific effects found, add as generic"
			endIf
			effectsFound += 1
			effectTypesGenericHarmful = 1
		endIf
		if (DebugToFile)
			Debug.TraceUser("FollowerPotions", msg)
		endIf
		RegisterPotion()
		; nothing more to do - return here
		return
	endIf
	
	if (!playerMade || identByEffectType)
		if (DebugToFile)
			msg += ActorName + ": IdentifyPotion " + ThisPotion.GetFormId() + " - find " + numEffects + " effect(s) by relevant effect types (player-made: " + playerMade + ", method " + IdentifyPotionEffects + ")"
		endIf
		
		if (numEffects == 1 || !identByEffectType || Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_RESTORE) != 0)
			effectTypesRestore = CheckFormEffects(RestoreEffects, ThisPotion, EffectKeywords, false)
		endIf
			
		if (numEffects == 1 || !identByEffectType || Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_FORTIFY) != 0)
			effectTypesFortifyStats = CheckFormEffects(FortifyEffectsStats, ThisPotion, EffectKeywords, false)
			effectTypesFortifyWarrior = CheckFormEffects(FortifyEffectsWarrior, ThisPotion, EffectKeywords, false)
			effectTypesFortifyMage = CheckFormEffects(FortifyEffectsMage, ThisPotion, EffectKeywords, false)
		endIf
			
		if (numEffects == 1 || !identByEffectType || Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_RESIST) != 0)
			effectTypesResist = CheckFormEffects(ResistEffects, ThisPotion, EffectKeywords, false)
		endIf

		if (DebugToFile)
			Debug.TraceUser("FollowerPotions", msg)
		endIf
		RegisterPotion()
		; all identifying done - return here
		return
	endIf
	
	; OK, let's find these effects
	int getEffect = 0
	if (numEffects < 3 && Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_THIRD) != 0 || numEffects < 2 && Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_SECOND) != 0)
		getEffect = numEffects
	elseIf (Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_THIRD) != 0)
		getEffect = 3
	elseIf (Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_SECOND) != 0)
		getEffect = 2
	elseIf (Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_FIRST) != 0)
		getEffect = 1
	endIf
	
	if (DebugToFile)
		Debug.TraceUser("FollowerPotions", ActorName + ": IdentifyPotion " + ThisPotion.GetFormId() + " - find by single effect (method " + IdentifyPotionEffects + ", effect " + getEffect + " of " + numEffects + ")")
	endIf
	
	; adjust for 0-based indexing
	getEffect -= 1
	
	if (getEffect < 0)
		; gee, something went wrong there..
		return
	endIf
	
	; get relevant effect, and return at first keyword match
	MagicEffect thisEffect = effects[getEffect]
	
	effectTypesRestore = CheckFormEffects(RestoreEffects, thisEffect, EffectKeywords, true)
	if (effectTypesRestore > 0)
		RegisterPotion()
		return
	endIf

	effectTypesFortifyStats = CheckFormEffects(FortifyEffectsStats, thisEffect, EffectKeywords, true)
	if (effectTypesFortifyStats > 0)
		RegisterPotion()
		return
	endIf
	effectTypesFortifyWarrior = CheckFormEffects(FortifyEffectsWarrior, thisEffect, EffectKeywords, true)
	if (effectTypesFortifyWarrior > 0)
		RegisterPotion()
		return
	endIf
	effectTypesFortifyMage = CheckFormEffects(FortifyEffectsMage, thisEffect, EffectKeywords, true)
	if (effectTypesFortifyMage > 0)
		RegisterPotion()
		return
	endIf

	effectTypesResist = CheckFormEffects(ResistEffects, thisEffect, EffectKeywords, true)
	if (effectTypesResist > 0)
		RegisterPotion()
		return
	endIf
	
endFunction

int Function CheckFormEffects(int[] akEffectsArray, Form akFormToCheck, Keyword[] akEffectKeywords, bool abReturnOnFirst)
	int itemEffects = 0
	int i = akEffectsArray.Length
	while (i)
		i -= 1
		if (akFormToCheck.HasKeyword(akEffectKeywords[akEffectsArray[i]]))
			effectsFound += 1
			itemEffects = Math.LogicalOr(itemEffects, Math.Pow(2, i) as int)
			if (abReturnOnFirst)
				return itemEffects
			endIf
		endIf
	endWhile
	return itemEffects
endFunction

Function RegisterPotion()
	; attempting to assign directly to arrays led (inevitably) to race conditions
	; raise event and throw the potion back to the main script for assignment
	int handle = ModEvent.Create("_FPP_Callback_RegisterPotion")
    if (handle)
		ModEvent.PushForm(handle, self)
		ModEvent.PushString(handle, ActorName)
		ModEvent.PushForm(handle, ThisPotion)
		ModEvent.PushInt(handle, PotionCount)
		ModEvent.PushInt(handle, effectsFound)
		ModEvent.PushBool(handle, isPoisonItem)
		ModEvent.PushInt(handle, effectTypesRestore)
		ModEvent.PushInt(handle, effectTypesFortifyStats)
		ModEvent.PushInt(handle, effectTypesFortifyWarrior)
		ModEvent.PushInt(handle, effectTypesFortifyMage)
		ModEvent.PushInt(handle, effectTypesResist)
		ModEvent.PushInt(handle, effectTypesSpecial)
		ModEvent.PushInt(handle, effectTypesDamageStats)
		ModEvent.PushInt(handle, effectTypesWeakness)
		ModEvent.PushInt(handle, effectTypesGenericHarmful)
		ModEvent.Send(handle)
	endIf
endFunction



function ClearThreadVars()
	;Reset all thread variables to default state
	ActorName = None
	ThisPotion = None
	PotionCount = 0
	IdentifyPotionEffects = 0
	DebugToFile = false
	effectsFound = 0
	isPoisonItem = false
	effectTypesRestore = 0
	effectTypesFortifyStats = 0
	effectTypesFortifyWarrior = 0
	effectTypesFortifyMage = 0
	effectTypesResist = 0
	effectTypesSpecial = 0
	effectTypesDamageStats = 0
	effectTypesWeakness = 0
	effectTypesGenericHarmful = 0
endFunction

; Create the callback, including the specific actor name so other actors can ignore it
function RaiseEvent_IdentifyPotionCallback()
	;Debug.TraceUser("FollowerPotions", ActorName + ": IdentifyPotionThread - sending _FPP_Callback_PotionIdentified")
	int handle = ModEvent.Create("_FPP_Callback_PotionIdentified")
    if (handle)
		ModEvent.PushForm(handle, self)
		ModEvent.PushString(handle, ActorName)
		ModEvent.Send(handle)
	endIf
endFunction
