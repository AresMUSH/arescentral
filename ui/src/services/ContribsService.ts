import { sendGet } from "./RequestHelper";
import { Game } from "./GamesService"

export interface Plugin {
  id: string;
  name: string;
  description: string;
  key: string;
  url: string;
  custom_code: boolean;
  web_portal: boolean;
  category: string;
  installs: number;
  author_name: string;
  games: Game[];
}

export interface PluginsIndexResponse {
  plugins: Plugin[];
}

export interface PluginResponse {
  plugin: Plugin;
}

export async function getPlugins() : Promise<PluginsIndexResponse> {
  const response = await sendGet('plugins');
  return { plugins: response.data };
}

export async function getPlugin(pluginId : string) : Promise<PluginResponse> {
  const response = await sendGet(`plugin/${pluginId}`);
  return { plugin: response.data };
}