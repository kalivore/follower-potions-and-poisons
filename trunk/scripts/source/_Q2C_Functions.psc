Scriptname _Q2C_Functions hidden

; Valid Hand Slot:
; 0 - Left
; 1 - Right
;-----Poison Functions
;/
Function 		Worn_PoisonWeapon(Actor akActor, int handSlot, Potion poison, int Charges = 1) 	global native
bool Function 	Worn_IsWeaponPoisoned(Actor akActor, int handSlot) 								global native
Potion Function	Worn_GetPoison(Actor akActor, int handSlot) 									global native
int Function 	Worn_GetPoisonCharges(Actor akActor, int handSlot) 								global native
Function 	 	Worn_SetPoisonCharges(Actor akActor, int handSlot, int Charges = 1) 			global native
Function 		PoisonWeapon(ObjectReference objRef, Potion poison, int Charges = 1) 			global native
bool Function 	IsWeaponPoisoned(ObjectReference objRef) 										global native
Potion Function GetPoison(ObjectReference objRef) 												global native
int Function 	GetPoisonCharges(ObjectReference objRef) 										global native
Function 		SetPoisonCharges(ObjectReference objRef, int Charges = 1) 						global native
/;
;-----Inventory Functions
int Function 	GetNumItemsWithKeyword(ObjectReference objRef, Keyword key) 					global native
Form Function 	GetNthFormWithKeyword(ObjectReference objRef, Keyword key, int KeywordIndex) 	global native
int Function 	GetNumItemsOfType(ObjectReference objRef, int type)			 					global native
Form Function 	GetNthFormOfType(ObjectReference objRef, int type, int KeywordIndex) 			global native
;int Function 	GetTotalNumItemsWithKeyword(ObjectReference objRef, Keyword key) 				global native
;int Function 	GetTotalNumItems(ObjectReference ObjectReference) 								global native
