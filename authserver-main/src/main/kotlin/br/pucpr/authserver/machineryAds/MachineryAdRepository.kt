package br.pucpr.authserver.machineryAds;

import org.springframework.data.jpa.repository.JpaRepository

interface MachineryAdRepository : JpaRepository<MachineryAd, Long> {
}