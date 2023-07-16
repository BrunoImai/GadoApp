package br.pucpr.authserver.users.responses

import br.pucpr.authserver.animalAds.AnimalAd
import br.pucpr.authserver.animalAds.responses.AnimalAdResponse
import br.pucpr.authserver.landAds.LandAd
import br.pucpr.authserver.landAds.response.LandAdResponse
import br.pucpr.authserver.machineryAds.MachineryAd
import br.pucpr.authserver.machineryAds.response.MachineryAdResponse

data class FavoriteResponse (
    val animalAdList: List<AnimalAdResponse> = listOf(),
    val landAdList: List<LandAdResponse> = listOf(),
    val machineryAdList: List<MachineryAdResponse> = listOf()
)