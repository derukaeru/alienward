extends Node

var NULL_SPRITE: String = "uid://cnely2yvr8exu"
var DEFAULT_STATUS_BUBBLE: String = "uid://bb5lto8ig5u4g"

var UID: Dictionary[String, String] = {
	"npc": "uid://cwhgebq7q0h5y",
	"patient": "uid://inedntn6htqj",
	"baby": "uid://b51jsxro6uk0a",

	"bacteria": "uid://cfcu3gbpctv5v",

	"world": "uid://cx0rposj2xxxe",
	"ward": "uid://bivpb6edg64k5",

	"shop_screen": "uid://b4sil7n400wmm",
	"microscope_screen": "uid://d2wp275ru8mkw",

	"subtitle_instance": "uid://2k1clpfoqeso",

	"loading_screen": "uid://tetiuyj7kfoe",
	"splash_screen": "uid://b4ggbq71lpwo4",
	"title_screen": "uid://dix67ojrdr6ht",
	"pause_screen": "uid://7jemke30bxqq",
	"settings_screen": "uid://5186ghdvrog8",

	"dialogue_box": "uid://6cae11kpahyv",
	"status_bubble_instance": "uid://dafcp1h7ayfne",

	# statuses
	"status_walking": DEFAULT_STATUS_BUBBLE,
	"status_checkup": DEFAULT_STATUS_BUBBLE,
	"status_waiting": DEFAULT_STATUS_BUBBLE,
	"status_following_patient": DEFAULT_STATUS_BUBBLE,
	"status_labor": DEFAULT_STATUS_BUBBLE,
	"status_watching_baby": DEFAULT_STATUS_BUBBLE,
	"status_guiding_out_of_ward": DEFAULT_STATUS_BUBBLE,
	"status_leaving_with_patient": DEFAULT_STATUS_BUBBLE,

	"status_too_hot": DEFAULT_STATUS_BUBBLE,
	"status_too_cold": DEFAULT_STATUS_BUBBLE,

	"dirt": "uid://yhp2sprkwy51",
	"water_spill": "uid://cjod10hvj1g0s",

	# item instances
	"ultrasound_print_instance": "uid://dl7ni1qig34fo",
	"antidote_instance": "uid://b328136vl47io",
	"chili_instance": "uid://c41nfst6ynh2f",
	"ginger_instance": "uid://buekuvxp14xat",
	"coffee_bean_instance": "uid://d06ar3qs1prff",
	"ink_sac_instance": "uid://cvc5jqvc2bum4",

	# sprites for hand held items
	"baby_sprite": "uid://ddavebcvrlptn",
	"clipboard": "uid://dpwx6lq1basmc",
	"swab_sprite": "uid://byleeb4m3vftg",
	"ultrasound_scanner": "uid://b6x66nbtoqd3",
	"antidote": NULL_SPRITE,
	"mop": "uid://dkh8gc602jl65",
	"swab": "uid://bkhvrcq5sh51q",
	"swab_used": "uid://cjfwpijoxhkk6",
	"ultrasound_print": "uid://c4o52kbdwbt6n",
	"chili": "uid://d3mgfl15h1hqx",
	"coffee_bean": "uid://dn7kddm81blbe",
	"ginger": "uid://c40w002lqkhxm",
	"ink_sac": "uid://df1yri0gtbcot",

	"hand_hold": "uid://cceairqcr4n0v",
	"hand_point": "uid://ssnb0c6x2qpt",

	"bioluminescence_shader": "uid://c3ov2tp76hj31",
	"fumes_instance": "uid://djhx67h6d4tv8",
}
