GM_DebugMenu:
	; TODO
	ret

Debug_MainMenuText:
	db	"                    "
	db	"   - REBOUND GB -   "
	db	"     DEBUG MENU     "
	db	"                    "
	db	"   START GAME       "
	db	"   LEVEL SELECT     "
	db	"   SOUND TEST       "
	db	"   GFX TEST         "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	" "
	dbp	strupr(__DATE__),19," "
	db	" "
	dbp	strupr(__TIME__),19," "
	db	"                    "

Debug_LevelSelectMenuText:
	db	"                    "
	db	"  - LEVEL SELECT -  "
	db	"                    "
	db	"   PLAIN PLAINS     "
	db	"    1  2  3  4  5   "
	db	"   PYRAMID POWER    "
	db	"    1  2  3  4  5   "
	db	"   GREAT GROTTO     "
	db	"    1  2  3  4  5   "
	db	"  FORGOTTEN FOREST  "
	db	"    1  2  3  4  5   "
	db	"    TRAP TEMPLE     "
	db	"    1  2  3  4  5   "
	db	"   BONUS ROUND      "
	db	"   BACK             "
	db	"                    "
	db	"                    "
	db	"                    "
	