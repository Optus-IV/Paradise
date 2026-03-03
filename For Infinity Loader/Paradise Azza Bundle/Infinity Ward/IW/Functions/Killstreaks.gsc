give_killstreak(streak) {
	self thread scripts\mp\_hud_message::func_10134(streak, undefined, 1);
	self scripts\mp\killstreaks\_killstreaks::func_26D4(streak, self);
}