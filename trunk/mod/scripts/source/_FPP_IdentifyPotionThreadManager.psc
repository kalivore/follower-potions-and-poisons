scriptname _FPP_IdentifyPotionThreadManager extends Quest
 
Quest property IdentifyPotionQuest auto
{The name of the thread management quest.}
 
_FPP_IdentifyPotionThread01 thread01
_FPP_IdentifyPotionThread02 thread02
_FPP_IdentifyPotionThread03 thread03
_FPP_IdentifyPotionThread04 thread04
_FPP_IdentifyPotionThread05 thread05
_FPP_IdentifyPotionThread06 thread06
_FPP_IdentifyPotionThread07 thread07
_FPP_IdentifyPotionThread08 thread08
_FPP_IdentifyPotionThread09 thread09
_FPP_IdentifyPotionThread10 thread10
_FPP_IdentifyPotionThread11 thread11
_FPP_IdentifyPotionThread12 thread12
_FPP_IdentifyPotionThread13 thread13
_FPP_IdentifyPotionThread14 thread14
_FPP_IdentifyPotionThread15 thread15
_FPP_IdentifyPotionThread16 thread16
_FPP_IdentifyPotionThread17 thread17
_FPP_IdentifyPotionThread18 thread18
_FPP_IdentifyPotionThread19 thread19
_FPP_IdentifyPotionThread20 thread20

bool blocked = false
 
Event OnInit()
    ;Let's cast our threads to local variables so things are less cluttered in our code
    thread01 = IdentifyPotionQuest as _FPP_IdentifyPotionThread01
    thread02 = IdentifyPotionQuest as _FPP_IdentifyPotionThread02
    thread03 = IdentifyPotionQuest as _FPP_IdentifyPotionThread03
    thread04 = IdentifyPotionQuest as _FPP_IdentifyPotionThread04
    thread05 = IdentifyPotionQuest as _FPP_IdentifyPotionThread05
    thread06 = IdentifyPotionQuest as _FPP_IdentifyPotionThread06
    thread07 = IdentifyPotionQuest as _FPP_IdentifyPotionThread07
    thread08 = IdentifyPotionQuest as _FPP_IdentifyPotionThread08
    thread09 = IdentifyPotionQuest as _FPP_IdentifyPotionThread09
    thread10 = IdentifyPotionQuest as _FPP_IdentifyPotionThread10
    thread11 = IdentifyPotionQuest as _FPP_IdentifyPotionThread11
    thread12 = IdentifyPotionQuest as _FPP_IdentifyPotionThread12
    thread13 = IdentifyPotionQuest as _FPP_IdentifyPotionThread13
    thread14 = IdentifyPotionQuest as _FPP_IdentifyPotionThread14
    thread15 = IdentifyPotionQuest as _FPP_IdentifyPotionThread15
    thread16 = IdentifyPotionQuest as _FPP_IdentifyPotionThread16
    thread17 = IdentifyPotionQuest as _FPP_IdentifyPotionThread17
    thread18 = IdentifyPotionQuest as _FPP_IdentifyPotionThread18
    thread19 = IdentifyPotionQuest as _FPP_IdentifyPotionThread19
    thread20 = IdentifyPotionQuest as _FPP_IdentifyPotionThread20
EndEvent
 
;The 'public-facing' function that our scripts will interact with.
function IdentifyPotionAsync(bool waitForAny, bool abDebug, string asActorName, Potion akPotion, Keyword[] akEffectKeywords, int[] akRestoreEffects, int[] akFortifyEffectsStats, int[] akFortifyEffectsWarrior, int[] akFortifyEffectsMage, int[] akResistEffects, \
							int aiIdentifyPotionEffects, int aiC_IDENTIFY_RESTORE, int aiC_IDENTIFY_FORTIFY, int aiC_IDENTIFY_RESIST, int aiC_IDENTIFY_FIRST, int aiC_IDENTIFY_SECOND, int aiC_IDENTIFY_THIRD)
    if (!thread01.Queued())
        thread01.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread02.Queued())
        thread02.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread03.Queued())
        thread03.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread04.Queued())
        thread04.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread05.Queued())
        thread05.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread06.Queued())
        thread06.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread07.Queued())
        thread07.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread08.Queued())
        thread08.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread09.Queued())
        thread09.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread10.Queued())
        thread10.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread11.Queued())
        thread11.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread12.Queued())
        thread12.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread13.Queued())
        thread13.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread14.Queued())
        thread14.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread15.Queued())
        thread15.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread16.Queued())
        thread16.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread17.Queued())
        thread17.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread18.Queued())
        thread18.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread19.Queued())
        thread19.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    elseif (!thread20.Queued())
        thread20.GetAsync(abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
    else
		; All threads are queued; start all threads, wait, and try again.
		blocked = true
        if (waitForAny)
			;Debug.TraceUser("FollowerPotions", "IdentifyPotionThreadManager - All threads queued when calling IdentifyPotionAsync for " + asActorName + " - raising event and waiting for any", 1)
			WaitAny()
		else
			;Debug.TraceUser("FollowerPotions", "IdentifyPotionThreadManager - All threads queued when calling IdentifyPotionAsync for " + asActorName + " - raising event and waiting for all", 1)
			WaitAll()
		endIf
        IdentifyPotionAsync(waitForAny, abDebug, asActorName, akPotion, akEffectKeywords, akRestoreEffects, akFortifyEffectsStats, akFortifyEffectsWarrior, akFortifyEffectsMage, akResistEffects, aiIdentifyPotionEffects, aiC_IDENTIFY_RESTORE, aiC_IDENTIFY_FORTIFY, aiC_IDENTIFY_RESIST, aiC_IDENTIFY_FIRST, aiC_IDENTIFY_SECOND, aiC_IDENTIFY_THIRD)
	endif
endFunction
 
function WaitAll()
	;Debug.TraceUser("FollowerPotions", "IdentifyPotionThreadManager - WaitAll")
    RaiseEvent_TriggerIdentifyPotion()
    BeginWaiting(false)
endFunction

function WaitAny()
	;Debug.TraceUser("FollowerPotions", "IdentifyPotionThreadManager - WaitAny")
    RaiseEvent_TriggerIdentifyPotion()
    BeginWaiting(true)
endFunction

function BeginWaiting(bool forAny)
    bool waiting = true
    int i = 0
    while waiting
        if ((forAny && AllQueued()) || (!forAny && AnyQueued()))
            i += 1
			Utility.WaitMenuMode(0.1)
            if i >= 100
                Debug.Trace("[FollowerPotions] FATAL: A catastrophic error has occurred. All threads have become unresponsive. Please debug this issue or notify the author.")
                ;Debug.TraceUser("FollowerPotions", "IdentifyPotionThreadManager - A catastrophic error has occurred. All threads have become unresponsive. Please debug this issue or notify the author.", 2)
                i = 0
                ; Fail by returning None. The mod needs to be fixed.
                return
            endif
        else
			if (blocked)
				blocked = false
                ;Debug.TraceUser("FollowerPotions", "IdentifyPotionThreadManager - Iteration " + i + ", one or more previously-queued thread(s) are available again.")
			endIf
            waiting = false
        endif
    endWhile
endFunction

bool function AllQueued()
	return thread01.Queued() && thread02.Queued() && thread03.Queued() && thread04.Queued() && thread05.Queued() && \
           thread06.Queued() && thread07.Queued() && thread08.Queued() && thread09.Queued() && thread10.Queued() && \
           thread11.Queued() && thread12.Queued() && thread13.Queued() && thread14.Queued() && thread15.Queued() && \
           thread16.Queued() && thread17.Queued() && thread18.Queued() && thread19.Queued() && thread20.Queued()
endFunction

bool function AnyQueued()
	return thread01.Queued() || thread02.Queued() || thread03.Queued() || thread04.Queued() || thread05.Queued() || \
           thread06.Queued() || thread07.Queued() || thread08.Queued() || thread09.Queued() || thread10.Queued() || \
           thread11.Queued() || thread12.Queued() || thread13.Queued() || thread14.Queued() || thread15.Queued() || \
           thread16.Queued() || thread17.Queued() || thread18.Queued() || thread19.Queued() || thread20.Queued()
endFunction

; Create the ModEvent that will start all queued threads
function RaiseEvent_TriggerIdentifyPotion()
	int handle = ModEvent.Create("_FPP_Trigger_IdentifyPotion")
    if (handle)
		ModEvent.Send(handle)
	endIf
endFunction
