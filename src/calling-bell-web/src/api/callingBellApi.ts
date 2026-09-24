import { request } from './client'
import type {
  BusinessDetails,
  BusinessRegistration,
  BusinessRegistrationResult,
  BusinessSummary,
  Category,
  HomePage,
  LocationOptions,
  Pagination,
} from './types'

export async function getHome(): Promise<HomePage> {
  return (await request<HomePage>('/api/v1/home')).data
}

export async function getCategories(): Promise<Category[]> {
  return (await request<Category[]>('/api/v1/categories')).data
}

export async function getLocations(): Promise<LocationOptions> {
  return (await request<LocationOptions>('/api/v1/locations')).data
}

export async function searchBusinesses(query: string, categorySlug?: string): Promise<{ items: BusinessSummary[]; pagination: Pagination | null }> {
  const parameters = new URLSearchParams({ pageSize: '12' })
  if (query.trim()) parameters.set('query', query.trim())
  if (categorySlug) parameters.set('categorySlug', categorySlug)

  const response = await request<BusinessSummary[]>(`/api/v1/businesses?${parameters.toString()}`)
  return { items: response.data, pagination: response.pagination }
}

export async function getBusiness(slug: string): Promise<BusinessDetails> {
  return (await request<BusinessDetails>(`/api/v1/businesses/${encodeURIComponent(slug)}`)).data
}

export async function registerBusiness(payload: BusinessRegistration): Promise<BusinessRegistrationResult> {
  return (
    await request<BusinessRegistrationResult>('/api/v1/businesses', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })
  ).data
}
