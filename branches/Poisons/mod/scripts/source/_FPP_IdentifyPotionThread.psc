Scriptname _FPP_IdentifyPotionThread extends Quest

; Thread variables
bool threadQueued = false
bool threadBusy = false
int effectsFound = 0
bool isPoisonItem = false

; Variables you need to get things done go here
bool WriteDebug
string ActorName
Potion ThisPotion
int PotionCount
Keyword[] EffectKeywords
int[] RestoreEffects
int[] FortifyEffectsStats
int[] FortifyEffectsWarrior
int[] FortifyEffectsMage
int[] ResistEffects
int[] PoisonEffectsStats
int[] PoisonEffectsWeakness
int[] PoisonEffectsGeneric
int IdentifyPotionEffects
int C_IDENTIFY_RESTORE
int C_IDENTIFY_FORTIFY
int C_IDENTIFY_RESIST
int C_IDENTIFY_FIRST
int C_IDENTIFY_SECOND
int C_IDENTIFY_THIRD

; Thread queuing and set-up
function GetAsync(bool abDebug, string asActorName, Potion akPotion, int aiPotionCount, Keyword[] akEffectKeywords, \
					int[] akRestoreEffects, int[] akFortifyEffectsStats, int[] akFortifyEffectsWarrior, int[] akFortifyEffectsMage, int[] akResistEffects, \
					int[] akPoisonEffectsStats, int[] akPoisonEffectsWeakness, int[] akPoisonEffectsGeneric, \
					int aiIdentifyPotionEffects, int aiC_IDENTIFY_RESTORE, int aiC_IDENTIFY_FORTIFY, int aiC_IDENTIFY_RESIST, int aiC_IDENTIFY_FIRST, int aiC_IDENTIFY_SECOND, int aiC_IDENTIFY_THIRD)
 
    ; Let the Thread Manager know that this thread is busy
    threadQueued = true
 
	effectsFound = 0
	isPoisonItem = false

    ; Store our passed-in parameters to member variables
	WriteDebug = abDebug
	ActorName = asActorName
	ThisPotion = akPotion
	PotionCount = aiPotionCount
	EffectKeywords = akEffectKeywords
	RestoreEffects = akRestoreEffects
	FortifyEffectsStats = akFortifyEffectsStats
	FortifyEffectsWarrior = akFortifyEffectsWarrior
	FortifyEffectsMage = akFortifyEffectsMage
	ResistEffects = akResistEffects
	PoisonEffectsStats = akPoisonEffectsStats
	PoisonEffectsWeakness = akPoisonEffectsWeakness
	PoisonEffectsGeneric = akPoisonEffectsGeneric
	IdentifyPotionEffects = aiIdentifyPotionEffects
	C_IDENTIFY_RESTORE = aiC_IDENTIFY_RESTORE
	C_IDENTIFY_FORTIFY = aiC_IDENTIFY_FORTIFY
	C_IDENTIFY_RESIST = aiC_IDENTIFY_RESIST
	C_IDENTIFY_FIRST = aiC_IDENTIFY_FIRST
	C_IDENTIFY_SECOND = aiC_IDENTIFY_SECOND
	C_IDENTIFY_THIRD = aiC_IDENTIFY_THIRD

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
	
	bool playerMade = Math.RightShift(ThisPotion.GetFormId(), 24) >= 255
	bool identByEffectType = IdentifyPotionEffects < C_IDENTIFY_FIRST
	MagicEffect[] effects = ThisPotion.GetMagicEffects()
	int numEffects = effects.Length
	
	if (isPoisonItem)
		if (WriteDebug)
			Debug.TraceUser("FollowerPotions", ActorName + ": IdentifyPotion " + ThisPotion.GetFormId() + " (poison) - find " + numEffects + " effect(s) by relevant effect types (player-made: " + playerMade + ", method " + IdentifyPotionEffects + ")")
		endIf
		CheckFormEffects(PoisonEffectsStats, ThisPotion, false)
		CheckFormEffects(PoisonEffectsWeakness, ThisPotion, false)
		if (effectsFound == 0)
			Debug.TraceUser("FollowerPotions", ActorName + ": IdentifyPotion " + ThisPotion.GetFormId() + " (poison) - no specific effects found, add as generic")
			effectsFound += 1
			RegisterPotion(PoisonEffectsGeneric[0])
		endIf
		; nothing more to do - return here
		return
	endIf
	
	if (!playerMade || identByEffectType)
		if (WriteDebug)
			Debug.TraceUser("FollowerPotions", ActorName + ": IdentifyPotion " + ThisPotion.GetFormId() + " - find " + numEffects + " effect(s) by relevant effect types (player-made: " + playerMade + ", method " + IdentifyPotionEffects + ")")
		endIf
		
		if (numEffects == 1 || !identByEffectType || Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_RESTORE) != 0)
			CheckFormEffects(RestoreEffects, ThisPotion, false)
		endIf
			
		if (numEffects == 1 || !identByEffectType || Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_FORTIFY) != 0)
			CheckFormEffects(FortifyEffectsStats, ThisPotion, false)
			CheckFormEffects(FortifyEffectsWarrior, ThisPotion, false)
			CheckFormEffects(FortifyEffectsMage, ThisPotion, false)
		endIf
			
		if (numEffects == 1 || !identByEffectType || Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_RESIST) != 0)
			CheckFormEffects(ResistEffects, ThisPotion, false)
		endIf
		
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
	
	if (WriteDebug)
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
	
	if (CheckFormEffects(RestoreEffects, thisEffect, true))
		return
	endIf

	if (CheckFormEffects(FortifyEffectsStats, thisEffect, true))
		return
	endIf
	if (CheckFormEffects(FortifyEffectsWarrior, thisEffect, true))
		return
	endIf
	if (CheckFormEffects(FortifyEffectsMage, thisEffect, true))
		return
	endIf

	if (CheckFormEffects(ResistEffects, thisEffect, true))
		return
	endIf
	
endFunction

bool Function CheckFormEffects(int[] akEffectsArray, Form akFormToCheck, bool abReturnOnFirst)
	int i = akEffectsArray.Length
	while (i)
		i -= 1
		if (akFormToCheck.HasKeyword(EffectKeywords[akEffectsArray[i]]))
			effectsFound += 1
			RegisterPotion(akEffectsArray[i])
			if (abReturnOnFirst)
				return true
			endIf
		endIf
	endWhile
	return false
endFunction

Function RegisterPotion(int aiEffectType)
	; attempting to assign directly to arrays led (inevitably) to race conditions
	; raise event and throw the potion back to the main script for assignment
	int handle = ModEvent.Create("_FPP_Callback_RegisterPotion")
    if (handle)
		ModEvent.PushForm(handle, self)
		ModEvent.PushString(handle, ActorName)
		ModEvent.PushForm(handle, ThisPotion)
		ModEvent.PushInt(handle, PotionCount)
		ModEvent.PushInt(handle, aiEffectType)
		ModEvent.Send(handle)
	endIf
endFunction



function ClearThreadVars()
	;Reset all thread variables to default state
	effectsFound = 0
	isPoisonItem = false
	WriteDebug = false
	ActorName = None
	ThisPotion = None
	PotionCount = 0
	EffectKeywords = new Keyword[1]
	RestoreEffects = new int[1]
	FortifyEffectsStats = new int[1]
	FortifyEffectsWarrior = new int[1]
	FortifyEffectsMage = new int[1]
	ResistEffects = new int[1]
	PoisonEffectsStats = new int[1]
	PoisonEffectsWeakness = new int[1]
	PoisonEffectsGeneric = new int[1]
	IdentifyPotionEffects = 0
	C_IDENTIFY_RESTORE = 0
	C_IDENTIFY_FORTIFY = 0
	C_IDENTIFY_RESIST = 0
	C_IDENTIFY_FIRST = 0
	C_IDENTIFY_SECOND = 0
	C_IDENTIFY_THIRD = 0
endFunction

; Create the callback, including the specific actor name so other actors can ignore it
function RaiseEvent_IdentifyPotionCallback()
	;Debug.TraceUser("FollowerPotions", ActorName + ": IdentifyPotionThread - sending _FPP_Callback_PotionIdentified")
	int handle = ModEvent.Create("_FPP_Callback_PotionIdentified")
    if (handle)
		ModEvent.PushForm(handle, self)
		ModEvent.PushString(handle, ActorName)
		ModEvent.PushInt(handle, effectsFound)
		ModEvent.PushBool(handle, isPoisonItem)
		ModEvent.PushInt(handle, PotionCount)
		ModEvent.Send(handle)
	endIf
endFunction
