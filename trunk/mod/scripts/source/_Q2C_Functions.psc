Scriptname _Q2C_Functions hidden

;-----Poison Functions
; unfortunately don't have the source for these, so will have to re-do if possible
; Valid Hand Slot:
; 0 - Left
; 1 - Right
;/
Function 		Worn_PoisonWeapon(Actor akActor, int handSlot, Potion poison, int charges = 1) 	global native
bool Function 	Worn_IsWeaponPoisoned(Actor akActor, int handSlot) 								global native
Potion Function	Worn_GetPoison(Actor akActor, int handSlot) 									global native
int Function 	Worn_GetPoisonCharges(Actor akActor, int handSlot) 								global native
Function 	 	Worn_SetPoisonCharges(Actor akActor, int handSlot, int charges = 1) 			global native
Function 		PoisonWeapon(ObjectReference objRef, Potion poison, int charges = 1) 			global native
bool Function 	IsWeaponPoisoned(ObjectReference objRef) 										global native
Potion Function GetPoison(ObjectReference objRef) 												global native
int Function 	GetPoisonCharges(ObjectReference objRef) 										global native
Function 		SetPoisonCharges(ObjectReference objRef, int charges = 1) 						global native
/;



;-------------------------------------------------
;              Inventory Functions
;-------------------------------------------------
; Q2C's original functions, updated for SKSE 1.7.3
; Note that GetNumItemsWithKeyword groups by item type
; ie, a stack of ten daggers counts as ONE toward the total, NOT ten
int Function 	GetNumItemsWithKeyword(ObjectReference objRef, Keyword key) 					global native
Form Function 	GetNthFormWithKeyword(ObjectReference objRef, Keyword key, int KeywordIndex) 	global native

; these functions will return the full number of items in the container
; ie, a stack of ten daggers actually counts as ten items
;int Function 	GetTotalNumItemsWithKeyword(ObjectReference objRef, Keyword key) 				global native
;int Function 	GetTotalNumItems(ObjectReference ObjectReference) 								global native

; added by Kalivore - type is the SKSE itemType (eg 26 for armour, or 46 for potion)
; full list at http://www.creationkit.com/index.php?title=GetType_-_Form
int Function 	GetNumItemsOfType(ObjectReference objRef, int type)			 					global native
Form Function 	GetNthFormOfType(ObjectReference objRef, int type, int KeywordIndex) 			global native



;----------------------------------------
;     Additional spell-checking Functions
;          also added by Kalivore
;----------------------------------------
bool Function 		ActorHasSpellSchool(Actor akActor, string asSchool, bool abSearchBase) 		global native
{
Scans the MagicEffects of the Actor's spells, returning true at the first one of the relevant school.
Optionally will also check through the relevant ActorBase (which is more likely to be the one with the spells)
}

bool Function 		ActorBaseHasSpellSchool(ActorBase akActorBase, string asSchool) 			global native
{
Scans the MagicEffects of the ActorBase's spells, returning true at the first one of the relevant school.
}



;--------------------------------------
;     Additional Keyword Functions
;       also added by Kalivore
;--------------------------------------
bool Function 		ActorHasSpellKeyword(Actor akActor, Keyword akKeyword, bool abSearchBase) 	global native
{
Scans the Actor's spells for the specified Keywords, returning true at the first one it finds
(NOTE - although Keywords are technically applied to the Magic Effects, the game considers them as being on Spell as well)
Optionally will also check through the relevant ActorBase (which is more likely to be the one with the spells)
}

bool Function 		ActorBaseHasSpellKeyword(ActorBase akActorBase, Keyword akKeyword) 			global native
{
Scans the ActorBase's spells for the specified Keywords, returning true at the first one it finds
(NOTE - although Keywords are technically applied to the Magic Effects, the game considers them as being on Spell as well)
}