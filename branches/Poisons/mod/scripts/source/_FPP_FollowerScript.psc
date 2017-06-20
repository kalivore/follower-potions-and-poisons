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
bool Property EnableWarningNoPotions Auto
float Property UpdateIntervalNoPotions Auto

bool[] Property EnableWarnings Auto
float[] Property WarningIntervals Auto

float[] Property StatLimitsInCombat Auto
float[] Property StatLimitsNonCombat Auto

int Property LvlDiffTrigger Auto
bool[] Property TriggerRaces Auto
bool[] Property UsePotionOfType Auto

int Property LvlDiffTriggerPoison Auto
int[] Property GlobalUsePoisons Auto
bool[] Property UsePoisonOfType Auto

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

int GLOBAL_POISONS_ANY		= 0
int GLOBAL_POISONS_MAIN		= 1
int GLOBAL_POISONS_BOW		= 2
int GLOBAL_POISONS_OFFHAND	= 3

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
Keyword[] PoisonImmunityKeywords
int[] PoisonImmunityMappings

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
int[] MyPotionCounts
int[] MyPoisonCounts

int MyTotalPotionCount = 0
int MyTotalPoisonCount = 0

Actor MyEnemy
Race EnemyRace
int EnemyLevel
int EnemyLvlDiff
bool EnemyIsBoss
bool EnemyFireSpell
bool EnemyFrostSpell
bool EnemyShockSpell
bool EnemyHasMagic
bool EnemyPoisonable

float CurrentUpdateInterval
float[] MyPotionWarningTimes
float[] CurrentStatLimits
int[] HasItemOfType

bool IgnoreEvents = false
bool IgnoreCombatStateEvents = false
bool TargetUpdateLock = false

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
	AliasDebug("Assigned to " + MyName, "$FPPNotsRecognised{" + MyActorName + "}")
endFunction

Function Maintenance()
	IgnoreEvents = false
	IgnoreCombatStateEvents = false
	TargetUpdateLock = false
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
	MyPotionWarningTimes = Utility.CreateFloatArray(7, currentHoursPassed)
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
	AliasDebug("DeInit - Complete", "$FPPNotsRemoved{" + MyActorName + "}")
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
	FPPQuest.FPPThreadManager.IdentifyPotionAsync(true, MyActorName, thisPotion, aiItemCount, IdentifyPotionEffects, DebugToFile)
	FPPQuest.FPPThreadManager.WaitAny()
	;AliasDebug("OnItemAdded - " + aiItemCount + " of " + thisPotion.GetName() + " sent for identification")
endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	Potion thisPotion = akBaseItem as Potion
	if (!thisPotion || thisPotion.IsFood() || (!thisPotion.IsPoison() && thisPotion.IsHostile()))
		return
	endIf
	bool isPoisonItem = thisPotion.IsPoison()
	string itemName = thisPotion.GetName()
	Potion[] itemList = MyPotionList
	int[] itemCountList = MyPotionCounts
	if (isPoisonItem)
		itemList = MyPoisonList
		itemCountList = MyPoisonCounts
	endIf
	int index = itemList.Find(thisPotion)
	if (index < 0)
		;AliasDebug("OnItemRemoved - " + aiItemCount + " of " + itemName + "; not a tracked item", isPoisonItem)
		return
	endIf
	int itemCountTracked = itemCountList[index]
	int itemCountActual = MyActor.GetItemCount(thisPotion)
	if (itemCountTracked == itemCountActual)
		;AliasDebug("OnItemRemoved - " + aiItemCount + " of " + itemName + "; current count (" + itemCountTracked + ") matches remaining (" + itemCountActual + ")", isPoisonItem)
		return
	endIf
	string destId = "None"
	if (akDestContainer)
		destId = akDestContainer.GetFormId()
	endIf
	string refId = "None"
	if (akItemReference)
		refId = akItemReference.GetFormId()
	endIf
	int listsAffected = UpdateCountsAndArrays("OnItemRemoved", isPoisonItem, index, aiItemCount, itemCountActual == 0)
	if (listsAffected > 0)
		itemCountList[index] = itemCountTracked - aiItemCount
		if (isPoisonItem)
			MyTotalPoisonCount -= aiItemCount
		else
			MyTotalPotionCount -= aiItemCount
		endIf
	endIf
	AliasDebug("OnItemRemoved - " + aiItemCount + " of " + itemName + "; " + itemCountActual + " (" + (itemCountTracked - aiItemCount) + ") remaining, updated " + listsAffected + " lists (ref " + refId + ", dest " + destId + ")")
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
		string asState = "PendingEvent::OnAnimationEvent(" + asEventName + ")"
		if (PoisonsEnabled(false))
			int lhItem = MyActor.GetEquippedItemType(C_HAND_LEFT)
			int rhItem = MyActor.GetEquippedItemType(C_HAND_RIGHT)
			RefreshCombatTarget(asState, None, true)
			if (ShouldUseCombatPoisons(asState, lhItem, rhItem))
				if (asEventName == "weaponSwing" || asEventName == "arrowRelease")
					AttemptPoisonChain(asState, C_HAND_RIGHT, rhItem, false)
				elseIf (asEventName == "weaponLeftSwing")
					AttemptPoisonChain(asState, C_HAND_LEFT, lhItem, false)
				endIf
			endIf
		endIf
		if (!UsePotionOfType[EFFECT_RESTORESTAMINA] || (asEventName != "arrowRelease" && !MyActor.GetAnimationVariableBool("bAllowRotation")))
			IgnoreEvents = false
			return
		endIf
		HandleAnimEvent(asState)
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
			if (PoisonsEnabled(false))
				int lhItem = MyActor.GetEquippedItemType(C_HAND_LEFT)
				int rhItem = MyActor.GetEquippedItemType(C_HAND_RIGHT)
				RefreshCombatTarget("PendingUpdate::OnUpdate", None, true)
				if (ShouldUseCombatPoisons("PendingUpdate::OnUpdate", lhItem, rhItem))
					if (AttemptPoisonChain("PendingUpdate::OnUpdate", C_HAND_RIGHT, rhItem, false))
						Utility.Wait(0.3)
					endIf
					AttemptPoisonChain("PendingUpdate::OnUpdate", C_HAND_LEFT, lhItem, false)
				endIf
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
			if (EnableWarningNoPotions)
				AliasDebug("", "$FPPNoPotions{" + MyActorName + "}")
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
			AliasDebug("", "$FPPNotsFinishedRefresh{" + MyActorName + "}")
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
	asState += "::HandleUpdate"
	float currStatHealth = MyActor.GetActorValuePercentage("health")
	float currStatStamina = MyActor.GetActorValuePercentage("stamina")
	float currStatMagicka = MyActor.GetActorValuePercentage("magicka")
	string msg = asState + " - H:" + ((currStatHealth * 100) as int) + "%, S:" + ((currStatStamina * 100) as int) + "%, M:" + ((currStatMagicka * 100) as int) + "%"
	if (IsIncapacitated())
		;if incapacitated, not much point going further
		AliasDebug(msg + " - incapacitated")
		return false
	endIf
	AliasDebug(msg)
	
	; check & try to replenish Health, Stamina, Magicka in that order. Only return false if you didn't need any of them
	bool neededHealth = UsePotionOfType[EFFECT_RESTOREHEALTH] && currStatHealth < CurrentStatLimits[EFFECT_RESTOREHEALTH]
	if (neededHealth && UseItemIfPossible(asState, false, EFFECT_RESTOREHEALTH))
		return true
	endIf
	bool neededStamina = UsePotionOfType[EFFECT_RESTORESTAMINA] && currStatStamina < CurrentStatLimits[EFFECT_RESTORESTAMINA]
	if (neededStamina && UseItemIfPossible(asState, false, EFFECT_RESTORESTAMINA))
		return true
	endIf
	bool neededMagicka = UsePotionOfType[EFFECT_RESTOREMAGICKA] && currStatMagicka < CurrentStatLimits[EFFECT_RESTOREMAGICKA]
	if (neededMagicka && UseItemIfPossible(asState, false, EFFECT_RESTOREMAGICKA))
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
	return currStat < CurrentStatLimits[EFFECT_RESTOREHEALTH] && UseItemIfPossible(asState + "::HandleHit", false, EFFECT_RESTOREHEALTH)
endFunction

bool function HandleAnimEvent(string asState)
	float currStat = MyActor.GetActorValuePercentage("stamina")
	string msg = asState + "::HandleAnimEvent: stamina " + ((currStat * 100) as int) + "%"
	if (IsIncapacitated())
		;if incapacitated, not much point going further
		AliasDebug(msg + " - incapacitated")
		return false
	endIf
	AliasDebug(msg)
	return currStat < CurrentStatLimits[EFFECT_RESTORESTAMINA] && UseItemIfPossible(asState + "::HandleAnimEvent", false, EFFECT_RESTORESTAMINA)
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
	return currStat < CurrentStatLimits[EFFECT_RESTOREMAGICKA] && UseItemIfPossible(asState+ "::HandleSpellCast", false, EFFECT_RESTOREMAGICKA)
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
				FPPQuest.FPPThreadManager.IdentifyPotionAsync(false, MyActorName, foundPotion, potionCount, IdentifyPotionEffects, DebugToFile)
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
			AliasDebug("", "$FPPNotsNoPotionsToIdent{" + MyActorName + "}")
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
	asState += "::HandleCombatStateChange"
	string msg = asState + " - "
	if (IsIncapacitated())
		;if incapacitated, not much point going further
		AliasDebug(msg + "incapacitated")
		IgnoreCombatStateEvents = false
		return
	endIf
	
	int lhItem = MyActor.GetEquippedItemType(C_HAND_LEFT)
	int rhItem = MyActor.GetEquippedItemType(C_HAND_RIGHT)
	RefreshCombatTarget(asState, akTarget, false)
	msg += "LH: " + lhItem + ", RH: " + rhItem + "; "
	
	if (PoisonsEnabled(true) && ShouldUseCombatPoisons(asState, lhItem, rhItem))
		msg += "use poisons; "
		if (AttemptPoisonChain(asState, C_HAND_RIGHT, rhItem, true))
			Utility.Wait(0.3)
		endIf
		AttemptPoisonChain(asState, C_HAND_LEFT, lhItem, true)
	else
		msg += "don't use poisons; "
	endIf

	if (ShouldUseCombatPotions())
		msg += "use potions"
		; chain these ones as an AND, since you want to keep going through (using potions)
		; until any one returns false (ie because you're not in combat any more)
		UseCombatPotionsFortifyStats(asState) \
			&& UseCombatPotionsWarrior(asState, lhItem, rhItem) \
			&& UseCombatPotionsMage(asState) \
			&& UseCombatPotionsResist(asState)
	else
		msg += "don't use potions"
	endIf
	AliasDebug(msg)
	IgnoreCombatStateEvents = false
endFunction

bool function PoisonsEnabled(bool abOnEngage)
	return GlobalUsePoisons[GLOBAL_POISONS_ANY] > 0 \
		&& ((abOnEngage && (GlobalUsePoisons[GLOBAL_POISONS_MAIN] > 0 || GlobalUsePoisons[GLOBAL_POISONS_BOW] > 0 || GlobalUsePoisons[GLOBAL_POISONS_OFFHAND] > 0)) \
			|| (!abOnEngage && (GlobalUsePoisons[GLOBAL_POISONS_MAIN] > 1 || GlobalUsePoisons[GLOBAL_POISONS_BOW] > 1 || GlobalUsePoisons[GLOBAL_POISONS_OFFHAND] > 1)))
endFunction

function RefreshCombatTarget(string asState, Actor akTarget, bool abForPoisons)
	if (TargetUpdateLock)
		return
	endIf
	TargetUpdateLock = true
	if (!akTarget)
		akTarget = MyActor.GetCombatTarget()
	endIf
	string msg = asState + "::RefreshCombatTarget"
	if (akTarget == MyEnemy)
		AliasDebug(msg + " - not changed")
		TargetUpdateLock = false
		return
	endIf
	if (!akTarget)
		MyEnemy = None
		EnemyRace = None
		EnemyLevel = 0
		EnemyLvlDiff = 0
		EnemyIsBoss = false
		EnemyFireSpell = false
		EnemyFrostSpell = false
		EnemyShockSpell = false
		EnemyHasMagic = false
		msg += " - no target"
	else
		MyEnemy = akTarget
		EnemyRace = MyEnemy.GetRace()
		EnemyLevel = MyEnemy.GetLevel()
		EnemyLvlDiff = EnemyLevel - MyActor.GetLevel()
		EnemyIsBoss = MyEnemy.HasRefType(LocRefTypeBoss)
		EnemyFireSpell = _Q2C_Functions.ActorHasSpell(MyEnemy, MagicDamageFire)
		EnemyFrostSpell = _Q2C_Functions.ActorHasSpell(MyEnemy, MagicDamageFrost)
		EnemyShockSpell = _Q2C_Functions.ActorHasSpell(MyEnemy, MagicDamageShock)
		EnemyHasMagic = EnemyFireSpell || EnemyFrostSpell || EnemyShockSpell
		msg += " - combat with level " + EnemyLevel + " " + EnemyRace.GetName()
		if (EnemyIsBoss)
			msg += " boss"
		endIf
		msg += " " + MyEnemy.GetLeveledActorBase().GetName() + " (" + MyEnemy.GetFormId() + ", diff " + EnemyLvlDiff + ", triggers: " + LvlDiffTrigger + "/" + LvlDiffTriggerPoison + ")"
	endIf
	EnemyPoisonable = -1
	AliasDebug(msg)
	TargetUpdateLock = false
endFunction

bool function ShouldUseCombatPoisons(string asState, int aiLHItem, int aiRHItem)
	asState += "::ShouldUseCombatPoisons"
	if (MyTotalPoisonCount < 1)
		AliasDebug(asState + " - no poisons")
		WarnNoItems(asState, EFFECT_HARMFUL, "any poison", true)
		return false
	endIf
	if (!MyEnemy)
		AliasDebug(asState + " - no enemy")
		return false
	endIf
	if (EnemyPoisonable == -1)
		if (EnemyLvlDiff < LvlDiffTriggerPoison)
			EnemyPoisonable = 0
			AliasDebug(asState + " - enemy not enough level")
			return false
		endIf
		if (MyEnemy.GetActorValue("PoisonResist") > 90)
			EnemyPoisonable = 0
			AliasDebug(asState + " - enemy too resistant")
			return false
		endIf
		int i = PoisonImmunityKeywords.Length
		while (i)
			i -= 1
			if (Math.LogicalAnd(PoisonImmunityMappings[EFFECT_HARMFUL], Math.Pow(2, i) as int) != 0 && MyEnemy.HasKeyword(PoisonImmunityKeywords[i]))
				EnemyPoisonable = 0
				AliasDebug(asState + " - enemy has total immunity keyword " + PoisonImmunityKeywords[i])
				return false
			endIf
		endWhile
		EnemyPoisonable = 1
	endIf
	return EnemyPoisonable == 1
endFunction

bool function ShouldUseCombatPotions()
	; simplest check first
	if (!MyEnemy)
		return false
	endIf
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
	if (!MyEnemy)
		AliasDebug(asState + " - no enemy")
		return false
	endIf
	int threshold = 2
	if (abOnEngage)
		threshold = 1
	endIf
	if (aiHand == C_HAND_RIGHT)
		if (IsBowItem(aiEquippedItemType))
			if (GlobalUsePoisons[GLOBAL_POISONS_BOW] < threshold)
				AliasDebug(asState + " - poisons disabled for bows")
				return false
			endIf
		elseIf (GlobalUsePoisons[GLOBAL_POISONS_MAIN] < threshold)
			AliasDebug(asState + " - poisons disabled for main hand")
			return false
		endIf
	elseIf (GlobalUsePoisons[GLOBAL_POISONS_OFFHAND] < threshold)
		AliasDebug(asState + " - poisons disabled for off-hand")
		return false
	endIf
	if (!EquippedItemPoisonable(aiHand, aiEquippedItemType))
		AliasDebug(asState + " - " + GetHand(aiHand) + " is not poisonable")
		return false
	endIf
	if (WornObject.GetPoison(MyActor, aiHand, 0) != None)
		AliasDebug(asState + " - " + MyActor.GetEquippedWeapon(aiHand == C_HAND_LEFT).GetName() + " in " + GetHand(aiHand) + " already poisoned")
		return false
	endIf

	; by chaining these as an inline, it avoids needless calls to subsequent functions 
	; if any one returns true (ie because you've used a poison)
	int enemyRHItem = MyEnemy.GetEquippedItemType(C_HAND_RIGHT)
	if (UseCombatPoisonsSpecial(asState, aiHand, aiEquippedItemType, enemyRHItem, abOnEngage) \
		|| UseCombatPoisonsWeaknessMagic(asState, aiHand, aiEquippedItemType, enemyRHItem, abOnEngage) \
		|| UseCombatPoisonsDamageStats(asState, aiHand, aiEquippedItemType, enemyRHItem, abOnEngage) \
		|| UseCombatPoisonsGeneric(asState, aiHand, aiEquippedItemType, enemyRHItem, abOnEngage))
		AliasDebug(asState + " (" + MyTotalPoisonCount + " poisons) - used poison for " + GetHand(aiHand))
		return true
	endIf
	AliasDebug(asState + " (" + MyTotalPoisonCount + " poisons) - didn't use poisons for " + GetHand(aiHand))
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

bool function UseCombatPoisonsSpecial(string asState, int aiHand, int aiEquippedItemType, int aiEnemyRHItem, bool abOnEngage)
	bool[] effectConditions = new bool[8]
	effectConditions[0] = true ; paralysis
	effectConditions[1] = true ; slow
	effectConditions[2] = true ; fear
	effectConditions[3] = IsBowItem(aiEquippedItemType) ; frenzy
	effectConditions[4] = EnemyHasMagic ; silence
	effectConditions[5] = !EnemyHasMagic || (aiEnemyRHItem != C_ITEM_SPELL && aiEnemyRHItem != C_ITEM_STAFF) ; fatigue
	effectConditions[6] = EnemyHasMagic ; drainInt
	effectConditions[7] = !EnemyHasMagic || (aiEnemyRHItem != C_ITEM_SPELL && aiEnemyRHItem != C_ITEM_STAFF) ; drainStr
	int i = PoisonEffectsSpecial.Length
	while (i)
		i -= 1
		if (UsePoisonOfType[PoisonEffectsSpecial[i]] && effectConditions[i] && !EnemyImmune(asState, PoisonEffectsSpecial[i]) && UseItemIfPossible(asState + "::UseCombatPoisonsSpecial", true, PoisonEffectsSpecial[i], aiHand))
			return true
		endIf
	endWhile
	return false
endFunction

bool function UseCombatPoisonsDamageStats(string asState, int aiHand, int aiEquippedItemType, int aiEnemyRHItem, bool abOnEngage)
	bool[] effectConditions = new bool[3]
	effectConditions[0] = true
	effectConditions[1] = !EnemyHasMagic || (aiEnemyRHItem != C_ITEM_SPELL && aiEnemyRHItem != C_ITEM_STAFF)
	effectConditions[2] = EnemyHasMagic
	int i = PoisonEffectsStats.Length
	while (i)
		i -= 1
		if (UsePoisonOfType[PoisonEffectsStats[i]] && effectConditions[i] && !EnemyImmune(asState, PoisonEffectsStats[i]) && UseItemIfPossible(asState + "::UseCombatPoisonsDamageStats", true, PoisonEffectsStats[i], aiHand))
			return true
		endIf
	endWhile
	return false
endFunction

bool function UseCombatPoisonsWeaknessMagic(string asState, int aiHand, int aiEquippedItemType, int aiEnemyRHItem, bool abOnEngage)
	bool[] effectConditions = new bool[4]
	effectConditions[0] = true ; AllyHasFire
	effectConditions[1] = true ; AllyHasFrost
	effectConditions[2] = true ; AllyHasShock
	effectConditions[3] = true ; AllyHasMagic
	int i = PoisonEffectsWeakness.Length
	while (i)
		i -= 1
		if (UsePoisonOfType[PoisonEffectsWeakness[i]] && effectConditions[i] && !EnemyImmune(asState, PoisonEffectsWeakness[i]) && UseItemIfPossible(asState + "::UseCombatPoisonsWeaknessMagic", true, PoisonEffectsWeakness[i], aiHand))
			return true
		endIf
	endWhile
	return false
endFunction

bool function UseCombatPoisonsGeneric(string asState, int aiHand, int aiEquippedItemType, int aiEnemyRHItem, bool abOnEngage)
	int i = PoisonEffectsGeneric.Length
	while (i)
		i -= 1
		if (UsePoisonOfType[PoisonEffectsGeneric[i]] && UseItemIfPossible(asState + "::UseCombatPoisonsGeneric", true, PoisonEffectsGeneric[i], aiHand))
			return true
		endIf
	endWhile
	return false
endFunction

bool function EnemyImmune(string asState, int aiEffectType)
	if (PoisonImmunityMappings[aiEffectType] < 1)
		return false
	endIf
	int i = PoisonImmunityKeywords.Length
	while (i)
		i -= 1
		if (Math.LogicalAnd(PoisonImmunityMappings[aiEffectType], Math.Pow(2, i) as int) != 0 && MyEnemy && MyEnemy.HasKeyword(PoisonImmunityKeywords[i]))
			AliasDebug(asState + " - enemy has immunity keyword " + PoisonImmunityKeywords[i] + " to " + EffectNames[aiEffectType])
			return true
		endIf
	endWhile
	return false
endFunction

bool function UseCombatPotionsFortifyStats(string asState)
	string msgNofight = asState + "::UseCombatPotionsFortifyStats - no longer in combat, returning"
	if (!MyEnemy || !MyActor.IsInCombat())
		AliasDebug(msgNofight)
		return false
	endIf
	int i = FortifyEffectsStats.Length
	while (i)
		i -= 1
		if (UsePotionOfType[FortifyEffectsStats[i]] && UseItemIfPossible(asState + "::UseCombatPotionsFortifyStats", false, FortifyEffectsStats[i]))
			Utility.Wait(1)
			if (!MyEnemy || !MyActor.IsInCombat())
				AliasDebug(msgNofight)
				return false
			endIf
		endIf
	endWhile
	return true
endFunction

bool function UseCombatPotionsWarrior(string asState, int aiLHItem, int aiRHItem)
	string msgNofight = asState + "::UseCombatPotionsWarrior - no longer in combat, returning"
	if (!MyEnemy || !MyActor.IsInCombat())
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
		if (UsePotionOfType[FortifyEffectsWarrior[i]] && effectConditions[i] && UseItemIfPossible(asState + "::UseCombatPotionsWarrior", false, FortifyEffectsWarrior[i]))
			Utility.Wait(1)
			if (!MyEnemy || !MyActor.IsInCombat())
				AliasDebug(msgNofight)
				return false
			endIf
		endIf
	endWhile
	return true
endFunction

bool function UseCombatPotionsMage(string asState)
	string msgNofight = asState + "::UseCombatPotionsMage - no longer in combat, returning"
	if (!MyEnemy || !MyActor.IsInCombat())
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
		if (UsePotionOfType[FortifyEffectsMage[i]] && _Q2C_Functions.ActorHasSpell(MyActor, None, spellSchools[i]) && UseItemIfPossible(asState + "::UseCombatPotionsMage", false, FortifyEffectsMage[i]))
			Utility.Wait(1)
			if (!MyEnemy || !MyActor.IsInCombat())
				AliasDebug(msgNofight)
				return false
			endIf
		endIf
	endWhile
	return true
endFunction

bool function UseCombatPotionsResist(string asState)
	string msgNofight = asState + "::UseCombatPotionsResist - no longer in combat, returning"
	if (!MyEnemy || !MyActor.IsInCombat())
		AliasDebug(msgNofight)
		return false
	endIf
	ActorBase akTargetBase = MyEnemy.GetLeveledActorBase()
	bool[] effectConditions = new bool[5]
	effectConditions[0] = EnemyFireSpell || _Q2C_Functions.ActorBaseHasShout(akTargetBase, MagicDamageFire)
	effectConditions[1] = EnemyFrostSpell || _Q2C_Functions.ActorBaseHasShout(akTargetBase, MagicDamageFrost)
	effectConditions[2] = EnemyShockSpell || _Q2C_Functions.ActorBaseHasShout(akTargetBase, MagicDamageShock)
	effectConditions[3] = EnemyHasMagic
	effectConditions[4] = true
	int i = ResistEffects.Length
	while (i)
		i -= 1
		if (UsePotionOfType[ResistEffects[i]] && effectConditions[i] && UseItemIfPossible(asState + "::UseCombatPotionsResist", false, ResistEffects[i]))
			Utility.Wait(1)
			if (!MyEnemy || !MyActor.IsInCombat())
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
	string itemName = akPotion.GetName()
	int potionIndex = potionList.Find(akPotion)
	if (potionIndex < 0)
		int freeIndex = potionList.Find(None)
		if (freeIndex > -1)
			potionList[freeIndex] = akPotion
			UpdateItemCounts(freeIndex, aiPotionCount, abIsPoison, aiEffectTypesRestore, aiEffectTypesFortifyStats, aiEffectTypesFortifyWarrior, aiEffectTypesFortifyMage, aiEffectTypesResist, aiEffectTypesSpecial, aiEffectTypesDamageStats, aiEffectTypesWeakness, aiEffectTypesGenericHarmful)
			if (DebugToFile)
				AliasDebug("RegisterPotion - Added " + aiPotionCount + " of " + itemName + " (Id " + akPotion.GetFormId() + ") at index " + freeIndex)
			endIf
		else
			AliasDebug("RegisterPotion - No more room in potions array for " + itemName + "! (Id " + akPotion.GetFormId() + ")", \
						"$FPPNotsNoRoomForItem{" + MyActorName + "}{" + itemName + "}")
		endIf
	else
		UpdateItemCounts(potionIndex, aiPotionCount, abIsPoison, aiEffectTypesRestore, aiEffectTypesFortifyStats, aiEffectTypesFortifyWarrior, aiEffectTypesFortifyMage, aiEffectTypesResist, aiEffectTypesSpecial, aiEffectTypesDamageStats, aiEffectTypesWeakness, aiEffectTypesGenericHarmful)
		if (DebugToFile)
			AliasDebug("RegisterPotion - Increased " + aiPotionCount + " of " + itemName + " (Id " + akPotion.GetFormId() + ") at index " + potionIndex)
		endIf
	endIf
endFunction

Function UpdateItemCounts(int aiPotionIndex, int aiPotionCount, bool abIsPoison, \
							int aiEffectTypesRestore, int aiEffectTypesFortifyStats, int aiEffectTypesFortifyWarrior, int aiEffectTypesFortifyMage, int aiEffectTypesResist, \
							int aiEffectTypesSpecial, int aiEffectTypesDamageStats, int aiEffectTypesWeakness, int aiEffectTypesGenericHarmful)
	int newTotal = aiPotionCount
	if (!abIsPoison)
		UpdateEffectCounts(RestoreEffects, aiEffectTypesRestore, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(FortifyEffectsStats, aiEffectTypesFortifyStats, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(FortifyEffectsWarrior, aiEffectTypesFortifyWarrior, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(FortifyEffectsMage, aiEffectTypesFortifyMage, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(ResistEffects, aiEffectTypesResist, aiPotionCount, aiPotionIndex, abIsPoison)
		MyTotalPotionCount += aiPotionCount
		newTotal += MyPotionCounts[aiPotionIndex]
		MyPotionCounts[aiPotionIndex] = newTotal
		AliasDebug("UpdateItemCounts - increment by " + aiPotionCount + ": MyTotalPotionCount = " + MyTotalPotionCount + ", MyPotionCounts[" + aiPotionIndex + "] = " + newTotal)
	else
		UpdateEffectCounts(PoisonEffectsSpecial, aiEffectTypesSpecial, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(PoisonEffectsStats, aiEffectTypesDamageStats, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(PoisonEffectsWeakness, aiEffectTypesWeakness, aiPotionCount, aiPotionIndex, abIsPoison)
		UpdateEffectCounts(PoisonEffectsGeneric, aiEffectTypesGenericHarmful, aiPotionCount, aiPotionIndex, abIsPoison)
		MyTotalPoisonCount += aiPotionCount
		newTotal += MyPoisonCounts[aiPotionIndex]
		MyPoisonCounts[aiPotionIndex] = newTotal
		AliasDebug("UpdateItemCounts - increment by " + aiPotionCount + ": MyTotalPoisonCount = " + MyTotalPoisonCount + ", MyPoisonCounts[" + aiPotionIndex + "] = " + newTotal)
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
			AliasDebug("UpdateEffectCounts - set HasItemOfType[" + effectType + "] to " + newTotal + ", and array" + effectType + "[" + aiPotionIndex + "] to true ")
		else
			trackerList[aiPotionIndex] = false
		endIf
	endWhile
endFunction

bool function UseItemIfPossible(string asState, bool abIsPoison, int aiEffectType, int aiHand = -1)
	string itemType = "potion"
	Actor subject = MyActor
	if (abIsPoison)
		itemType = "poison"
		subject = MyEnemy
	endIf
	string effectName = EffectNames[aiEffectType]
	string msg = asState + "::UseItemIfPossible (" + itemType + ", " + aiEffectType + ": " + effectName + ") - "
	bool itemUsed = false
	if (HasItemOfType[aiEffectType] < 1)
		if (!abIsPoison)
			WarnNoItems(asState, aiEffectType, effectName, abIsPoison)
		endIf
		msg += "no " + effectName + " " + itemType + " items"
	elseif (IsInCooldown(aiEffectType, subject))
		msg += effectName + " " + itemType + " still taking effect"
	else
		bool itemWorked = false
		if (abIsPoison)
			itemWorked = TryFirstPoisonThatExists(asState, aiEffectType, aiHand)
		else
			itemWorked = TryFirstPotionThatExists(asState, aiEffectType)
		endIf
		if (itemWorked)
			msg += "used " + effectName  + " " + itemType + " from array" + aiEffectType
			itemUsed = true
		else
			if (!abIsPoison)
				WarnNoItems(asState, aiEffectType, effectName, abIsPoison)
			endIf
			msg += "failed to use " + effectName  + " " + itemType + " (something out of sync?)"
		endIf
	endIf
	AliasDebug(msg)
	return itemUsed
endFunction

function WarnNoItems(string asState, int aiEffectType, string asEffectName, bool abIsPoison)
	asState += "::WarnNoItems"
	int index
	string itemName
	if (abIsPoison)
		index = 5
		itemName = "poisons"
	else
		if (RestoreEffects.Find(aiEffectType) > -1)
			index = aiEffectType
			itemName = asEffectName
		elseIf (FortifyEffectsStats.Find(aiEffectType) > -1 || FortifyEffectsWarrior.Find(aiEffectType) > -1 || FortifyEffectsMage.Find(aiEffectType) > -1)
			index = 3
			itemName = "Fortify"
		elseIf (ResistEffects.Find(aiEffectType) > -1)
			index = 4
			itemName = "Resist"
		endIf
		itemName += " potions"
	endIf
	if (!EnableWarnings[index])
		AliasDebug(asState + " - warnings disabled for " + asEffectName)
		return
	endIf
	float currentHoursPassed = Game.GetRealHoursPassed()
	float nextWarning = MyPotionWarningTimes[index] + (WarningIntervals[index] / 3600.0)
	if (currentHoursPassed >= nextWarning)
		AliasDebug(asState + " - " + itemName + " warning (for " + asEffectName + ") updated to " + currentHoursPassed, "$FPPNotsNeedsMoreItem{" + MyActorName + "}{" + itemName + "}")
		MyPotionWarningTimes[index] = currentHoursPassed
	else
		AliasDebug(asState + " - no " + itemName + " (for " + asEffectName + "; last warning " + MyPotionWarningTimes[index] + ", currently " + currentHoursPassed + ", next " + nextWarning + ")")
	endif
endFunction

bool function TryFirstPotionThatExists(string asState, int aiEffectType)
	bool[] trackerList = GetTrackerList(aiEffectType)
	int itemIndex = trackerList.Find(true)
	if (itemIndex < 0)
		return false
	endIf
	while (itemIndex < MyPotionList.Length)
		if (trackerList[itemIndex])
			Potion thisItem = MyPotionList[itemIndex] as Potion
			string msg = asState + "::TryFirstPotionThatExists - array" + aiEffectType + "[" + itemIndex + "]"
			if (thisItem != None && thisItem.HasKeyword(EffectKeywords[aiEffectType]))
				int itemCount = MyActor.GetItemCount(thisItem)
				int arrayCount = MyPotionCounts[itemIndex]
				msg += ", have " + itemCount + " (" + arrayCount + "/" + HasItemOfType[aiEffectType] + "/" + MyTotalPotionCount + ")"
				if (itemCount > 0)
					MyPotionCounts[itemIndex] = arrayCount - 1
					MyActor.EquipItemEx(thisItem, 2, false, true)
					UpdateCountsAndArrays(asState, false, itemIndex, 1, itemCount == 1)
					MyTotalPotionCount -= 1
					msg += ", use " + thisItem.GetName() + " (" + thisItem.GetFormId() + "), " + (itemCount - 1) + " remaining"
					AliasDebug(msg)
					return true
				else
					UpdateCountsAndArrays(asState, false, itemIndex, 0, true)
					AliasDebug(msg + " - removed from arrays SHOUND'T HAPPEN!")
				endif
			endIf
		endIf
		itemIndex += 1
	endWhile
	return false
endFunction

bool function TryFirstPoisonThatExists(string asState, int aiEffectType, int aiHand)
	bool[] trackerList = GetTrackerList(aiEffectType)
	int itemIndex = trackerList.Find(true)
	if (itemIndex < 0)
		return false
	endIf
	while (itemIndex < MyPoisonList.Length)
		if (trackerList[itemIndex])
			Potion thisItem = MyPoisonList[itemIndex] as Potion
			; some poisons (eg venoms) do not actually have MagicAlchHarmful, only VendorItemPoison.
			; That isn't technically an effect type, but for purposes of the mod, all generic poisons
			; are registered as having it. So if we're testing for it here, convert to sending -1,
			; so the TryFirstPoisonThatExists function will bypass testing for the specific keyword
			int passedEffectType = aiEffectType
			if (aiEffectType == EFFECT_HARMFUL)
				passedEffectType = -1
			endIf
			string msg = asState + "::TryFirstPoisonThatExists - array" + aiEffectType + "[" + itemIndex + "]"
			if (thisItem != None && (passedEffectType < 0 || thisItem.HasKeyword(EffectKeywords[aiEffectType])))
				int itemCount = MyActor.GetItemCount(thisItem)
				int arrayCount = MyPoisonCounts[itemIndex]
				msg += ", have " + itemCount + " (" + arrayCount + "/" + HasItemOfType[aiEffectType] + "/" + MyTotalPoisonCount + ")"
				if (itemCount > 0)
					msg += ", try use " + thisItem.GetName() + " poison on " + GetHand(aiHand) + ": "
					int ret = _Q2C_Functions.WornObjectSetPoison(MyActor, aiHand, 0, thisItem, 1)
					if (ret < 0)
						msg += "fail (for unknown reason)"
						AliasDebug(msg)
					else
						MyPoisonCounts[itemIndex] = arrayCount - 1
						MyActor.RemoveItem(thisItem)
						UpdateCountsAndArrays(asState, true, itemIndex, 1, itemCount == 1)
						MyTotalPoisonCount -= 1
						msg += "success, " + (itemCount - 1) + " remaining"
						AliasDebug(msg)
						return true
					endIf
				else
					UpdateCountsAndArrays(asState, true, itemIndex, 0, true)
					AliasDebug(msg + " - removed from arrays SHOUND'T HAPPEN!")
				endIf
			endIf
		endIf
		itemIndex += 1
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

Function ShowItems(bool abShowPoisons)
	if (!MyActor)
		return
	endIf
	string msg = GetPotionReport(abShowPoisons)
	AliasDebug(msg)
	Debug.MessageBox(msg)
endFunction

string Function GetPotionReport(bool abShowPoisons)
	Potion[] itemList = MyPotionList
	if (abShowPoisons)
		itemList = MyPoisonList
	endIf
	int i = itemList.Length
	string potionReport = ""
	while (i)
		i -= 1
		if (itemList[i])
			potionReport += itemList[i].GetName() + " (" + MyActor.GetItemCount(itemList[i]) + "); "
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
	AliasDebug("Can't find list for " + aiEffectType + ", return empty")
	return new bool[1]
endFunction

int function UpdateCountsAndArrays(string asState, bool abIsPoison, int aiIndex, int aiCount, bool abSetToNone)
	if (aiIndex < 0)
		return 0
	endIf
;string msg = asState + "::UpdateCountsAndArrays - "
;float ftimeStart = Utility.GetCurrentRealTime()
	if (abSetToNone)
		if (!abIsPoison)
			MyPotionList[aiIndex] = None
			;msg += "Set MyPotionList[" + aiIndex + "] to None - "
		else
			MyPoisonList[aiIndex] = None
			;msg += "Set MyPoisonList[" + aiIndex + "] to None - "
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
	AliasDebug(msg)
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
	PoisonImmunityKeywords = FPPQuest.PoisonImmunityKeywords
	PoisonImmunityMappings = FPPQuest.PoisonImmunityMappings

	DebugToFile = FPPQuest.DebugToFile
endFunction

Function SetDefaults()
	UpdateIntervalInCombat = FPPQuest.DefaultUpdateIntervalInCombat
	UpdateIntervalNonCombat = FPPQuest.DefaultUpdateIntervalNonCombat
	EnableWarningNoPotions = FPPQuest.DefaultEnableWarningNoPotions
	UpdateIntervalNoPotions = FPPQuest.DefaultUpdateIntervalNoPotions

	EnableWarnings = FPPQuest.GetDefaultEnableWarnings()
	WarningIntervals = FPPQuest.GetDefaultWarningIntervals()

	StatLimitsInCombat = FPPQuest.GetDefaultStatLimits(true)
	StatLimitsNonCombat = FPPQuest.GetDefaultStatLimits(false)

	LvlDiffTrigger = FPPQuest.DefaultLvlDiffTrigger
	TriggerRaces = FPPQuest.GetDefaultTriggerRaces()
	UsePotionOfType = FPPQuest.GetDefaultUsePotionsOfTypes()

	LvlDiffTriggerPoison = FPPQuest.DefaultLvlDiffTriggerPoison
	GlobalUsePoisons = FPPQuest.GetDefaultGlobalUsePoisons()
	UsePoisonOfType = FPPQuest.GetDefaultUsePoisonsOfTypes()
	
	IdentifyPotionEffects = FPPQuest.DefaultIdentifyPotionEffects
	
	ResetHasItemOfType()
endFunction

Function ResetHasItemOfType()
	EffectKeywords = FPPQuest.EffectKeywords
	HasItemOfType = Utility.CreateIntArray(EffectKeywords.Length, 0)
endFunction

Function ClearPotionLists()
	MyTotalPotionCount = 0
	MyPotionList = new Potion[127]
	MyPotionCounts = new int[127]
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
	MyTotalPoisonCount = 0
	MyPoisonList = new Potion[127]
	MyPoisonCounts = new int[127]
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

function AliasDebug(string asLogMsg, string asScreenMsg = "")
	if (DebugToFile && asLogMsg != "")
		Debug.TraceUser("FollowerPotions", MyActorName + ": " + asLogMsg)
	endIf
	if (asScreenMsg != "")
		FPPQuest.UINotification(asScreenMsg)
	endIf
endFunction
