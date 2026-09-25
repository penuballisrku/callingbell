import { useState } from 'react'
import { getNearby } from '../api/platform'
import type { NearbyBusiness } from '../api/types'
import { ErrorState,LoadingState } from '../components/States'

export function NearbyPage(){
 const [items,setItems]=useState<NearbyBusiness[]|null>(null);const [loading,setLoading]=useState(false);const [error,setError]=useState<string|null>(null)
 const find=()=>{setLoading(true);setError(null);navigator.geolocation.getCurrentPosition(async p=>{try{setItems(await getNearby(p.coords.latitude,p.coords.longitude))}catch(e){setError(e instanceof Error?e.message:'Unable to load nearby services.')}finally{setLoading(false)}},()=>{setError('Location permission is required to find nearby businesses.');setLoading(false)},{enableHighAccuracy:true,timeout:10000})}
 return <main className="page-content"><section className="page-intro"><p className="eyebrow">Nearby Services</p><h1>Services near you</h1><p>Use your location to discover active Calling Bell businesses around you.</p><button className="button-link" onClick={find}>Find nearby</button></section>{loading?<LoadingState/>:null}{error?<ErrorState title="Nearby search failed" detail={error}/>:null}{items?<div className="business-grid">{items.map(x=><article className="business-card" key={x.businessId}><div className="business-card__body"><span className="card-labels">{x.isVerified?'Verified':''}</span><h3>{x.businessName}</h3><p>{x.categoryName??'Local service'}</p><p className="muted">{x.distanceKm.toFixed(1)} km · {x.address??'Address unavailable'}</p>{x.phone?<div className="card-actions"><a href={`tel:${x.phone}`}>Call</a></div>:null}</div></article>)}</div>:null}</main>
}
