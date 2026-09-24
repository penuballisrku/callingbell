import { useEffect, useState } from 'react'
import type { FormEvent } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { searchBusinesses } from '../api/callingBellApi'
import type { BusinessSummary } from '../api/types'
import { SafeImage } from '../components/SafeImage'
import { EmptyState, ErrorState, LoadingState } from '../components/States'

function BusinessResultCard({ business }: { business: BusinessSummary }) {
  const phone = business.phone?.replace(/[^+\d]/g, '')

  return (
    <article className="business-card business-result">
      <Link to={`/businesses/${encodeURIComponent(business.slug)}`} className="business-card__image">
        <SafeImage src={business.coverImageUrl ?? business.logoUrl} alt={business.businessName} sizes="(max-width: 680px) 86vw, 360px" />
      </Link>
      <div className="business-card__body">
        <div className="card-labels">
          {business.isSponsored ? <span>Sponsored</span> : null}
          {business.isVerified ? <span className="verified">Verified</span> : null}
        </div>
        <Link to={`/businesses/${encodeURIComponent(business.slug)}`}><h2>{business.businessName}</h2></Link>
        <p className="rating"><b>★ {business.rating.toFixed(1)}</b> · {business.reviewCount} reviews</p>
        {business.categoryName ? <p>{business.categoryName}</p> : null}
        {business.areaName || business.cityName ? <p className="muted">{[business.areaName, business.cityName].filter(Boolean).join(', ')}</p> : null}
        <div className="card-actions">
          {phone ? <a href={`tel:${phone}`}>Call</a> : null}
          <Link to={`/businesses/${encodeURIComponent(business.slug)}`}>View details</Link>
        </div>
      </div>
    </article>
  )
}

export function SearchPage() {
  const [searchParams, setSearchParams] = useSearchParams()
  const currentQuery = searchParams.get('q') ?? ''
  const category = searchParams.get('category') ?? undefined
  const [query, setQuery] = useState(currentQuery)

  function submitSearch(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const nextParameters = new URLSearchParams()
    if (query.trim()) nextParameters.set('q', query.trim())
    if (category) nextParameters.set('category', category)
    setSearchParams(nextParameters)
  }

  return (
    <main className="page-content search-page">
      <header className="page-intro">
        <p className="eyebrow">Search Calling Bell</p>
        <h1>{currentQuery ? `Results for “${currentQuery}”` : 'Explore local businesses'}</h1>
        <form className="search-page__form" onSubmit={submitSearch} role="search">
          <label className="sr-only" htmlFor="results-search">Search businesses or services</label>
          <input id="results-search" value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Search businesses or services" />
          <button type="submit">Search</button>
        </form>
      </header>
      <SearchResults key={`${currentQuery}:${category ?? ''}`} query={currentQuery} category={category} />
    </main>
  )
}

function SearchResults({ query, category }: { query: string; category?: string }) {
  const [items, setItems] = useState<BusinessSummary[]>([])
  const [totalCount, setTotalCount] = useState<number | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    let active = true

    searchBusinesses(query, category)
      .then((result) => {
        if (!active) return
        setItems(result.items)
        setTotalCount(result.pagination?.totalCount ?? null)
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
  }, [category, query])

  if (loading) return <LoadingState />
  if (error) return <ErrorState title="Search is unavailable" detail={error} />
  if (items.length === 0) return <EmptyState title="No matches found" detail="Try a broader service or business name." />

  return (
    <>
      {totalCount !== null ? <p className="result-count">{totalCount} businesses found</p> : null}
      <section className="business-grid" aria-label="Business results">{items.map((business) => <BusinessResultCard business={business} key={business.businessId} />)}</section>
    </>
  )
}
