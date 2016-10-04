Scriptname _FPP_FollowerScript extends ReferenceAlias  
{handles all events and functions on a follower}

; fundamental internal state properties
string MyName
int MyIndex
_FPP_Quest FPPQuest
_FPP_IdentifyPotionThreadManager IdentifyPotionThreadManager

Actor MyActor
string MyActorName

; public properties and/or thread-safe accessors - set/used by MCM
string Property ActorName
	string Function Get()
		return MyActorName
	endFunction
endProperty

float Property UpdateIntervalInCombat Auto
float Property UpdateIntervalNonCombat Auto
float Property UpdateIntervalNoPotions Auto

float[] Property StatLimitsInCombat Auto
float[] Property StatLimitsNonCombat Auto

int Property LvlDiffTrigger Auto

bool[] Property UsePotionOfType Auto

bool Property DebugToFile Auto

int Property PotionCountRefreshed
	int Function Get()
		return RefreshedPotionCount
	endFunction
endProperty

int Property PotionCountTotal
	int Function Get()
		return TotalPotionCount
	endFunction
endProperty


; private vars set from main Quest during SetProperties()
; (to avoid threading issues if we made an external cal to the Quest)
string C_SCHOOL_ALTERATION
string C_SCHOOL_CONJURATION
string C_SCHOOL_DESTRUCTION
string C_SCHOOL_ILLUSION
string C_SCHOOL_RESTORATION

int C_ITEM_HAND
int C_ITEM_1H_SWORD
int C_ITEM_1H_DAGGER
int C_ITEM_1H_AXE
int C_ITEM_1H_MACE
int C_ITEM_2H_SWORD
int C_ITEM_2H_AXE_MACE
int C_ITEM_BOW
int C_ITEM_STAFF
int C_ITEM_SPELL
int C_ITEM_SHIELD
int C_ITEM_TORCH
int C_ITEM_CROSSBOW

int EFFECT_RESTOREHEALTH
int EFFECT_RESTOREMAGICKA
int EFFECT_RESTORESTAMINA
int EFFECT_BENEFICIAL
int EFFECT_DAMAGEHEALTH
int EFFECT_DAMAGEMAGICKA
int EFFECT_DAMAGESTAMINA
int EFFECT_DURATIONBASED
int EFFECT_FORTIFYALCHEMY
int EFFECT_FORTIFYALTERATION
int EFFECT_FORTIFYBLOCK
int EFFECT_FORTIFYCARRYWEIGHT
int EFFECT_FORTIFYCONJURATION
int EFFECT_FORTIFYDESTRUCTION
int EFFECT_FORTIFYENCHANTING
int EFFECT_FORTIFYHEALRATE
int EFFECT_FORTIFYHEALTH
int EFFECT_FORTIFYHEAVYARMOR
int EFFECT_FORTIFYILLUSION
int EFFECT_FORTIFYLIGHTARMOR
int EFFECT_FORTIFYLOCKPICKING
int EFFECT_FORTIFYMAGICKA
int EFFECT_FORTIFYMAGICKARATE
int EFFECT_FORTIFYMARKSMAN
int EFFECT_FORTIFYMASS
int EFFECT_FORTIFYONEHANDED
int EFFECT_FORTIFYPICKPOCKET
int EFFECT_FORTIFYRESTORATION
int EFFECT_FORTIFYSMITHING
int EFFECT_FORTIFYSNEAK
int EFFECT_FORTIFYSPEECHCRAFT
int EFFECT_FORTIFYSTAMINA
int EFFECT_FORTIFYSTAMINARATE
int EFFECT_FORTIFYTWOHANDED
int EFFECT_HARMFUL
int EFFECT_RESISTFIRE
int EFFECT_RESISTFROST
int EFFECT_RESISTMAGIC
int EFFECT_RESISTPOISON
int EFFECT_RESISTSHOCK
int EFFECT_WEAKNESSFIRE
int EFFECT_WEAKNESSFROST
int EFFECT_WEAKNESSMAGIC
int EFFECT_WEAKNESSSHOCK

Keyword[] EffectKeywords
string[] EffectNames

int[] RestoreEffects
int[] FortifyEffectsStats
int[] FortifyEffectsWarrior
int[] FortifyEffectsMage
int[] ResistEffects

Keyword KeywordPotion

Keyword KeywordArmorHeavy
Keyword KeywordArmorLight

Keyword MagicDamageFire
Keyword MagicDamageFrost
Keyword MagicDamageShock

LocationRefType LocRefTypeBoss


; other private vars for state
Potion[] MyRestorePotions
Potion[] MyFortifyPotions
Potion[] MyResistPotions

float CurrentUpdateInterval
float[] CurrentStatLimits
int[] MyPotionWarningCounts
int[] MyPotionWarningTriggers
bool[] HasPotionOfType

bool IgnoreEvents = false
bool IgnoreCombatStateEvents = false

int RefreshedPotionCount = 0
int TotalPotionCount = 0
bool DoingInit = false



Event OnInit()
	MyName = self.GetName()
	FPPQuest = GetOwningQuest() as _FPP_Quest
	IdentifyPotionThreadManager = GetOwningQuest() as _FPP_IdentifyPotionThreadManager
	MyIndex = FPPQuest.AllFollowers.Find(self)
	Init()
endEvent

Function Init()
	MyActor = self.GetReference() as Actor
	if (MyActor == None)
		FPPQuest.DebugStuff("Init " + MyName + " - ref empty, exiting")
		return
	endIf

	DoingInit = true

	MyActorName = MyActor.GetLeveledActorBase().GetName()

	SetProperties()

	SetDefaults()

	RegisterForModEvent("_FPP_Callback_RegisterPotion", "OnPotionRegister")
	RegisterForModEvent("_FPP_Callback_PotionIdentified", "OnPotionIdentified")
	RefreshPotions()

endFunction

Function FinishInit()
	Maintenance()
	AliasDebug("Assigned to " + MyName, "recognised " + MyActorName, true)
endFunction

Function Maintenance()
	IgnoreEvents = false
	IgnoreCombatStateEvents = false
	if (!RegisterForAnimationEvent(MyActor, "weaponSwing") || !RegisterForAnimationEvent(MyActor, "weaponLeftSwing"))
		AliasDebug("Failed to register for animation events")
	endIf
	if (!DoingInit)
		RegisterForModEvent("_FPP_Callback_RegisterPotion", "OnPotionRegister")
		RegisterForModEvent("_FPP_Callback_PotionIdentified", "OnPotionIdentified")
	endIf
	DoingInit = false
	SetProperties()

	MyPotionWarningCounts = Utility.CreateIntArray(EffectKeywords.Length, 0)
	GoToDeterminedState("Maintenance Complete")
endFunction

Function DeInit()
	GoToState("Inert")
	UnregisterForUpdate()
	UnregisterForAnimationEvent(MyActor, "weaponSwing")
	UnregisterForAnimationEvent(MyActor, "weaponLeftSwing")
	UnregisterForModEvent("_FPP_Callback_RegisterPotion")
	UnregisterForModEvent("_FPP_Callback_PotionIdentified")
	AliasDebug("DeInit - Complete", "removed " + MyActorName, true)
	MyActor = None
	MyActorName = None
endFunction



Function GoToDeterminedState(string asMsg)
	string newState = DetermineState()
	AliasDebug(asMsg + ", going to " + newState)
	GoToState(newState)
endFunction

string Function DetermineState()
	bool inCombat = MyActor.IsInCombat()
	bool bleedingOut = MyActor.IsBleedingOut()
	bool incapacitated = IsIncapacitated()
	if (inCombat || bleedingOut)
		CurrentStatLimits = StatLimitsInCombat
		CurrentUpdateInterval = UpdateIntervalInCombat
		if (incapacitated)
			return "Incapacitated"
		elseIf (bleedingOut)
			return "PendingUpdate"
		elseIf (HasAnyPotions())
			return "PendingEvent"
		else
			return "HaveNoPotions"
		endIf
	else
		CurrentStatLimits = StatLimitsNonCombat
		CurrentUpdateInterval = UpdateIntervalNonCombat
		if (incapacitated)
			return "Incapacitated"
		elseIf (HasAnyPotions())
			return "PendingEvent"
		else
			return "HaveNoPotions"
		endIf
	endIf
endFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Events and States
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if (akBaseItem == None)
		return
	endIf
	Potion thisPotion = akBaseItem as Potion
	if (thisPotion == None || thisPotion.IsFood() || thisPotion.IsHostile())
		return
	endIf
	IdentifyPotionThreadManager.IdentifyPotionAsync(true, MyActorName, thisPotion, EffectKeywords, RestoreEffects, FortifyEffectsStats, FortifyEffectsWarrior, FortifyEffectsMage, ResistEffects)
	IdentifyPotionThreadManager.WaitAny()
	;AliasDebug("OnItemAdded - " + thisPotion.GetName() + " sent for identification")
endEvent

Event OnPotionRegister(Form akSender, string asActorName, Form akPotion, string asListName, int aiEffectType)
	if (asActorName != MyActorName)
		;AliasDebug("OnPotionRegister - for " + asActorName + ", not me!")
		return
	endIf
	Potion thisPotion = akPotion as Potion
	if (thisPotion == None)
		;AliasDebug("OnPotionRegister - not a potion")
		return
	endIf
	RegisterPotion(thisPotion, asListName, aiEffectType)
endEvent

; Should only be relevant if Refreshing Potions (in which case you're in RefreshingPotions state already)
; or if you have no potions (in which case you're in HaveNoPotions state already)
Event OnPotionIdentified(Form akSender, string asActorName)
endEvent

Event OnDying(Actor akKiller)
	FppQuest.RemoveFollower(MyActor)
endEvent

; generic safety 'resume normal-ish operations' 
Event OnEndState()
	UnregisterForUpdate()
	IgnoreEvents = false
;	AliasDebug(GetState() + "::OnEndState")
EndEvent

State PendingEvent

 	Event OnBeginState()
		IgnoreEvents = false
		AliasDebug("PendingEvent::Begin")
	EndEvent

	Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
		if (IgnoreEvents)
			return
		endIf
		IgnoreEvents = true
		string newState = DetermineState()
		string msg = "PendingEvent::OnCombatStateChanged - new state " + aeCombatState + " - "
		if (newState == "PendingEvent")
			AliasDebug(msg + "no change")
		else
			AliasDebug(msg + "go to " + newState)
			GoToState(newState)
		endIf
		IgnoreEvents = false
		if (!IgnoreCombatStateEvents && aeCombatState == 1 && akTarget != None)
			IgnoreCombatStateEvents = true
			UseCombatPotions("PendingEvent::OnCombatStateChanged", akTarget)
		endIf
	EndEvent

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		if (IgnoreEvents || !UsePotionOfType[EFFECT_RESTOREHEALTH])
			return
		endIf
		IgnoreEvents = true
		HandleHit("PendingEvent::OnHit")
		GoToState("PendingUpdate")
	EndEvent

	Event OnEnterBleedout()
		if (IgnoreEvents || !UsePotionOfType[EFFECT_RESTOREHEALTH])
			return
		endIf
		IgnoreEvents = true
		CurrentStatLimits = StatLimitsInCombat
		HandleHit("PendingEvent::OnEnterBleedout")
		CurrentUpdateInterval = UpdateIntervalInCombat
		GoToState("PendingUpdate")
	EndEvent

	Event OnAnimationEvent(ObjectReference aktarg, string asEventName)
		if (IgnoreEvents || !UsePotionOfType[EFFECT_RESTORESTAMINA])
			return
		endIf
		IgnoreEvents = true
		if (!MyActor.GetAnimationVariableBool("bAllowRotation"))
			IgnoreEvents = false
			return
		endIf
		HandleAnimEvent("PendingEvent::OnAnimationEvent", asEventName)
		GoToState("PendingUpdate")
	endEvent

	Event OnSpellCast(Form akSpell)
		if (IgnoreEvents || !UsePotionOfType[EFFECT_RESTOREMAGICKA])
			return
		endIf
		IgnoreEvents = true
		HandleSpellCast("PendingEvent::OnSpellCast", akSpell as Spell)
		GoToState("PendingUpdate")
	endEvent

endState

State PendingUpdate

 	Event OnBeginState()
		IgnoreEvents = false
		; call DetermineState to set current StatLimits and UpdateInterval
		DetermineState()
		if (DebugToFile)
			AliasDebug("PendingUpdate::Begin (" + "H:" + GetStringPercentage("Health") + ", S:" + GetStringPercentage("Stamina") + ", M:" + GetStringPercentage("Magicka") + ") - update in " + CurrentUpdateInterval)
		endIf
		RegisterForSingleUpdate(CurrentUpdateInterval)
	EndEvent

	Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
		if (IgnoreEvents)
			return
		endIf
		IgnoreEvents = true
		AliasDebug("PendingUpdate::OnCombatStateChanged - new state " + aeCombatState + " - queue new update in " + UpdateIntervalInCombat)
		RegisterForSingleUpdate(UpdateIntervalInCombat)
		IgnoreEvents = false
		if (!IgnoreCombatStateEvents && aeCombatState == 1 && akTarget != None)
			IgnoreCombatStateEvents = true
			UseCombatPotions("PendingUpdate::OnCombatStateChanged", akTarget)
		endIf
	EndEvent

	Event OnUpdate()
		if (IgnoreEvents)
			return
		endIf
		IgnoreEvents = true
		string newState = DetermineState()
		bool extendUpdate = HandleUpdate("PendingUpdate::OnUpdate")
		if (extendUpdate || newState == "PendingUpdate")
			AliasDebug("PendingUpdate::OnUpdate - update in " + CurrentUpdateInterval)
			RegisterForSingleUpdate(CurrentUpdateInterval)
			IgnoreEvents = false
		else
			AliasDebug("PendingUpdate::OnUpdate - go to " + newState)
			GoToState(newState)
		endIf
	EndEvent

	Event OnEnterBleedout()
		if (IgnoreEvents || !UsePotionOfType[EFFECT_RESTOREHEALTH])
			return
		endIf
		IgnoreEvents = true
		CurrentStatLimits = StatLimitsInCombat
		HandleHit("PendingUpdate::OnEnterBleedout")
		RegisterForSingleUpdate(UpdateIntervalInCombat)
		IgnoreEvents = false
	EndEvent

endState

State Incapacitated
 	Event OnBeginState()
		if (DebugToFile)
			AliasDebug("Incapacitated::Begin (" + "H:" + GetStringPercentage("Health") + ") - update in " + UpdateIntervalNonCombat)
		endIf
		RegisterForSingleUpdate(UpdateIntervalNonCombat)
	EndEvent

	Event OnUpdate()
		string msg = "Incapacitated::OnUpdate - (" + "H:" + GetStringPercentage("Health") + ")"
		if (IsIncapacitated())
			AliasDebug(msg + " - still incapacitated")
			RegisterForSingleUpdate(UpdateIntervalNonCombat)
		else
			string newState = DetermineState()
			AliasDebug(msg + " - woken up, go to " + newState)
			GoToState(newState)
		endIf
	endEvent

	; you got a potion, so check to see if it's woken you up (courtesy of NKO)
	Event OnPotionIdentified(Form akSender, string asActorName)
		RegisterForSingleUpdate(UpdateIntervalInCombat)
	endEvent
endState

State HaveNoPotions
	;Shouldn't really need to do much here, as OnPotionIdentified will get you out of this, if you receive a usable potion

 	Event OnBeginState()
		AliasDebug("HaveNoPotions::Begin - update in " + UpdateIntervalNoPotions)
		RegisterForSingleUpdate(UpdateIntervalNoPotions)
	EndEvent

	Event OnUpdate()
		string newState = DetermineState()
		if (newState == "HaveNoPotions")
			AliasDebug("HaveNoPotions::OnUpdate - still no useful potions", MyActorName + " has no useful potions at all!", true)
			RegisterForSingleUpdate(UpdateIntervalNoPotions)
		else
			AliasDebug("HaveNoPotions::OnUpdate - go to " + newState)
			GoToState(newState)
		endIf
	endEvent

	Event OnPotionIdentified(Form akSender, string asActorName)
		if (asActorName != MyActorName)
			;AliasDebug("HaveNoPotions::OnPotionIdentified - for " + asActorName + ", not me!")
			return
		endIf
		if (HasAnyPotions())
			string newState = DetermineState()
			GoToState(newState)
			AliasDebug("HaveNoPotions::OnPotionIdentified - have one now, go to " + newState)
		endIf
	endEvent

endState

State RefreshingPotions

	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		; Ignore this - we're doing Important Stuff
	endEvent

	Event OnPotionIdentified(Form akSender, string asActorName)
		if (asActorName != MyActorName)
			;AliasDebug("RefreshingPotions::OnPotionIdentified - for " + asActorName + ", not me!")
			return
		endIf
		
		RefreshedPotionCount += 1
		int handleUpdated = ModEvent.Create("_FPP_Event_FollowerPotionRefreshCountUpdated")
		if (handleUpdated)
			ModEvent.PushString(handleUpdated, MyActorName)
			ModEvent.PushInt(handleUpdated, MyIndex)
			ModEvent.PushInt(handleUpdated, RefreshedPotionCount)
			ModEvent.PushInt(handleUpdated, TotalPotionCount)
			ModEvent.Send(handleUpdated)
		endIf
		
		if (RefreshedPotionCount < TotalPotionCount)
			AliasDebug("RefreshingPotions::OnPotionIdentified - not enough potions yet (" + RefreshedPotionCount + " of " + TotalPotionCount + ")")
			return
		endIf
		
		if (DoingInit)
			AliasDebug("RefreshingPotions::OnPotionIdentified - all potions identified, finish Init")
			FinishInit()
		else
			AliasDebug("", MyActorName + " finished refreshing potions", true)
			GoToDeterminedState("RefreshingPotions::OnPotionIdentified - Complete, all potions identified, send _FPP_Event_FollowerPotionRefreshComplete")
			int handleComplete = ModEvent.Create("_FPP_Event_FollowerPotionRefreshComplete")
			if (handleComplete)
				ModEvent.PushString(handleComplete, MyActorName)
				ModEvent.PushInt(handleComplete, MyIndex)
				ModEvent.Send(handleComplete)
			endIf
		endIf
	endEvent

endState

State Inert
	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		; Not listening..
	endEvent
	Event OnPotionRegister(Form akSender, string asActorName, Form akPotion, string asListName, int aiEffectType)
		; Nothing happens.. tumbleweed..
	endEvent
endState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; State-related functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bool function HandleUpdate(string asState)
	float currStatHealth = MyActor.GetActorValuePercentage("health")
	float currStatStamina = MyActor.GetActorValuePercentage("stamina")
	float currStatMagicka = MyActor.GetActorValuePercentage("magicka")
	string msg = asState + "::HandleUpdate - H:" + ((currStatHealth * 100) as int) + "%, S:" + ((currStatStamina * 100) as int) + "%, M:" + ((currStatMagicka * 100) as int) + "%"
	if (IsIncapacitated())
		;if incapacitated, not much point going further
		AliasDebug(msg + " - incapacitated")
		return false
	endIf
	AliasDebug(msg)
	
	; check & try to replenish Health, Stamina, Magicka in that order. Only return false if you didn't need any of them
	bool neededHealth = currStatHealth < CurrentStatLimits[EFFECT_RESTOREHEALTH] && UsePotionOfType[EFFECT_RESTOREHEALTH]
	if (neededHealth && UsePotionIfPossible(asState + "::HandleUpdate", EFFECT_RESTOREHEALTH, MyRestorePotions, "MyRestorePotions"))
		return true
	endIf
	bool neededStamina = currStatStamina < CurrentStatLimits[EFFECT_RESTORESTAMINA] && UsePotionOfType[EFFECT_RESTORESTAMINA]
	if (neededStamina && UsePotionIfPossible(asState + "::HandleUpdate", EFFECT_RESTORESTAMINA, MyRestorePotions, "MyRestorePotions"))
		return true
	endIf
	bool neededMagicka = currStatMagicka < CurrentStatLimits[EFFECT_RESTOREMAGICKA] && UsePotionOfType[EFFECT_RESTOREMAGICKA]
	if (neededMagicka && UsePotionIfPossible(asState + "::HandleUpdate", EFFECT_RESTOREMAGICKA, MyRestorePotions, "MyRestorePotions"))
		return true
	endIf
	return neededHealth || neededStamina || neededMagicka
endFunction

bool function HandleHit(string asState)
	float currStat = MyActor.GetActorValuePercentage("health")
	string msg = asState + "::HandleHit: health " + ((currStat * 100) as int) + "%"
	if (IsIncapacitated())
		;if incapacitated, not much point going further
		AliasDebug(msg + " - incapacitated")
		return false
	endIf
	AliasDebug(msg)
	return currStat < CurrentStatLimits[EFFECT_RESTOREHEALTH] && UsePotionIfPossible(asState + "::HandleHit", EFFECT_RESTOREHEALTH, MyRestorePotions, "MyRestorePotions")
endFunction

bool function HandleAnimEvent(string asState, string asEventName)
	float currStat = MyActor.GetActorValuePercentage("stamina")
	string msg = asState + "::HandleAnimEvent: stamina " + ((currStat * 100) as int) + "%"
	if (DebugToFile)
		msg += " (event " + asEventName + ")"
	endIf
	if (IsIncapacitated())
		;if incapacitated, not much point going further
		AliasDebug(msg + " - incapacitated")
		return false
	endIf
	AliasDebug(msg)
	return currStat < CurrentStatLimits[EFFECT_RESTORESTAMINA] && UsePotionIfPossible(asState + "::HandleAnimEvent", EFFECT_RESTORESTAMINA, MyRestorePotions, "MyRestorePotions")
endFunction

bool function HandleSpellCast(string asState, Spell akSpellCast)
	if (!akSpellCast)
		return false
	endIf
	float currStat = MyActor.GetActorValuePercentage("magicka")
	string msg = asState + "::HandleSpellCast: magicka " + ((currStat * 100) as int) + "%"
	if (DebugToFile)
		msg += " (cast " + akSpellCast.GetName() + ")"
	endIf
	if (IsIncapacitated())
		;if incapacitated, not much point going further
		AliasDebug(msg + " - incapacitated")
		return false
	endIf
	AliasDebug(msg)
	return currStat < CurrentStatLimits[EFFECT_RESTOREMAGICKA] && UsePotionIfPossible(asState+ "::HandleSpellCast", EFFECT_RESTOREMAGICKA, MyRestorePotions, "MyRestorePotions")
endFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utility functions
;; could poss be moved to external file, but they use a LOT of internal vars,
;; so not sure about performance/thread safety..
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; rattle through inventory, send each potion to IdentifyPotionThreadManager for async identification
Function RefreshPotions()
	GoToState("RefreshingPotions")
	MyRestorePotions = new Potion[127]
	MyFortifyPotions = new Potion[127]
	MyResistPotions = new Potion[127]
	RefreshedPotionCount = 0
	
	TotalPotionCount = _Q2C_Functions.GetNumItemsOfType(MyActor, 46)
	
	int handleCounted = ModEvent.Create("_FPP_Event_FollowerPotionsCounted")
	if (handleCounted)
		ModEvent.PushString(handleCounted, MyActorName)
		ModEvent.PushInt(handleCounted, TotalPotionCount)
		ModEvent.Send(handleCounted)
	endIf
	
	int iFormIndex = 0
	if (TotalPotionCount > 0)
		iFormIndex = 0
		While iFormIndex < TotalPotionCount
			Potion foundPotion = _Q2C_Functions.GetNthFormOfType(MyActor, 46, iFormIndex) as Potion
			if (foundPotion != None)
				IdentifyPotionThreadManager.IdentifyPotionAsync(false, MyActorName, foundPotion, EffectKeywords, RestoreEffects, FortifyEffectsStats, FortifyEffectsWarrior, FortifyEffectsMage, ResistEffects)
			endIf
			iFormIndex += 1
		EndWhile
		AliasDebug("RefreshPotions - Complete, potions found and all queued, waiting on _FPP_Callback_PotionIdentified event(s)")
		IdentifyPotionThreadManager.WaitAll()
	else
		if (DoingInit)
			AliasDebug("RefreshPotions - Complete, no potions found to identify, finishing Init immediately")
			FinishInit()
		else
			AliasDebug("", MyActorName + " has no potions to refresh", true)
			GoToDeterminedState("RefreshPotions - Complete, no potions found to identify, sending _FPP_Event_FollowerPotionRefreshComplete immediately")
			int handleComplete = ModEvent.Create("_FPP_Event_FollowerPotionRefreshComplete")
			if (handleComplete)
				ModEvent.PushString(handleComplete, MyActorName)
				ModEvent.PushInt(handleComplete, MyIndex)
				ModEvent.Send(handleComplete)
			endIf
		endIf
	endIf
endFunction

function UseCombatPotions(string asState, Actor akTarget)
	string msg = asState + "::UseCombatPotions - "
	if (IsIncapacitated())
		;if incapacitated, not much point going further
		AliasDebug(msg + "incapacitated")
		IgnoreCombatStateEvents = false
		return
	endIf
	
	int enemyLevel = akTarget.GetLevel()
	bool isBoss = akTarget.HasRefType(LocRefTypeBoss)
	int lvlDiff = enemyLevel - MyActor.GetLevel()
	int lhItem = MyActor.GetEquippedItemType(0)
	int rhItem = MyActor.GetEquippedItemType(1)
	
	msg += "combat with level " + enemyLevel
	if (isBoss)
		msg += " boss"
	endIf
	msg += " " + akTarget.GetLeveledActorBase().GetName() + " (diff " + lvlDiff + ", trigger " + LvlDiffTrigger + "); LH: " + lhItem + ", RH: " + rhItem + " - "
	
	if (ShouldUseCombatPotions(lvlDiff, isBoss))
		AliasDebug(msg + "use potions")
		; by chaining these as an inline, it avoids needless calls to subsequent functions 
		; if any one returns false (ie because you're not in combat any more)
		UseCombatPotionsFortifyStats(asState + "::UseCombatPotions") \
			&& UseCombatPotionsWarrior(asState + "::UseCombatPotions", lhItem, rhItem) \
			&& UseCombatPotionsMage(asState + "::UseCombatPotions") \
			&& UseCombatPotionsResist(asState + "::UseCombatPotions", akTarget)
	else
		AliasDebug(msg + "not enough")
	endIf
	IgnoreCombatStateEvents = false
endFunction

bool function ShouldUseCombatPotions(int aiLvlDiff, bool abIsBoss)
	return aiLvlDiff > LvlDiffTrigger
endFunction

bool function UseCombatPotionsFortifyStats(string asState)

	string msgNofight = asState + "::UseCombatPotionsFortifyStats - no longer in combat, returning"
	if (!MyActor.IsInCombat())
		AliasDebug(msgNofight)
		return false
	endIf
	
	int i = FortifyEffectsStats.Length
	while (i)
		i -= 1
		if (UsePotionOfType[FortifyEffectsStats[i]] && UsePotionIfPossible(asState + "::UseCombatPotionsFortifyStats", FortifyEffectsStats[i], MyFortifyPotions, "MyFortifyPotions"))
			Utility.Wait(1)
			if (!MyActor.IsInCombat())
				AliasDebug(msgNofight)
				return false
			endIf
		endIf
	endWhile
	
	return true
endFunction

bool function UseCombatPotionsWarrior(string asState, int aiLHItem, int aiRHItem)
	
	string msgNofight = asState + "::UseCombatPotionsWarrior - no longer in combat, returning"
	if (!MyActor.IsInCombat())
		AliasDebug(msgNofight)
		return false
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYBLOCK] \
		&& (aiLHItem == C_ITEM_SHIELD || aiRHItem == C_ITEM_SHIELD) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", EFFECT_FORTIFYBLOCK, MyFortifyPotions, "MyFortifyPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYHEAVYARMOR] \
		&& MyActor.WornHasKeyword(KeywordArmorHeavy) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", EFFECT_FORTIFYHEAVYARMOR, MyFortifyPotions, "MyFortifyPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYLIGHTARMOR] \
		&& MyActor.WornHasKeyword(KeywordArmorLight) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", EFFECT_FORTIFYLIGHTARMOR, MyFortifyPotions, "MyFortifyPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYMARKSMAN] \
		&& (aiLHItem == C_ITEM_BOW) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", EFFECT_FORTIFYMARKSMAN, MyFortifyPotions, "MyFortifyPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYONEHANDED] \
		&& (aiLHItem == C_ITEM_1H_SWORD || aiLHItem == C_ITEM_1H_DAGGER || aiLHItem == C_ITEM_1H_AXE || aiLHItem == C_ITEM_1H_MACE \
			|| aiRHItem == C_ITEM_1H_SWORD || aiRHItem == C_ITEM_1H_DAGGER || aiRHItem == C_ITEM_1H_AXE || aiRHItem == C_ITEM_1H_MACE) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", EFFECT_FORTIFYONEHANDED, MyFortifyPotions, "MyFortifyPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYTWOHANDED] \
		&& (aiLHItem == C_ITEM_2H_SWORD || aiLHItem == C_ITEM_2H_AXE_MACE) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", EFFECT_FORTIFYTWOHANDED, MyFortifyPotions, "MyFortifyPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	return true
endFunction

bool function UseCombatPotionsMage(string asState)

	string msgNofight = asState + "::UseCombatPotionsMage - no longer in combat, returning"
	if (!MyActor.IsInCombat())
		AliasDebug(msgNofight)
		return false
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYALTERATION] \
		&& _Q2C_Functions.ActorHasSpellSchool(MyActor, C_SCHOOL_ALTERATION, true) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsMage", EFFECT_FORTIFYALTERATION, MyFortifyPotions, "MyFortifyPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYCONJURATION] \
		&& _Q2C_Functions.ActorHasSpellSchool(MyActor, C_SCHOOL_CONJURATION, true) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsMage", EFFECT_FORTIFYCONJURATION, MyFortifyPotions, "MyFortifyPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYDESTRUCTION] \
		&& _Q2C_Functions.ActorHasSpellSchool(MyActor, C_SCHOOL_DESTRUCTION, true) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsMage", EFFECT_FORTIFYDESTRUCTION, MyFortifyPotions, "MyFortifyPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYILLUSION] \
		&& _Q2C_Functions.ActorHasSpellSchool(MyActor, C_SCHOOL_ILLUSION, true) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsMage", EFFECT_FORTIFYILLUSION, MyFortifyPotions, "MyFortifyPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYRESTORATION] \
		&& _Q2C_Functions.ActorHasSpellSchool(MyActor, C_SCHOOL_RESTORATION, true) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsMage", EFFECT_FORTIFYRESTORATION, MyFortifyPotions, "MyFortifyPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	return true
endFunction

bool function UseCombatPotionsResist(string asState, Actor akTarget)

	string msgNofight = asState + "::UseCombatPotionsResist - no longer in combat, returning"
	if (!MyActor.IsInCombat())
		AliasDebug(msgNofight)
		return false
	endIf
	
	bool hasFire = _Q2C_Functions.ActorHasSpellKeyword(akTarget, MagicDamageFire, true)
	if (UsePotionOfType[EFFECT_RESISTFIRE] \
		&& (hasFire) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsResist", EFFECT_RESISTFIRE, MyResistPotions, "MyResistPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	bool hasFrost = _Q2C_Functions.ActorHasSpellKeyword(akTarget, MagicDamageFrost, true)
	if (UsePotionOfType[EFFECT_RESISTFROST] \
		&& (hasFrost) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsResist", EFFECT_RESISTFROST, MyResistPotions, "MyResistPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	bool hasShock = _Q2C_Functions.ActorHasSpellKeyword(akTarget, MagicDamageShock, true)
	if (UsePotionOfType[EFFECT_RESISTSHOCK] \
		&& (hasShock) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsResist", EFFECT_RESISTSHOCK, MyResistPotions, "MyResistPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_RESISTMAGIC] \
		&& (hasFire || hasFrost || hasShock) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsResist", EFFECT_RESISTMAGIC, MyResistPotions, "MyResistPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_RESISTPOISON] \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsResist", EFFECT_RESISTPOISON, MyResistPotions, "MyResistPotions"))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	return true
endFunction

; called from OnPotionRegister, which is triggered by thread manager when a potion is identified
; need to do the actual adding-to-array here to avoid race conditions
Function RegisterPotion(Potion akPotion, string asListName, int aiEffectType)
	Potion[] thisPotionList
	if (asListName == "MyRestorePotions")
		thisPotionList = MyRestorePotions
	elseIf (asListName == "MyFortifyPotions")
		thisPotionList = MyFortifyPotions
	elseIf (asListName == "MyResistPotions")
		thisPotionList = MyResistPotions
	else
		return
	endIf
	int potionIndex = thisPotionList.Find(akPotion)
	if (potionIndex < 0)
		int freeIndex = thisPotionList.Find(None)
		if (freeIndex > -1)
			thisPotionList[freeIndex] = akPotion
			if (DebugToFile)
				AliasDebug("RegisterPotion - Recognised " + akPotion.GetName() + " (Id " + akPotion.GetFormId() + ", assigned " + asListName + "[" + freeIndex + "], type " + aiEffectType + ")")
			endIf
		else
			AliasDebug("", MyActorName + " - can't add " + akPotion.GetName() + " potion; no more room for this type of potion!", true)
			if (DebugToFile)
				AliasDebug("RegisterPotion - No more room in potions array for " + akPotion.GetName() + "! (Id " + akPotion.GetFormId() + ", tried to add to " + asListName + ", type " + aiEffectType + ")")
			endIf
		endIf
	else
		if (DebugToFile)
			AliasDebug("RegisterPotion - Restocked " + akPotion.GetName() + " (Id " + akPotion.GetFormId() + ", at " + asListName + "[" + potionIndex + "], type " + aiEffectType + ")")
		endIf
	endIf
	HasPotionOfType[aiEffectType] = true
endFunction

bool function UsePotionIfPossible(string asState, int aiEffectType, Potion[] akPotionList, string asListName)
	string effectName = EffectNames[aiEffectType]
	string msg = asState + "::UsePotionIfPossible (" + aiEffectType + ": " + effectName + ") - "
	bool potionUsed = false
	if (!HasPotionOfType[aiEffectType])
		IncAndCheckLimit(aiEffectType)
		msg += "no " + effectName + " potions (warning " + MyPotionWarningCounts[aiEffectType] + ")"
	elseif (IsInCooldown(aiEffectType))
		msg += effectName + " potion still taking effect"
	else
		bool potionWorked = TryFirstPotionThatExists(aiEffectType, akPotionList, asListName)
		if (potionWorked)
			msg += "used " + effectName  + " potion from " + asListName
			potionUsed = true
		else
			HasPotionOfType[aiEffectType] = false
			IncAndCheckLimit(aiEffectType)
			msg += "no " + effectName  + " potions (warning " + MyPotionWarningCounts[aiEffectType] + ")"
		endIf
	endIf
	AliasDebug(msg)
	return potionUsed
endFunction

function IncAndCheckLimit(int aiEffectType)
	MyPotionWarningCounts[aiEffectType] = MyPotionWarningCounts[aiEffectType] + 1
	if (MyPotionWarningCounts[aiEffectType] >= MyPotionWarningTriggers[aiEffectType])
		AliasDebug("no " + EffectNames[aiEffectType] + " potions", MyActorName + " has no " + EffectNames[aiEffectType] + " potions to use!", false)
		MyPotionWarningCounts[aiEffectType] = 0
	endif
endFunction

bool function IsInCooldown(int aiEffectType)
	if (EffectKeywords[aiEffectType] == None)
		return false
	endIf
	return MyActor.HasEffectKeyword(EffectKeywords[aiEffectType])
endFunction

bool Function HasAnyPotions()
	return HasPotionOfType.Find(true) > -1
endFunction

bool function IsIncapacitated()
	; NKO uses paralysis for KO'd followers - but then, being paralysed should be enough to stop you using potions anyway..
	return MyActor.GetActorValue("Paralysis") > 0 || MyActor.IsUnconscious()
endFunction

bool function TryFirstPotionThatExists(int aiEffectType, Potion[] akPotionList, string asListName)
	int potionIndex = 0
	while (potionIndex < akPotionList.Length)
		Potion thisPotion = akPotionList[potionIndex]
		;string m = asListName + "[" + potionIndex + "]:"
		if (thisPotion != None && !thisPotion.IsHostile() && thisPotion.HasKeyword(EffectKeywords[aiEffectType]))
			int potionCount = MyActor.GetItemCount(thisPotion)
			;m += ", have " + potionCount
			if (potionCount > 0)
				MyActor.EquipItem(thisPotion)
				;m += ", used " + thisPotion.GetName() + " (" + thisPotion.GetFormId() + "), " + (potionCount - 1) + " remaining"
				if (potionCount == 1)
					; Clear this potion from lists if it's the last one..
					akPotionList[potionIndex] = None
					;m += ", removed from index " + potionIndex
					if (asListName != "MyRestorePotions" && RemoveFromArray(thisPotion, MyRestorePotions) > -1)
						;m += ", also removed from MyRestorePotions"
					endIf
					if (asListName != "MyFortifyPotions" && RemoveFromArray(thisPotion, MyFortifyPotions) > -1)
						;m += ", also removed from MyFortifyPotions"
					endIf
					if (asListName != "MyResistPotions" && RemoveFromArray(thisPotion, MyResistPotions) > -1)
						;m += ", also removed from MyResistPotions"
					endIf
				endIf
				;AliasDebug(m)
				return true
			else
				potionIndex += 1
				;AliasDebug(m)
			endif
		else
			potionIndex += 1
		endif
	endWhile
	return false
endFunction

int function RemoveFromArray(Potion akPotion, Potion[] akPotionList)
	int i = akPotionList.Find(akPotion)
	if (i > -1)
		akPotionList[i] = None
	endIf
	return i
endFunction

Function ShowInfo()
	if (MyActor == None)
		return
	endIf

	string msg = "State: " + GetState() + "\n"
	msg += "\n"
	msg += "Restore Potions: " + GetPotionReport(MyRestorePotions)
	msg += "\n"
	msg += "Fortify Potions: " + GetPotionReport(MyFortifyPotions)
	msg += "\n"
	msg += "Resist Potions: " + GetPotionReport(MyResistPotions)
	AliasDebug(msg)
	Debug.MessageBox(MyActorName + "\n" + msg)
endFunction

string Function GetPotionReport(Potion[] akPotionList)
	int iP = akPotionList.Length
	string potionReport = ""
	while iP > 0
		iP -= 1
		Potion thisPotion = akPotionList[iP]
		if (thisPotion)
			potionReport += thisPotion.GetName() + " (" + MyActor.GetItemCount(thisPotion) + "); "
		endIf
	endWhile
	return potionReport
endFunction


Function SetProperties()
{set all internal properties, to avoid halting the thread when looking them up}

	C_SCHOOL_ALTERATION = FPPQuest.C_SCHOOL_ALTERATION
	C_SCHOOL_CONJURATION = FPPQuest.C_SCHOOL_CONJURATION
	C_SCHOOL_DESTRUCTION = FPPQuest.C_SCHOOL_DESTRUCTION
	C_SCHOOL_ILLUSION = FPPQuest.C_SCHOOL_ILLUSION
	C_SCHOOL_RESTORATION = FPPQuest.C_SCHOOL_RESTORATION

	C_ITEM_HAND = FPPQuest.C_ITEM_HAND
	C_ITEM_1H_SWORD = FPPQuest.C_ITEM_1H_SWORD
	C_ITEM_1H_DAGGER = FPPQuest.C_ITEM_1H_DAGGER
	C_ITEM_1H_AXE = FPPQuest.C_ITEM_1H_AXE
	C_ITEM_1H_MACE = FPPQuest.C_ITEM_1H_MACE
	C_ITEM_2H_SWORD = FPPQuest.C_ITEM_2H_SWORD
	C_ITEM_2H_AXE_MACE = FPPQuest.C_ITEM_2H_AXE_MACE
	C_ITEM_BOW = FPPQuest.C_ITEM_BOW
	C_ITEM_STAFF = FPPQuest.C_ITEM_STAFF
	C_ITEM_SPELL = FPPQuest.C_ITEM_SPELL
	C_ITEM_SHIELD = FPPQuest.C_ITEM_SHIELD
	C_ITEM_TORCH = FPPQuest.C_ITEM_TORCH
	C_ITEM_CROSSBOW = FPPQuest.C_ITEM_CROSSBOW

	EFFECT_RESTOREHEALTH = FPPQuest.EFFECT_RESTOREHEALTH
	EFFECT_RESTOREMAGICKA = FPPQuest.EFFECT_RESTOREMAGICKA
	EFFECT_RESTORESTAMINA = FPPQuest.EFFECT_RESTORESTAMINA
	EFFECT_BENEFICIAL = FPPQuest.EFFECT_BENEFICIAL
	EFFECT_DAMAGEHEALTH = FPPQuest.EFFECT_DAMAGEHEALTH
	EFFECT_DAMAGEMAGICKA = FPPQuest.EFFECT_DAMAGEMAGICKA
	EFFECT_DAMAGESTAMINA = FPPQuest.EFFECT_DAMAGESTAMINA
	EFFECT_DURATIONBASED = FPPQuest.EFFECT_DURATIONBASED
	EFFECT_FORTIFYALCHEMY = FPPQuest.EFFECT_FORTIFYALCHEMY
	EFFECT_FORTIFYALTERATION = FPPQuest.EFFECT_FORTIFYALTERATION
	EFFECT_FORTIFYBLOCK = FPPQuest.EFFECT_FORTIFYBLOCK
	EFFECT_FORTIFYCARRYWEIGHT = FPPQuest.EFFECT_FORTIFYCARRYWEIGHT
	EFFECT_FORTIFYCONJURATION = FPPQuest.EFFECT_FORTIFYCONJURATION
	EFFECT_FORTIFYDESTRUCTION = FPPQuest.EFFECT_FORTIFYDESTRUCTION
	EFFECT_FORTIFYENCHANTING = FPPQuest.EFFECT_FORTIFYENCHANTING
	EFFECT_FORTIFYHEALRATE = FPPQuest.EFFECT_FORTIFYHEALRATE
	EFFECT_FORTIFYHEALTH = FPPQuest.EFFECT_FORTIFYHEALTH
	EFFECT_FORTIFYHEAVYARMOR = FPPQuest.EFFECT_FORTIFYHEAVYARMOR
	EFFECT_FORTIFYILLUSION = FPPQuest.EFFECT_FORTIFYILLUSION
	EFFECT_FORTIFYLIGHTARMOR = FPPQuest.EFFECT_FORTIFYLIGHTARMOR
	EFFECT_FORTIFYLOCKPICKING = FPPQuest.EFFECT_FORTIFYLOCKPICKING
	EFFECT_FORTIFYMAGICKA = FPPQuest.EFFECT_FORTIFYMAGICKA
	EFFECT_FORTIFYMAGICKARATE = FPPQuest.EFFECT_FORTIFYMAGICKARATE
	EFFECT_FORTIFYMARKSMAN = FPPQuest.EFFECT_FORTIFYMARKSMAN
	EFFECT_FORTIFYMASS = FPPQuest.EFFECT_FORTIFYMASS
	EFFECT_FORTIFYONEHANDED = FPPQuest.EFFECT_FORTIFYONEHANDED
	EFFECT_FORTIFYPICKPOCKET = FPPQuest.EFFECT_FORTIFYPICKPOCKET
	EFFECT_FORTIFYRESTORATION = FPPQuest.EFFECT_FORTIFYRESTORATION
	EFFECT_FORTIFYSMITHING = FPPQuest.EFFECT_FORTIFYSMITHING
	EFFECT_FORTIFYSNEAK = FPPQuest.EFFECT_FORTIFYSNEAK
	EFFECT_FORTIFYSPEECHCRAFT = FPPQuest.EFFECT_FORTIFYSPEECHCRAFT
	EFFECT_FORTIFYSTAMINA = FPPQuest.EFFECT_FORTIFYSTAMINA
	EFFECT_FORTIFYSTAMINARATE = FPPQuest.EFFECT_FORTIFYSTAMINARATE
	EFFECT_FORTIFYTWOHANDED = FPPQuest.EFFECT_FORTIFYTWOHANDED
	EFFECT_HARMFUL = FPPQuest.EFFECT_HARMFUL
	EFFECT_RESISTFIRE = FPPQuest.EFFECT_RESISTFIRE
	EFFECT_RESISTFROST = FPPQuest.EFFECT_RESISTFROST
	EFFECT_RESISTMAGIC = FPPQuest.EFFECT_RESISTMAGIC
	EFFECT_RESISTPOISON = FPPQuest.EFFECT_RESISTPOISON
	EFFECT_RESISTSHOCK = FPPQuest.EFFECT_RESISTSHOCK
	EFFECT_WEAKNESSFIRE = FPPQuest.EFFECT_WEAKNESSFIRE
	EFFECT_WEAKNESSFROST = FPPQuest.EFFECT_WEAKNESSFROST
	EFFECT_WEAKNESSMAGIC = FPPQuest.EFFECT_WEAKNESSMAGIC
	EFFECT_WEAKNESSSHOCK = FPPQuest.EFFECT_WEAKNESSSHOCK

	EffectKeywords = FPPQuest.EffectKeywords
	EffectNames = FPPQuest.EffectNames
	RestoreEffects = FPPQuest.RestoreEffects
	FortifyEffectsStats = FPPQuest.FortifyEffectsStats
	FortifyEffectsWarrior = FPPQuest.FortifyEffectsWarrior
	FortifyEffectsMage = FPPQuest.FortifyEffectsMage
	ResistEffects = FPPQuest.ResistEffects
	
	KeywordPotion = FPPQuest.VendorItemPotion
	
	KeywordArmorHeavy = FPPQuest.ArmorHeavy
	KeywordArmorLight = FPPQuest.ArmorLight
	
	MagicDamageFire = FPPQuest.MagicDamageFire
	MagicDamageFrost = FPPQuest.MagicDamageFrost
	MagicDamageShock = FPPQuest.MagicDamageShock

	LocRefTypeBoss = FPPQuest.LocRefTypeBoss

	DebugToFile = FPPQuest.DebugToFile
endFunction

Function SetDefaults()
	UpdateIntervalInCombat = FPPQuest.DefaultUpdateIntervalInCombat
	UpdateIntervalNonCombat = FPPQuest.DefaultUpdateIntervalNonCombat
	UpdateIntervalNoPotions = FPPQuest.DefaultUpdateIntervalNoPotions

	StatLimitsInCombat = FPPQuest.GetDefaultStatLimits(true)
	StatLimitsNonCombat = FPPQuest.GetDefaultStatLimits(false)

	LvlDiffTrigger = FPPQuest.DefaultLvlDiffTrigger as int

	MyPotionWarningTriggers = Utility.CreateIntArray(EffectKeywords.Length, 10)
	HasPotionOfType = FPPQuest.CreateBoolArray(EffectKeywords.Length, false)
	UsePotionOfType = FPPQuest.GetDefaultUsePotionsOfTypes()
endFunction


string function GetStringPercentage(string asActorValue)
	return ((MyActor.GetActorValuePercentage(asActorValue) * 100) as int) + "%"
endFunction

function AliasDebug(string asLogMsg, string asScreenMsg = "", bool abFpPrefix = false)
	if (DebugToFile && asLogMsg != "")
		Debug.TraceUser("FollowerPotions", MyActorName + ": " + asLogMsg)
	endIf
	if (asScreenMsg != "")
		if (abFpPrefix)
			asScreenMsg = "Follower Potions - " + asScreenMsg
		endIf
		Debug.Notification(asScreenMsg)
	endIf
endFunction
