Scriptname _FPP_IdentifyPotionThread extends Quest

;Thread variables
bool threadQueued = false
bool threadBusy = false
 
;Variables you need to get things done go here 
string ActorName
Potion ThisPotion
Keyword[] EffectKeywords
int[] RestoreEffects
int[] FortifyEffectsStats
int[] FortifyEffectsWarrior
int[] FortifyEffectsMage
int[] ResistEffects

;Thread queuing and set-up
function GetAsync(string asActorName, Potion akPotion, Keyword[] akEffectKeywords, int[] akRestoreEffects, int[] akFortifyEffectsStats, int[] akFortifyEffectsWarrior, int[] akFortifyEffectsMage, int[] akResistEffects)
 
    ;Let the Thread Manager know that this thread is busy
    threadQueued = true
 
    ;Store our passed-in parameters to member variables
	ActorName = asActorName
	ThisPotion = akPotion
	EffectKeywords = akEffectKeywords
	RestoreEffects = akRestoreEffects
	FortifyEffectsStats = akFortifyEffectsStats
	FortifyEffectsWarrior = akFortifyEffectsWarrior
	FortifyEffectsMage = akFortifyEffectsMage
	ResistEffects = akResistEffects

endFunction
 
;Allows the Thread Manager to determine if this thread is available
bool function Queued()
	return threadQueued
endFunction
 
;For Thread Manager troubleshooting.
bool function ForceUnlock()
    ClearThreadVars()
    threadBusy = false
    threadQueued = false
    return true
endFunction
 
;The actual set of code we want to multithread.
Event OnIdentifyPotion()
	;Debug.TraceUser("FollowerPotions", ActorName + ": IdentifyPotionThread - OnIdentifyPotion: queued: " + threadQueued + ", busy: " + threadBusy)
	if (!threadQueued)
		return
	endif
	if (threadBusy)
		return
	endif
	
	threadBusy = true
	
	;OK, let's get some work done!
	IdentifyPotion()

	;OK, we're done - raise event to return results
	RaiseEvent_IdentifyPotionCallback()

	;Set all variables back to default
	ClearThreadVars()

	;Make the thread available to the Thread Manager again
	threadBusy = false
	threadQueued = false
endEvent
 
;Called from Event OnIdentifyPotion
Function IdentifyPotion()
	if (ThisPotion == None)
		return
	endIf
	int i = RestoreEffects.Length
	while (i)
		i -= 1
		if (ThisPotion.HasKeyword(EffectKeywords[RestoreEffects[i]]))
			RegisterPotion("MyRestorePotions", RestoreEffects[i])
		endIf
	endWhile
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
	i = ResistEffects.Length
	while (i)
		i -= 1
		if (ThisPotion.HasKeyword(EffectKeywords[ResistEffects[i]]))
			RegisterPotion("MyResistPotions", ResistEffects[i])
		endIf
	endWhile
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
