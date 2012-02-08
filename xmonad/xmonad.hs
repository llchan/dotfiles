--------------------------------------------------------------------------------------------
-- ~/.xmonad/xmonad.hs                                                                    --
-- validate syntax: xmonad --recompile                                                    --
--------------------------------------------------------------------------------------------
-- author: nnoell <nnoell3[at]gmail.com>                                                  --
-- credit: milomouse     -> copied about 60% of his xmonad.hs. Too many thanks to mention --
--         and1          -> config used as my starting grounds                            --
--         count-corrupt -> copied clickable workspaces and clickable layout swithcher    --
--------------------------------------------------------------------------------------------

-- Misc
{-# LANGUAGE DeriveDataTypeable, NoMonomorphismRestriction, TypeSynonymInstances, MultiParamTypeClasses #-}

-- Imported libraries
import XMonad
import XMonad.Core
import XMonad.Layout
import XMonad.Layout.IM
import XMonad.Layout.Gaps
import XMonad.Layout.Named
import XMonad.Layout.Tabbed
import XMonad.Layout.OneBig
import XMonad.Layout.Master
import XMonad.Layout.Reflect
import XMonad.Layout.MosaicAlt
import XMonad.Layout.NoBorders (noBorders,smartBorders,withBorder)
import XMonad.Layout.ResizableTile
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Minimize
import XMonad.StackSet (RationalRect (..), currentTag)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts,avoidStrutsOn,manageDocks)
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad
import XMonad.Util.Cursor
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Scratchpad (scratchpadManageHook, scratchpadSpawnActionCustom)
import XMonad.Util.NamedScratchpad
import XMonad.Actions.CycleWS (nextWS, prevWS, toggleWS, toggleOrView)
import XMonad.Actions.GridSelect
import XMonad.Actions.FloatKeys
import Data.Monoid
import Data.List
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import System.IO (Handle, hPutStrLn)
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified XMonad.Actions.FlexibleResize as Flex

-- Main
main :: IO ()
main = do
	workspaceBar            <- spawnPipe myWorkspaceBar
	{- bottomStatusBar         <- spawnPipe myBottomStatusBar -}
	{- topStatusBar            <- spawnPipe myTopStatusBar -}
	statusBar               <- spawnPipe myStatusBar
	xmonad $ myUrgencyHook $ ewmh defaultConfig
		{ terminal           = "urxvt"
		, modMask            = mod4Mask
		, focusFollowsMouse  = True
		, borderWidth        = 1
		, normalBorderColor  = myNormalBorderColor
		, focusedBorderColor = myFocusedBorderColor
		, layoutHook         = myLayoutHook
		, workspaces         = myWorkspaces
		, manageHook         = manageDocks <+> myManageHook
		, logHook            = myLogHook >> (dynamicLogWithPP $ myDzenPP workspaceBar)
		, handleEventHook    = fullscreenEventHook
		, keys               = myKeys
		, mouseBindings      = myMouseBindings
		, startupHook        = myStartupHook
		}

-- Colors and fonts
myFont               = "-xos4-terminus-medium-r-normal-*-12-120-72-72-c-60-*-*"
{- dzenFont             = "-xos4-terminus-medium-r-normal-*-12-120-72-72-c-60-*-*" -}
dzenFont             = "-*-montecarlo-medium-r-normal-*-11-*-*-*-*-*-*-*"
colorBlack           = "#020202" --Background (Dzen_BG)
colorBlackAlt        = "#1c1c1c" --Black Xdefaults
colorGray            = "#444444" --Gray       (Dzen_FG2)
colorGrayAlt         = "#161616" --Gray dark
colorWhite           = "#a9a6af" --Foreground (Shell_FG)
colorWhiteAlt        = "#9d9d9d" --White dark (Dzen_FG)
colorMagenta         = "#8e82a2"
colorBlue            = "#3475aa"
colorRed             = "#d74b73"
colorGreen           = "#99cc66"
myArrow              = "^fg(" ++ colorWhiteAlt ++ ")>^fg(" ++ colorBlue ++ ")>^fg(" ++ colorGray ++ ")>"
myNormalBorderColor  = colorBlackAlt
myFocusedBorderColor = colorGray

-- Tab theme
myTabTheme = defaultTheme
	{ fontName            = myFont
	, inactiveBorderColor = colorBlackAlt
	, inactiveColor       = colorBlack
	, inactiveTextColor   = colorGray
	, activeBorderColor   = colorGray
	, activeColor         = colorBlackAlt
	, activeTextColor     = colorWhiteAlt
	, urgentBorderColor   = colorGray
	, urgentTextColor     = colorGreen
	, decoHeight          = 14
	}

-- Prompt theme
myXPConfig = defaultXPConfig
	{ font                = myFont
	, bgColor             = colorBlack
	, fgColor             = colorWhite
	, bgHLight            = colorBlue
	, fgHLight            = colorWhite
	, borderColor         = colorGrayAlt
	, promptBorderWidth   = 1
	, height              = 16
	, position            = Top
	, historySize         = 100
	, historyFilter       = deleteConsecutive
	, autoComplete        = Nothing
	}

-- GridSelect color scheme
myColorizer = colorRangeFromClassName
	(0x00,0x00,0x00) -- lowest inactive bg
	(0x60,0xA0,0xC0) -- highest inactive bg
	(0x34,0x75,0xAA) -- active bg
	(0xBB,0xBB,0xBB) -- inactive fg
	(0x00,0x00,0x00) -- active fg
	where
		black = minBound
		white = maxBound

-- GridSelect theme
myGSConfig colorizer = (buildDefaultGSConfig myColorizer)
	{ gs_cellheight  = 50
	, gs_cellwidth   = 200
	, gs_cellpadding = 10
	, gs_font        = myFont
	}

-- Scratchpad (Alt+º)
manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect (0) (1/50) (1) (3/4))
scratchPad = scratchpadSpawnActionCustom "urxvt -name scratchpad"

-- Transformers (Ctrl+f)
data TABBED = TABBED deriving (Read, Show, Eq, Typeable)
instance Transformer TABBED Window where
	transform TABBED x k = k (named "TS" (smartBorders (tabbedAlways shrinkText myTabTheme))) (\_ -> x)

-- StartupHook
myStartupHook = setWMName "LG3D" >> setDefaultCursor xC_left_ptr

-- LogHook (needed for running java apps)
myLogHook = ewmhDesktopsLogHook >> setWMName "LG3D"

-- UrgencyHook
myUrgencyHook = withUrgencyHook dzenUrgencyHook
	{ args = ["-fn", dzenFont, "-bg", colorBlack, "-fg", colorGreen] }

-- StatusBars
{- myWorkspaceBar, myBottomStatusBar, myTopStatusBar :: String -}
myWorkspaceBar, myStatusBar :: String
{- myWorkspaceBar    = "dzen2 -x '0' -y '884' -h '16' -w '1440' -ta 'l' -fg '" ++ colorWhiteAlt ++ "' -bg '" ++ colorBlack ++ "' -fn '" ++ dzenFont ++ "' -p -e ''" -}
myWorkspaceBar    = "dzen2 -x '0' -y '0' -h '16' -w '640' -ta 'l' -fg '" ++ colorWhiteAlt ++ "' -bg '" ++ colorBlack ++ "' -fn '" ++ dzenFont ++ "' -p -e ''"
{- myBottomStatusBar = "/home/llchan/bin/bottomstatusbar.sh" -}
{- myTopStatusBar    = "/home/llchan/bin/topstatusbar.sh" -}
myStatusBar = "/home/llchan/.xmonad/status.sh"

-- Workspaces
myWorkspaces :: [WorkspaceId]
myWorkspaces = --clickable $ --clickable workspaces now declared in myDzenPP
    ["1"
    ,"2"
    ,"3"
    ,"4"
    ,"5"
    ,"6"
    ,"7"
    ,"8"
	]
	{- ["TERM"  --0 -}
	{- ,"WEBS"  --1 -}
	{- ,"CODE"  --2 -}
	{- ,"GRFX"  --3 -}
	{- ,"CHAT"  --4 -}
	{- ,"GAME"  --5 -}
	{- ,"VIDS"  --6 -}
	{- ,"OTHR"  --7 -}
--	where clickable l = [ "^ca(1,xdotool key super+" ++ show (n) ++ ")" ++ ws ++ "^ca()" |
--		(i,ws) <- zip [1..] l,
--		let n = if i == 10 then 0 else i ]

{- $ gaps [(U,16), (D,16), (L,0), (R,0)] -}
-- Layout hook
myLayoutHook = id
	$ gaps [(U,16), (D,0), (L,0), (R,0)]
	{- $ avoidStruts -}
	$ minimize
	$ mkToggle (single TABBED)
	$ mkToggle (single MIRROR)
	$ mkToggle (single REFLECTX)
	$ mkToggle (single REFLECTY)
	$ onWorkspace (myWorkspaces !! 1) webLayouts  --Workspace 1 layouts
	$ onWorkspace (myWorkspaces !! 2) codeLayouts --Workspace 2 layouts
	$ onWorkspace (myWorkspaces !! 3) gimpLayouts --Workspace 3 layouts
	$ onWorkspace (myWorkspaces !! 4) chatLayouts --Workspace 4 layouts
	$ allLayouts
	where
		allLayouts  = myTile ||| myObig ||| myMirr ||| myMosA ||| myTabM
		webLayouts  = myTabs ||| myTabM
		codeLayouts = myTabM ||| myTile
		gimpLayouts = myGimp
		chatLayouts = myChat
		--Layouts
		myTile = named "T"  (smartBorders (ResizableTall 1 0.03 0.5 []))
		myMirr = named "MT" (smartBorders (Mirror myTile))
		myMosA = named "M"  (smartBorders (MosaicAlt M.empty))
		myObig = named "O"  (smartBorders (OneBig 0.75 0.65))
		myTabs = named "TS" (smartBorders (tabbed shrinkText myTabTheme))
		myTabM = named "TM" (smartBorders (mastered 0.01 0.4 $ (tabbed shrinkText myTabTheme)))
		myGimp = named "G"  (withIM (0.15) (Role "gimp-toolbox") $ reflectHoriz $ withIM (0.20) (Role "gimp-dock") (myMosA))
		myChat = named "C"  (withIM (0.20) (Title "Buddy List") $ Mirror myTile)

-- Manage hook
myManageHook :: ManageHook
myManageHook = (composeAll . concat $
	[ [resource     =? r     --> doIgnore                             | r <- myIgnores] --ignore desktop
	, [className    =? c     --> doShift (myWorkspaces !! 1)          | c <- myWebS   ] --move myWebS windows to workspace 1 by classname
	, [className    =? c     --> doShift (myWorkspaces !! 4)          | c <- myChatS  ] --move myChatS windows to workspace 4 by classname
	, [className    =? c     --> doShift (myWorkspaces !! 3)          | c <- myGfxS   ] --move myGfxS windows to workspace 4 by classname
	, [className    =? c     --> doShiftAndGo (myWorkspaces !! 5)     | c <- myGameS  ] --move myGameS windows to workspace 5 by classname
	, [className    =? c     --> doCenterFloat                        | c <- myFloatCC] --float center geometry by classname
	, [name         =? n     --> doCenterFloat                        | n <- myFloatCN] --float center geometry by name
	, [name         =? n     --> doSideFloat NW                       | n <- myFloatSN] --float side NW geometry by name
	, [className    =? c     --> doF W.focusDown                      | c <- myFocusDC] --dont focus on launching by classname
	, [isFullscreen          --> doF W.focusDown <+> doFullFloat]
	]) <+> manageScratchPad
	where
		doShiftAndGo ws = doF (W.greedyView ws) <+> doShift ws
		role            = stringProperty "WM_WINDOW_ROLE"
		name            = stringProperty "WM_NAME"
		myIgnores       = ["desktop","desktop_window"]
		myWebS          = ["Chromium","Firefox"]
		myGfxS          = ["gimp-2.6", "Gimp-2.6", "Gimp", "gimp", "GIMP"]
		myChatS         = ["Pidgin", "Xchat"]
		myGameS         = ["zsnes", "jpcsp-MainGUI", "Desmume"]
		myFloatCC       = ["MPlayer", "File-roller", "zsnes", "Gcalctool", "Exo-helper-1", "Gksu", "PSX", "Galculator", "Nvidia-settings", "XFontSel", "XCalc", "XClock", "Desmume", "Ossxmix", "Xvidcap"]
		myFloatCN       = ["ePSXe - Enhanced PSX emulator", "Seleccione Archivo", "Config Video", "Testing plugin", "Config Sound", "Config Cdrom", "Config Bios", "Config Netplay", "Config Memcards", "About ePSXe", "Config Controller", "Config Gamepads", "Select one or more files to open", "Add media", "Choose a file", "Open Image", "File Operation Progress", "Firefox Preferences", "Preferences", "Search Engines", "Set up sync", "Passwords and Exceptions", "Autofill Options", "Rename File", "Copying files", "Moving files", "File Properties", "Replace", ""]
		myFloatSN       = ["Event Tester"]
		myFocusDC       = ["Event Tester", "Notify-osd"]

-- myWorkspaceBar config
myDzenPP h = defaultPP
	{ ppOutput          = hPutStrLn h
	, ppSort            = fmap (namedScratchpadFilterOutWorkspace.) (ppSort defaultPP) -- hide "NSP" from workspace list
	, ppOrder           = \(ws:l:t:_) -> [ws,l,t]
	, ppExtras          = []
	, ppSep             = "^fg(" ++ colorGray ++ ")|"
	, ppWsSep           = ""
	, ppCurrent         = dzenColor colorBlue     colorBlack . pad
	, ppUrgent          = dzenColor colorGreen    colorBlack . pad . wrapClickWorkSpace . (\a -> (a,a))
	, ppVisible         = dzenColor colorGray	  colorBlack . pad . wrapClickWorkSpace . (\a -> (a,a))
	, ppHidden          = dzenColor colorWhiteAlt colorBlack . pad . wrapClickWorkSpace . (\a -> (a,a))
	, ppHiddenNoWindows = dzenColor colorGray	  colorBlack . pad . wrapClickWorkSpace . (\a -> (a,a))
	, ppTitle           = dzenColor colorWhiteAlt colorBlack . pad . wrapClickTitle .
		(\x -> if null x
			then "Desktop " ++ myArrow ++ ""
			else "" ++ shorten 85 x ++ " " ++ myArrow ++ ""
		) . dzenEscape
	, ppLayout          = dzenColor colorBlue     colorBlack . pad . wrapClickLayout .
		(\x -> case x of
			"Minimize T"                    -> "ReTall"
			"Minimize O"                    -> "OneBig"
			"Minimize TS"                   -> "Tabbed"
			"Minimize TM"                   -> "Master"
			"Minimize M"                    -> "Mosaic"
			"Minimize MT"                   -> "Mirror"
			"Minimize G"                    -> "Mosaic"
			"Minimize C"                    -> "Mirror"
			"Minimize ReflectX T"           -> "^fg(" ++ colorGreen ++ ")ReTall X^fg()"
			"Minimize ReflectX O"           -> "^fg(" ++ colorGreen ++ ")OneBig X^fg()"
			"Minimize ReflectX TS"          -> "^fg(" ++ colorGreen ++ ")Tabbed X^fg()"
			"Minimize ReflectX TM"          -> "^fg(" ++ colorGreen ++ ")Master X^fg()"
			"Minimize ReflectX M"           -> "^fg(" ++ colorGreen ++ ")Mosaic X^fg()"
			"Minimize ReflectX MT"          -> "^fg(" ++ colorGreen ++ ")Mirror X^fg()"
			"Minimize ReflectX G"           -> "^fg(" ++ colorGreen ++ ")Mosaic X^fg()"
			"Minimize ReflectX C"           -> "^fg(" ++ colorGreen ++ ")Mirror X^fg()"
			"Minimize ReflectY T"           -> "^fg(" ++ colorGreen ++ ")ReTall Y^fg()"
			"Minimize ReflectY O"           -> "^fg(" ++ colorGreen ++ ")OneBig Y^fg()"
			"Minimize ReflectY MT"          -> "^fg(" ++ colorGreen ++ ")Tabbed Y^fg()"
			"Minimize ReflectY TM"          -> "^fg(" ++ colorGreen ++ ")Master Y^fg()"
			"Minimize ReflectY M"           -> "^fg(" ++ colorGreen ++ ")Mosaic Y^fg()"
			"Minimize ReflectY MT"          -> "^fg(" ++ colorGreen ++ ")Mirror Y^fg()"
			"Minimize ReflectY G"           -> "^fg(" ++ colorGreen ++ ")Mosaic Y^fg()"
			"Minimize ReflectY C"           -> "^fg(" ++ colorGreen ++ ")Mirror Y^fg()"
			"Minimize ReflectX ReflectY T"  -> "^fg(" ++ colorGreen ++ ")ReTall XY^fg()"
			"Minimize ReflectX ReflectY O"  -> "^fg(" ++ colorGreen ++ ")OneBig XY^fg()"
			"Minimize ReflectX ReflectY TS" -> "^fg(" ++ colorGreen ++ ")Tabbed XY^fg()"
			"Minimize ReflectX ReflectY TM" -> "^fg(" ++ colorGreen ++ ")Master XY^fg()"
			"Minimize ReflectX ReflectY M"  -> "^fg(" ++ colorGreen ++ ")Mosaic XY^fg()"
			"Minimize ReflectX ReflectY MT" -> "^fg(" ++ colorGreen ++ ")Mirror XY^fg()"
			"Minimize ReflectX ReflectY G"  -> "^fg(" ++ colorGreen ++ ")Mosaic XY^fg()"
			"Minimize ReflectX ReflectY C"  -> "^fg(" ++ colorGreen ++ ")Mirror XY^fg()"
			_                               -> "^fg(" ++ colorGreen ++ ")" ++ x ++ "^fg()" --Only for Mirror
		)
	}
	where
		--clickable workspaces, layout and title (thanks to count-corrupt). Carefull, tabulations will be evaluated
		wrapClickLayout content = "^ca(1,xdotool key super+space)" ++ content ++ "^ca()"
		wrapClickTitle content = "^ca(1,xdotool key super+j)" ++ content ++ "^ca()"
		currentWsIndex w = case (elemIndex w myWorkspaces) of
			Nothing -> "1"
			Just n -> show (n+1)
		wrapClickWorkSpace (idx,str) = "^ca(1," ++ xdo "w;" ++ xdo index ++ ")" ++ "^ca(3," ++ xdo "e;" ++ xdo index ++ ")" ++ str ++ "^ca()^ca()"
			where
				index = currentWsIndex idx
				xdo key = "xdotool key super+" ++ key

-- Key bindings
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
	[ ((modMask, xK_Return), spawn $ XMonad.terminal conf)                       --Launch a terminal
	, ((mod1Mask, xK_F2), shellPrompt myXPConfig)                                              --Launch Xmonad shell prompt
	, ((mod1Mask, xK_space), shellPrompt myXPConfig)                                           --Launch Xmonad shell prompt
	, ((modMask, xK_F2), xmonadPrompt myXPConfig)                                              --Launch Xmonad prompt
	, ((modMask, xK_g), goToSelected $ myGSConfig myColorizer)                                 --Launch GridSelect
	, ((modMask, xK_semicolon), scratchPad)                                                    --Scratchpad
	{- , ((modMask, xK_o), spawn "gksu halt")                                                     --Power off -}
	{- , ((modMask .|. shiftMask, xK_o), spawn "gksu reboot")                                     --Reboot -}
	{- , ((mod1Mask, xK_F3), spawn "chromium")                                                    --Launch chromium -}
	, ((modMask, xK_c), kill)                                                                  --Close focused window
	, ((mod1Mask, xK_F4), kill)
	, ((modMask, xK_space), sendMessage NextLayout)                                            --Rotate through the available layout algorithms
	, ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)                 --Reset the layouts on the current workspace to default
	, ((modMask, xK_n), refresh)                                                               --Resize viewed windows to the correct size
	, ((modMask, xK_Tab), windows W.focusDown)                                                 --Move focus to the next window
	, ((modMask, xK_j), windows W.focusDown)
	, ((mod1Mask, xK_Tab), windows W.focusDown)
	, ((modMask, xK_k), windows W.focusUp)                                                     --Move focus to the previous window
	, ((modMask, xK_a), windows W.focusMaster)                                                 --Move focus to the master window
	, ((modMask .|. shiftMask, xK_a), windows W.swapMaster)                                    --Swap the focused window and the master window
	, ((modMask .|. shiftMask, xK_j), windows W.swapDown  )                                    --Swap the focused window with the next window
	, ((modMask .|. shiftMask, xK_k), windows W.swapUp    )                                    --Swap the focused window with the previous window
	, ((modMask, xK_h), sendMessage Shrink)                                                    --Shrink the master area
	, ((modMask .|. shiftMask, xK_Left), sendMessage Shrink)
	, ((modMask, xK_l), sendMessage Expand)                                                    --Expand the master area
	, ((modMask .|. shiftMask, xK_Right), sendMessage Expand)
	, ((modMask .|. shiftMask, xK_h), sendMessage MirrorShrink)                                --MirrorShrink the master area
	, ((modMask .|. shiftMask, xK_Down), sendMessage MirrorShrink)
	, ((modMask .|. shiftMask, xK_l), sendMessage MirrorExpand)                                --MirrorExpand the master area
	, ((modMask .|. shiftMask, xK_Up), sendMessage MirrorExpand)
	, ((modMask .|. controlMask, xK_Left), withFocused (keysResizeWindow (-30,0) (0,0)))       --Shrink floated window horizontally by 50 pixels
	, ((modMask .|. controlMask, xK_Right), withFocused (keysResizeWindow (30,0) (0,0)))       --Expand floated window horizontally by 50 pixels
	, ((modMask .|. controlMask, xK_Up), withFocused (keysResizeWindow (0,-30) (0,0)))         --Shrink floated window verticaly by 50 pixels
	, ((modMask .|. controlMask, xK_Down), withFocused (keysResizeWindow (0,30) (0,0)))        --Expand floated window verticaly by 50 pixels
	, ((modMask, xK_t), withFocused $ windows . W.sink)                                        --Push window back into tiling
	, ((modMask .|. shiftMask, xK_t), rectFloatFocused)                                        --Push window into float
	, ((modMask, xK_f), sendMessage $ XMonad.Layout.MultiToggle.Toggle TABBED)                 --Push layout into tabbed
	, ((modMask .|. shiftMask, xK_z), sendMessage $ Toggle MIRROR)                             --Push layout into mirror
	, ((modMask .|. shiftMask, xK_x), sendMessage $ XMonad.Layout.MultiToggle.Toggle REFLECTX) --Reflect layout by X
	, ((modMask .|. shiftMask, xK_y), sendMessage $ XMonad.Layout.MultiToggle.Toggle REFLECTY) --Reflect layout by Y
	, ((modMask, xK_m), withFocused minimizeWindow)                                            --Minimize window
	, ((modMask .|. shiftMask, xK_m), sendMessage RestoreNextMinimizedWin)                     --Restore window
	, ((modMask .|. shiftMask, xK_f), fullFloatFocused)                                        --Push window into full screen
	, ((modMask, xK_comma), sendMessage (IncMasterN 1))                                        --Increment the number of windows in the master area
	, ((modMask, xK_period), sendMessage (IncMasterN (-1)))                                    --Deincrement the number of windows in the master area
	, ((modMask , xK_d), spawn "killall dzen2 trayer")                                         --Kill dzen2 and trayer
	, ((modMask , xK_s), spawn "xscreensaver-command -lock")                                   --Lock screen
	, ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))                               --Quit xmonad
	, ((modMask, xK_q), restart "xmonad" True)                                                 --Restart xmonad
	, ((modMask, xK_comma), toggleWS)                                                          --Toggle to the workspace displayed previously
	, ((mod1Mask, xK_masculine), toggleOrView (myWorkspaces !! 0))                             --if ws != 0 then move to workspace 0, else move to latest ws I was
	, ((mod1Mask .|. controlMask, xK_Left),  prevWS)                                           --Move to previous Workspace
	, ((modMask, xK_Left), prevWS)
	, ((modMask, xK_Right), nextWS)                                                            --Move to next Workspace
	, ((mod1Mask .|. controlMask, xK_Right), nextWS)
	, ((0, xF86XK_AudioMute), spawn "sh /home/nnoell/bin/volosd.sh mute")                      --Mute/unmute volume
	, ((0, xF86XK_AudioRaiseVolume), spawn "sh /home/nnoell/bin/volosd.sh up")                 --Raise volume
	, ((0, xF86XK_AudioLowerVolume), spawn "sh /home/nnoell/bin/volosd.sh down")               --Lower volume
	, ((0, xF86XK_AudioNext), spawn "ncmpcpp next")                                            --next song
	, ((0, xF86XK_AudioPrev), spawn "ncmpcpp prev")                                            --prev song
	, ((0, xF86XK_AudioPlay), spawn "ncmpcpp toggle")                                          --toggle song
	, ((0, xF86XK_AudioStop), spawn "ncmpcpp stop")                                            --stop song
	, ((0, xF86XK_MonBrightnessUp), spawn "sh /home/nnoell/bin/briosd.sh")                     --Raise brightness
	, ((0, xF86XK_MonBrightnessDown), spawn "sh /home/nnoell/bin/briosd.sh")                   --Lower brightness
	, ((0, xF86XK_ScreenSaver), spawn "xscreensaver-command -lock")                            --Lock screen
	, ((0, xK_Print), spawn "scrot '%Y-%m-%d_$wx$h.png'")                                      --Take a screenshot
	]
	++
	[((m .|. modMask, k), windows $ f i)                                                       --Switch to n workspaces and send client to n workspaces
		| (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
		, (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
	++
	[((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))                --Switch to n screens and send client to n screens
		| (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
		, (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
	where
		fullFloatFocused = withFocused $ \f -> windows =<< appEndo `fmap` runQuery doFullFloat f
		rectFloatFocused = withFocused $ \f -> windows =<< appEndo `fmap` runQuery (doRectFloat $ RationalRect 0.05 0.05 0.9 0.9) f

-- Mouse bindings
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
	[ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)) -- set the window to floating mode and move by dragging
	, ((modMask, button2), (\w -> focus w >> windows W.shiftMaster))                      -- raise the window to the top of the stack
	, ((modMask, button3), (\w -> focus w >> Flex.mouseResizeWindow w))                   -- set the window to floating mode and resize by dragging
	, ((modMask, button4), (\_ -> prevWS))                                                -- switch to previous workspace
	, ((modMask, button5), (\_ -> nextWS))                                                -- switch to next workspace
	]
