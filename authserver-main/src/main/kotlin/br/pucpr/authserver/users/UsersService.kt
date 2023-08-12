package br.pucpr.authserver.users

import br.pucpr.authserver.advertising.AdvertisingAd
import br.pucpr.authserver.advertising.AdvertisingRepository
import br.pucpr.authserver.advertising.requests.AdvertisingRequest
import br.pucpr.authserver.animalAds.AnimalAd
import br.pucpr.authserver.animalAds.AnimalAdRepository
import br.pucpr.authserver.animalAds.requests.AnimalAdRequest
import br.pucpr.authserver.animalAds.responses.AnimalAdResponse
import br.pucpr.authserver.landAds.LandAd
import br.pucpr.authserver.landAds.LandAdRepository
import br.pucpr.authserver.landAds.requests.LandAdRequest
import br.pucpr.authserver.landAds.response.LandAdResponse
import br.pucpr.authserver.machineryAds.MachineryAd
import br.pucpr.authserver.machineryAds.MachineryAdRepository
import br.pucpr.authserver.machineryAds.requests.MachineryAdRequest
import br.pucpr.authserver.machineryAds.response.MachineryAdResponse
import br.pucpr.authserver.security.Jwt
import br.pucpr.authserver.security.UserToken
import br.pucpr.authserver.users.requests.LoginRequest
import br.pucpr.authserver.users.requests.UserRequest
import br.pucpr.authserver.users.responses.FavoriteResponse
import br.pucpr.authserver.users.responses.LoginResponse
import br.pucpr.authserver.users.responses.UserAdsResponse
import jakarta.servlet.http.HttpServletRequest
import org.springframework.data.domain.Sort
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service

@Service
class UsersService(
    val userRepository: UsersRepository,
    val advertisingRepository: AdvertisingRepository,
    val rolesRepository: RolesRepository,
    val animalAdRepository: AnimalAdRepository,
    val machineryAdRepository: MachineryAdRepository,
    val landAdRepository: LandAdRepository,
    val request: HttpServletRequest,
    val jwt: Jwt,
) {

    fun save(req: UserRequest): LoginResponse {
        val user = User(
            email = req.email!!,
            password = req.password!!,
            name = req.name!!,
            animalAds = ArrayList(),
            landAds = ArrayList(),
            machineryAds = ArrayList(),
        )
        val userRole = rolesRepository.findByName("USER")
            ?: throw IllegalStateException("Role 'USER' not found!")

        user.roles.add(userRole)
        userRepository.save(user)
        return LoginResponse(
            token = jwt.createToken(user),
            user.toResponse()
        )
    }

    fun createAnimalAd(req: AnimalAdRequest, ownerId: Long): AnimalAd {

        val owner = userRepository.findByIdOrNull(ownerId)
            ?: throw IllegalStateException("User with id: $ownerId, dont exist!")

        val animalAd = AnimalAd(
            name = req.name,
            weight = req.weight,
            localization = req.localization,
            quantity = req.quantity,
            price = req.price,
            priceType = req.priceType,
            description = req.description,
            owner = owner,
            images = req.images,
        )

        owner.animalAds.add(animalAd)

        return animalAdRepository.save(animalAd)
    }

    fun createLandAd(req: LandAdRequest, ownerId: Long): LandAd {

        val owner = userRepository.findByIdOrNull(ownerId)
            ?: throw IllegalStateException("User with id: $ownerId, dont exist!")


        val landAd = LandAd(
            name = req.name,
            area = req.area,
            localization = req.localization,
            price = req.price,
            priceType = req.priceType,
            description = req.description,
            owner = owner,
            batch = "0000",
            images = req.images,

        )

        owner.landAds.add(landAd)

        return landAdRepository.save(landAd)
    }

    fun createMachineryAd(req: MachineryAdRequest, ownerId: Long): MachineryAd {

        val owner = userRepository.findByIdOrNull(ownerId)
            ?: throw IllegalStateException("User with id: $ownerId, dont exist!")

        val machineryAd = MachineryAd(
            name = req.name,
            quantity = req.quantity,
            localization = req.localization,
            price = req.price,
            priceType = req.priceType,
            description = req.description,
            owner = owner,
            images = req.images,
        )

        owner.machineryAds.add(machineryAd)

        return machineryAdRepository.save(machineryAd)
    }

    fun createAdvertising(req: AdvertisingRequest): AdvertisingAd {
        val advertisingAd = AdvertisingAd (
            description = req.description,
            name = req.name,
            images = req.images
        )

        return advertisingRepository.save(advertisingAd)
    }

    fun getById(id: Long) = userRepository.findByIdOrNull(id)

    private fun getUserIdFromToken(): Long? {
        val authentication = jwt.extract(request)

        return authentication?.let {
            val user = it.principal as UserToken
            user.id
        } ?: throw IllegalStateException("User is not authenticated")
    }

    fun getAnimalById(adId: Long): AnimalAdResponse {
        val userId = getUserIdFromToken()
        val animalAd = animalAdRepository.findByIdOrNull(adId)
            ?: throw IllegalStateException("AnimalAd with id: $adId, doesn't exist!")
        val user = userRepository.findByIdOrNull(userId)
            ?: throw IllegalStateException("User with id: $userId, doesn't exist!")
        val animalAdDto = animalAd.toResponse()
        if (user.favoriteAnimalAds.contains(animalAd)) animalAdDto.isFavorite = true
        return animalAdDto
    }

    fun getMachineryById(adId: Long): MachineryAdResponse {
        val userId = getUserIdFromToken()
        val machineryAd = machineryAdRepository.findByIdOrNull(adId)
            ?: throw IllegalStateException("MachineAd with id: $adId, doesn't exist!")
        val user = userRepository.findByIdOrNull(userId)
            ?: throw IllegalStateException("User with id: $userId, doesn't exist!")
        val machineryAdDto = machineryAd.toResponse()
        if (user.favoriteMachineAds.contains(machineryAd)) machineryAdDto.isFavorite = true
        return machineryAdDto
    }

    fun getLandById(adId: Long): LandAdResponse {
        val userId = getUserIdFromToken()
        val landAd = landAdRepository.findByIdOrNull(adId)
            ?: throw IllegalStateException("landAd with id: $adId, doesn't exist!")
        val user = userRepository.findByIdOrNull(userId)
            ?: throw IllegalStateException("User with id: $userId, doesn't exist!")
        val landAdDto = landAd.toResponse()
        if (user.favoriteLandAds.contains(landAd)) landAdDto.isFavorite = true
        return landAdDto
    }

    fun findAll(role: String?): List<User> =
        if (role == null) userRepository.findAll(Sort.by("name"))
        else userRepository.findAllByRole(role)

    fun findAllAnimalAd(status: String): List<AnimalAd> = animalAdRepository.findAllByStatus(status)

    fun findAllLandAd(status: String): List<LandAd> = landAdRepository.findAllByStatus(status)

    fun findAllMachineryAd(status: String): List<MachineryAd> = machineryAdRepository.findAllByStatus(status)

    fun findAllAdvertisingAd(): List<AdvertisingAd> = advertisingRepository.findAll()

    fun login(credentials: LoginRequest): LoginResponse? {
        val user = userRepository.findByEmail(credentials.email!!) ?: return null
        if (user.password != credentials.password) return null

        return LoginResponse(
            token = jwt.createToken(user),
            user.toResponse()
        )
    }

    fun delete(id: Long): Boolean {
        val user = userRepository.findByIdOrNull(id) ?: return false
        if (user.roles.any { it.name == "ADMIN" }) {
            val count = userRepository.findAllByRole("ADMIN").size
            if (count == 1) throw br.pucpr.authserver.exception.BadRequestException("Cannot delete the last system admin!")
        }

        userRepository.delete(user)
        return true
    }

    fun deleteAdvertisingAd(id: Long): Boolean {
        val ad = advertisingRepository.findByIdOrNull(id) ?: return false
        advertisingRepository.delete(ad)
        return true
    }

    fun deleteLandAd(id: Long): Boolean {
        val ad = landAdRepository.findByIdOrNull(id) ?: return false
        landAdRepository.delete(ad)
        return true
    }

    fun deleteAnimalAd(id: Long): Boolean {
        val ad = animalAdRepository.findByIdOrNull(id) ?: return false
        animalAdRepository.delete(ad)
        return true
    }

    fun deleteMachineryAd(id: Long): Boolean {
        val ad = machineryAdRepository.findByIdOrNull(id) ?: return false
        machineryAdRepository.delete(ad)
        return true
    }

    fun deleteSelfLandAd(id: Long): Boolean {
        val userId = getUserIdFromToken()
        val ad = landAdRepository.findByIdOrNull(id) ?: return false
        val user = userRepository.findByIdOrNull(userId)
            ?: throw IllegalStateException("User with id: $userId, doesn't exist!")
        if (ad.owner != user) throw IllegalStateException("User with id: $userId, is not the owner of this Ad!")
        landAdRepository.delete(ad)
        return true
    }

    fun deleteSelfAnimalAd(id: Long): Boolean {
        val userId = getUserIdFromToken()
        val ad = animalAdRepository.findByIdOrNull(id) ?: return false
        val user = userRepository.findByIdOrNull(userId)
            ?: throw IllegalStateException("User with id: $userId, doesn't exist!")
        if (ad.owner != user) throw IllegalStateException("User with id: $userId, is not the owner of this Ad!")
        animalAdRepository.delete(ad)
        return true
    }

    fun deleteSelfMachineryAd(id: Long): Boolean {
        val userId = getUserIdFromToken()
        val ad = machineryAdRepository.findByIdOrNull(id) ?: return false
        val user = userRepository.findByIdOrNull(userId)
            ?: throw IllegalStateException("User with id: $userId, doesn't exist!")
        if (ad.owner != user) throw IllegalStateException("User with id: $userId, is not the owner of this Ad!")
        machineryAdRepository.delete(ad)
        return true
    }

    fun getAllAdsCreatedByUser(ownerId: Long): UserAdsResponse {
        val owner = userRepository.findByIdOrNull(ownerId)
            ?: throw IllegalStateException("User with id: $ownerId, dont exist!")

        return UserAdsResponse(
            owner.animalAds.map { it.toResponse() },
            owner.landAds.map { it.toResponse() },
            owner.machineryAds.map { it.toResponse() }
        )
    }

    fun getAllAnalysisAds(): UserAdsResponse {
        return UserAdsResponse(
            findAllAnimalAd("Em Análise").map { it.toResponse() },
            findAllLandAd("Em Análise").map { it.toResponse() },
            findAllMachineryAd("Em Análise").map { it.toResponse() },
        )
    }

    fun validateAnimalAd(adId: Long): Boolean {
        val oldAd = animalAdRepository.findByIdOrNull(adId)?:
        throw IllegalStateException("Ad with id: $adId, doesn't exist!")

        val animalAd = AnimalAd(
            name = oldAd.name,
            weight = oldAd.weight,
            localization = oldAd.localization,
            quantity = oldAd.quantity,
            price = oldAd.price,
            priceType = oldAd.priceType,
            description = oldAd.description,
            owner = oldAd.owner,
            images = oldAd.images?.toList(),
            status = "Aprovado"
        )
        deleteAnimalAd(adId)
        animalAdRepository.save(animalAd)
        return true
    }

    fun validateMachineryAd(adId: Long): Boolean {
        val oldAd = machineryAdRepository.findByIdOrNull(adId)?:
        throw IllegalStateException("Ad with id: $adId, doesn't exist!")

        val machineryAd = MachineryAd(
            name = oldAd.name,
            localization = oldAd.localization!!,
            quantity = oldAd.quantity,
            price = oldAd.price,
            priceType = oldAd.priceType,
            description = oldAd.description,
            owner = oldAd.owner,
            images = oldAd.images?.toList(),
            status = "Aprovado",
        )

        deleteMachineryAd(adId)
        machineryAdRepository.save(machineryAd)
        return true
    }

    fun validateLandAd(adId: Long): Boolean {
        val oldAd = landAdRepository.findByIdOrNull(adId)?:
        throw IllegalStateException("Ad with id: $adId, doesn't exist!")
        val machineryAd = LandAd(
            name = oldAd.name,
            localization = oldAd.localization!!,
            price = oldAd.price,
            priceType = oldAd.priceType,
            description = oldAd.description,
            owner = oldAd.owner,
            images = oldAd.images?.toList(),
            status = "Aprovado",
            area = oldAd.area
        )

        deleteLandAd(adId)
        landAdRepository.save(machineryAd)
        return true
    }

    fun addLandAdFavorite(userId: Long, landAdId: Long): Boolean {
        val user = userRepository.findByIdOrNull(userId)
        val landAd = landAdRepository.findByIdOrNull(landAdId)

        if (user != null && landAd != null) {
            user.favoriteLandAds.add(landAd)
            userRepository.save(user)
            return true
        }
        return false
    }

    fun addAnimalAdFavorite(userId: Long, animalAdId: Long): Boolean {
        val user = userRepository.findByIdOrNull(userId)
        val animalAd = animalAdRepository.findByIdOrNull(animalAdId)

        if (user != null && animalAd != null) {
            user.favoriteAnimalAds.add(animalAd)
            userRepository.save(user)
            return true
        }
        return false
    }

    fun addMachineryAdFavorite(userId: Long, machineryAdId: Long): Boolean {
        val user = userRepository.findByIdOrNull(userId)
        val mechineryAd = machineryAdRepository.findByIdOrNull(machineryAdId)

        if (user != null && mechineryAd != null) {
            user.favoriteMachineAds.add(mechineryAd)
            userRepository.save(user)
            return true
        }
        return false
    }

    fun removeLandFavorite(userId: Long, landAdId: Long): Boolean {
        val user = userRepository.findByIdOrNull(userId)
        val landAd = landAdRepository.findByIdOrNull(landAdId)

        if (user != null && landAd != null) {
            user.favoriteLandAds.remove(landAd)
            userRepository.save(user)
            return true
        }
        return false
    }

    fun removeAnimalFavorite(userId: Long, animalAdId: Long): Boolean {
        val user = userRepository.findByIdOrNull(userId)
        val animalAd = animalAdRepository.findByIdOrNull(animalAdId)

        if (user != null && animalAd != null) {
            user.favoriteAnimalAds.remove(animalAd)
            userRepository.save(user)
            return true
        }
        return false
    }

    fun removeMachineryFavorite(userId: Long, machineryAdId: Long): Boolean {
        val user = userRepository.findByIdOrNull(userId)
        val machineryAd = machineryAdRepository.findByIdOrNull(machineryAdId)

        if (user != null && machineryAd != null) {
            user.favoriteMachineAds.remove(machineryAd)
            userRepository.save(user)
            return true
        }
        return false
    }

    fun getFavoriteAds(userId: Long): FavoriteResponse {
        val user = userRepository.findByIdOrNull(userId)
            ?: throw IllegalStateException("User with id: $userId, doesn't exist!")

        return FavoriteResponse(
            user.favoriteAnimalAds.map { it.toResponse() },
            user.favoriteLandAds.map { it.toResponse() },
            user.favoriteMachineAds.map { it.toResponse() }
        )
    }

    fun updateAnimalAd(req: AnimalAdRequest, ownerId: Long, animalAdId : Long): AnimalAd {
        val owner = userRepository.findByIdOrNull(ownerId)
            ?: throw IllegalStateException("User with id: $ownerId, dont exist!")

        val oldAd = animalAdRepository.findByIdOrNull(animalAdId)
            ?: throw IllegalStateException("Ad with id: $animalAdId, dont exist!")

        animalAdRepository.delete(oldAd)

        val animalAd = AnimalAd(
            name = req.name,
            weight = req.weight,
            localization = req.localization,
            quantity = req.quantity,
            price = req.price,
            priceType = req.priceType,
            description = req.description,
            owner = owner,
            images = req.images,
        )

        owner.animalAds.add(animalAd)

        return animalAdRepository.save(animalAd)
    }

    fun updateLandAd(req: LandAdRequest, ownerId: Long, landAdId : Long): LandAd {
        val owner = userRepository.findByIdOrNull(ownerId)
            ?: throw IllegalStateException("User with id: $ownerId, dont exist!")

        val oldAd = landAdRepository.findByIdOrNull(landAdId)
            ?: throw IllegalStateException("Ad with id: $landAdId, dont exist!")

        landAdRepository.delete(oldAd)

        val landAd = LandAd(
            name = req.name,
            localization = req.localization,
            price = req.price,
            priceType = req.priceType,
            description = req.description,
            owner = owner,
            images = req.images,
            area = req.area,
        )

        owner.landAds.add(landAd)

        return landAdRepository.save(landAd)
    }

    fun updateAdvertisingAd(req: AdvertisingRequest, advertisingAdId: Long): AdvertisingAd {

        val oldAd = advertisingRepository.findByIdOrNull(advertisingAdId)
            ?: throw IllegalStateException("Advertising with id: $advertisingAdId, dont exist!")

        advertisingRepository.delete(oldAd)

        val advertisingAd = AdvertisingAd(
            name = req.name,
            description = req.description,
            images = req.images,
        )

        return advertisingRepository.save(advertisingAd)
    }

    fun updateMachineryAd(req: MachineryAdRequest, ownerId: Long, machineryAdId : Long): MachineryAd {
        val owner = userRepository.findByIdOrNull(ownerId)
            ?: throw IllegalStateException("User with id: $ownerId, dont exist!")

        val oldAd = animalAdRepository.findByIdOrNull(machineryAdId)
            ?: throw IllegalStateException("Ad with id: $machineryAdId, dont exist!")

        animalAdRepository.delete(oldAd)

        val machineryAd = MachineryAd(
            name = req.name,
            localization = req.localization,
            quantity = req.quantity,
            price = req.price,
            priceType = req.priceType,
            description = req.description,
            owner = owner,
            images = req.images,
        )

        owner.machineryAds.add(machineryAd)

        return machineryAdRepository.save(machineryAd)
    }
}