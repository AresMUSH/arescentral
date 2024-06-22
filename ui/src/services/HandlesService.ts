import { sendGet, sendPost, ErrorResponse } from "./RequestHelper";

export interface LinkedCharGame {
  id: string;
  name: string;
}

export interface LinkedChar {
  id: string;
  game: LinkedCharGame;
  name: string;
  char_id: string;
  temp_password: string|null;
  replayed: boolean;
}

export interface HandleLink {
  game: LinkedCharGame;
  chars: LinkedChar[];
}

export interface Handle {
  name: string;
  id: string;
  profile: string;
  image_url: string;
  banned: boolean;
  security_question: string | null;
  email: string | null;
  last_ip: string | null;
  current_chars: HandleLink[];
  past_chars: HandleLink[];
}

export interface HandlePreferences {
  email: string;
  security_question: string;
  pose_autospace: string;
  pose_quote_color: string;
  page_autospace: string;
  page_color: string;
  ascii_only: boolean;
  screen_reader: boolean;
  timezone: string;
  profile_image: string;
  profile: string;
};

export interface HandlePreferencesResponse {
  preferences: HandlePreferences;
  timezones: string[];
};

export interface Friendship {
  name: string;
  id: string;
  games: HandleLink[];
};

export interface HandlesIndexResponse {
  handles: Handle[];
};

export interface HandleResponse {
  handle: Handle;
};

export interface FriendsResponse {
  handles: Handle[];
  friends: Friendship[];
};

export interface UpdateFriendsResponse {
  friends: Friendship[];
};

export interface LinkedCharsResponse {
  links: LinkedChar[];
  codes: string[];
}

export interface GenerateLinkResponse {
  codes: string[];
}

export interface UpdateLinkResponse {
  links: LinkedChar[];
}

export async function getHandles() : Promise<HandlesIndexResponse> {
  const response = await sendGet('handles');
  return { handles: response.data };
}

export async function getHandle(handleId : string) : Promise<HandleResponse> {
  const response = await sendGet(`handle/${handleId}`);
  return { handle: response.data };
}

export async function getFriends() : Promise<FriendsResponse|ErrorResponse> {
  const response = await sendGet(`friends`);
  return response.data;
}

export async function addFriend(friendId : string) : Promise<UpdateFriendsResponse|ErrorResponse> {
  const response = await sendPost(`friend/${friendId}/add`, {});
  return response.data;
}

export async function removeFriend(friendId : string) : Promise<UpdateFriendsResponse|ErrorResponse> {
  const response = await sendPost(`friend/${friendId}/remove`, {});
  return response.data;
}

export async function getLinkedChars() : Promise<LinkedCharsResponse> {
  const response = await sendGet(`links`);
  return response.data;
}

export async function generateLinkCode() : Promise<GenerateLinkResponse|ErrorResponse> {
  const response = await sendPost('links/code', {});
  return response.data;
}

export async function resetLinkPassword(linkId : string) : Promise<UpdateLinkResponse|ErrorResponse> {
  const response = await sendPost(`link/${linkId}/reset-password`, {});
  return response.data;
}

export async function unlinkCharacter(linkId : string) : Promise<UpdateLinkResponse|ErrorResponse> {
  const response = await sendPost(`link/${linkId}/unlink`, {});
  return response.data;
}


export async function getPreferences() : Promise<HandlePreferencesResponse> {
  const response = await sendGet('preferences');
  return response.data;
}

export async function savePreferences(preferences : HandlePreferences) : Promise<void|ErrorResponse> {
  const body_data = {
    preferences: preferences
  };
  const response = await sendPost('preferences', body_data);
  return response.data;
}