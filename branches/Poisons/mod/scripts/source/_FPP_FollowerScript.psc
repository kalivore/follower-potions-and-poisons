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

bool[] Property EnableWarnings Auto
float[] Property WarningIntervals Auto

float[] Property StatLimitsInCombat Auto
float[] Property StatLimitsNonCombat Auto

int Property LvlDiffTrigger Auto
bool[] Property TriggerRaces Auto

bool[] Property UsePotionOfType Auto

int Property IdentifyPotionEffects Auto

bool Property DebugToFile Auto

int Property RefreshedItemCount
	int Function Get()
		return _refreshedItemCount
	endFunction
endProperty

int Property TotalItemCount
	int Function Get()
		return _totalItemCount
	endFunction
endProperty


; private vars set from main Quest during SetProperties()
; (to avoid threading issues if we made an external cal to the Quest)
string C_SCHOOL_ALTERATION
string C_SCHOOL_CONJURATION
string C_SCHOOL_DESTRUCTION
string C_SCHOOL_ILLUSION
string C_SCHOOL_RESTORATION

int C_IDENTIFY_RESTORE
int C_IDENTIFY_FORTIFY
int C_IDENTIFY_RESIST
int C_IDENTIFY_FIRST
int C_IDENTIFY_SECOND
int C_IDENTIFY_THIRD

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

int C_HAND_LEFT
int C_HAND_RIGHT

int EFFECT_RESTOREHEALTH
int EFFECT_RESTORESTAMINA
int EFFECT_RESTOREMAGICKA
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

int[] PoisonEffectsStats
int[] PoisonEffectsWeakness
int[] PoisonEffectsGeneric

Keyword KeywordPotion
Keyword KeywordPoison

Keyword KeywordArmorHeavy
Keyword KeywordArmorLight

Keyword MagicDamageFire
Keyword MagicDamageFrost
Keyword MagicDamageShock

LocationRefType LocRefTypeBoss

Race[] AvailableTriggerRaces
int[] TriggerRaceMappings

; other private vars for state
Potion[] potionListRestoreHealth
Potion[] potionListRestoreStamina
Potion[] potionListRestoreMagicka
Potion[] potionListFortifyHealth
Potion[] potionListFortifyHealRate
Potion[] potionListFortifyMagicka
Potion[] potionListFortifyMagickaRate
Potion[] potionListFortifyStamina
Potion[] potionListFortifyStaminaRate
Potion[] potionListFortifyBlock
Potion[] potionListFortifyHeavyArmor
Potion[] potionListFortifyLightArmor
Potion[] potionListFortifyMarksman
Potion[] potionListFortifyOneHanded
Potion[] potionListFortifyTwoHanded
Potion[] potionListFortifyAlteration
Potion[] potionListFortifyConjuration
Potion[] potionListFortifyDestruction
Potion[] potionListFortifyIllusion
Potion[] potionListFortifyRestoration
Potion[] potionListResistFire
Potion[] potionListResistFrost
Potion[] potionListResistMagic
Potion[] potionListResistPoison
Potion[] potionListResistShock
Potion[] potionListDamageHealth
Potion[] potionListDamageMagicka
Potion[] potionListDamageStamina
Potion[] potionListWeaknessFire
Potion[] potionListWeaknessFrost
Potion[] potionListWeaknessShock
Potion[] potionListWeaknessMagic
Potion[] potionListHarmful

int MyTotalPotionCount = 0
int MyTotalPoisonCount = 0

Race EnemyRace
int EnemyLvlDiff
bool EnemyIsBoss
float CurrentUpdateInterval
int[] MyPotionWarningCounts
int[] MyPotionWarningTriggers
float[] MyPotionWarningTimes
float[] CurrentStatLimits
int[] HasItemOfType

bool IgnoreEvents = false
bool IgnoreCombatStateEvents = false

int _refreshedItemCount = 0
int _totalItemCount = 0
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
	if (!MyActor)
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
	if (!RegisterForAnimationEvent(MyActor, "weaponSwing") || !RegisterForAnimationEvent(MyActor, "weaponLeftSwing") || !RegisterForAnimationEvent(MyActor, "arrowRelease"))
		AliasDebug("Failed to register for animation events")
	endIf
	if (!DoingInit)
		RegisterForModEvent("_FPP_Callback_RegisterPotion", "OnPotionRegister")
		RegisterForModEvent("_FPP_Callback_PotionIdentified", "OnPotionIdentified")
	endIf
	DoingInit = false
	SetProperties()
	float currentHoursPassed = Game.GetRealHoursPassed()
	MyPotionWarningCounts = Utility.CreateIntArray(5, 0)
	MyPotionWarningTimes = Utility.CreateFloatArray(5, currentHoursPassed)
	GoToDeterminedState("Maintenance Complete")
endFunction

Function DeInit()
	GoToState("Inert")
	UnregisterForUpdate()
	UnregisterForAnimationEvent(MyActor, "weaponSwing")
	UnregisterForAnimationEvent(MyActor, "weaponLeftSwing")
	UnregisterForAnimationEvent(MyActor, "arrowRelease")
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
		elseIf (HasAnyPotions() || HasAnyPoisons())
			return "PendingEvent"
		else
			return "HaveNoPotions"
		endIf
	else
		CurrentStatLimits = StatLimitsNonCombat
		CurrentUpdateInterval = UpdateIntervalNonCombat
		if (incapacitated)
			return "Incapacitated"
		elseIf (HasAnyPotions() || HasAnyPoisons())
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
	Potion thisPotion = akBaseItem as Potion
	if (!thisPotion || thisPotion.IsFood() || (!thisPotion.IsPoison() && thisPotion.IsHostile()))
		return
	endIf
	IdentifyPotionThreadManager.IdentifyPotionAsync(true, DebugToFile, MyActorName, thisPotion, aiItemCount, EffectKeywords, RestoreEffects, FortifyEffectsStats, FortifyEffectsWarrior, FortifyEffectsMage, ResistEffects, PoisonEffectsStats, PoisonEffectsWeakness, PoisonEffectsGeneric, IdentifyPotionEffects, C_IDENTIFY_RESTORE, C_IDENTIFY_FORTIFY, C_IDENTIFY_RESIST, C_IDENTIFY_FIRST, C_IDENTIFY_SECOND, C_IDENTIFY_THIRD)
	IdentifyPotionThreadManager.WaitAny()
	;AliasDebug("OnItemAdded - " + aiItemCount + "x " + thisPotion.GetName() + " sent for identification")
endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	Potion thisPotion = akBaseItem as Potion
	if (!akDestContainer || !thisPotion || thisPotion.IsFood() || (!thisPotion.IsPoison() && thisPotion.IsHostile()))
		return
	endIf
	int listsAffected = UpdateCountsAndArrays(thisPotion, aiItemCount, false)
	if (listsAffected > 0)
		if (thisPotion.IsPoison())
			MyTotalPoisonCount -= aiItemCount
		else
			MyTotalPotionCount -= aiItemCount
		endIf
	endIf
	string refId = "None"
	if (akItemReference != None)
		refId = akItemReference.GetFormId()
	endIf
	string destId = akDestContainer.GetFormId()
	AliasDebug2("OnItemRemoved - " + aiItemCount + "x " + thisPotion.GetName() + " removed from " + listsAffected + " lists (ref " + refId + ", dest " + destId + ")")
endEvent

Event OnPotionRegister(Form akSender, string asActorName, Form akPotion, int aiPotionCount, int aiEffectType)
	if (asActorName != MyActorName)
		;AliasDebug("OnPotionRegister - for " + asActorName + ", not me!")
		return
	endIf
	Potion thisPotion = akPotion as Potion
	if (!thisPotion)
		;AliasDebug("OnPotionRegister - not a potion")
		return
	endIf
	RegisterPotion(thisPotion, aiPotionCount, aiEffectType)
endEvent

; Should only be relevant if Refreshing Potions (in which case you're in RefreshingPotions state already)
; or if you have no potions (in which case you're in HaveNoPotions state already)
Event OnPotionIdentified(Form akSender, string asActorName, int aiEffectsFound, bool abIsPoison, int aiItemCount)
	UpdateItemCounts(asActorName, aiEffectsFound, abIsPoison, aiItemCount)
endEvent

Event OnDying(Actor akKiller)
	FPPQuest.RemoveFollower(MyActor)
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
			HandleCombatStateChange("PendingEvent::OnCombatStateChanged", akTarget)
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
		if (IgnoreEvents)
			return
		endIf
		IgnoreEvents = true
		if (asEventName == "arrowRelease")
			; just assume they're using a bow, even if they might have switched equipment in the moment
			if (ShouldUseCombatPoisonsOnUpdate(C_ITEM_BOW, C_ITEM_BOW))
				AttemptPoisonChain("PendingEvent::OnAnimationEvent(bow shot)", C_HAND_RIGHT, C_ITEM_BOW, false)
			endIf
			IgnoreEvents = false
			return
		endIf
		if (!UsePotionOfType[EFFECT_RESTORESTAMINA] || !MyActor.GetAnimationVariableBool("bAllowRotation"))
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
			AliasDebug("PendingUpdate::Begin (H:" + GetStringPercentage("Health") + ", S:" + GetStringPercentage("Stamina") + ", M:" + GetStringPercentage("Magicka") + ") - update in " + CurrentUpdateInterval)
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
			HandleCombatStateChange("PendingUpdate::OnCombatStateChanged", akTarget)
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
			int lhItem = MyActor.GetEquippedItemType(C_HAND_LEFT)
			int rhItem = MyActor.GetEquippedItemType(1)
			if (ShouldUseCombatPoisonsOnUpdate(lhItem, rhItem))
				if (AttemptPoisonChain("PendingUpdate::OnUpdate", C_HAND_RIGHT, rhItem, true))
					Utility.Wait(1)
				endIf
				AttemptPoisonChain("PendingUpdate::OnUpdate", C_HAND_LEFT, lhItem, true)
			endIf
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
			AliasDebug("Incapacitated::Begin (H:" + GetStringPercentage("Health") + ") - update in " + UpdateIntervalNonCombat)
		endIf
		RegisterForSingleUpdate(UpdateIntervalNonCombat)
	EndEvent

	Event OnUpdate()
		string msg = "Incapacitated::OnUpdate - (H:" + GetStringPercentage("Health") + ")"
		if (IsIncapacitated())
			AliasDebug(msg + " - still incapacitated")
			RegisterForSingleUpdate(UpdateIntervalNonCombat)
		else
			AliasDebug(msg + " - woken up, go to PendingUpdate")
			GoToState("PendingUpdate")
		endIf
	endEvent

	; you got a potion, so check to see if it's woken you up (courtesy of NKO)
	Event OnPotionIdentified(Form akSender, string asActorName, int aiEffectsFound, bool abIsPoison, int aiItemCount)
		UpdateItemCounts(asActorName, aiEffectsFound, abIsPoison, aiItemCount)
		RegisterForSingleUpdate(UpdateIntervalInCombat)
	endEvent
endState

State HaveNoPotions
	; Shouldn't really need to do much here, as OnPotionIdentified will get you out of this, if you receive a usable potion

 	Event OnBeginState()
		AliasDebug("HaveNoPotions::Begin - update in " + UpdateIntervalNoPotions)
		RegisterForSingleUpdate(UpdateIntervalNoPotions)
	EndEvent

	Event OnUpdate()
		string newState = DetermineState()
		if (newState == "HaveNoPotions")
			AliasDebug("HaveNoPotions::OnUpdate - still no useful potions")
			if (EnableWarnings[5])
				AliasDebug("", MyActorName + " has no useful potions at all!", true)
			endIf
			RegisterForSingleUpdate(UpdateIntervalNoPotions)
		else
			AliasDebug("HaveNoPotions::OnUpdate - go to " + newState)
			GoToState(newState)
		endIf
	endEvent

	Event OnPotionIdentified(Form akSender, string asActorName, int aiEffectsFound, bool abIsPoison, int aiItemCount)
		UpdateItemCounts(asActorName, aiEffectsFound, abIsPoison, aiItemCount)
		if (HasAnyPotions() || HasAnyPoisons())
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
	Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		; this too
	endEvent

	Event OnPotionIdentified(Form akSender, string asActorName, int aiEffectsFound, bool abIsPoison, int aiItemCount)
		UpdateItemCounts(asActorName, aiEffectsFound, abIsPoison, aiItemCount)
		
		_refreshedItemCount += 1
		int handleUpdated = ModEvent.Create("_FPP_Event_FollowerPotionRefreshCountUpdated")
		if (handleUpdated)
			ModEvent.PushString(handleUpdated, MyActorName)
			ModEvent.PushInt(handleUpdated, MyIndex)
			ModEvent.PushInt(handleUpdated, _refreshedItemCount)
			ModEvent.PushInt(handleUpdated, _totalItemCount)
			ModEvent.Send(handleUpdated)
		endIf
		
		if (_refreshedItemCount < _totalItemCount)
			AliasDebug("RefreshingPotions::OnPotionIdentified - not enough potions yet (" + _refreshedItemCount + " of " + _totalItemCount + ")")
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
	Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		; Nope..
	endEvent
	Event OnPotionRegister(Form akSender, string asActorName, Form akPotion, int aiPotionCount, int aiEffectType)
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
	if (neededHealth && UsePotionIfPossible(asState + "::HandleUpdate", EFFECT_RESTOREHEALTH, potionListRestoreHealth))
		return true
	endIf
	bool neededStamina = currStatStamina < CurrentStatLimits[EFFECT_RESTORESTAMINA] && UsePotionOfType[EFFECT_RESTORESTAMINA]
	if (neededStamina && UsePotionIfPossible(asState + "::HandleUpdate", EFFECT_RESTORESTAMINA, potionListRestoreStamina))
		return true
	endIf
	bool neededMagicka = currStatMagicka < CurrentStatLimits[EFFECT_RESTOREMAGICKA] && UsePotionOfType[EFFECT_RESTOREMAGICKA]
	if (neededMagicka && UsePotionIfPossible(asState + "::HandleUpdate", EFFECT_RESTOREMAGICKA, potionListRestoreMagicka))
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
	return currStat < CurrentStatLimits[EFFECT_RESTOREHEALTH] && UsePotionIfPossible(asState + "::HandleHit", EFFECT_RESTOREHEALTH, potionListRestoreHealth)
endFunction

bool function HandleAnimEvent(string asState, string asEventName)
	float currStat = MyActor.GetActorValuePercentage("stamina")
	string msg = asState + "::HandleAnimEvent: stamina " + ((currStat * 100) as int) + "% (event " + asEventName + ")"
	if (IsIncapacitated())
		;if incapacitated, not much point going further
		AliasDebug(msg + " - incapacitated")
		return false
	endIf
	AliasDebug(msg)
	return currStat < CurrentStatLimits[EFFECT_RESTORESTAMINA] && UsePotionIfPossible(asState + "::HandleAnimEvent", EFFECT_RESTORESTAMINA, potionListRestoreStamina)
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
	return currStat < CurrentStatLimits[EFFECT_RESTOREMAGICKA] && UsePotionIfPossible(asState+ "::HandleSpellCast", EFFECT_RESTOREMAGICKA, potionListRestoreMagicka)
endFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utility functions
;; could poss be moved to external file, but they use a LOT of internal vars,
;; so not sure about performance/thread safety..
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; rattle through inventory, send each potion to IdentifyPotionThreadManager for async identification
Function RefreshPotions()
	GoToState("RefreshingPotions")
	ResetHasItemOfType()
	ClearPotionLists()
	ClearPoisonLists()
	_refreshedItemCount = 0
	
	_totalItemCount = _Q2C_Functions.GetNumItemsOfType(MyActor, 46)
	
	int handleCounted = ModEvent.Create("_FPP_Event_FollowerPotionsCounted")
	if (handleCounted)
		ModEvent.PushString(handleCounted, MyActorName)
		ModEvent.PushInt(handleCounted, _totalItemCount)
		ModEvent.Send(handleCounted)
	endIf
	
	int iFormIndex = 0
	if (_totalItemCount > 0)
		iFormIndex = 0
		While iFormIndex < _totalItemCount
			Potion foundPotion = _Q2C_Functions.GetNthFormOfType(MyActor, 46, iFormIndex) as Potion
			if (foundPotion != None)
				int potionCount = MyActor.GetItemCount(foundPotion)
				IdentifyPotionThreadManager.IdentifyPotionAsync(false, DebugToFile, MyActorName, foundPotion, potionCount, EffectKeywords, RestoreEffects, FortifyEffectsStats, FortifyEffectsWarrior, FortifyEffectsMage, ResistEffects, PoisonEffectsStats, PoisonEffectsWeakness, PoisonEffectsGeneric, IdentifyPotionEffects, C_IDENTIFY_RESTORE, C_IDENTIFY_FORTIFY, C_IDENTIFY_RESIST, C_IDENTIFY_FIRST, C_IDENTIFY_SECOND, C_IDENTIFY_THIRD)
			endIf
			iFormIndex += 1
		EndWhile
		AliasDebug("RefreshPotions - Complete, " + _totalItemCount + " potions found and all queued, waiting on _FPP_Callback_PotionIdentified event(s)")
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

function HandleCombatStateChange(string asState, Actor akTarget)
	string msg = asState + "::HandleCombatStateChange - "
	if (IsIncapacitated())
		;if incapacitated, not much point going further
		AliasDebug(msg + "incapacitated")
		IgnoreCombatStateEvents = false
		return
	endIf
	
	int enemyLevel = akTarget.GetLevel()
	EnemyRace = akTarget.GetRace()
	EnemyIsBoss = akTarget.HasRefType(LocRefTypeBoss)
	EnemyLvlDiff = enemyLevel - MyActor.GetLevel()
	int lhItem = MyActor.GetEquippedItemType(C_HAND_LEFT)
	int rhItem = MyActor.GetEquippedItemType(1)
	
	msg += "combat with level " + enemyLevel + " " + EnemyRace.GetName()
	if (EnemyIsBoss)
		msg += " boss"
	endIf
	msg += " " + akTarget.GetLeveledActorBase().GetName() + " (diff " + EnemyLvlDiff + ", trigger " + LvlDiffTrigger + "); LH: " + lhItem + ", RH: " + rhItem + " - "
	
	if (ShouldUseCombatPoisons(lhItem, rhItem))
		AliasDebug3(msg + "use poisons")
		if (AttemptPoisonChain(asState + "::HandleCombatStateChange", C_HAND_RIGHT, rhItem, true))
			Utility.Wait(1)
		endIf
		AttemptPoisonChain(asState + "::HandleCombatStateChange", C_HAND_LEFT, lhItem, true)
	else
		AliasDebug3(msg + "not enough to use poisons")
	endIf
	
	if (ShouldUseCombatPotions())
		AliasDebug(msg + "use potions")
		; chain these ones as an AND, since you want to keep going through (using potions)
		; until any one returns false (ie because you're not in combat any more)
		UseCombatPotionsFortifyStats(asState + "::HandleCombatStateChange") \
			&& UseCombatPotionsWarrior(asState + "::HandleCombatStateChange", lhItem, rhItem) \
			&& UseCombatPotionsMage(asState + "::HandleCombatStateChange") \
			&& UseCombatPotionsResist(asState + "::HandleCombatStateChange", akTarget)
	else
		AliasDebug(msg + "not enough to use potions")
	endIf
	IgnoreCombatStateEvents = false
endFunction

bool function ShouldUseCombatPoisons(int aiLHItem, int aiRHItem)
	return true
endFunction
bool function ShouldUseCombatPoisonsOnUpdate(int aiLHItem, int aiRHItem)
	return true
endFunction

bool function ShouldUseCombatPotions()
	; simplest check first
	if (EnemyLvlDiff > LvlDiffTrigger)
		return true
	endIf
	int i = AvailableTriggerRaces.Find(EnemyRace)
	if (i < 0)
		return false
	endIf
	return TriggerRaces[TriggerRaceMappings[i]]
endFunction

bool function AttemptPoisonChain(string asState, int aiHand, int aiEquippedItemType, bool abOnEngage)
	if (!EquippedItemPoisonable(aiHand, aiEquippedItemType))
		AliasDebug3(asState + "::AttemptPoisonChain - " + GetHand(aiHand) + " is empty")
		return false
	endIf
	if (WornObject.GetPoison(MyActor, aiHand, 0) != None)
		AliasDebug3(asState + "::AttemptPoisonChain - " + MyActor.GetEquippedWeapon(aiHand == C_HAND_LEFT).GetName() + " in " + GetHand(aiHand) + " already poisoned")
		return false
	endIf

	; by chaining these as an inline, it avoids needless calls to subsequent functions 
	; if any one returns true (ie because you've used a poison)
	if (UseCombatPoisonsDamageStats(asState + "::AttemptPoisonChain", aiHand) \
		|| UseCombatPoisonsWeaknessMagic(asState + "::AttemptPoisonChain", aiHand) \
		|| UseCombatPoisonsGeneric(asState + "::AttemptPoisonChain", aiHand))
		AliasDebug3(asState + "::AttemptPoisonChain (" + MyTotalPoisonCount + " poisons) - used poison for " + GetHand(aiHand))
		return true
	endIf
	AliasDebug3(asState + "::AttemptPoisonChain (" + MyTotalPoisonCount + " poisons) - didn't use poisons for " + GetHand(aiHand))
	return false
endFunction

bool function EquippedItemPoisonable(int aiHand, int aiEquippedItemType)
	bool is1H = is1HItem(aiEquippedItemType)
	if (aiHand == C_HAND_LEFT) ; left hand
		return is1H
	elseIf (aiHand == 1) ; right hand
		return is1H || is2HItem(aiEquippedItemType) || isBowItem(aiEquippedItemType)
	endIf
	return false
endFunction

bool function UseCombatPoisonsDamageStats(string asState, int aiHand)
	int i = PoisonEffectsStats.Length
	while (i)
		i -= 1
		if (UsePoisonIfPossible(asState + "::UseCombatPoisonsDamageStats", PoisonEffectsStats[i], new Potion[1], aiHand))
			return true
		endIf
	endWhile
	return false
endFunction

bool function UseCombatPoisonsWeaknessMagic(string asState, int aiHand)
	int i = PoisonEffectsWeakness.Length
	while (i)
		i -= 1
		if (UsePoisonIfPossible(asState + "::UseCombatPoisonsWeaknessMagic", PoisonEffectsWeakness[i], new Potion[1], aiHand))
			return true
		endIf
	endWhile
	return false
endFunction

bool function UseCombatPoisonsGeneric(string asState, int aiHand)
	int i = PoisonEffectsGeneric.Length
	while (i)
		i -= 1
		if (UsePoisonIfPossible(asState + "::UseCombatPoisonsGeneric", PoisonEffectsGeneric[i], new Potion[1], aiHand))
			return true
		endIf
	endWhile
	return false
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
		if (UsePotionOfType[FortifyEffectsStats[i]] && UsePotionIfPossible(asState + "::UseCombatPotionsFortifyStats", FortifyEffectsStats[i], new Potion[1]))
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
		&& (isShieldItem(aiLHItem) || isShieldItem(aiRHItem)) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", EFFECT_FORTIFYBLOCK, potionListFortifyBlock))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYHEAVYARMOR] \
		&& MyActor.WornHasKeyword(KeywordArmorHeavy) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", EFFECT_FORTIFYHEAVYARMOR, potionListFortifyHeavyArmor))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYLIGHTARMOR] \
		&& MyActor.WornHasKeyword(KeywordArmorLight) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", EFFECT_FORTIFYLIGHTARMOR, potionListFortifyLightArmor))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYMARKSMAN] \
		&& (isBowItem(aiLHItem) || isBowItem(aiRHItem)) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", EFFECT_FORTIFYMARKSMAN, potionListFortifyMarksman))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYONEHANDED] \
		&& (is1HItem(aiLHItem) || is1HItem(aiRHItem)) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", EFFECT_FORTIFYONEHANDED, potionListFortifyOneHanded))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYTWOHANDED] \
		&& (is2HItem(aiLHItem) || is2HItem(aiRHItem)) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", EFFECT_FORTIFYTWOHANDED, potionListFortifyTwoHanded))
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
		&& _Q2C_Functions.ActorHasSpell(MyActor, None, _Q2C_Functions.SpellSchoolAlteration()) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsMage", EFFECT_FORTIFYALTERATION, potionListFortifyAlteration))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYCONJURATION] \
		&& _Q2C_Functions.ActorHasSpell(MyActor, None, _Q2C_Functions.SpellSchoolConjuration()) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsMage", EFFECT_FORTIFYCONJURATION, potionListFortifyConjuration))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYDESTRUCTION] \
		&& _Q2C_Functions.ActorHasSpell(MyActor, None, _Q2C_Functions.SpellSchoolDestruction()) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsMage", EFFECT_FORTIFYDESTRUCTION, potionListFortifyDestruction))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYILLUSION] \
		&& _Q2C_Functions.ActorHasSpell(MyActor, None, _Q2C_Functions.SpellSchoolIllusion()) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsMage", EFFECT_FORTIFYILLUSION, potionListFortifyIllusion))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_FORTIFYRESTORATION] \
		&& _Q2C_Functions.ActorHasSpell(MyActor, None, _Q2C_Functions.SpellSchoolRestoration()) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsMage", EFFECT_FORTIFYRESTORATION, potionListFortifyRestoration))
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
	
	ActorBase akTargetBase = aktarget.GetLeveledActorBase()
	
	bool hasFire = _Q2C_Functions.ActorHasSpell(akTarget, MagicDamageFire) || _Q2C_Functions.ActorBaseHasShout(akTargetBase, MagicDamageFire)
	if (UsePotionOfType[EFFECT_RESISTFIRE] \
		&& (hasFire) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsResist", EFFECT_RESISTFIRE, potionListResistFire))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	bool hasFrost = _Q2C_Functions.ActorHasSpell(akTarget, MagicDamageFrost) || _Q2C_Functions.ActorBaseHasShout(akTargetBase, MagicDamageFrost)
	if (UsePotionOfType[EFFECT_RESISTFROST] \
		&& (hasFrost) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsResist", EFFECT_RESISTFROST, potionListResistFrost))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	bool hasShock = _Q2C_Functions.ActorHasSpell(akTarget, MagicDamageShock) || _Q2C_Functions.ActorBaseHasShout(akTargetBase, MagicDamageShock)
	if (UsePotionOfType[EFFECT_RESISTSHOCK] \
		&& (hasShock) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsResist", EFFECT_RESISTSHOCK, potionListResistShock))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_RESISTMAGIC] \
		&& (hasFire || hasFrost || hasShock) \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsResist", EFFECT_RESISTMAGIC, potionListResistMagic))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	if (UsePotionOfType[EFFECT_RESISTPOISON] \
		&& UsePotionIfPossible(asState + "::UseCombatPotionsResist", EFFECT_RESISTPOISON, potionListResistPoison))
		Utility.Wait(1)
		if (!MyActor.IsInCombat())
			AliasDebug(msgNofight)
			return false
		endIf
	endIf
	
	return true
endFunction

Function RegisterPotion(Potion akPotion, int aiPotionCount, int aiEffectType)
	Potion[] potionList = GetPotionList(aiEffectType)
	if (potionList.Length == 1)
		AliasDebug2("RegisterPotion - can't determine array for effect " + aiEffectType)
		return
	endIf
	int newTotal = 0
	int potionIndex = potionList.Find(akPotion)
	if (potionIndex < 0)
		int freeIndex = potionList.Find(None)
		if (freeIndex > -1)
			potionList[freeIndex] = akPotion
			newTotal = HasItemOfType[aiEffectType] + aiPotionCount
			HasItemOfType[aiEffectType] = newTotal
			;if (DebugToFile)
				AliasDebug2("RegisterPotion - Added " + aiPotionCount + "x " + akPotion.GetName() + " (Id " + akPotion.GetFormId() + ") to array" + aiEffectType + "[" + freeIndex + "], total " + newTotal + " for this effect")
			;endIf
		else
			AliasDebug("", MyActorName + " - can't add " + akPotion.GetName() + " potion; no more room for this type of potion!", true)
			if (DebugToFile)
				AliasDebug("RegisterPotion - No more room in potions array for " + akPotion.GetName() + "! (Id " + akPotion.GetFormId() + ") - tried to add to array" + aiEffectType)
			endIf
		endIf
	else
		newTotal = HasItemOfType[aiEffectType] + aiPotionCount
		HasItemOfType[aiEffectType] = newTotal
		;if (DebugToFile)
			AliasDebug2("RegisterPotion - Increased " + aiPotionCount + "x " + akPotion.GetName() + " (Id " + akPotion.GetFormId() + ") in array" + aiEffectType + "[" + potionIndex + "], total " + newTotal + " for this effect")
		;endIf
	endIf
endFunction

Function UpdateItemCounts(string asActorName, int aiEffectsFound, bool abIsPoison, int aiItemCount)
	if (asActorName != MyActorName)
		;AliasDebug("HaveNoPotions::OnPotionIdentified - for " + asActorName + ", not me!")
		return
	endIf
	if (aiEffectsFound < 1)
		return
	endIf
	if (abIsPoison)
		AliasDebug3("UpdateItemCounts - found " + aiEffectsFound + ", increment MyTotalPoisonCount by " + aiItemCount)
		MyTotalPoisonCount += aiItemCount
	else
		AliasDebug2("UpdateItemCounts - found " + aiEffectsFound + ", increment MyTotalPotionCount by " + aiItemCount)
		MyTotalPotionCount += aiItemCount
	endIf
endFunction

bool function UsePotionIfPossible(string asState, int aiEffectType, Potion[] akPotionList)
	string effectName = EffectNames[aiEffectType]
	string msg = asState + "::UsePotionIfPossible (" + aiEffectType + ": " + effectName + ") - "
	bool potionUsed = false
	if (HasItemOfType[aiEffectType] < 1)
		WarnNoPotions(asState + "::UsePotionIfPossible", aiEffectType, effectName)
		msg += "no " + effectName + " potions"
	elseif (IsInCooldown(aiEffectType))
		msg += effectName + " potion still taking effect"
	else
		if (akPotionList.Length == 1)
			akPotionList = GetPotionList(aiEffectType)
		endIf
		if (akPotionList.Length == 1)
			return false
		endIf
		bool potionWorked = TryFirstPotionThatExists(asState, aiEffectType, akPotionList)
		if (potionWorked)
			msg += "used " + effectName  + " potion from array" + aiEffectType
			potionUsed = true
		else
			WarnNoPotions(asState + "::UsePotionIfPossible", aiEffectType, effectName)
			msg += "no " + effectName  + " potions"
		endIf
	endIf
	AliasDebug(msg)
	return potionUsed
endFunction

bool function UsePoisonIfPossible(string asState, int aiEffectType, Potion[] akPotionList, int aiHand)
	string effectName = EffectNames[aiEffectType]
	string msg = asState + "::UsePoisonIfPossible (" + aiEffectType + ": " + effectName + ") - "
	bool poisonUsed = false
	if (HasItemOfType[aiEffectType] < 1)
		; nothing to use
		msg += "no " + effectName + " poisons"
		AliasDebug3(msg)
		return poisonUsed
	endIf
	if (akPotionList.Length == 1)
		akPotionList = GetPotionList(aiEffectType)
	endIf
	if (akPotionList.Length == 1)
		return poisonUsed
	endIf
	bool poisonWorked = TryFirstPoisonThatExists(asState, aiEffectType, akPotionList, aiHand)
	if (poisonWorked)
		msg += "used " + effectName  + " poison from array" + aiEffectType
		;AliasDebug3(msg)
		poisonUsed = true
	else
		msg += "failed to use " + effectName  + " poison"
		AliasDebug3(msg)
	endIf
	return poisonUsed
endFunction

function WarnNoPotions(string asState, int aiEffectType, string asEffectName)
	int index
	string potionName
	if (RestoreEffects.Find(aiEffectType) > -1)
		index = aiEffectType
		potionName = asEffectName
	elseif (FortifyEffectsStats.Find(aiEffectType) > -1 || FortifyEffectsWarrior.Find(aiEffectType) > -1 || FortifyEffectsMage.Find(aiEffectType) > -1)
		index = 3
		potionName = "Fortify"
	elseif (ResistEffects.Find(aiEffectType) > -1)
		index = 4
		potionName = "Resist"
	endIf
	if (!EnableWarnings[index])
		AliasDebug(asState + "::WarnNoPotions - warnings disabled for " + asEffectName + " potions")
		return
	endif
	MyPotionWarningCounts[index] = MyPotionWarningCounts[index] + 1
	float currentHoursPassed = Game.GetRealHoursPassed()
	float nextWarning = MyPotionWarningTimes[index] + (WarningIntervals[index] / 3600.0)
	if (MyPotionWarningCounts[index] >= MyPotionWarningTriggers[index] && currentHoursPassed >= nextWarning)
		AliasDebug(asState + "::WarnNoPotions - " + potionName + " potion warning updated to " + currentHoursPassed, MyActorName + " needs more " + potionName + " potions!", false)
		MyPotionWarningCounts[index] = 0
		MyPotionWarningTimes[index] = currentHoursPassed
	else
		AliasDebug(asState + "::WarnNoPotions - no " + asEffectName + " potions (warning " + MyPotionWarningCounts[index] + ", last warning " + MyPotionWarningTimes[index] + ", currently " + currentHoursPassed + ", next " + nextWarning + ")")
	endif
endFunction

bool function IsInCooldown(int aiEffectType)
	if (!EffectKeywords[aiEffectType])
		return false
	endIf
	return MyActor.HasEffectKeyword(EffectKeywords[aiEffectType])
endFunction

bool Function HasAnyPotions()
	return MyTotalPotionCount > 0
endFunction
bool Function HasAnyPoisons()
	return MyTotalPoisonCount > 0
endFunction

bool function IsIncapacitated()
	; NKO uses paralysis for KO'd followers - but then, being paralysed should be enough to stop you using potions anyway..
	return MyActor.GetActorValue("Paralysis") > 0 || MyActor.IsUnconscious()
endFunction

bool function TryFirstPotionThatExists(string asState, int aiEffectType, Potion[] akPotionList)
	int potionIndex = 0
	while (potionIndex < akPotionList.Length)
		Potion thisPotion = akPotionList[potionIndex] as Potion
		string msg = asState + "::TryFirstPotionThatExists - array" + aiEffectType + "[" + potionIndex + "]"
		if (thisPotion != None)
			int potionCount = MyActor.GetItemCount(thisPotion)
			msg += ", have " + potionCount + " (of " + HasItemOfType[aiEffectType] + ")"
			if (potionCount > 0)
				MyActor.EquipItem(thisPotion, false, true)
				UpdateCountsAndArrays(thisPotion, 1, potionCount == 1)
				MyTotalPotionCount -= 1
				msg += ", use " + thisPotion.GetName() + " (" + thisPotion.GetFormId() + "), " + (potionCount - 1) + " remaining"
				AliasDebug2(msg)
				return true
			else
				UpdateCountsAndArrays(thisPotion, 0, true)
				AliasDebug2(msg + " - removed from arrays")
			endif
		endif
		potionIndex += 1
	endWhile
	return false
endFunction

bool function TryFirstPoisonThatExists(string asState, int aiEffectType, Potion[] akPotionList, int aiHand)
	int poisonIndex = 0
	while (poisonIndex < akPotionList.Length)
		Potion thisPoison = akPotionList[poisonIndex] as Potion
		; some poisons (eg venoms) do not actually have MagicAlchHarmful, only VendorItemPoison.
		; That isn't technically an effect type, but for purposes of the mod, all generic poisons
		; are registered as having it. So if we're testing for it here, convert to sending -1,
		; so the TryFirstPoisonThatExists function will bypass testing for the specific keyword
		int passedEffectType = aiEffectType
		if (aiEffectType == EFFECT_HARMFUL)
			passedEffectType = -1
		endIf
		string msg = asState + "::TryFirstPoisonThatExists - array" + aiEffectType + "[" + poisonIndex + "]"
		if (thisPoison != None && (passedEffectType < 0 || thisPoison.HasKeyword(EffectKeywords[aiEffectType])))
			int poisonCount = MyActor.GetItemCount(thisPoison)
			msg += ", have " + poisonCount + " (of " + HasItemOfType[aiEffectType] + ")"
			if (poisonCount > 0)
				msg += ", try use " + thisPoison.GetName() + " poison on " + MyActor.GetEquippedWeapon(aiHand == C_HAND_LEFT).GetName() + " in " + GetHand(aiHand) + ": "
				int ret = _Q2C_Functions.WornObjectSetPoison(MyActor, aiHand, 0, thisPoison, 1)
				if (ret < 0)
					msg += "fail (for unknown reason)"
					AliasDebug3(msg)
				else
					MyActor.RemoveItem(thisPoison)
					UpdateCountsAndArrays(thisPoison, 1, poisonCount == 1)
					MyTotalPoisonCount -= 1
					msg += "success, " + (poisonCount - 1) + " remaining"
					AliasDebug3(msg)
					return true
				endIf
			else
				UpdateCountsAndArrays(thisPoison, 0, true)
				AliasDebug3(msg + " - removed from arrays")
			endIf
		endIf
		poisonIndex += 1
	endWhile
	return false
endFunction

bool function isShieldItem(int aiItemType)
	return aiItemType == C_ITEM_SHIELD
endFunction
bool function is1HItem(int aiItemType)
	return aiItemType == C_ITEM_1H_SWORD || aiItemType == C_ITEM_1H_DAGGER || aiItemType == C_ITEM_1H_AXE || aiItemType == C_ITEM_1H_MACE
endFunction
bool function is2HItem(int aiItemType)
	return aiItemType == C_ITEM_2H_SWORD || aiItemType == C_ITEM_2H_AXE_MACE
endFunction
bool function isBowItem(int aiItemType)
	return aiItemType == C_ITEM_BOW || aiItemType == C_ITEM_CROSSBOW
endFunction

Function ShowInfo()
	if (!MyActor)
		return
	endIf
	string msg = "State: " + GetState() + "\n"
	msg += "Total potions: " + MyTotalPotionCount + "\n"
	msg += "Total poisons: " + MyTotalPoisonCount + "\n"
	msg += "\n"
	msg += "Restore Potions: " + GetPotionReport(potionListRestoreHealth) + GetPotionReport(potionListRestoreStamina) + GetPotionReport(potionListRestoreMagicka)
	msg += "\n"
;	msg += "Fortify Potions: " + GetPotionReport(MyFortifyPotions)
	msg += "\n"
;	msg += "Resist Potions: " + GetPotionReport(MyResistPotions)
	msg += "\n\n"
	msg += "Poisons: " + GetPotionReport(potionListDamageHealth) + GetPotionReport(potionListDamageStamina) + GetPotionReport(potionListDamageMagicka) + GetPotionReport(potionListHarmful)
	AliasDebug2(msg)
	Debug.MessageBox(MyActorName + "\n" + msg)
endFunction

string Function GetPotionReport(Potion[] akPotionList)
	int i = akPotionList.Length
	string potionReport = ""
	while (i)
		i -= 1
		Potion thisPotion = akPotionList[i]
		if (thisPotion)
			potionReport += thisPotion.GetName() + " (" + MyActor.GetItemCount(thisPotion) + "); "
		endIf
	endWhile
	return potionReport
endFunction


Potion[] function GetPotionList(int aiEffectType)
	if (aiEffectType == EFFECT_RESTOREHEALTH)
		return potionListRestoreHealth
	elseIf (aiEffectType == EFFECT_RESTORESTAMINA)
		return potionListRestoreStamina
	elseIf (aiEffectType == EFFECT_RESTOREMAGICKA)
		return potionListRestoreMagicka
	elseIf (aiEffectType == EFFECT_FORTIFYHEALTH)
		return potionListFortifyHealth
	elseIf (aiEffectType == EFFECT_FORTIFYHEALRATE)
		return potionListFortifyHealRate
	elseIf (aiEffectType == EFFECT_FORTIFYMAGICKA)
		return potionListFortifyMagicka
	elseIf (aiEffectType == EFFECT_FORTIFYMAGICKARATE)
		return potionListFortifyMagickaRate
	elseIf (aiEffectType == EFFECT_FORTIFYSTAMINA)
		return potionListFortifyStamina
	elseIf (aiEffectType == EFFECT_FORTIFYSTAMINARATE)
		return potionListFortifyStaminaRate
	elseIf (aiEffectType == EFFECT_FORTIFYBLOCK)
		return potionListFortifyBlock
	elseIf (aiEffectType == EFFECT_FORTIFYHEAVYARMOR)
		return potionListFortifyHeavyArmor
	elseIf (aiEffectType == EFFECT_FORTIFYLIGHTARMOR)
		return potionListFortifyLightArmor
	elseIf (aiEffectType == EFFECT_FORTIFYMARKSMAN)
		return potionListFortifyMarksman
	elseIf (aiEffectType == EFFECT_FORTIFYONEHANDED)
		return potionListFortifyOneHanded
	elseIf (aiEffectType == EFFECT_FORTIFYTWOHANDED)
		return potionListFortifyTwoHanded
	elseIf (aiEffectType == EFFECT_FORTIFYALTERATION)
		return potionListFortifyAlteration
	elseIf (aiEffectType == EFFECT_FORTIFYCONJURATION)
		return potionListFortifyConjuration
	elseIf (aiEffectType == EFFECT_FORTIFYDESTRUCTION)
		return potionListFortifyDestruction
	elseIf (aiEffectType == EFFECT_FORTIFYILLUSION)
		return potionListFortifyIllusion
	elseIf (aiEffectType == EFFECT_FORTIFYRESTORATION)
		return potionListFortifyRestoration
	elseIf (aiEffectType == EFFECT_RESISTFIRE)
		return potionListResistFire
	elseIf (aiEffectType == EFFECT_RESISTFROST)
		return potionListResistFrost
	elseIf (aiEffectType == EFFECT_RESISTMAGIC)
		return potionListResistMagic
	elseIf (aiEffectType == EFFECT_RESISTPOISON)
		return potionListResistPoison
	elseIf (aiEffectType == EFFECT_RESISTSHOCK)
		return potionListResistShock
	elseIf (aiEffectType == EFFECT_DAMAGEHEALTH)
		return potionListDamageHealth
	elseIf (aiEffectType == EFFECT_DAMAGEMAGICKA)
		return potionListDamageMagicka
	elseIf (aiEffectType == EFFECT_DAMAGESTAMINA)
		return potionListDamageStamina
	elseIf (aiEffectType == EFFECT_WEAKNESSFIRE)
		return potionListWeaknessFire
	elseIf (aiEffectType == EFFECT_WEAKNESSFROST)
		return potionListWeaknessFrost
	elseIf (aiEffectType == EFFECT_WEAKNESSSHOCK)
		return potionListWeaknessShock
	elseIf (aiEffectType == EFFECT_WEAKNESSMAGIC)
		return potionListWeaknessMagic
	elseIf (aiEffectType == EFFECT_HARMFUL)
		return potionListHarmful
	endIf
	AliasDebug2("Can't find list for " + aiEffectType + ", return empty")
	return new Potion[1]
endFunction

int function UpdateCountsAndArrays(Potion akPotion, int aiCount, bool abSetToNone)
float ftimeStart = Utility.GetCurrentRealTime()
	int affected = 0
	
	affected += UpdateCountAndArray(potionListRestoreHealth, akPotion, EFFECT_RESTOREHEALTH, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListRestoreStamina, akPotion, EFFECT_RESTORESTAMINA, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListRestoreMagicka, akPotion, EFFECT_RESTOREMAGICKA, aiCount, abSetToNone)
	
	affected += UpdateCountAndArray(potionListFortifyHealth, akPotion, EFFECT_FORTIFYHEALTH, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyHealRate, akPotion, EFFECT_FORTIFYHEALRATE, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyStamina, akPotion, EFFECT_FORTIFYSTAMINA, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyStaminaRate, akPotion, EFFECT_FORTIFYSTAMINARATE, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyMagicka, akPotion, EFFECT_FORTIFYMAGICKA, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyMagickaRate, akPotion, EFFECT_FORTIFYMAGICKARATE, aiCount, abSetToNone)
	
	affected += UpdateCountAndArray(potionListFortifyBlock, akPotion, EFFECT_FORTIFYBLOCK, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyHeavyArmor, akPotion, EFFECT_FORTIFYHEAVYARMOR, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyLightArmor, akPotion, EFFECT_FORTIFYLIGHTARMOR, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyMarksman, akPotion, EFFECT_FORTIFYMARKSMAN, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyOneHanded, akPotion, EFFECT_FORTIFYONEHANDED, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyTwoHanded, akPotion, EFFECT_FORTIFYTWOHANDED, aiCount, abSetToNone)

	affected += UpdateCountAndArray(potionListFortifyAlteration, akPotion, EFFECT_FORTIFYALTERATION, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyConjuration, akPotion, EFFECT_FORTIFYCONJURATION, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyDestruction, akPotion, EFFECT_FORTIFYDESTRUCTION, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyIllusion, akPotion, EFFECT_FORTIFYILLUSION, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListFortifyRestoration, akPotion, EFFECT_FORTIFYRESTORATION, aiCount, abSetToNone)

	affected += UpdateCountAndArray(potionListResistFire, akPotion, EFFECT_RESISTFIRE, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListResistFrost, akPotion, EFFECT_RESISTFROST, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListResistShock, akPotion, EFFECT_RESISTSHOCK, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListResistMagic, akPotion, EFFECT_RESISTMAGIC, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListResistPoison, akPotion, EFFECT_RESISTPOISON, aiCount, abSetToNone)

	affected += UpdateCountAndArray(potionListDamageHealth, akPotion, EFFECT_DAMAGEHEALTH, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListDamageStamina, akPotion, EFFECT_DAMAGESTAMINA, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListDamageMagicka, akPotion, EFFECT_DAMAGEMAGICKA, aiCount, abSetToNone)

	affected += UpdateCountAndArray(potionListWeaknessFire, akPotion, EFFECT_WEAKNESSFIRE, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListWeaknessFrost, akPotion, EFFECT_WEAKNESSFROST, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListWeaknessShock, akPotion, EFFECT_WEAKNESSSHOCK, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListWeaknessMagic, akPotion, EFFECT_WEAKNESSMAGIC, aiCount, abSetToNone)
	affected += UpdateCountAndArray(potionListHarmful, akPotion, EFFECT_HARMFUL, aiCount, abSetToNone)

float ftimeEnd = Utility.GetCurrentRealTime()
AliasDebug2("UpdateCountsAndArrays: " + (ftimeEnd - ftimeStart) + "s")
	return affected
endFunction

int function UpdateCountAndArray(Potion[] akPotionList, Potion akPotion, int aiEffect, int aiCount, bool abSetToNone)
	int i = akPotionList.Find(akPotion)
	if (i < 0)
		return 0
	endIf
	HasItemOfType[aiEffect] = HasItemOfType[aiEffect] - aiCount
	if (HasItemOfType[aiEffect] < 0)
		HasItemOfType[aiEffect] = 0
	endIf
	if (HasItemOfType[aiEffect] == 0 || abSetToNone)
		akPotionList[i] = None
		AliasDebug2("Set array" + aiEffect + "[" + i + "] to None")
	endIf
	return 1
endFunction

Function SetProperties()
{set all internal properties, to avoid halting the thread when looking them up}

	C_SCHOOL_ALTERATION = FPPQuest.C_SCHOOL_ALTERATION
	C_SCHOOL_CONJURATION = FPPQuest.C_SCHOOL_CONJURATION
	C_SCHOOL_DESTRUCTION = FPPQuest.C_SCHOOL_DESTRUCTION
	C_SCHOOL_ILLUSION = FPPQuest.C_SCHOOL_ILLUSION
	C_SCHOOL_RESTORATION = FPPQuest.C_SCHOOL_RESTORATION

	C_IDENTIFY_RESTORE = FPPQuest.C_IDENTIFY_RESTORE
	C_IDENTIFY_FORTIFY = FPPQuest.C_IDENTIFY_FORTIFY
	C_IDENTIFY_RESIST = FPPQuest.C_IDENTIFY_RESIST
	C_IDENTIFY_FIRST = FPPQuest.C_IDENTIFY_FIRST
	C_IDENTIFY_SECOND = FPPQuest.C_IDENTIFY_SECOND
	C_IDENTIFY_THIRD = FPPQuest.C_IDENTIFY_THIRD

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

	C_HAND_LEFT = FPPQuest.C_HAND_LEFT
	C_HAND_RIGHT = FPPQuest.C_HAND_RIGHT

	EFFECT_RESTOREHEALTH = FPPQuest.EFFECT_RESTOREHEALTH
	EFFECT_RESTORESTAMINA = FPPQuest.EFFECT_RESTORESTAMINA
	EFFECT_RESTOREMAGICKA = FPPQuest.EFFECT_RESTOREMAGICKA
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
	
	PoisonEffectsStats = FPPQuest.PoisonEffectsStats
	PoisonEffectsWeakness = FPPQuest.PoisonEffectsWeakness
	PoisonEffectsGeneric = FPPQuest.PoisonEffectsGeneric
	
	KeywordPotion = FPPQuest.VendorItemPotion
	KeywordPoison = FPPQuest.VendorItemPoison
	
	KeywordArmorHeavy = FPPQuest.ArmorHeavy
	KeywordArmorLight = FPPQuest.ArmorLight
	
	MagicDamageFire = FPPQuest.MagicDamageFire
	MagicDamageFrost = FPPQuest.MagicDamageFrost
	MagicDamageShock = FPPQuest.MagicDamageShock

	LocRefTypeBoss = FPPQuest.LocRefTypeBoss

	AvailableTriggerRaces = FPPQuest.AvailableTriggerRaces
	TriggerRaceMappings = FPPQuest.TriggerRaceMappings

	DebugToFile = FPPQuest.DebugToFile
endFunction

Function SetDefaults()
	UpdateIntervalInCombat = FPPQuest.DefaultUpdateIntervalInCombat
	UpdateIntervalNonCombat = FPPQuest.DefaultUpdateIntervalNonCombat
	UpdateIntervalNoPotions = FPPQuest.DefaultUpdateIntervalNoPotions

	EnableWarnings = FPPQuest.GetDefaultEnableWarnings()
	WarningIntervals = FPPQuest.GetDefaultWarningIntervals()

	StatLimitsInCombat = FPPQuest.GetDefaultStatLimits(true)
	StatLimitsNonCombat = FPPQuest.GetDefaultStatLimits(false)

	LvlDiffTrigger = FPPQuest.DefaultLvlDiffTrigger as int
	TriggerRaces = FPPQuest.GetDefaultTriggerRaces()

	UsePotionOfType = FPPQuest.GetDefaultUsePotionsOfTypes()
	
	IdentifyPotionEffects = FPPQuest.DefaultIdentifyPotionEffects
	
	ResetPotionWarningTriggers()
	ResetHasItemOfType()
endFunction

Function ResetPotionWarningTriggers()
	MyPotionWarningTriggers = Utility.CreateIntArray(5, 10)
endFunction

Function ResetHasItemOfType()
	HasItemOfType = Utility.CreateIntArray(EffectKeywords.Length, 0)
endFunction

Function ClearPotionLists()
	potionListRestoreHealth = new Potion[127]
	potionListRestoreStamina = new Potion[127]
	potionListRestoreMagicka = new Potion[127]
	potionListFortifyHealth = new Potion[127]
	potionListFortifyHealRate = new Potion[127]
	potionListFortifyMagicka = new Potion[127]
	potionListFortifyMagickaRate = new Potion[127]
	potionListFortifyStamina = new Potion[127]
	potionListFortifyStaminaRate = new Potion[127]
	potionListFortifyBlock = new Potion[127]
	potionListFortifyHeavyArmor = new Potion[127]
	potionListFortifyLightArmor = new Potion[127]
	potionListFortifyMarksman = new Potion[127]
	potionListFortifyOneHanded = new Potion[127]
	potionListFortifyTwoHanded = new Potion[127]
	potionListFortifyAlteration = new Potion[127]
	potionListFortifyConjuration = new Potion[127]
	potionListFortifyDestruction = new Potion[127]
	potionListFortifyIllusion = new Potion[127]
	potionListFortifyRestoration = new Potion[127]
	potionListResistFire = new Potion[127]
	potionListResistFrost = new Potion[127]
	potionListResistMagic = new Potion[127]
	potionListResistPoison = new Potion[127]
	potionListResistShock = new Potion[127]
endFunction

Function ClearPoisonLists()
	potionListDamageHealth = new Potion[127]
	potionListDamageStamina = new Potion[127]
	potionListDamageMagicka = new Potion[127]
	potionListWeaknessFire = new Potion[127]
	potionListWeaknessFrost = new Potion[127]
	potionListWeaknessShock = new Potion[127]
	potionListWeaknessMagic = new Potion[127]
	potionListHarmful = new Potion[127]
endFunction

string function GetStringPercentage(string asActorValue)
	return ((MyActor.GetActorValuePercentage(asActorValue) * 100) as int) + "%"
endFunction

string function GetHand(int aiHand)
	if (aiHand == C_HAND_LEFT)
		return "left hand"
	elseIf (aiHand == C_HAND_RIGHT)
		return "right hand"
	endIf
	return "unknown hand"
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

function AliasDebug2(string asLogMsg, string asScreenMsg = "", bool abFpPrefix = false)
	if (asLogMsg != "")
		Debug.TraceUser("FollowerPotions", MyActorName + ": " + asLogMsg)
	endIf
	if (asScreenMsg != "")
		if (abFpPrefix)
			asScreenMsg = "Follower Potions - " + asScreenMsg
		endIf
		Debug.Notification(asScreenMsg)
	endIf
endFunction

function AliasDebug3(string asLogMsg, string asScreenMsg = "", bool abFpPrefix = false)
	if (asLogMsg != "")
		Debug.TraceUser("FollowerPoisons", MyActorName + ": " + asLogMsg)
	endIf
	if (asScreenMsg != "")
		if (abFpPrefix)
			asScreenMsg = "Follower Poisons - " + asScreenMsg
		endIf
		Debug.Notification(asScreenMsg)
	endIf
endFunction
