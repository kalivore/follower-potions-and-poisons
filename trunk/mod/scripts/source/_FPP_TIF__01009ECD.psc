;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _FPP_TIF__01009ECD Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
_FPP_Quest FPP_Quest = GetOwningQuest() as _FPP_Quest
int i = 0
int iMax = FPP_Quest.AllFollowers.Length
while (i < iMax)
	if (FPP_Quest.AllFollowers[i] && (FPP_Quest.AllFollowers[i].GetReference() as Actor) == akSpeaker)
		(FPP_Quest.AllFollowers[i] as _FPP_FollowerScript).ShowItems(false)
	endIf
	i += 1
endWhile
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
