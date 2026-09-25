import { useEffect, useState } from 'react'
import type { FormEvent } from 'react'
import { useNavigate } from 'react-router-dom'
import { getDashboard } from '../api/dashboard'
import type { Dashboard } from '../api/types'
import { EmptyState, ErrorState, LoadingState } from '../components/States'
import { SectionRenderer } from '../components/SectionRenderer'

export function HomePage() {
  const navigate = useNavigate()
  const [query, setQuery] = useState('')

  function submitSearch(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const parameters = new URLSearchParams()
    if (query.trim()) parameters.set('q', query.trim())
    navigate(`/search?${parameters.toString()}`)
  }

  return (
    <>
      <section className="hero-search">
        <div className="hero-search__content">
          <p className="eyebrow">All Local Services, One Powerful Platform</p>
          <h1>Discover Local Services Near You</h1>
          <p>Find trusted businesses, book services, compare offers and more.</p>
          <form onSubmit={submitSearch} className="hero-search__form" role="search">
            <label className="sr-only" htmlFor="hero-search">What are you looking for?</label>
            <input
              id="hero-search"
              value={query}
              onChange={(event) => setQuery(event.target.value)}
              placeholder="Search business, service, category or location"
            />
            <button type="submit">Search</button>
          </form>
        </div>
      </section>
      <HomeSections />
    </>
  )
}

function HomeSections() {
  const [dashboard, setDashboard] = useState<Dashboard | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)

  async function loadDashboard() {
    setLoading(true)
    setError(null)

    try {
      setDashboard(await getDashboard())
    } catch (requestError) {
      setError(requestError instanceof Error ? requestError.message : 'Unable to load Calling Bell.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    void loadDashboard()
  }, [])

  return (
    <main className="page-content">
      {loading ? <LoadingState /> : null}
      {error ? <ErrorState title="Local services are unavailable" detail={error} action={<button onClick={() => void loadDashboard()}>Try again</button>} /> : null}
      {!loading && !error && dashboard && dashboard.categories.length === 0 && dashboard.sections.length === 0 ? (
        <EmptyState title="Your homepage is ready for content" detail="Add active categories and home sections in SQL Server to populate Calling Bell." />
      ) : null}
      {!loading && !error ? dashboard?.sections.map((section) => <SectionRenderer key={section.sectionId} section={section} />) : null}
    </main>
  )
}
