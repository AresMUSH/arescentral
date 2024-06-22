import { sendGet, sendPost, ErrorResponse } from "./RequestHelper";
import { Game } from "./GamesService"

export interface Stats {
  total_handles: number;
  total_games: number;
  open_games: number;
  dev_games: number;
  private_games: number;
  closed_games: number;  
}

export interface StatsResponse {
  stats: Stats;
}

export interface ResetPasswordResponse {
  password: string;
}

export interface PluginUpdateResponse {
  id: string;
}

export interface GamesAdminResponse {
  games: Game[]
}

export async function getStats() : Promise<StatsResponse> {
  const response = await sendGet('admin/stats');
  return { stats: response.data };
}

export async function getGamesAdmin() : Promise<GamesAdminResponse> {
  const response = await sendGet('admin/games');
  return { games: response.data };
}

export async function banPlayer(handleId : string, banState : boolean) : Promise<void | ErrorResponse> {
  let endpoint = `admin/ban/${handleId}`
  if (!banState) {
    endpoint = `admin/un-ban/${handleId}`;
  }
  const response = await sendPost(endpoint, {});
  return response.data;
}

export async function resetPlayerPassword(handleId : string) : Promise<ResetPasswordResponse | ErrorResponse> {
  const response = await sendPost(`admin/reset-password/${handleId}`, {});
  return response.data;
}

export async function createPlugin(values : {}) : Promise<PluginUpdateResponse | ErrorResponse> {
  const response = await sendPost('admin/plugin/create', values);
  return response.data;
}

export async function updatePlugin(pluginId : string, values: {}) : Promise<PluginUpdateResponse | ErrorResponse> {
  const response = await sendPost(`admin/plugin/${pluginId}/update`, values);
  return response.data;
}

export async function updateGameStatus(gameId : string, status : string, isPublic : boolean) : Promise<void | ErrorResponse> {
  const body = {
    status: status,
    is_public: isPublic
  };
  
  const response = await sendPost(`admin/game-status/${gameId}`, body);
  return response.data;
}