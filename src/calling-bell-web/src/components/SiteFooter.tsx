const socialLinks = [
  ['Facebook', 'https://www.facebook.com/JustDial'],
  ['YouTube', 'https://www.youtube.com/user/justdialind'],
  ['Instagram', 'https://www.instagram.com/jd_justdial'],
  ['LinkedIn', 'https://www.linkedin.com/company/justdial'],
  ['Twitter', 'https://twitter.com/jd_justdial'],
] as const

export function SiteFooter() {
  return (
    <footer className="site-footer">
      <div className="site-footer__brand">
        <span className="footer-brand">Calling Bell</span>
        <p>Discover trusted local services, businesses, and professionals in one place.</p>
      </div>
      <div className="site-footer__social">
        <h2>Follow us on</h2>
        <nav aria-label="Social media">
          {socialLinks.map(([name, url]) => <a href={url} key={name} target="_blank" rel="noreferrer" aria-label={`Calling Bell on ${name}`}><span aria-hidden="true">{name.slice(0, 1)}</span>{name}</a>)}
        </nav>
      </div>
      <div className="site-footer__about">
        <h2>One-Stop for All Local Businesses</h2>
        <p>Welcome to Calling Bell, your one-stop destination for day-to-day services, local discoveries, and exclusive planning and purchasing needs. We bring trusted businesses and helpful services together in one convenient place.</p>
      </div>
      <p className="copyright">© {new Date().getFullYear()} Calling Bell</p>
    </footer>
  )
}
