import { createContext, useContext, useState, useEffect } from 'react';
import { authenticate, registerHandle } from '../services/LoginService';
import { getUserData, saveUserData, clearUserData, LoginSession} from '../services/SessionStorage';
import { isErrorResponse } from "../services/RequestHelper";

interface IAuthContext {
  user: LoginSession | null | undefined;
  register: (
    username : string, 
    password : string, 
    email : string, 
    securityQuestion : string, 
    captchaToken : string
  ) => Promise<string|null>;
  login: (
    username : string, 
    password : string) => Promise<string|null>;
  logout: () => void;
};

const defaultAuthContext: IAuthContext = {
  user: null,
  register: () => Promise.reject(null),
  login: () => Promise.reject(null),
  logout: () => {}
};

const AuthContext = createContext<IAuthContext>(defaultAuthContext);

export const useAuth = () => { 
  return useContext(AuthContext);
};

export const authContextValue = () => {
  
  const [user, setUser] = useState<LoginSession|null|undefined>(undefined);
  
  useEffect(() => {
    
    const savedData = getUserData();
    
    const isTokenSet = savedData.token && savedData.token.length > 0;
    const tokenHasTimeLeft = savedData.expires - Date.now();

    if (isTokenSet && tokenHasTimeLeft) {
      setUser(savedData);
    } else {
      // console.log(`Invalid token: set:${isTokenSet} timeLeft:${tokenHasTimeLeft}`);
      // console.log(savedData);
      setUser(null);
      clearUserData();
    }        
  }, []);
  
  async function login ( 
    username : string, 
    password : string) : Promise<string|null> {
    const response = await authenticate(username, password);
    if (isErrorResponse(response)) {
      return response.error;
    } else {
      setUser(response);
      saveUserData(response);
      return null;
    }
  }
  
  async function register(
    username : string, 
    password : string, 
    email : string, 
    securityQuestion : string, 
    captchaToken : string) : Promise<string|null> {
    const response = await registerHandle(username, password, email, securityQuestion, captchaToken);
    if (isErrorResponse(response)) {
      return response.error;
    } else {
      setUser(response);
      saveUserData(response);
      return null;
    }
  }
  
  function logout() {
    setUser(null);
    clearUserData();
  }
  
  return { user, login, logout, register };
}

export function AuthProvider({ children }: React.PropsWithChildren) {
  const value = authContextValue();
  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}