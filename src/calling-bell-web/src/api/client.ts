import type { ApiResponse, Pagination } from './types'

const apiBaseUrl = (import.meta.env.VITE_API_BASE_URL ?? '').replace(/\/$/, '')

export class ApiClientError extends Error {
  readonly status: number
  readonly code: string

  constructor(message: string, status: number, code: string) {
    super(message)
    this.status = status
    this.code = code
  }
}

export async function request<T>(path: string, init?: RequestInit): Promise<{ data: T; pagination: Pagination | null }> {
  let response: Response

  try {
    response = await fetch(`${apiBaseUrl}${path}`, {
      ...init,
      headers: {
        Accept: 'application/json',
        ...init?.headers,
      },
    })
  } catch {
    throw new ApiClientError('Unable to reach Calling Bell right now.', 0, 'NETWORK_ERROR')
  }

  const payload = (await response.json().catch(() => null)) as ApiResponse<T> | null
  if (!response.ok || !payload?.success || payload.data === null) {
    throw new ApiClientError(
      payload?.error?.message ?? payload?.message ?? 'Something went wrong.',
      response.status,
      payload?.error?.code ?? 'REQUEST_FAILED',
    )
  }

  return { data: payload.data, pagination: payload.pagination }
}
