export interface LoginSession {
  id: string;
  name: string;
  token: string;
  is_admin: boolean;
  expires: number;
};

export function saveUserData(userData : LoginSession) {
  localStorage.setItem('arescentral.user', JSON.stringify(userData));
}

export function getUserData() : LoginSession {
  const storage = localStorage.getItem('arescentral.user');
  if (!storage) {
    return { id: '', name: '', token: '', is_admin: false, expires: Date.now() };
  }
  const session : LoginSession = JSON.parse(storage);
  return session;
}

export function clearUserData() {
  localStorage.removeItem('arescentral.user');
}