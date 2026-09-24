import { useEffect, useMemo, useState } from 'react'
import type { FormEvent } from 'react'
import { getCategories, getLocations, registerBusiness } from '../api/callingBellApi'
import type { Area, BusinessRegistration, Category, City } from '../api/types'
import { ErrorState, LoadingState } from '../components/States'

const initialForm: BusinessRegistration = {
  businessName: '',
  ownerName: '',
  categoryId: 0,
  phone: '',
  address: '',
}

export function AddBusinessPage() {
  const [categories, setCategories] = useState<Category[]>([])
  const [cities, setCities] = useState<City[]>([])
  const [areas, setAreas] = useState<Area[]>([])
  const [form, setForm] = useState<BusinessRegistration>(initialForm)
  const [loading, setLoading] = useState(true)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState<string | null>(null)

  useEffect(() => {
    let active = true
    Promise.all([getCategories(), getLocations()])
      .then(([categoryData, locationData]) => {
        if (!active) return
        setCategories(categoryData)
        setCities(locationData.cities)
        setAreas(locationData.areas)
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

  const availableAreas = useMemo(() => areas.filter((area) => area.cityId === form.cityId), [areas, form.cityId])

  function update<K extends keyof BusinessRegistration>(key: K, value: BusinessRegistration[K]) {
    setForm((current) => ({ ...current, [key]: value }))
  }

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setError(null)
    setSuccess(null)
    setSubmitting(true)

    try {
      const result = await registerBusiness(form)
      setSuccess(`Your listing was submitted with status ${result.status.replace('_', ' ').toLowerCase()}.`)
      setForm(initialForm)
    } catch (requestError) {
      setError(requestError instanceof Error ? requestError.message : 'Unable to submit your business.')
    } finally {
      setSubmitting(false)
    }
  }

  if (loading) return <main className="page-content"><LoadingState /></main>
  if (error && categories.length === 0) return <main className="page-content"><ErrorState title="Registration is unavailable" detail={error} /></main>

  return (
    <main className="page-content registration-page">
      <header className="page-intro">
        <p className="eyebrow">For local businesses</p>
        <h1>List your business</h1>
        <p>Submit your core listing details for review. Your listing stays inactive until approved.</p>
      </header>
      {success ? <p className="notice notice--success" role="status">{success}</p> : null}
      {error ? <p className="notice notice--error" role="alert">{error}</p> : null}
      <form className="registration-form" onSubmit={submit}>
        <label>Business name<input required maxLength={160} value={form.businessName} onChange={(event) => update('businessName', event.target.value)} /></label>
        <label>Owner name<input required maxLength={120} value={form.ownerName} onChange={(event) => update('ownerName', event.target.value)} /></label>
        <label>Category<select required value={form.categoryId || ''} onChange={(event) => update('categoryId', Number(event.target.value))}><option value="" disabled>Select a category</option>{categories.map((category) => <option value={category.categoryId} key={category.categoryId}>{category.name}</option>)}</select></label>
        <label>Phone<input required inputMode="tel" maxLength={30} value={form.phone} onChange={(event) => update('phone', event.target.value)} /></label>
        <label>WhatsApp<input inputMode="tel" maxLength={30} value={form.whatsApp ?? ''} onChange={(event) => update('whatsApp', event.target.value || undefined)} /></label>
        <label>Email<input type="email" maxLength={254} value={form.email ?? ''} onChange={(event) => update('email', event.target.value || undefined)} /></label>
        <label>Website<input type="url" maxLength={500} value={form.website ?? ''} onChange={(event) => update('website', event.target.value || undefined)} /></label>
        <label>City<select value={form.cityId ?? ''} onChange={(event) => { const cityId = event.target.value ? Number(event.target.value) : undefined; setForm((current) => ({ ...current, cityId, areaId: undefined })) }}><option value="">Select a city</option>{cities.map((city) => <option value={city.cityId} key={city.cityId}>{city.name}</option>)}</select></label>
        <label>Area<select disabled={!form.cityId} value={form.areaId ?? ''} onChange={(event) => update('areaId', event.target.value ? Number(event.target.value) : undefined)}><option value="">Select an area</option>{availableAreas.map((area) => <option value={area.areaId} key={area.areaId}>{area.name}</option>)}</select></label>
        <label>Address<input required maxLength={500} value={form.address} onChange={(event) => update('address', event.target.value)} /></label>
        <label>Pincode<input maxLength={12} value={form.pincode ?? ''} onChange={(event) => update('pincode', event.target.value || undefined)} /></label>
        <label className="form-field--wide">Description<textarea maxLength={4000} rows={5} value={form.description ?? ''} onChange={(event) => update('description', event.target.value || undefined)} /></label>
        <button type="submit" disabled={submitting}>{submitting ? 'Submitting…' : 'Submit listing'}</button>
      </form>
    </main>
  )
}
