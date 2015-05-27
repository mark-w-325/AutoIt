#include <ImageSearch.au3>

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         Mark Williams

 Script Function:
	Auto raid in Clash of Lords 2 on Bluestacks

#ce ----------------------------------------------------------------------------

Local Const $reduce_factor = 0.2
Local Const $minuskey = Chr(45)
Local Const $title = "BlueStacks App Player"
Local $gameimage = @ScriptDir & "\Images\ClashofLords2.bmp" ;==> Game icon
Local $full = WinGetTitle($title)
Local $hWnD = WinGetHandle($full)

; Function to search for images and click them
Func _SearchImage($img, $sleep = 500, $noimg = False, $imgname = "default")
   ;Local $imgresult = _ImageSearchArea($raidbutton, 1, $bsx1, $bsy1, $bsx2, $bsy2, $x, $y, 0)
   Local $x = 0
   Local $y = 0

   Local $imgresult = _ImageSearch($img, 1, $x, $y, 0)

   If $imgresult = 1 Then
	  MouseMove(_ConvertCoord($x), _ConvertCoord($y))
	  Sleep(10)
	  ;ControlClick($title, "", $hWnD, "left", 1, _ConvertCoord($x), _ConvertCoord($y))
	  MouseClick("left")
	  Sleep($sleep)
   ElseIf $imgresult = 0 And $noimg = True Then
	  _NoImage($imgname)
   EndIf
EndFunc ;==>_SearchImage

; Function to find game in BlueStacks and click it.
Func _ClickGame($gamestarted=False)
   ControlFocus($title, "", $hWnD)

   If Not $gamestarted Then
	  _SearchImage($gameimage, 60000, True, "Game Icon")
	  _ZoomOut()
   Else
	  _ZoomOut()
   EndIf
EndFunc ;==_ClickGame

; Drop heroes into map
Func _DropHeroes()
   MouseClickDrag("left", 641, 279, 641, 700)
   Sleep(1000)
   MouseClickDrag("left", 641, 279, 641, 641)
   Sleep(1000)
   $i = 0
   Do
	  ;ControlClick($title, "", $hWnD, "left", 1, 641, 149)
	  MouseClick("left", 641, 149)
	  Sleep(200)
	  $i += 1
   Until $i = 5
EndFunc ;==>_DropHeroes

; Use Skill
Func _HeroSkill($img)
   _SearchImage($img, 10)
EndFunc ;==>_HeroSkill

; Use Divine skill
Func _DivineSkill($img)
   _SearchImage($img, 1000)
EndFunc ;==>_DivineSkill

Func _UseSkill($endraidimg, $returnbtnimg, $hero1, $hero2, $hero3, $hero4, $hero5)
   Local $result = _ImageSearch($endraidimg, 1, $x, $y, 0)
   Local $result2 = _ImageSearch($returnbtnimg, 1, $x, $y, 0)

   Do
	  _HeroSkill($hero1)
	  _HeroSkill($hero2)
	  _HeroSkill($hero3)
	  _HeroSkill($hero4)
	  _HeroSkill($hero5)
	  MouseMove(585, 355)
	  $result = _ImageSearch($endraidimg, 1, $x, $y, 0)
	  $result2 = _ImageSearch($returnbtnimg, 1, $x, $y, 0)
   Until $result > 0 Or $result2 > 0
EndFunc ;==>_UseSkill

Func _ConvertCoord($coord)
   Local $returncoord = $coord - ($coord * $reduce_factor)
   Return $returncoord
EndFunc ;==>_ConvertCoord

Func _ZoomOut()
   Send("^{" & $minuskey & " 500}")
EndFunc ;==>_ZoomOut

Func _MintoMilli($minutes)
   Local $returnval = $minutes * 60 * 1000
   Return $returnval
EndFunc ;==>_MintoMilli

Func _SectoMilli($seconds)
   Local $returnval = $seconds * 1000
   Return $returnval
EndFunc ;==> _SectoMilli

Func _Terminate()
    Exit 0
 EndFunc ;==>_Terminate

Func _NoImage($imagename)
   MsgBox(0, "No Image", "Could not find the image for " & $imagename & ". Will now exit script.")
   Exit 1
EndFunc ;==>_NoImage