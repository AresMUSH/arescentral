import { sendPost, ErrorResponse } from "./RequestHelper";
import { LoginSession } from "./SessionStorage";

export interface SsoLoginResponse {
  redirect_url: string;
}

export async function authenticate(name : string, password : string) : 
   Promise<LoginSession | ErrorResponse> {
  const body = {
    name: name,
    password: password
  };
  
  const response = await sendPost('login', body);
  return response.data;
}

export async function registerHandle(
  name : string, 
  password : string, email : string, 
  securityQuestion : string, 
  captchaToken : string) : Promise<LoginSession | ErrorResponse> {
  const body = {
    name: name,
    password: password,
    email: email,
    security_question: securityQuestion,
    captcha: captchaToken
  };
  
  const response = await sendPost('register', body);
  return response.data;
}

export async function forgotPassword(name : string, email : string) : Promise<void | ErrorResponse> {
  const body = {
    email: email,
    name: name
  };
  
  const response = await sendPost('forgot-password', body);
  return response.data;
}

export async function changePassword(oldPassword : string, newPassword : string) : Promise<void | ErrorResponse> {
  const body = {
    old_password: oldPassword,
    new_password: newPassword
  };
  
  const response = await sendPost('change-password', body);
  return response.data;
}

export async function checkToken(session : LoginSession) : Promise<LoginSession | ErrorResponse> {
  const body = {
      id: session.id,
      token: session.token
  };

  const response = await sendPost('token/verify', body);
  return response.data;
}

export async function ssoLogin(name : string, password : string, sso_request : string) : Promise<SsoLoginResponse | ErrorResponse> {
  const body = {
    name: name,
    password: password,
    sso_request: sso_request
  };
  
  const response = await sendPost('/sso/login', body);
  return response.data;
}

