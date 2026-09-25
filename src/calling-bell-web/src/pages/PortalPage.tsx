import { useEffect,useState } from 'react'
import { getBookings,getEnquiries,getAdvertisements } from '../api/platform'
import type { Advertisement,Booking,Enquiry } from '../api/types'
import { useAuth } from '../contexts/AuthContext'
import { LoadingState } from '../components/States'

export function PortalPage({mode}:{mode:'customer'|'business-owner'|'admin'}){
 const {auth,signOut}=useAuth();const [bookings,setBookings]=useState<Booking[]>([]);const [enquiries,setEnquiries]=useState<Enquiry[]>([]);const [ads,setAds]=useState<Advertisement[]>([]);const [loading,setLoading]=useState(true)
 useEffect(()=>{Promise.all([getBookings().catch(()=>[]),getEnquiries().catch(()=>[]),getAdvertisements().catch(()=>[])]).then(([b,e,a])=>{setBookings(b);setEnquiries(e);setAds(a)}).finally(()=>setLoading(false))},[])
 if(!auth)return <main className="page-content"><section className="state"><h1>Sign in required</h1><p>Sign in to access your Calling Bell dashboard.</p></section></main>
 return <main className="page-content portal-page"><section className="page-intro"><p className="eyebrow">{mode.replace('-',' ')}</p><h1>Welcome, {auth.user.name}</h1><p>Manage your Calling Bell activity from one responsive dashboard.</p><button className="button-link" onClick={signOut}>Sign out</button></section>{loading?<LoadingState/>:<div className="portal-grid"><article><strong>{bookings.length}</strong><span>Bookings</span></article><article><strong>{enquiries.length}</strong><span>Enquiries</span></article><article><strong>{ads.length}</strong><span>Active advertisements</span></article></div>}<section className="portal-panel"><h2>Recent bookings</h2>{bookings.length?bookings.slice(0,8).map(b=><div className="portal-row" key={b.bookingId}><b>{b.businessName}</b><span>{b.status}</span><time>{new Date(b.bookingDateUtc).toLocaleString()}</time></div>):<p className="muted">No bookings yet.</p>}</section></main>
}
