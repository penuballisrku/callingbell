import { useEffect, useState } from 'react'
import { BrowserRouter, Link, Outlet, Route, Routes } from 'react-router-dom'
import { SiteFooter } from './components/SiteFooter'
import { SiteHeader } from './components/SiteHeader'
import { AddBusinessPage } from './pages/AddBusinessPage'
import { BusinessDetailPage } from './pages/BusinessDetailPage'
import { HomePage } from './pages/HomePage'
import { SearchPage } from './pages/SearchPage'
import { AuthPage } from './pages/AuthPage'
import './App.css'

function Layout() {
  const [theme, setTheme] = useState(() => localStorage.getItem('calling-bell-theme') ?? 'ember')

  useEffect(() => {
    document.documentElement.dataset.theme = theme
    localStorage.setItem('calling-bell-theme', theme)
  }, [theme])

  return (
    <div className="app-shell">
      <SiteHeader theme={theme} onThemeChange={setTheme} />
      <Outlet />
      <SiteFooter />
    </div>
  )
}

function NotFoundPage() {
  return (
    <main className="page-content">
      <section className="state">
        <h1>Page not found</h1>
        <p>The page you requested is not available.</p>
        <Link className="button-link" to="/">Return home</Link>
      </section>
    </main>
  )
}

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<Layout />}>
          <Route index element={<HomePage />} />
          <Route path="search" element={<SearchPage />} />
          <Route path="businesses/:slug" element={<BusinessDetailPage />} />
          <Route path="add-business" element={<AddBusinessPage />} />
          <Route path="login" element={<AuthPage mode="login" />} />
          <Route path="signup" element={<AuthPage mode="signup" />} />
          <Route path="*" element={<NotFoundPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  )
}

export default App
