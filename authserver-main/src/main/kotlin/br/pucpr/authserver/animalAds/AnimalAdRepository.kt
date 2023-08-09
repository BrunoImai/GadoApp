package br.pucpr.authserver.animalAds;

import br.pucpr.authserver.users.User
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository

interface AnimalAdRepository : JpaRepository<AnimalAd, Long> {
    fun findAllByStatus(status : String) : List<AnimalAd>
}