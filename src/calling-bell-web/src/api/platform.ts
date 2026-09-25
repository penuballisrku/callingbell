import { request } from './client'
import type { Advertisement, AuthResult, Booking, Enquiry, NearbyBusiness, Review } from './types'

export const login=async(email:string,password:string)=> (await request<AuthResult>('/api/v1/auth/login',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email,password})})).data
export const register=async(name:string,email:string,password:string)=> (await request<AuthResult>('/api/v1/auth/register',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({name,email,password})})).data
export const getNearby=async(latitude:number,longitude:number,radiusKm=10)=> (await request<NearbyBusiness[]>(`/api/v1/businesses/nearby?latitude=${latitude}&longitude=${longitude}&radiusKm=${radiusKm}&pageSize=30`)).data
export const getReviews=async(businessId:number)=> (await request<Review[]>(`/api/v1/businesses/${businessId}/reviews`)).data
export const createReview=async(payload:{businessId:number;rating:number;review?:string})=>(await request<number>('/api/v1/reviews',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(payload)})).data
export const getBookings=async()=>(await request<Booking[]>('/api/v1/bookings')).data
export const getEnquiries=async()=>(await request<Enquiry[]>('/api/v1/enquiries')).data
export const getAdvertisements=async()=>(await request<Advertisement[]>('/api/v1/advertisements')).data
