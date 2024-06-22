import { Handle, LinkedChar } from "./HandlesService"
import { sendGet } from "./RequestHelper";

export interface GameLink {
  handle: Handle;
  chars: LinkedChar[];
}

export interface Game {
  id: string;
  name: string;
  description: string;
  host: string;
  port: string;
  category: string;
  public_game: boolean;
  website: string;
  wiki_archive: string;
  status: string;
  up_status: string;
  is_open: boolean;
  last_ping: string;
  summary: string;
  activity_points: number;
  activity_rating: number;
  is_active: boolean;
  recently_updated: boolean;
  current_chars: GameLink[];
  past_chars: GameLink[];
  activity_table: any;
  activity_time_titles: string[];
  activity_day_titles: string[];
};

export interface GamesIndex {
  open: Game[];
  dev: Game[];
  closed: Game[];
};

export interface GamesIndexResponse {
  games: GamesIndex;
}

export interface GameResponse { 
  game: Game;
}

export async function getGames() : Promise<GamesIndexResponse>{
  const response = await sendGet('games');
  return { games: response.data };
}

export async function getGame(gameId : string) : Promise<GameResponse> {
  const response = await sendGet(`game/${gameId}`);
  return { game: response.data };
}
