import { useEffect,useState } from 'react'
import { BrowserRouter,Link,Outlet,Route,Routes } from 'react-router-dom'
import { SiteFooter } from './components/SiteFooter'
import { SiteHeader } from './components/SiteHeader'
import { AddBusinessPage } from './pages/AddBusinessPage'
import { BusinessDetailPage } from './pages/BusinessDetailPage'
import { HomePage } from './pages/HomePage'
import { SearchPage } from './pages/SearchPage'
import { AuthPage } from './pages/AuthPage'
import { NearbyPage } from './pages/NearbyPage'
import { PortalPage } from './pages/PortalPage'
import { AuthProvider } from './contexts/AuthContext'
import './App.css'

function Layout(){const[theme,setTheme]=useState(()=>localStorage.getItem('calling-bell-theme')??'default');useEffect(()=>{document.documentElement.dataset.theme=theme;localStorage.setItem('calling-bell-theme',theme)},[theme]);return <div className="app-shell"><SiteHeader theme={theme} onThemeChange={setTheme}/><Outlet/><SiteFooter/></div>}
function NotFoundPage(){return <main className="page-content"><section className="state"><h1>Page not found</h1><p>The page you requested is not available.</p><Link className="button-link" to="/">Return home</Link></section></main>}
export default function App(){return <AuthProvider><BrowserRouter><Routes><Route element={<Layout/>}><Route index element={<HomePage/>}/><Route path="search" element={<SearchPage/>}/><Route path="businesses/:slug" element={<BusinessDetailPage/>}/><Route path="nearby" element={<NearbyPage/>}/><Route path="add-business" element={<AddBusinessPage/>}/><Route path="login" element={<AuthPage mode="login"/>}/><Route path="signup" element={<AuthPage mode="signup"/>}/><Route path="dashboard" element={<PortalPage mode="customer"/>}/><Route path="bookings" element={<PortalPage mode="customer"/>}/><Route path="enquiries" element={<PortalPage mode="customer"/>}/><Route path="business-owner" element={<PortalPage mode="business-owner"/>}/><Route path="admin" element={<PortalPage mode="admin"/>}/><Route path="*" element={<NotFoundPage/>}/></Route></Routes></BrowserRouter></AuthProvider>}