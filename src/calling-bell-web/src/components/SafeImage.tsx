import { useEffect, useState } from 'react'

type SafeImageProps = {
  src?: string | null
  thumbnailSrc?: string | null
  mobileSrc?: string | null
  alt: string
  className?: string
  sizes?: string
}

const fallbackSource = '/assets/calling-bell-placeholder.svg'

function isDataUrl(source?: string | null) {
  return source?.trimStart().startsWith('data:') ?? false
}

function normalizeSource(source: string) {
  if (!/^data:image\/svg\+xml,/i.test(source)) return source

  const payload = source.slice(source.indexOf(',') + 1)
  try {
    return `data:image/svg+xml;charset=utf-8,${encodeURIComponent(decodeURIComponent(payload))}`
  } catch {
    return source
  }
}

export function SafeImage({ src, thumbnailSrc, mobileSrc, alt, className, sizes }: SafeImageProps) {
  const sources = [src, thumbnailSrc, mobileSrc, fallbackSource].filter((source, index, all): source is string => Boolean(source?.trim()) && all.indexOf(source) === index)
  const [sourceIndex, setSourceIndex] = useState(0)
  const [loaded, setLoaded] = useState(false)
  const currentSource = normalizeSource(sources[sourceIndex] ?? fallbackSource)
  const canUseResponsiveSources = sourceIndex === 0 && !isDataUrl(src)

  useEffect(() => {
    setSourceIndex(0)
    setLoaded(false)
  }, [src, thumbnailSrc, mobileSrc])

  return (
    <span className={`safe-image ${loaded ? 'safe-image--loaded' : ''} ${className ?? ''}`} aria-busy={!loaded}>
      <picture>
        {mobileSrc && canUseResponsiveSources && !isDataUrl(mobileSrc) ? <source media="(max-width: 680px)" srcSet={mobileSrc} /> : null}
        <img
          src={currentSource}
          srcSet={thumbnailSrc && canUseResponsiveSources && !isDataUrl(thumbnailSrc) ? `${thumbnailSrc} 480w, ${src} 960w` : undefined}
          sizes={sizes}
          alt={alt}
          loading={isDataUrl(currentSource) ? 'eager' : 'lazy'}
          onLoad={() => setLoaded(true)}
          onError={() => setSourceIndex((index) => Math.min(index + 1, sources.length - 1))}
        />
      </picture>
    </span>
  )
}
