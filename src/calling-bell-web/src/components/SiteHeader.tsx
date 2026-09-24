import { useState } from 'react'
import type { FormEvent } from 'react'
import { Link, useNavigate } from 'react-router-dom'

type SiteHeaderProps = {
  theme: string
  onThemeChange: (theme: string) => void
}

const themes = [
  { value: 'ember', label: 'Ember' },
  { value: 'ocean', label: 'Ocean' },
  { value: 'forest', label: 'Forest' },
  { value: 'royal', label: 'Royal' },
  { value: 'mono', label: 'Monochrome' },
  { value: 'sunset', label: 'Sunset' },
  { value: 'lavender', label: 'Lavender' },
  { value: 'aqua', label: 'Aqua' },
  { value: 'citrus', label: 'Citrus' },
  { value: 'rose', label: 'Rose' },
  { value: 'midnight', label: 'Midnight' },
]

export function SiteHeader({ theme, onThemeChange }: SiteHeaderProps) {
  const navigate = useNavigate()
  const [query, setQuery] = useState('')

  function submitSearch(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const parameters = new URLSearchParams()
    if (query.trim()) parameters.set('q', query.trim())
    navigate(`/search?${parameters.toString()}`)
  }

  return (
    <header className="site-header">
      <Link className="brand" to="/" aria-label="Calling Bell home">
        <span className="brand-mark" aria-hidden="true">CB</span>
        <span>Calling Bell</span>
      </Link>
      <form className="header-search" onSubmit={submitSearch} role="search">
        <label className="sr-only" htmlFor="site-search">Search Calling Bell</label>
        <input
          id="site-search"
          value={query}
          onChange={(event) => setQuery(event.target.value)}
          placeholder="Search services or businesses"
        />
        <button type="submit">Search</button>
      </form>
      <nav aria-label="Primary navigation">
        <Link to="/search">Explore</Link>
        <label className="theme-picker">
          <span className="sr-only">Choose theme</span>
          <select value={theme} onChange={(event) => onThemeChange(event.target.value)} aria-label="Choose theme">
            {themes.map((option) => <option key={option.value} value={option.value}>{option.label}</option>)}
          </select>
        </label>
        <Link className="header-auth-link" to="/login">Log in</Link>
        <Link className="header-auth-button" to="/signup">Sign up</Link>
        <Link className="header-cta" to="/add-business">Add business</Link>
      </nav>
    </header>
  )
}
