package br.pucpr.authserver.users

import br.pucpr.authserver.advertising.requests.AdvertisingRequest
import br.pucpr.authserver.animalAds.requests.AnimalAdRequest
import br.pucpr.authserver.landAds.requests.LandAdRequest
import br.pucpr.authserver.machineryAds.requests.MachineryAdRequest
import br.pucpr.authserver.users.requests.LoginRequest
import br.pucpr.authserver.users.requests.UserRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.Parameter
import io.swagger.v3.oas.annotations.security.SecurityRequirement
import jakarta.transaction.Transactional
import jakarta.validation.Valid
import org.springframework.http.HttpStatus
import org.springframework.http.HttpStatus.CREATED
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.Authentication
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/users")
class UsersController (val service: UsersService) {
    @Operation(
        summary = "Lista todos os usuários",
        parameters = [
            Parameter(
                name = "role",
                description = "Papel a ser usado no filtro (opcional)",
                example = "USER"
            )]
    )

    @GetMapping
    fun listUsers(@RequestParam("role") role: String?) =
        service.findAll(role)
            .map { it.toResponse() }

    @GetMapping("/ads/animal")
    fun listAnimalAds() =
        service.findAllAnimalAd("Aprovado")
            .map { it.toResponse() }

    @GetMapping("/ads/land")
    fun listLandAds() =
        service.findAllLandAd("Aprovado")
            .map { it.toResponse() }

    @GetMapping("/ads/machinery")
    fun listMachineryAds() =
        service.findAllMachineryAd("Aprovado")
            .map { it.toResponse() }

    @GetMapping("/adm/ads/animal")
    fun listAnalysisAnimalAds() =
        service.findAllAnimalAd("Em Análise")
            .map { it.toResponse() }

    @GetMapping("/adm/ads/land")
    fun listAnalysisLandAds() =
        service.findAllLandAd("Em Análise")
            .map { it.toResponse() }

    @GetMapping("/adm/ads/machinery")
    fun listAnalysisMachineryAds() =
        service.findAllMachineryAd("Em Análise")
            .map { it.toResponse() }

    @GetMapping("/adm/advertising")
    fun listAdvertisingAds() =
        service.findAllAdvertisingAd().map { it.toResponse() }

    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "AuthServer")
    @GetMapping("/adm/ads")
    fun listAnalysisAds() =
        service.getAllAnalysisAds()


    @Transactional
    @PostMapping
    fun createUser(@Valid @RequestBody req: UserRequest) =
        service.save(req)
            .let { ResponseEntity.status(CREATED).body(it) }

    @PostMapping("/{userId}/ads/animal")
    fun createAnimalAd(@Valid @RequestBody req: AnimalAdRequest, @PathVariable("userId") userId: Long) =
        service.createAnimalAd(req, userId)
            .toResponse()
            .let { ResponseEntity.status(CREATED).body(it) }

    @PostMapping("/adm/advertising")
    fun createAdvertising(@Valid @RequestBody req: AdvertisingRequest) =
        service.createAdvertising(req)
            .toResponse()
            .let { ResponseEntity.status(CREATED).body(it) }

    @PostMapping("/{userId}/ads/land")
    fun createLandAd(@Valid @RequestBody req: LandAdRequest, @PathVariable("userId") userId: Long) =
        service.createLandAd(req, userId)
            .toResponse()
            .let { ResponseEntity.status(CREATED).body(it) }

    @PostMapping("/{userId}/ads/machinery")
    fun createMachineryAd(@Valid @RequestBody req: MachineryAdRequest, @PathVariable("userId") userId: Long) =
        service.createMachineryAd(req, userId)
            .toResponse()
            .let { ResponseEntity.status(CREATED).body(it) }

    @PutMapping("/{userId}/ads/animal/{adId}")
    fun updateAnimalAd(@Valid @RequestBody req: AnimalAdRequest, @PathVariable("userId") userId: Long, @PathVariable("adId") adId: Long ) =
        service.updateAnimalAd(req, userId, adId)
            .toResponse()
            .let { ResponseEntity.status(CREATED).body(it) }

    @PutMapping("/{userId}/ads/land/{adId}")
    fun updateLandAd(@Valid @RequestBody req: LandAdRequest, @PathVariable("userId") userId: Long, @PathVariable("adId") adId: Long ) =
        service.updateLandAd(req, userId, adId)
            .toResponse()
            .let { ResponseEntity.status(CREATED).body(it) }

    @PutMapping("/{userId}/ads/machinery/{adId}")
    fun updateMachineryAd(@Valid @RequestBody req: MachineryAdRequest, @PathVariable("userId") userId: Long, @PathVariable("adId") adId: Long ) =
        service.updateMachineryAd(req, userId, adId)
            .toResponse()
            .let { ResponseEntity.status(CREATED).body(it) }

    @GetMapping("/me")
    @PreAuthorize("permitAll()")
    @SecurityRequirement(name = "AuthServer")
    fun getSelf(auth: Authentication) = getUser(auth.credentials as Long)

    @GetMapping("/{id}")
    fun getUser(@PathVariable("id") id: Long) =
        service.getById(id)
            ?.let { ResponseEntity.ok(it.toResponse()) }
            ?: ResponseEntity.notFound().build()

    @GetMapping("/adm/advertising/{adId}")
    fun getAdvertising(@PathVariable("adId") adId: Long) =
        service.getAdvertisingById(adId)
            .let { ResponseEntity.ok(it) }
    @GetMapping("/ads/animal/{adId}")
    fun getAnimal(@PathVariable("adId") adId: Long) =
        service.getAnimalById(adId)
            .let { ResponseEntity.ok(it) }


    @GetMapping("/ads/land/{adId}")
    fun getLand(@PathVariable("adId") adId: Long) =
        service.getLandById(adId)
            .let { ResponseEntity.ok(it) }



    @GetMapping("/ads/machinery/{adId}")
    fun getMachinery(@PathVariable("adId") adId: Long) =
        service.getMachineryById(adId)
            .let { ResponseEntity.ok(it) }


    @GetMapping("/{id}/ads")
    fun getAllUserAds(@PathVariable("id") id: Long) =
        service.getAllAdsCreatedByUser(id)


    @PostMapping("/login")
    fun login(@Valid @RequestBody credentials: LoginRequest) =
        service.login(credentials)
            ?.let { ResponseEntity.ok(it) }
            ?: ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()

    @DeleteMapping("/adm/advertising/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "AuthServer")
    fun deleteAdvertising(@PathVariable("id") id: Long): ResponseEntity<Void> =
        if (service.deleteAdvertisingAd(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()


    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "AuthServer")
    fun delete(@PathVariable("id") id: Long): ResponseEntity<Void> =
        if (service.delete(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    @DeleteMapping("/adm/animalAd/{animalAdId}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "AuthServer")
    fun deleteAnimalAd(@PathVariable("animalAdId") id: Long): ResponseEntity<Void> =
        if (service.deleteAnimalAd(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    @DeleteMapping("/adm/landAd/{landAdId}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "AuthServer")
    fun deleteLandAd(@PathVariable("landAdId") id: Long): ResponseEntity<Void> =
        if (service.deleteLandAd(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    @DeleteMapping("/adm/machineryAd/{machineryAdId}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "AuthServer")
    fun deleteMachineryAd(@PathVariable("machineryAdId") id: Long): ResponseEntity<Void> =
        if (service.deleteMachineryAd(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    @PutMapping("/adm/animalAd/{animalAdId}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "AuthServer")
    fun validateAnimalAd(@PathVariable("animalAdId") id: Long): ResponseEntity<Void> =
        if (service.validateAnimalAd(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    @PutMapping("/adm/landAd/{landAdId}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "AuthServer")
    fun validateLandAd(@PathVariable("landAdId") id: Long): ResponseEntity<Void> =
        if (service.validateLandAd(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    @PutMapping("/adm/machineryAd/{machineryAdId}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "AuthServer")
    fun validateMachineryAd(@PathVariable("machineryAdId") id: Long): ResponseEntity<Void> =
        if (service.validateMachineryAd(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    @PutMapping("/adm/advertising/{adId}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "AuthServer")
    fun updateAdvertising(@Valid @RequestBody req: AdvertisingRequest, @PathVariable("adId") adId: Long ) =
        service.updateAdvertisingAd(req, adId)
            .toResponse()
            .let { ResponseEntity.status(CREATED).body(it) }

    @DeleteMapping("/animalAd/{animalAdId}")
    fun deleteSelfAnimalAd(@PathVariable("animalAdId") id: Long): ResponseEntity<Void> =
        if (service.deleteSelfAnimalAd(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    @DeleteMapping("/landAd/{landAdId}")
    fun deleteSelfLandAd(@PathVariable("landAdId") id: Long): ResponseEntity<Void> =
        if (service.deleteSelfLandAd(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    @DeleteMapping("/machineryAd/{machineryAdId}")
    fun deleteSelfMachineryAd(@PathVariable("machineryAdId") id: Long): ResponseEntity<Void> =
        if (service.deleteSelfMachineryAd(id)) ResponseEntity.ok().build()
        else ResponseEntity.notFound().build()

    @PostMapping("/{userId}/favorites/landAd/{landAdId}")
    fun addLandFavorite(@PathVariable("userId") userId: Long, @PathVariable("landAdId") landAdId: Long): ResponseEntity<Void> {
        if (service.addLandAdFavorite(userId, landAdId)) {
            return ResponseEntity.ok().build()
        }
        return ResponseEntity.notFound().build()
    }

    @PostMapping("/{userId}/favorites/animalAd/{animalAdId}")
    fun addAnimalFavorite(@PathVariable("userId") userId: Long, @PathVariable("animalAdId") animalAdId: Long): ResponseEntity<Void> {
        if (service.addAnimalAdFavorite(userId, animalAdId)) {
            return ResponseEntity.ok().build()
        }
        return ResponseEntity.notFound().build()
    }

    @PostMapping("/{userId}/favorites/machineryAd/{mechineryAdId}")
    fun addMachineryFavorite(@PathVariable("userId") userId: Long, @PathVariable("mechineryAdId") mechineryAdId: Long): ResponseEntity<Void> {
        if (service.addMachineryAdFavorite(userId, mechineryAdId)) {
            return ResponseEntity.ok().build()
        }
        return ResponseEntity.notFound().build()
    }

    @DeleteMapping("/{userId}/favorites/landAd/l{landAdId}")
    fun removeLandFavorite(@PathVariable("userId") userId: Long, @PathVariable("landAdId") landAdId: Long): ResponseEntity<Void> {
        if (service.removeLandFavorite(userId, landAdId)) {
            return ResponseEntity.ok().build()
        }
        return ResponseEntity.notFound().build()
    }

    @DeleteMapping("/{userId}/favorites/animalAd/{animalAdId}")
    fun removeAnimalFavorite(@PathVariable("userId") userId: Long, @PathVariable("animalAdId") animalAdId: Long): ResponseEntity<Void> {
        if (service.removeAnimalFavorite(userId, animalAdId)) {
            return ResponseEntity.ok().build()
        }
        return ResponseEntity.notFound().build()
    }

    @DeleteMapping("/{userId}/favorites/machineryAd/{machineryAdId}")
    fun removeMachineryFavorite(@PathVariable("userId") userId: Long, @PathVariable("machineryAdId") machineryAdId: Long): ResponseEntity<Void> {
        if (service.removeMachineryFavorite(userId, machineryAdId)) {
            return ResponseEntity.ok().build()
        }
        return ResponseEntity.notFound().build()
    }

    @GetMapping("/{userId}/favorites")
    fun getFavoriteAds(@PathVariable("userId") userId: Long) =
        service.getFavoriteAds(userId)

}