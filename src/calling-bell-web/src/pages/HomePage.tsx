import { useEffect, useState } from 'react'
import type { FormEvent } from 'react'
import { useNavigate } from 'react-router-dom'
import { getHome } from '../api/callingBellApi'
import type { HomePage as HomePageData } from '../api/types'
import { EmptyState, ErrorState, LoadingState } from '../components/States'
import { SectionRenderer } from '../components/SectionRenderer'

export function HomePage() {
  const navigate = useNavigate()
  const [retryCount, setRetryCount] = useState(0)
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
          <p className="eyebrow">Local discovery, made simple</p>
          <h1>Find local services near you</h1>
          <p>Discover trusted businesses, professionals and services around you.</p>
          <form onSubmit={submitSearch} className="hero-search__form" role="search">
            <label className="sr-only" htmlFor="hero-search">What are you looking for?</label>
            <input
              id="hero-search"
              value={query}
              onChange={(event) => setQuery(event.target.value)}
              placeholder="What are you looking for?"
            />
            <button type="submit">Search</button>
          </form>
        </div>
      </section>
      <HomeSections key={retryCount} onRetry={() => setRetryCount((value) => value + 1)} />
    </>
  )
}

function HomeSections({ onRetry }: { onRetry: () => void }) {
  const [home, setHome] = useState<HomePageData | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let active = true

    getHome()
      .then((data) => {
        if (active) setHome(data)
      })
      .catch((requestError: Error) => {
        if (active) setError(requestError.message)
      })
      .finally(() => {
        if (active) setLoading(false)
      })

    return () => {
      active = false
    }
  }, [])

  return (
    <main className="page-content">
      {loading ? <LoadingState /> : null}
      {error ? <ErrorState title="Local services are unavailable" detail={error} action={<button onClick={onRetry}>Try again</button>} /> : null}
      {!loading && !error && home?.sections.length === 0 ? <EmptyState title="Your homepage is ready for content" detail="Add active sections and their items in SQL Server to populate Calling Bell." /> : null}
      {!loading && !error ? home?.sections.map((section) => <SectionRenderer key={section.sectionId} section={section} />) : null}
    </main>
  )
}
