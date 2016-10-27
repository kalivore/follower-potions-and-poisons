Scriptname _FPP_IdentifyPotionThread extends Quest

; Thread variables
bool threadQueued = false
bool threadBusy = false
 
; Variables you need to get things done go here 
string ActorName
Potion ThisPotion
Keyword[] EffectKeywords
int[] RestoreEffects
int[] FortifyEffectsStats
int[] FortifyEffectsWarrior
int[] FortifyEffectsMage
int[] ResistEffects
int IdentifyPotionEffects
int C_IDENTIFY_RESTORE
int C_IDENTIFY_FORTIFY
int C_IDENTIFY_RESIST
int C_IDENTIFY_FIRST
int C_IDENTIFY_SECOND
int C_IDENTIFY_THIRD

; Thread queuing and set-up
function GetAsync(string asActorName, Potion akPotion, Keyword[] akEffectKeywords, int[] akRestoreEffects, int[] akFortifyEffectsStats, int[] akFortifyEffectsWarrior, int[] akFortifyEffectsMage, int[] akResistEffects, \
					int aiIdentifyPotionEffects, int aiC_IDENTIFY_RESTORE, int aiC_IDENTIFY_FORTIFY, int aiC_IDENTIFY_RESIST, int aiC_IDENTIFY_FIRST, int aiC_IDENTIFY_SECOND, int aiC_IDENTIFY_THIRD)
 
    ; Let the Thread Manager know that this thread is busy
    threadQueued = true
 
    ; Store our passed-in parameters to member variables
	ActorName = asActorName
	ThisPotion = akPotion
	EffectKeywords = akEffectKeywords
	RestoreEffects = akRestoreEffects
	FortifyEffectsStats = akFortifyEffectsStats
	FortifyEffectsWarrior = akFortifyEffectsWarrior
	FortifyEffectsMage = akFortifyEffectsMage
	ResistEffects = akResistEffects
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
 
;F or Thread Manager troubleshooting.
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

	; OK, we're done - raise event to return results
	RaiseEvent_IdentifyPotionCallback()

	; Set all variables back to default
	ClearThreadVars()

	; Make the thread available to the Thread Manager again
	threadBusy = false
	threadQueued = false
endEvent
 
; Called from Event OnIdentifyPotion
Function IdentifyPotion()
	if (ThisPotion == None || ThisPotion.IsFood() || ThisPotion.IsHostile())
		return
	endIf
	
	bool playerMade = Math.RightShift(ThisPotion.GetFormId(), 24) >= 255
	int i = 0
	if (!playerMade || IdentifyPotionEffects < C_IDENTIFY_FIRST)
	
		Debug.TraceUser("FollowerPotions", ActorName + ": IdentifyPotion " + ThisPotion.GetFormId() + " - find by relevant effects (player-made: " + playerMade + ", method " + IdentifyPotionEffects + ")")
		
		if (Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_RESTORE) != 0)
			i = RestoreEffects.Length
			while (i)
				i -= 1
				if (ThisPotion.HasKeyword(EffectKeywords[RestoreEffects[i]]))
					RegisterPotion("MyRestorePotions", RestoreEffects[i])
				endIf
			endWhile
		endIf
			
		if (Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_FORTIFY) != 0)
			i = FortifyEffectsStats.Length
			while (i)
				i -= 1
				if (ThisPotion.HasKeyword(EffectKeywords[FortifyEffectsStats[i]]))
					RegisterPotion("MyFortifyPotions", FortifyEffectsStats[i])
				endIf
			endWhile
			i = FortifyEffectsWarrior.Length
			while (i)
				i -= 1
				if (ThisPotion.HasKeyword(EffectKeywords[FortifyEffectsWarrior[i]]))
					RegisterPotion("MyFortifyPotions", FortifyEffectsWarrior[i])
				endIf
			endWhile
			
			i = FortifyEffectsMage.Length
			while (i)
				i -= 1
				if (ThisPotion.HasKeyword(EffectKeywords[FortifyEffectsMage[i]]))
					RegisterPotion("MyFortifyPotions", FortifyEffectsMage[i])
				endIf
			endWhile
		endIf
			
		if (Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_RESIST) != 0)
			i = ResistEffects.Length
			while (i)
				i -= 1
				if (ThisPotion.HasKeyword(EffectKeywords[ResistEffects[i]]))
					RegisterPotion("MyResistPotions", ResistEffects[i])
				endIf
			endWhile
		endIf
	elseIf (playerMade)
		; OK, let's find these effects
		MagicEffect[] effects = ThisPotion.GetMagicEffects()
		int getEffect = 0
		if (effects.Length < 3 && Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_THIRD) != 0 \
			|| effects.Length < 2 && Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_SECOND) != 0)
			getEffect = effects.Length
		elseIf (Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_THIRD) != 0)
			getEffect = 3
		elseIf (Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_SECOND) != 0)
			getEffect = 2
		elseIf (Math.LogicalAnd(IdentifyPotionEffects, C_IDENTIFY_FIRST) != 0)
			getEffect = 1
		endIf
		
		; adjust for 0-based indexing
		Debug.TraceUser("FollowerPotions", ActorName + ": IdentifyPotion " + ThisPotion.GetFormId() + " - find by single effect (method " + IdentifyPotionEffects + ", effect " + getEffect + " of " + effects.Length + ")")
		getEffect -= 1
		
		if (getEffect < 0)
			; gee, something went wrong there..
			return
		endIf
		
		; get relevant effect, and return at first keyword match
		MagicEffect thisEffect = effects[getEffect]
		
		i = RestoreEffects.Length
		while (i)
			i -= 1
			if (thisEffect.HasKeyword(EffectKeywords[RestoreEffects[i]]))
				RegisterPotion("MyRestorePotions", RestoreEffects[i])
				return
			endIf
		endWhile
	
		i = FortifyEffectsStats.Length
		while (i)
			i -= 1
			if (ThisPotion.HasKeyword(EffectKeywords[FortifyEffectsStats[i]]))
				RegisterPotion("MyFortifyPotions", FortifyEffectsStats[i])
				return
			endIf
		endWhile
		
		i = FortifyEffectsWarrior.Length
		while (i)
			i -= 1
			if (ThisPotion.HasKeyword(EffectKeywords[FortifyEffectsWarrior[i]]))
				RegisterPotion("MyFortifyPotions", FortifyEffectsWarrior[i])
				return
			endIf
		endWhile
		
		i = FortifyEffectsMage.Length
		while (i)
			i -= 1
			if (ThisPotion.HasKeyword(EffectKeywords[FortifyEffectsMage[i]]))
				RegisterPotion("MyFortifyPotions", FortifyEffectsMage[i])
				return
			endIf
		endWhile
	
		i = ResistEffects.Length
		while (i)
			i -= 1
			if (ThisPotion.HasKeyword(EffectKeywords[ResistEffects[i]]))
				RegisterPotion("MyResistPotions", ResistEffects[i])
				return
			endIf
		endWhile
	endIf
	
endFunction

Function RegisterPotion(string asListName, int aiEffectType)
	; attempting to assign directly to arrays led (inevitably) to race conditions
	; raise event and throw the potion back to the main script for assignment
	int handle = ModEvent.Create("_FPP_Callback_RegisterPotion")
    if (handle)
		ModEvent.PushForm(handle, self)
		ModEvent.PushString(handle, ActorName)
		ModEvent.PushForm(handle, ThisPotion)
		ModEvent.PushString(handle, asListName)
		ModEvent.PushInt(handle, aiEffectType)
		ModEvent.Send(handle)
	endIf
endFunction



function ClearThreadVars()
	;Reset all thread variables to default state
	ActorName = None
	ThisPotion = None
	EffectKeywords = new Keyword[1]
	RestoreEffects = new int[1]
	FortifyEffectsStats = new int[1]
	FortifyEffectsWarrior = new int[1]
	FortifyEffectsMage = new int[1]
	ResistEffects = new int[1]
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
