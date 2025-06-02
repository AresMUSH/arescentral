import axios from "axios";
import { getUserData, clearUserData } from "./SessionStorage";
import { NotFoundError, PermissionsError, AuthenticationError } from "./Errors"

const baseUrl = import.meta.env.VITE_ARESCENTRAL_SERVER_URL;

export interface ErrorResponse {
  error: string;
}

export function isErrorResponse(response : any) : response is ErrorResponse {
  return (response as ErrorResponse).error !== undefined;
}

export function buildHeaders() {
  {
    const auth = getUserData();
    
    if (auth) {
        return {
           Authorization: `Bearer ${auth.id}:${auth.token}`,
           Accept: 'text/json',
           "Content-Type": 'text/json'
         };
    } else {
      return {
         Accept: 'text/json',
         "Content-Type": 'text/json'
       };
    }
  }
}
export async function sendGet(endpoint : string) {    
  const response = await axios.get(`${baseUrl}/${endpoint}`, {
      headers: buildHeaders(),
      validateStatus: null
    });

  if (response.status === 403) {
    throw new PermissionsError(`You are not allowed to view that page.`);
  }
  else if (response.status === 401) {
    clearUserData();
    throw new AuthenticationError(`Invalid login token. Please reload the page and log back in.`);
  }
  else if (response.status === 404) {
    throw new NotFoundError(`${endpoint} not found.`);
  }
  else if (response.status != 200) {
    throw new Error(`Trouble loading ${endpoint}.`);
  }
      
  return response;
}

export async function sendPost(endpoint : string, body : object) {  
  const response = await axios.post(`${baseUrl}/${endpoint}`, body, {
      headers: buildHeaders(),
      validateStatus: null
    });
    
  if (response.status === 401) {
    throw new PermissionsError(`Insufficient permissions for ${endpoint}.`);    
  }
  else if (response.status === 404) {
    throw new NotFoundError(`${endpoint} not found.`);
  }
  else if (response.status != 200) {
    throw new Error(`Trouble loading ${endpoint}.`);
  }
    
  return response;
}

