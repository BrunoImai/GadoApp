package br.pucpr.authserver.landAds;

import br.pucpr.authserver.animalAds.AnimalAd
import org.springframework.data.jpa.repository.JpaRepository

interface LandAdRepository : JpaRepository<LandAd, Long> {
    fun findAllByStatus(status : String) : List<LandAd>
}