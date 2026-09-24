import { Link } from 'react-router-dom'

type AuthPageProps = {
  mode: 'login' | 'signup'
}

export function AuthPage({ mode }: AuthPageProps) {
  const isLogin = mode === 'login'

  return (
    <main className="page-content auth-page">
      <section className="auth-card">
        <p className="eyebrow">Calling Bell account</p>
        <h1>{isLogin ? 'Welcome back' : 'Create your account'}</h1>
        <p className="auth-card__intro">
          {isLogin ? 'Sign in to save businesses and manage your local discoveries.' : 'Join Calling Bell to save local businesses and manage your listings.'}
        </p>
        <form className="auth-form" onSubmit={(event) => event.preventDefault()}>
          {!isLogin ? <label>Full name<input type="text" name="name" autoComplete="name" required /></label> : null}
          <label>Email address<input type="email" name="email" autoComplete="email" required /></label>
          <label>Password<input type="password" name="password" autoComplete={isLogin ? 'current-password' : 'new-password'} required /></label>
          <button type="submit">{isLogin ? 'Log in' : 'Sign up'}</button>
        </form>
        <p className="auth-card__switch">
          {isLogin ? 'New to Calling Bell?' : 'Already have an account?'}{' '}
          <Link to={isLogin ? '/signup' : '/login'}>{isLogin ? 'Create an account' : 'Log in'}</Link>
        </p>
      </section>
    </main>
  )
}
