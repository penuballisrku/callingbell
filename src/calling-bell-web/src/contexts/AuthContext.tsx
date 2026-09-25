import { createContext,useContext,useMemo,useState } from 'react'
import type { ReactNode } from 'react'
import { login,register } from '../api/platform'
import type { AuthResult } from '../api/types'

type AuthContextValue={auth:AuthResult|null;signIn:(email:string,password:string)=>Promise<void>;signUp:(name:string,email:string,password:string)=>Promise<void>;signOut:()=>void}
const AuthContext=createContext<AuthContextValue|null>(null)
const storageKey='calling-bell-auth'

export function AuthProvider({children}:{children:ReactNode}){
 const [auth,setAuth]=useState<AuthResult|null>(()=>{try{const raw=localStorage.getItem(storageKey);return raw?JSON.parse(raw) as AuthResult:null}catch{return null}})
 const save=(value:AuthResult|null)=>{setAuth(value);if(value)localStorage.setItem(storageKey,JSON.stringify(value));else localStorage.removeItem(storageKey)}
 const value=useMemo<AuthContextValue>(()=>({auth,signIn:async(email,password)=>save(await login(email,password)),signUp:async(name,email,password)=>save(await register(name,email,password)),signOut:()=>save(null)}),[auth])
 return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}
export function useAuth(){const value=useContext(AuthContext);if(!value)throw new Error('useAuth must be used inside AuthProvider');return value}
