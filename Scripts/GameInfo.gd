extends Node

enum GAME_STATES {INITIAL, TRADING_TERRITORY_CARDS, PLACING_TERRITORIES, ATTACKING, MOVING_TERRITORIES}
enum PLAYER_STATE {PLAYER, IA, DISABLED}

var active_players = []
var PLAYER_COUNT = 2

var WINNER = "JOGADOR AZUL"
var WINNER_COLOR = "#009fff"
