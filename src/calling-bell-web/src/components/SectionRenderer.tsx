import { Link } from 'react-router-dom'
import type { HomeItem, HomeSection } from '../api/types'
import { SafeImage } from './SafeImage'

const categorySections = new Set(['CATEGORY_GRID', 'POPULAR_SEARCH', 'WEDDING', 'BEAUTY_SPA', 'REPAIR', 'DAILY_NEEDS', 'HEALTHCARE'])
const bannerSections = new Set(['BANNER', 'ADVERTISEMENT'])

function formatCount(count: number | null) {
  return count === null ? null : `${new Intl.NumberFormat().format(count)} businesses`
}

function CategoryCard({ item }: { item: HomeItem }) {
  const destination = item.slug ? `/search?category=${encodeURIComponent(item.slug)}` : '/search'

  return (
    <Link className="category-card" to={destination}>
      <SafeImage src={item.imageUrl} thumbnailSrc={item.thumbnailUrl} mobileSrc={item.mobileImageUrl} alt={item.altText ?? `${item.name} services`} sizes="(max-width: 680px) 44vw, 220px" />
      <span className="card-content">
        <strong>{item.name}</strong>
        {formatCount(item.businessCount) ? <small>{formatCount(item.businessCount)}</small> : null}
      </span>
    </Link>
  )
}

function BusinessCard({ item }: { item: HomeItem }) {
  const destination = item.slug ? `/businesses/${encodeURIComponent(item.slug)}` : '/search'
  const phone = item.phone?.replace(/[^+\d]/g, '')

  return (
    <article className="business-card">
      <Link to={destination} className="business-card__image">
        <SafeImage src={item.imageUrl} thumbnailSrc={item.thumbnailUrl} mobileSrc={item.mobileImageUrl} alt={item.altText ?? item.name} sizes="(max-width: 680px) 86vw, 360px" />
      </Link>
      <div className="business-card__body">
        <div className="card-labels">
          {item.isSponsored ? <span>Sponsored</span> : null}
          {item.isVerified ? <span className="verified">Verified</span> : null}
        </div>
        <Link to={destination}><h3>{item.name}</h3></Link>
        {item.rating !== null ? <p className="rating"><b>★ {item.rating.toFixed(1)}</b>{item.reviewCount !== null ? ` · ${item.reviewCount} reviews` : ''}</p> : null}
        {item.categoryName ? <p>{item.categoryName}</p> : null}
        {item.address ? <p className="muted">{item.address}</p> : null}
        <div className="card-actions">
          {phone ? <a href={`tel:${phone}`}>Call</a> : null}
          <Link to={destination}>View details</Link>
        </div>
      </div>
    </article>
  )
}

function BannerCard({ item }: { item: HomeItem }) {
  const contents = (
    <>
      <SafeImage src={item.imageUrl} thumbnailSrc={item.thumbnailUrl} mobileSrc={item.mobileImageUrl} alt={item.altText ?? item.name} sizes="(max-width: 680px) 92vw, 1160px" />
      <span className="banner-card__copy">
        <strong>{item.name}</strong>
        {item.description ? <span>{item.description}</span> : null}
      </span>
    </>
  )

  return item.targetUrl?.startsWith('/') ? <Link className="banner-card" to={item.targetUrl}>{contents}</Link> : <article className="banner-card">{contents}</article>
}

export function SectionRenderer({ section }: { section: HomeSection }) {
  if (section.items.length === 0) return null

  const type = section.sectionType.toUpperCase()
  const styleClass = `home-section home-section--${section.theme.replace(/[^a-zA-Z0-9_-]/g, '')}`

  return (
    <section className={styleClass} aria-labelledby={`section-${section.sectionId}`}>
      <div className="section-heading">
        <div>
          <h2 id={`section-${section.sectionId}`}>{section.title}</h2>
          {section.subtitle ? <p>{section.subtitle}</p> : null}
        </div>
      </div>
      {bannerSections.has(type) ? <div className="banner-grid">{section.items.map((item) => <BannerCard item={item} key={item.id} />)}</div> : null}
      {categorySections.has(type) ? <div className="category-grid">{section.items.map((item) => <CategoryCard item={item} key={item.id} />)}</div> : null}
      {!bannerSections.has(type) && !categorySections.has(type) ? <div className="business-grid">{section.items.map((item) => <BusinessCard item={item} key={item.id} />)}</div> : null}
    </section>
  )
}
