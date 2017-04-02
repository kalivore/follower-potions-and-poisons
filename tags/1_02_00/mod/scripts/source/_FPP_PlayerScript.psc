Scriptname _FPP_PlayerScript extends ReferenceAlias  

_FPP_Quest FPPQuest

event OnInit()
	FPPQuest = GetOwningQuest() as _FPP_Quest
endEvent

event OnPlayerLoadGame()
	FPPQuest.Update()
endEvent
