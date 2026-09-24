import type { ReactNode } from 'react'

type StateProps = {
  title: string
  detail: string
  action?: ReactNode
}

export function LoadingState() {
  return (
    <div className="state state--loading" role="status" aria-live="polite">
      <span className="loading-orb" aria-hidden="true" />
      <p>Loading local services…</p>
    </div>
  )
}

export function EmptyState({ title, detail, action }: StateProps) {
  return (
    <section className="state">
      <h2>{title}</h2>
      <p>{detail}</p>
      {action}
    </section>
  )
}

export function ErrorState({ title, detail, action }: StateProps) {
  return (
    <section className="state state--error" role="alert">
      <h2>{title}</h2>
      <p>{detail}</p>
      {action}
    </section>
  )
}
