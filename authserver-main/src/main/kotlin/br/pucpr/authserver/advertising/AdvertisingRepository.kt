package br.pucpr.authserver.advertising;

import org.springframework.data.jpa.repository.JpaRepository

interface AdvertisingRepository : JpaRepository<AdvertisingAd, Long> {
}