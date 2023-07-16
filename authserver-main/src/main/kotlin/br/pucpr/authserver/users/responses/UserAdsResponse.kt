package br.pucpr.authserver.users.responses

import br.pucpr.authserver.animalAds.responses.AnimalAdResponse
import br.pucpr.authserver.landAds.response.LandAdResponse
import br.pucpr.authserver.machineryAds.response.MachineryAdResponse

data class UserAdsResponse(
    val animalAds: List<AnimalAdResponse>,
    val landAds: List<LandAdResponse>,
    val machineryAds: List<MachineryAdResponse>
)
