import { useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { getBusiness } from '../api/callingBellApi'
import { ApiClientError } from '../api/client'
import type { BusinessDetails } from '../api/types'
import { SafeImage } from '../components/SafeImage'
import { EmptyState, ErrorState, LoadingState } from '../components/States'

export function BusinessDetailPage() {
  const { slug = '' } = useParams()

  return <BusinessDetailContent key={slug} slug={slug} />
}

function BusinessDetailContent({ slug }: { slug: string }) {
  const [business, setBusiness] = useState<BusinessDetails | null>(null)
  const [error, setError] = useState<ApiClientError | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let active = true

    getBusiness(slug)
      .then((data) => {
        if (active) setBusiness(data)
      })
      .catch((requestError: ApiClientError) => {
        if (active) setError(requestError)
      })
      .finally(() => {
        if (active) setLoading(false)
      })

    return () => {
      active = false
    }
  }, [slug])

  if (loading) return <main className="page-content"><LoadingState /></main>
  if (error?.status === 404) return <main className="page-content"><EmptyState title="Business not found" detail="The listing may have moved or is no longer available." action={<Link className="button-link" to="/search">Explore businesses</Link>} /></main>
  if (error) return <main className="page-content"><ErrorState title="Business details are unavailable" detail={error.message} /></main>
  if (!business) return null

  const location = [business.address, business.areaName, business.cityName, business.pincode].filter(Boolean).join(', ')
  const phone = business.phone?.replace(/[^+\d]/g, '')
  const website = business.website?.startsWith('https://') || business.website?.startsWith('http://') ? business.website : null

  return (
    <main className="page-content business-detail">
      <section className="business-hero">
        <SafeImage src={business.coverImageUrl} alt={business.businessName} sizes="100vw" />
        <div className="business-hero__overlay">
          <SafeImage className="business-hero__logo" src={business.logoUrl} alt={`${business.businessName} logo`} sizes="96px" />
          <div className="card-labels">
            {business.isSponsored ? <span>Sponsored</span> : null}
            {business.isVerified ? <span className="verified">Verified</span> : null}
          </div>
          <h1>{business.businessName}</h1>
          <p className="rating"><b>★ {business.rating.toFixed(1)}</b> · {business.reviewCount} reviews</p>
          {business.categoryName ? <p>{business.categoryName}</p> : null}
        </div>
      </section>
      <section className="detail-layout">
        <article className="detail-copy">
          <h2>About</h2>
          {business.description ? <p>{business.description}</p> : <p>No description has been added to this listing.</p>}
          <h2>Location</h2>
          <p>{location}</p>
          <h2>Contact</h2>
          <div className="contact-list">
            {phone ? <a href={`tel:${phone}`}>{business.phone}</a> : null}
            {business.whatsApp ? <a href={`https://wa.me/${business.whatsApp.replace(/\D/g, '')}`} rel="noreferrer" target="_blank">WhatsApp</a> : null}
            {business.email ? <a href={`mailto:${business.email}`}>{business.email}</a> : null}
            {website ? <a href={website} rel="noreferrer" target="_blank">Visit website</a> : null}
          </div>
        </article>
        <aside className="detail-aside">
          <h2>Gallery</h2>
          {business.images.length > 0 ? <div className="gallery-grid">{business.images.map((image) => <SafeImage key={image.businessImageId} src={image.imageUrl} thumbnailSrc={image.thumbnailUrl} alt={image.altText ?? business.businessName} sizes="(max-width: 680px) 42vw, 240px" />)}</div> : <p className="muted">Images will appear here when the business adds them.</p>}
        </aside>
      </section>
    </main>
  )
}
