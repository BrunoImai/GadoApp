package br.pucpr.authserver.machineryAds;

import br.pucpr.authserver.landAds.LandAd
import org.springframework.data.jpa.repository.JpaRepository

interface MachineryAdRepository : JpaRepository<MachineryAd, Long> {
    fun findAllByStatus(status : String) : List<MachineryAd>
}