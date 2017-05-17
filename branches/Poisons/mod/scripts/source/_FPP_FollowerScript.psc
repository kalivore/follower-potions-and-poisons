Scriptname _FPP_FollowerScript extends ReferenceAlias  
{handles all events and functions on a follower}

; fundamental internal state properties
string MyName
int MyIndex
_FPP_Quest FPPQuest

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
int EFFECT_PARALYSIS
int EFFECT_SLOW
int EFFECT_FEAR
int EFFECT_FRENZY
int EFFECT_SILENCE
int EFFECT_FATIGUE
int EFFECT_DRAININTELLIGENCE
int EFFECT_DRAINSTRENGTH

Keyword[] EffectKeywords
string[] EffectNames

int[] RestoreEffects
int[] FortifyEffectsStats
int[] FortifyEffectsWarrior
int[] FortifyEffectsMage
int[] ResistEffects

int[] PoisonEffectsSpecial
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
bool[] potionListRestoreHealth
bool[] potionListRestoreStamina
bool[] potionListRestoreMagicka
bool[] potionListFortifyHealth
bool[] potionListFortifyHealRate
bool[] potionListFortifyMagicka
bool[] potionListFortifyMagickaRate
bool[] potionListFortifyStamina
bool[] potionListFortifyStaminaRate
bool[] potionListFortifyBlock
bool[] potionListFortifyHeavyArmor
bool[] potionListFortifyLightArmor
bool[] potionListFortifyMarksman
bool[] potionListFortifyOneHanded
bool[] potionListFortifyTwoHanded
bool[] potionListFortifyAlteration
bool[] potionListFortifyConjuration
bool[] potionListFortifyDestruction
bool[] potionListFortifyIllusion
bool[] potionListFortifyRestoration
bool[] potionListResistFire
bool[] potionListResistFrost
bool[] potionListResistMagic
bool[] potionListResistPoison
bool[] potionListResistShock
bool[] potionListParalysis
bool[] potionListSlow
bool[] potionListFear
bool[] potionListFrenzy
bool[] potionListSilence
bool[] potionListFatigue
bool[] potionListDrainIntelligence
bool[] potionListDrainStrength
bool[] potionListDamageHealth
bool[] potionListDamageMagicka
bool[] potionListDamageStamina
bool[] potionListWeaknessFire
bool[] potionListWeaknessFrost
bool[] potionListWeaknessShock
bool[] potionListWeaknessMagic
bool[] potionListHarmful

Potion[] MyPotionList
Potion[] MyPoisonList

int MyTotalPotionCount = 0
int MyTotalPoisonCount = 0

Actor MyEnemy
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
	if (!thisPotion)
		return
	endIf
	FPPQuest.FPPThreadManager.IdentifyPotionAsync(true, MyActorName, thisPotion, aiItemCount, IdentifyPotionEffects, true)
	FPPQuest.FPPThreadManager.WaitAny()
	;AliasDebug("OnItemAdded - " + aiItemCount + " of " + thisPotion.GetName() + " sent for identification")
endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	Potion thisPotion = akBaseItem as Potion
	if (!akDestContainer || !thisPotion || thisPotion.IsFood() || (!thisPotion.IsPoison() && thisPotion.IsHostile()))
		return
	endIf
	string refId = "None"
	if (akItemReference != None)
		refId = akItemReference.GetFormId()
	endIf
	string destId = akDestContainer.GetFormId()
	int remaining = MyActor.GetItemCount(thisPotion)
	int listsAffected = 0
	if (thisPotion.IsPoison())
		listsAffected = UpdateCountsAndArrays("OnItemRemoved", true, MyPoisonList.Find(thisPotion), aiItemCount, remaining == 0)
		if (listsAffected > 0)
			MyTotalPoisonCount -= aiItemCount
		endIf
		AliasDebug2("OnItemRemoved - " + aiItemCount + " of " + thisPotion.GetName() + " (" + remaining + " remaining), removed from " + listsAffected + " lists (ref " + refId + ", dest " + destId + ")", true)
	else
		listsAffected = UpdateCountsAndArrays("OnItemRemoved", false, MyPotionList.Find(thisPotion), aiItemCount, remaining == 0)
		if (listsAffected > 0)
			MyTotalPotionCount -= aiItemCount
		endIf
		AliasDebug2("OnItemRemoved - " + aiItemCount + " of " + thisPotion.GetName() + " (" + remaining + " remaining), removed from " + listsAffected + " lists (ref " + refId + ", dest " + destId + ")")
	endIf
endEvent

Event OnPotionRegister(Form akSender, string asActorName, Form akPotion, int aiPotionCount, int aiEffectsFound, bool abIsPoison, \
						int aiEffectTypesRestore, int aiEffectTypesFortifyStats, int aiEffectTypesFortifyWarrior, int aiEffectTypesFortifyMage, int aiEffectTypesResist, \
						int aiEffectTypesSpecial, int aiEffectTypesDamageStats, int aiEffectTypesWeakness, int aiEffectTypesGenericHarmful)
	if (asActorName != MyActorName || aiEffectsFound < 1)
		;AliasDebug("OnPotionRegister - for " + asActorName + ", not me!")
		return
	endIf
	Potion thisPotion = akPotion as Potion
	if (!thisPotion)
		;AliasDebug("OnPotionRegister - not a potion")
		return
	endIf
	RegisterPotion(thisPotion, aiPotionCount, abIsPoison, \
					aiEffectTypesRestore, aiEffectTypesFortifyStats, aiEffectTypesFortifyWarrior, aiEffectTypesFortifyMage, aiEffectTypesResist, \
					aiEffectTypesSpecial, aiEffectTypesDamageStats, aiEffectTypesWeakness, aiEffectTypesGenericHarmful)
endEvent

; Should only be relevant if Refreshing Potions (in which case you're in RefreshingPotions state already)
; or if you have no potions (in which case you're in HaveNoPotions state already)
Event OnPotionIdentified(Form akSender, string asActorName)
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
	Event OnPotionIdentified(Form akSender, string asActorName)
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

	Event OnPotionIdentified(Form akSender, string asActorName)
		if (asActorName != MyActorName)
			;AliasDebug("HaveNoPotions::OnPotionIdentified - for " + asActorName + ", not me!")
			return
		endIf
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

	Event OnPotionIdentified(Form akSender, string asActorName)
		if (asActorName != MyActorName)
			;AliasDebug("RefreshingPotions::OnPotionIdentified - for " + asActorName + ", not me!")
			return
		endIf
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
	Event OnPotionRegister(Form akSender, string asActorName, Form akPotion, int aiPotionCount, int aiEffectsFound, bool abIsPoison, \
						int aiEffectTypesRestore, int aiEffectTypesFortifyStats, int aiEffectTypesFortifyWarrior, int aiEffectTypesFortifyMage, int aiEffectTypesResist, \
						int aiEffectTypesSpecial, int aiEffectTypesDamageStats, int aiEffectTypesWeakness, int aiEffectTypesGenericHarmful)
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
	if (neededHealth && UsePotionIfPossible(asState + "::HandleUpdate", EFFECT_RESTOREHEALTH))
		return true
	endIf
	bool neededStamina = currStatStamina < CurrentStatLimits[EFFECT_RESTORESTAMINA] && UsePotionOfType[EFFECT_RESTORESTAMINA]
	if (neededStamina && UsePotionIfPossible(asState + "::HandleUpdate", EFFECT_RESTORESTAMINA))
		return true
	endIf
	bool neededMagicka = currStatMagicka < CurrentStatLimits[EFFECT_RESTOREMAGICKA] && UsePotionOfType[EFFECT_RESTOREMAGICKA]
	if (neededMagicka && UsePotionIfPossible(asState + "::HandleUpdate", EFFECT_RESTOREMAGICKA))
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
	return currStat < CurrentStatLimits[EFFECT_RESTOREHEALTH] && UsePotionIfPossible(asState + "::HandleHit", EFFECT_RESTOREHEALTH)
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
	return currStat < CurrentStatLimits[EFFECT_RESTORESTAMINA] && UsePotionIfPossible(asState + "::HandleAnimEvent", EFFECT_RESTORESTAMINA)
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
	return currStat < CurrentStatLimits[EFFECT_RESTOREMAGICKA] && UsePotionIfPossible(asState+ "::HandleSpellCast", EFFECT_RESTOREMAGICKA)
endFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utility functions
;; could poss be moved to external file, but they use a LOT of internal vars,
;; so not sure about performance/thread safety..
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; rattle through inventory, send each potion to FPPQuest.FPPThreadManager for async identification
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
				FPPQuest.FPPThreadManager.IdentifyPotionAsync(false, MyActorName, foundPotion, potionCount, IdentifyPotionEffects, true)
			endIf
			iFormIndex += 1
		EndWhile
		AliasDebug("RefreshPotions - Complete, " + _totalItemCount + " potions found and all queued, waiting on _FPP_Callback_PotionIdentified event(s)")
		FPPQuest.FPPThreadManager.WaitAll()
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
	
	MyEnemy = akTarget
	EnemyRace = akTarget.GetRace()
	EnemyIsBoss = akTarget.HasRefType(LocRefTypeBoss)
	int enemyLevel = akTarget.GetLevel()
	EnemyLvlDiff = enemyLevel - MyActor.GetLevel()
	int lhItem = MyActor.GetEquippedItemType(C_HAND_LEFT)
	int rhItem = MyActor.GetEquippedItemType(1)
	
	msg += "combat with level " + enemyLevel + " " + EnemyRace.GetName()
	if (EnemyIsBoss)
		msg += " boss"
	endIf
	msg += " " + akTarget.GetLeveledActorBase().GetName() + " (diff " + EnemyLvlDiff + ", trigger " + LvlDiffTrigger + "); LH: " + lhItem + ", RH: " + rhItem + " - "
	
	if (ShouldUseCombatPoisons(lhItem, rhItem))
		AliasDebug2(msg + "use poisons", true)
		if (AttemptPoisonChain(asState + "::HandleCombatStateChange", C_HAND_RIGHT, rhItem, true))
			Utility.Wait(1)
		endIf
		AttemptPoisonChain(asState + "::HandleCombatStateChange", C_HAND_LEFT, lhItem, true)
	else
		AliasDebug2(msg + "not enough to use poisons", true)
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
	asState += "::AttemptPoisonChain"
	if (!EquippedItemPoisonable(aiHand, aiEquippedItemType))
		AliasDebug2(asState + " - " + GetHand(aiHand) + " is empty", true)
		return false
	endIf
	if (WornObject.GetPoison(MyActor, aiHand, 0) != None)
		AliasDebug2(asState + " - " + MyActor.GetEquippedWeapon(aiHand == C_HAND_LEFT).GetName() + " in " + GetHand(aiHand) + " already poisoned", true)
		return false
	endIf

	; by chaining these as an inline, it avoids needless calls to subsequent functions 
	; if any one returns true (ie because you've used a poison)
	if (UseCombatPoisonsSpecial(asState + "::AttemptPoisonChain", aiHand) \
		|| UseCombatPoisonsDamageStats(asState, aiHand) \
		|| UseCombatPoisonsWeaknessMagic(asState, aiHand) \
		|| UseCombatPoisonsGeneric(asState, aiHand))
		AliasDebug2(asState + " (" + MyTotalPoisonCount + " poisons) - used poison for " + GetHand(aiHand), true)
		return true
	endIf
	AliasDebug2(asState + " (" + MyTotalPoisonCount + " poisons) - didn't use poisons for " + GetHand(aiHand), true)
	return false
endFunction

bool function EquippedItemPoisonable(int aiHand, int aiEquippedItemType)
	bool is1H = Is1HItem(aiEquippedItemType)
	if (aiHand == C_HAND_LEFT) ; left hand
		return is1H
	elseIf (aiHand == 1) ; right hand
		return is1H || Is2HItem(aiEquippedItemType) || IsBowItem(aiEquippedItemType)
	endIf
	return false
endFunction

bool function UseCombatPoisonsSpecial(string asState, int aiHand)
	int i = PoisonEffectsSpecial.Length
	while (i)
		i -= 1
		if (UsePoisonIfPossible(asState + "::UseCombatPoisonsSpecial", PoisonEffectsSpecial[i], aiHand))
			return true
		endIf
	endWhile
	return false
endFunction

bool function UseCombatPoisonsDamageStats(string asState, int aiHand)
	int i = PoisonEffectsStats.Length
	while (i)
		i -= 1
		if (UsePoisonIfPossible(asState + "::UseCombatPoisonsDamageStats", PoisonEffectsStats[i], aiHand))
			return true
		endIf
	endWhile
	return false
endFunction

bool function UseCombatPoisonsWeaknessMagic(string asState, int aiHand)
	int i = PoisonEffectsWeakness.Length
	while (i)
		i -= 1
		if (UsePoisonIfPossible(asState + "::UseCombatPoisonsWeaknessMagic", PoisonEffectsWeakness[i], aiHand))
			return true
		endIf
	endWhile
	return false
endFunction

bool function UseCombatPoisonsGeneric(string asState, int aiHand)
	int i = PoisonEffectsGeneric.Length
	while (i)
		i -= 1
		if (UsePoisonIfPossible(asState + "::UseCombatPoisonsGeneric", PoisonEffectsGeneric[i], aiHand))
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
		if (UsePotionOfType[FortifyEffectsStats[i]] && UsePotionIfPossible(asState + "::UseCombatPotionsFortifyStats", FortifyEffectsStats[i]))
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
	bool[] effectConditions = new bool[6]
	effectConditions[0] = IsShieldItem(aiLHItem) || IsShieldItem(aiRHItem)
	effectConditions[1] = MyActor.WornHasKeyword(KeywordArmorHeavy)
	effectConditions[2] = MyActor.WornHasKeyword(KeywordArmorLight)
	effectConditions[3] = IsBowItem(aiLHItem) || IsBowItem(aiRHItem)
	effectConditions[4] = Is1HItem(aiLHItem) || Is1HItem(aiRHItem)
	effectConditions[5] = Is2HItem(aiLHItem) || Is2HItem(aiRHItem)
	int i = FortifyEffectsWarrior.Length
	while (i)
		i -= 1
		if (UsePotionOfType[FortifyEffectsWarrior[i]] && effectConditions[i] && UsePotionIfPossible(asState + "::UseCombatPotionsWarrior", FortifyEffectsWarrior[i]))
			Utility.Wait(1)
			if (!MyActor.IsInCombat())
				AliasDebug(msgNofight)
				return false
			endIf
		endIf
	endWhile
	return true
endFunction

bool function UseCombatPotionsMage(string asState)
	string msgNofight = asState + "::UseCombatPotionsMage - no longer in combat, returning"
	if (!MyActor.IsInCombat())
		AliasDebug(msgNofight)
		return false
	endIf
	string[] spellSchools = new string[5]
	spellSchools[0] = "Alteration"
	spellSchools[1] = "Conjuration"
	spellSchools[2] = "Destruction"
	spellSchools[3] = "Illusion"
	spellSchools[4] = "Restoration"
	int i = FortifyEffectsMage.Length
	while (i)
		i -= 1
		if (UsePotionOfType[FortifyEffectsMage[i]] && _Q2C_Functions.ActorHasSpell(MyActor, None, spellSchools[i]) && UsePotionIfPossible(asState + "::UseCombatPotionsMage", FortifyEffectsMage[i]))
			Utility.Wait(1)
			if (!MyActor.IsInCombat())
				AliasDebug(msgNofight)
				return false
			endIf
		endIf
	endWhile
	return true
endFunction

bool function UseCombatPotionsResist(string asState, Actor akTarget)
	string msgNofight = asState + "::UseCombatPotionsResist - no longer in combat, returning"
	if (!MyActor.IsInCombat())
		AliasDebug(msgNofight)
		return false
	endIf
	ActorBase akTargetBase = aktarget.GetLeveledActorBase()
	bool[] effectConditions = new bool[5]
	effectConditions[0] = _Q2C_Functions.ActorHasSpell(akTarget, MagicDamageFire) || _Q2C_Functions.ActorBaseHasShout(akTargetBase, MagicDamageFire)
	effectConditions[1] = _Q2C_Functions.ActorHasSpell(akTarget, MagicDamageFrost) || _Q2C_Functions.ActorBaseHasShout(akTargetBase, MagicDamageFrost)
	effectConditions[2] = _Q2C_Functions.ActorHasSpell(akTarget, MagicDamageShock) || _Q2C_Functions.ActorBaseHasShout(akTargetBase, MagicDamageShock)
	effectConditions[3] = effectConditions[0] || effectConditions[1] || effectConditions[2]
	effectConditions[4] = true
	int i = ResistEffects.Length
	while (i)
		i -= 1
		if (UsePotionOfType[ResistEffects[i]] && effectConditions[i] && UsePotionIfPossible(asState + "::UseCombatPotionsResist", ResistEffects[i]))
			Utility.Wait(1)
			if (!MyActor.IsInCombat())
				AliasDebug(msgNofight)
				return false
			endIf
		endIf
	endWhile
	return true
endFunction

Function RegisterPotion(Potion akPotion, int aiPotionCount, bool abIsPoison, \
						int aiEffectTypesRestore, int aiEffectTypesFortifyStats, int aiEffectTypesFortifyWarrior, int aiEffectTypesFortifyMage, int aiEffectTypesResist, \
						int aiEffectTypesSpecial, int aiEffectTypesDamageStats, int aiEffectTypesWeakness, int aiEffectTypesGenericHarmful)
	Potion[] potionList = MyPotionList
	if (abIsPoison)
		potionList = MyPoisonList
	endIf
	string potionName = akPotion.GetName()
	int potionIndex = potionList.Find(akPotion)
	if (potionIndex < 0)
		int freeIndex = potionList.Find(None)
		if (freeIndex > -1)
			potionList[freeIndex] = akPotion
			UpdateItemCounts(freeIndex, aiPotionCount, abIsPoison, aiEffectTypesRestore, aiEffectTypesFortifyStats, aiEffectTypesFortifyWarrior, aiEffectTypesFortifyMage, aiEffectTypesResist, aiEffectTypesSpecial, aiEffectTypesDamageStats, aiEffectTypesWeakness, aiEffectTypesGenericHarmful)
			;if (DebugToFile)
				AliasDebug2("RegisterPotion - Added " + aiPotionCount + " of " + potionName + " (Id " + akPotion.GetFormId() + ") at index " + freeIndex, abIsPoison)
			;endIf
		else
			AliasDebug("RegisterPotion - No more room in potions array for " + potionName + "! (Id " + akPotion.GetFormId() + ")", \
						MyActorName + " - can't add " + potionName + " potion; no more room for this type of potion!", true)
		endIf
	else
		UpdateItemCounts(potionIndex, aiPotionCount, abIsPoison, aiEffectTypesRestore, aiEffectTypesFortifyStats, aiEffectTypesFortifyWarrior, aiEffectTypesFortifyMage, aiEffectTypesResist, aiEffectTypesSpecial, aiEffectTypesDamageStats, aiEffectTypesWeakness, aiEffectTypesGenericHarmful)
		;if (DebugToFile)
			AliasDebug2("RegisterPotion - Increased " + aiPotionCount + " of " + potionName + " (Id " + akPotion.GetFormId() + ") at index " + potionIndex, abIsPoison)
		;endIf
	endIf
endFunction

Function UpdateItemCounts(int aiPotionIndex, int aiPotionCount, bool abIsPoison, \
							int aiEffectTypesRestore, int aiEffectTypesFortifyStats, int aiEffectTypesFortifyWarrior, int aiEffectTypesFortifyMage, int aiEffectTypesResist, \
							int aiEffectTypesSpecial, int aiEffectTypesDamageStats, int aiEffectTypesWeakness, int aiEffectTypesGenericHarmful)
	if (!abIsPoison)
		UpdateEffectCounts(RestoreEffects, aiEffectTypesRestore, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(FortifyEffectsStats, aiEffectTypesFortifyStats, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(FortifyEffectsWarrior, aiEffectTypesFortifyWarrior, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(FortifyEffectsMage, aiEffectTypesFortifyMage, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(ResistEffects, aiEffectTypesResist, aiPotionCount, aiPotionIndex, abIsPoison)
		AliasDebug2("UpdateItemCounts - increment MyTotalPotionCount by " + aiPotionCount, true)
		MyTotalPotionCount += aiPotionCount
	else
		UpdateEffectCounts(PoisonEffectsSpecial, aiEffectTypesSpecial, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(PoisonEffectsStats, aiEffectTypesDamageStats, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(PoisonEffectsWeakness, aiEffectTypesWeakness, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(PoisonEffectsGeneric, aiEffectTypesGenericHarmful, aiPotionCount, aiPotionIndex, abIsPoison)
		AliasDebug2("UpdateItemCounts - increment MyTotalPoisonCount by " + aiPotionCount, true)
		MyTotalPoisonCount += aiPotionCount
	endIf
endFunction

Function UpdateEffectCounts(int[] akEffectTypesArray, int aiEffectTypesFound, int aiPotionCount, int aiPotionIndex, bool abIsPoison)
	int i = akEffectTypesArray.Length
	while (i)
		i -= 1
		int effectType = akEffectTypesArray[i]
		bool[] trackerList = GetTrackerList(effectType)
		if (Math.LogicalAnd(aiEffectTypesFound, Math.Pow(2, i) as int) != 0)
			int newTotal = HasItemOfType[effectType] + aiPotionCount
			HasItemOfType[effectType] = newTotal
			trackerList[aiPotionIndex] = true
			AliasDebug2("UpdateEffectCounts - set HasItemOfType[" + effectType + "] to " + newTotal + ", and array" + effectType + "[" + aiPotionIndex + "] to true ", abIsPoison)
		else
			trackerList[aiPotionIndex] = false
		endIf
	endWhile
endFunction

bool function UsePotionIfPossible(string asState, int aiEffectType)
	string effectName = EffectNames[aiEffectType]
	string msg = asState + "::UsePotionIfPossible (" + aiEffectType + ": " + effectName + ") - "
	bool potionUsed = false
	if (HasItemOfType[aiEffectType] < 1)
		WarnNoPotions(asState + "::UsePotionIfPossible", aiEffectType, effectName)
		msg += "no " + effectName + " potions"
	elseif (IsInCooldown(aiEffectType, MyActor))
		msg += effectName + " potion still taking effect"
	else
		bool potionWorked = TryFirstPotionThatExists(asState, aiEffectType)
		if (potionWorked)
			msg += "used " + effectName  + " potion from array" + aiEffectType
			potionUsed = true
		else
			WarnNoPotions(asState + "::UsePotionIfPossible", aiEffectType, effectName)
			msg += "failed to use " + effectName  + " potion (something out of sync?)"
		endIf
	endIf
	AliasDebug(msg)
	return potionUsed
endFunction

bool function UsePoisonIfPossible(string asState, int aiEffectType, int aiHand)
	string effectName = EffectNames[aiEffectType]
	string msg = asState + "::UsePoisonIfPossible (" + aiEffectType + ": " + effectName + ") - "
	bool poisonUsed = false
	if (HasItemOfType[aiEffectType] < 1)
		;WarnNoPotions(asState + "::UsePoisonIfPossible", aiEffectType, effectName)
		msg += "no " + effectName + " poisons"
	elseif (IsInCooldown(aiEffectType, MyEnemy))
		msg += effectName + " poison still taking effect"
	else
		bool poisonWorked = TryFirstPoisonThatExists(asState, aiEffectType, aiHand)
		if (poisonWorked)
			msg += "used " + effectName  + " poison from array" + aiEffectType
			poisonUsed = true
		else
			;WarnNoPotions(asState + "::UsePoisonIfPossible", aiEffectType, effectName)
			msg += "failed to use " + effectName  + " poison (something out of sync?)"
		endIf
	endIf
	AliasDebug2(msg, true)
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

bool function TryFirstPotionThatExists(string asState, int aiEffectType)
	bool[] trackerList = GetTrackerList(aiEffectType)
	int potionIndex = trackerList.Find(true)
	if (potionIndex < 0)
		return false
	endIf
	while (potionIndex < MyPotionList.Length)
		if (trackerList[potionIndex])
			Potion thisPotion = MyPotionList[potionIndex] as Potion
			string msg = asState + "::TryFirstPotionThatExists - array" + aiEffectType + "[" + potionIndex + "]"
			if (thisPotion != None && thisPotion.HasKeyword(EffectKeywords[aiEffectType]))
				int potionCount = MyActor.GetItemCount(thisPotion)
				msg += ", have " + potionCount + " (of " + HasItemOfType[aiEffectType] + ")"
				if (potionCount > 0)
					MyActor.EquipItem(thisPotion, false, true)
					UpdateCountsAndArrays(asState, false, potionIndex, 1, potionCount == 1)
					MyTotalPotionCount -= 1
					msg += ", use " + thisPotion.GetName() + " (" + thisPotion.GetFormId() + "), " + (potionCount - 1) + " remaining"
					AliasDebug2(msg)
					return true
				else
					UpdateCountsAndArrays(asState, false, potionIndex, 0, true)
					AliasDebug2(msg + " - removed from arrays SHOUND'T HAPPEN!")
				endif
			endIf
		endIf
		potionIndex += 1
	endWhile
	return false
endFunction

bool function TryFirstPoisonThatExists(string asState, int aiEffectType, int aiHand)
	bool[] trackerList = GetTrackerList(aiEffectType)
	int poisonIndex = trackerList.Find(true)
	if (poisonIndex < 0)
		return false
	endIf
	while (poisonIndex < MyPoisonList.Length)
		if (trackerList[poisonIndex])
			Potion thisPoison = MyPoisonList[poisonIndex] as Potion
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
						AliasDebug2(msg, true)
					else
						MyActor.RemoveItem(thisPoison)
						UpdateCountsAndArrays(asState, true, poisonIndex, 1, poisonCount == 1)
						MyTotalPoisonCount -= 1
						msg += "success, " + (poisonCount - 1) + " remaining"
						AliasDebug2(msg, true)
						return true
					endIf
				else
					UpdateCountsAndArrays(asState, true, poisonIndex, 0, true)
					AliasDebug2(msg + " - removed from arrays SHOUND'T HAPPEN!", true)
				endIf
			endIf
		endIf
		poisonIndex += 1
	endWhile
	return false
endFunction

bool function IsInCooldown(int aiEffectType, Actor akSubject)
	if (!akSubject || !EffectKeywords[aiEffectType])
		return false
	endIf
	return akSubject.HasEffectKeyword(EffectKeywords[aiEffectType])
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

bool function IsShieldItem(int aiItemType)
	return aiItemType == C_ITEM_SHIELD
endFunction
bool function Is1HItem(int aiItemType)
	return aiItemType == C_ITEM_1H_SWORD || aiItemType == C_ITEM_1H_DAGGER || aiItemType == C_ITEM_1H_AXE || aiItemType == C_ITEM_1H_MACE
endFunction
bool function Is2HItem(int aiItemType)
	return aiItemType == C_ITEM_2H_SWORD || aiItemType == C_ITEM_2H_AXE_MACE
endFunction
bool function IsBowItem(int aiItemType)
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
;	msg += "Restore Potions: " + GetPotionReport(potionListRestoreHealth) + GetPotionReport(potionListRestoreStamina) + GetPotionReport(potionListRestoreMagicka)
	msg += "\n"
;	msg += "Fortify Potions: " + GetPotionReport(MyFortifyPotions)
	msg += "\n"
;	msg += "Resist Potions: " + GetPotionReport(MyResistPotions)
	msg += "\n\n"
;	msg += "Poisons: " + GetPotionReport(potionListDamageHealth) + GetPotionReport(potionListDamageStamina) + GetPotionReport(potionListDamageMagicka) + GetPotionReport(potionListHarmful)
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


bool[] function GetTrackerList(int aiEffectType)
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
	elseIf (aiEffectType == EFFECT_PARALYSIS)
		return potionListParalysis
	elseIf (aiEffectType == EFFECT_SLOW)
		return potionListSlow
	elseIf (aiEffectType == EFFECT_FEAR)
		return potionListFear
	elseIf (aiEffectType == EFFECT_FRENZY)
		return potionListFrenzy
	elseIf (aiEffectType == EFFECT_SILENCE)
		return potionListSilence
	elseIf (aiEffectType == EFFECT_FATIGUE)
		return potionListFatigue
	elseIf (aiEffectType == EFFECT_DRAININTELLIGENCE)
		return potionListDrainIntelligence
	elseIf (aiEffectType == EFFECT_DRAINSTRENGTH)
		return potionListDrainStrength
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
	return new bool[1]
endFunction

int function UpdateCountsAndArrays(string asState, bool abIsPoison, int aiIndex, int aiCount, bool abSetToNone)
	if (aiIndex < 0)
		return 0
	endIf
string msg = asState + "::UpdateCountsAndArrays - "
float ftimeStart = Utility.GetCurrentRealTime()
	if (abSetToNone)
		if (!abIsPoison)
			MyPotionList[aiIndex] = None
			msg += "Set MyPotionList[" + aiIndex + "] to None - "
		else
			MyPoisonList[aiIndex] = None
			msg += "Set MyPoisonList[" + aiIndex + "] to None - "
		endIf
	endIf
	int affected = 0
	if (!abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListRestoreHealth, EFFECT_RESTOREHEALTH, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListRestoreStamina, EFFECT_RESTORESTAMINA, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListRestoreMagicka, EFFECT_RESTOREMAGICKA, aiCount, abSetToNone, abIsPoison)
		
		affected += UpdateCountAndArray(aiIndex, potionListFortifyHealth, EFFECT_FORTIFYHEALTH, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyHealRate, EFFECT_FORTIFYHEALRATE, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyStamina, EFFECT_FORTIFYSTAMINA, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyStaminaRate, EFFECT_FORTIFYSTAMINARATE, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyMagicka, EFFECT_FORTIFYMAGICKA, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyMagickaRate, EFFECT_FORTIFYMAGICKARATE, aiCount, abSetToNone, abIsPoison)
		
		affected += UpdateCountAndArray(aiIndex, potionListFortifyBlock, EFFECT_FORTIFYBLOCK, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyHeavyArmor, EFFECT_FORTIFYHEAVYARMOR, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyLightArmor, EFFECT_FORTIFYLIGHTARMOR, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyMarksman, EFFECT_FORTIFYMARKSMAN, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyOneHanded, EFFECT_FORTIFYONEHANDED, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyTwoHanded, EFFECT_FORTIFYTWOHANDED, aiCount, abSetToNone, abIsPoison)

		affected += UpdateCountAndArray(aiIndex, potionListFortifyAlteration, EFFECT_FORTIFYALTERATION, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyConjuration, EFFECT_FORTIFYCONJURATION, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyDestruction, EFFECT_FORTIFYDESTRUCTION, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyIllusion, EFFECT_FORTIFYILLUSION, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFortifyRestoration, EFFECT_FORTIFYRESTORATION, aiCount, abSetToNone, abIsPoison)

		affected += UpdateCountAndArray(aiIndex, potionListResistFire, EFFECT_RESISTFIRE, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListResistFrost, EFFECT_RESISTFROST, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListResistShock, EFFECT_RESISTSHOCK, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListResistMagic, EFFECT_RESISTMAGIC, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListResistPoison, EFFECT_RESISTPOISON, aiCount, abSetToNone, abIsPoison)
	else
		affected += UpdateCountAndArray(aiIndex, potionListParalysis, EFFECT_PARALYSIS, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListSlow, EFFECT_SLOW, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFear, EFFECT_FEAR, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFrenzy, EFFECT_FRENZY, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListSilence, EFFECT_SILENCE, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListFatigue, EFFECT_FATIGUE, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListDrainIntelligence, EFFECT_DRAININTELLIGENCE, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListDrainStrength, EFFECT_DRAINSTRENGTH, aiCount, abSetToNone, abIsPoison)

		affected += UpdateCountAndArray(aiIndex, potionListDamageHealth, EFFECT_DAMAGEHEALTH, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListDamageStamina, EFFECT_DAMAGESTAMINA, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListDamageMagicka, EFFECT_DAMAGEMAGICKA, aiCount, abSetToNone, abIsPoison)

		affected += UpdateCountAndArray(aiIndex, potionListWeaknessFire, EFFECT_WEAKNESSFIRE, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListWeaknessFrost, EFFECT_WEAKNESSFROST, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListWeaknessShock, EFFECT_WEAKNESSSHOCK, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListWeaknessMagic, EFFECT_WEAKNESSMAGIC, aiCount, abSetToNone, abIsPoison)
		affected += UpdateCountAndArray(aiIndex, potionListHarmful, EFFECT_HARMFUL, aiCount, abSetToNone, abIsPoison)
	endIf
float ftimeEnd = Utility.GetCurrentRealTime()
msg += (ftimeEnd - ftimeStart) + "s"
AliasDebug2(msg, abIsPoison)
	return affected
endFunction

int function UpdateCountAndArray(int aiIndex, bool[] akTrackerList, int aiEffect, int aiCount, bool abSetToNone, bool abIsPoison)
	if (!akTrackerList[aiIndex])
		return 0
	endIf
	int newCount = HasItemOfType[aiEffect] - aiCount
	if (newCount < 0)
		newCount = 0
	endIf
	HasItemOfType[aiEffect] = newCount
	string msg = "UpdateCountAndArray - Set HasItemOfType[" + aiEffect + "] to " + newCount
	if (newCount <= 0 || abSetToNone)
		akTrackerList[aiIndex] = false
		msg += " and array" + aiEffect + "[" + aiIndex + "] to false"
	endIf
AliasDebug2(msg, abIsPoison)
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
	EFFECT_PARALYSIS = FPPQuest.EFFECT_PARALYSIS
	EFFECT_SLOW = FPPQuest.EFFECT_SLOW
	EFFECT_FEAR = FPPQuest.EFFECT_FEAR
	EFFECT_FRENZY = FPPQuest.EFFECT_FRENZY
	EFFECT_SILENCE = FPPQuest.EFFECT_SILENCE
	EFFECT_FATIGUE = FPPQuest.EFFECT_FATIGUE
	EFFECT_DRAININTELLIGENCE = FPPQuest.EFFECT_DRAININTELLIGENCE
	EFFECT_DRAINSTRENGTH = FPPQuest.EFFECT_DRAINSTRENGTH

	EffectKeywords = FPPQuest.EffectKeywords
	EffectNames = FPPQuest.EffectNames
	
	RestoreEffects = FPPQuest.RestoreEffects
	FortifyEffectsStats = FPPQuest.FortifyEffectsStats
	FortifyEffectsWarrior = FPPQuest.FortifyEffectsWarrior
	FortifyEffectsMage = FPPQuest.FortifyEffectsMage
	ResistEffects = FPPQuest.ResistEffects
	
	PoisonEffectsSpecial = FPPQuest.PoisonEffectsSpecial
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
	EffectKeywords = FPPQuest.EffectKeywords
	HasItemOfType = Utility.CreateIntArray(EffectKeywords.Length, 0)
endFunction

Function ClearPotionLists()
	MyPotionList = new Potion[127]
	potionListRestoreHealth = new bool[127]
	potionListRestoreStamina = new bool[127]
	potionListRestoreMagicka = new bool[127]
	potionListFortifyHealth = new bool[127]
	potionListFortifyHealRate = new bool[127]
	potionListFortifyMagicka = new bool[127]
	potionListFortifyMagickaRate = new bool[127]
	potionListFortifyStamina = new bool[127]
	potionListFortifyStaminaRate = new bool[127]
	potionListFortifyBlock = new bool[127]
	potionListFortifyHeavyArmor = new bool[127]
	potionListFortifyLightArmor = new bool[127]
	potionListFortifyMarksman = new bool[127]
	potionListFortifyOneHanded = new bool[127]
	potionListFortifyTwoHanded = new bool[127]
	potionListFortifyAlteration = new bool[127]
	potionListFortifyConjuration = new bool[127]
	potionListFortifyDestruction = new bool[127]
	potionListFortifyIllusion = new bool[127]
	potionListFortifyRestoration = new bool[127]
	potionListResistFire = new bool[127]
	potionListResistFrost = new bool[127]
	potionListResistMagic = new bool[127]
	potionListResistPoison = new bool[127]
	potionListResistShock = new bool[127]
endFunction

Function ClearPoisonLists()
	MyPoisonList = new Potion[127]
	potionListParalysis = new bool[127]
	potionListSlow = new bool[127]
	potionListFear = new bool[127]
	potionListFrenzy = new bool[127]
	potionListSilence = new bool[127]
	potionListFatigue = new bool[127]
	potionListDrainIntelligence = new bool[127]
	potionListDrainStrength = new bool[127]
	potionListDamageHealth = new bool[127]
	potionListDamageStamina = new bool[127]
	potionListDamageMagicka = new bool[127]
	potionListWeaknessFire = new bool[127]
	potionListWeaknessFrost = new bool[127]
	potionListWeaknessShock = new bool[127]
	potionListWeaknessMagic = new bool[127]
	potionListHarmful = new bool[127]
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

function AliasDebug2(string asLogMsg, bool abIsPoison = false, string asScreenMsg = "", bool abFpPrefix = false)
	string logName = "FollowerPotions"
	if (abIsPoison)
		logName = "FollowerPoisons"
	endIf
	if (asLogMsg != "")
		Debug.TraceUser(logName, MyActorName + ": " + asLogMsg)
	endIf
	if (asScreenMsg != "")
		if (abFpPrefix)
			asScreenMsg = "Follower Potions - " + asScreenMsg
		endIf
		Debug.Notification(asScreenMsg)
	endIf
endFunction
