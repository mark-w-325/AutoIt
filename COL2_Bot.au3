#include <COL2_Functions.au3>

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         Mark Williams

 Script Function:
	Auto raid in Clash of Lords 2 on Bluestacks

#ce ----------------------------------------------------------------------------

HotKeySet("{ESC}", "_Terminate")

; Variables to be used
Global $x = 0
Global $y = 0
Global $manualrun = True
Global $maxsleeptime = 10 ; Represents minutes to sleep for heroes to revive
Global $botbaseonly = False
;Global $bluestackwindow = WinGetPos("BlueStacks App Player")
;Global $bsx1 = $bluestackwindow[0]
;Global $bsy1 = $bluestackwindow[1]
;Global $bsx2 = $bluestackwindow[2]
;Global $bsy2 = $bluestackwindow[3]

; Set up of images
Global $eventxbutton = @ScriptDir & "\Images\EventXButton.bmp" ;==> X button to look for
Global $raidxbutton = @ScriptDir & "\Images\RaidedXButton.bmp" ;==> X button to look for
Global $attackbutton = @ScriptDir & "\Images\Attack.bmp" ;==> Attack button at main screen
Global $shieldbutton = @ScriptDir & "\Images\CloseShield.bmp" ;==> Confirm removing shield
Global $raidbutton = @ScriptDir & "\Images\Raid.bmp" ;==> Raid button after Attack screen
Global $chestimg = @ScriptDir & "\Images\Open_Chest.bmp" ;==> Open Chest Image
Global $returnimg = @ScriptDir & "\Images\ReturntoMap.bmp" ;==> Return to map Image
Global $hero = @ScriptDir & "\Images\Hero.bmp" ;==> Hero button to view heroes
Global $savagechief = @ScriptDir & "\Images\SavageChief.bmp" ;==> For now we will just merge stuff to Savage Chief
Global $levelup = @ScriptDir & "\Images\LevelUp.bmp" ;==> Level up button
Global $autoselect = @ScriptDir & "\Images\AutoSelectEggs.bmp" ;==> Auto select eggs/heros to merge
Global $merge = @ScriptDir & "\Images\MergeHero.bmp" ;==> Button to merge those selected
Global $mergexbutton = @ScriptDir & "\Images\MergeXButton.bmp" ;==> X button to close merging heroes
Global $revivemsg = @ScriptDir & "\Images\Revive.bmp" ;==> Revive heroes message
Global $revivexbutton = @ScriptDir & "\Images\Revive_XButton.bmp" ;==> Revive message x button
Global $botbase = @ScriptDir & "\Images\Bot_Base.bmp"
Global $nextsearch = @ScriptDir & "\Images\NextSearch.bmp"

; Dead hero images
;Global $deadpdr = @ScriptDir & "\Images\Dead_PDR.bmp" ;==> Dead Pounder
;Global $deaddr = @ScriptDir & "\Images\Dead_DR.bmp" ;==> Dead Dark Rider
;Global $deadpg = @ScriptDir & "\Images\Dead_PG.bmp" ;==> Dead Pan Goli
;Global $deadrv = @ScriptDir & "\Images\Dead_RV.bmp" ;==> Dead Renee Ven

; Skill Images
Global $pgskill = @ScriptDir & "\Images\PG_Skill.bmp" ;==> Pan Goli's skill
Global $drskill = @ScriptDir & "\Images\DR_Skill.bmp" ;==> Dark Rider's skill
Global $pdrskill = @ScriptDir & "\Images\PDR_Skill.bmp" ;==> Pounder's skill
Global $chironskill = @ScriptDir & "\Images\Chiron_Skill.bmp" ;==> Chiron's skill
Global $rvskill = @ScriptDir & "\Images\RV_Skill.bmp" ;==> Renee Ven's skill
Global $alskill = @ScriptDir & "\Images\AL_Skill.bmp" ;==> Artic Lord's skill
Global $sappskill = @ScriptDir & "\Images\Sapp_Skill.bmp" ;==> Sapphirix's skill

; Divine Images
Global $pgdivine = @ScriptDir & "\Images\PG_Divine.bmp" ;==> Pan Goli's Divine
Global $drdivine = @ScriptDir & "\Images\DR_Divine.bmp" ;==> Dark Rider's Divine
Global $pdrdivine = @ScriptDir & "\Images\PDR_Divine.bmp" ;==> Pounder's Divine
Global $aldivine = @ScriptDir & "\Images\AL_Divine.bmp" ;==> Artic Lord's Divine

;~ Outside of Loop
; Start the game in BlueStacks
_ClickGame(True)

; Close any boxes that come up when the game loads
_SearchImage($raidxbutton, 2000)
_SearchImage($eventxbutton, 2000)

;~ Start Loop here
While 1
   ; Find the attack button
   _SearchImage($attackbutton, 4000, True, "Attack button")

   $reviveresult = _ImageSearch($revivemsg, 1, $x, $y, 0)

   If $reviveresult > 0 Then
	  _SearchImage($revivexbutton, 1000)
	  $waitMin = _MintoMilli($maxsleeptime)
	  $starttime = TimerInit()
	  $i = 0
	  While TimerDiff($starttime) < $waitMin
		 Sleep(100)
		 MouseMove($i, 355)
		 If $i > @DesktopWidth Then
			ConsoleWrite("Reset cursor location" & @CRLF)
			ConsoleWrite(TimerDiff($starttime) & @CRLF)
			$i = 0
		 Else
			$i = $i + 1
		 EndIf

	  WEnd
	  _SearchImage($attackbutton, 4000, True, "Attack button")
   EndIf

   ; Find the raid button
   _SearchImage($raidbutton, 2000, True, "Raid button")

   ; Continue if shield exists
   _SearchImage($shieldbutton, 3000)

   ; Sleep while raiding map loads
   Sleep(5000)

   ; Test if its a bot base
   $botresult = _ImageSearch($botbase, 1, $x, $y, 0)

   If $botbaseonly Then
   ; Search for bot base
	  While $botresult = 0
		 _SearchImage($nextsearch, 6000)
		 $botresult = _ImageSearch($botbase, 1, $x, $y, 0)
	  WEnd
   EndIf

   ; Drop heroes onto map
   _DropHeroes()

   ; Use Dark Rider's divine
   _DivineSkill($drDivine)

   ; Wait one second
   Sleep(1000)

   ; Use Pan Goli's divine
   _DivineSkill($pgdivine)

   ; Wait two seconds
   Sleep(2000)

   ; Use Pounder's divine
   _DivineSkill($pdrdivine)

   Sleep(1000)

   ;Use Artic Lord's divine
   _DivineSkill($aldivine)

   Sleep(1000)

   ; Use hero skills until the end of the raid
   _UseSkill($chestimg, $returnimg, $pgskill, $sappskill, $pdrskill, $drskill, $alskill)

   Sleep(3000)
   ; Open Chests
   _SearchImage($chestimg, 2000)

   ; Move the mouse to the center of the screen to not interrupt the image searching
   MouseMove(585, 355)

   ; Return to map
   _SearchImage($returnimg, 8000)

   ; Select hero to merge heroes
   _SearchImage($hero, 2000)

   ; Select Savage Chief
   _SearchImage($savagechief, 2000)

   ; Select level up button
   _SearchImage($levelup, 2000)

   ; Autoselect eggs and heroes to merge
   _SearchImage($autoselect, 2000)

   ; Select merge button
   _SearchImage($merge, 2000)

   ; Close the hero merge box
   _SearchImage($mergexbutton, 2000)

   Sleep(1000)

   ; Check for dead heroes
   ;$deadheroresult1 = _ImageSearch($deadpdr, 1, $x, $y, 0)
   ;$deadheroresult2 = _ImageSearch($deaddr, 1, $x, $y, 0)
   ;$deadheroresult3 = _ImageSearch($deadpg, 1, $x, $y, 0)
   ;$deadheroresult4 = _ImageSearch($deadrv, 1, $x, $y, 0)

   ;While 1
	  ;$deadheroresult1 = _ImageSearch($deadpdr, 1, $x, $y, 0)
	  ;If $deadheroresult1 = 0 Then
		 ;ExitLoop
	  ;ElseIf $deadheroresult1 > 0 Then
		 ;Sleep(240000)
	  ;EndIf
   ;WEnd
WEnd