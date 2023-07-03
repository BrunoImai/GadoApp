package br.pucpr.authserver.landAds;

import org.springframework.data.jpa.repository.JpaRepository

interface LandAdRepository : JpaRepository<LandAd, Long> {
}