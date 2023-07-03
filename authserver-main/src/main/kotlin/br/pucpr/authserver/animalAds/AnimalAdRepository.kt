package br.pucpr.authserver.animalAds;

import org.springframework.data.jpa.repository.JpaRepository

interface AnimalAdRepository : JpaRepository<AnimalAd, Long> {
}