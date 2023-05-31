package com.example.gadoAppDB.animalProduct;

import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/animalController")
public class AnimalProductController {
    private final AnimalProductService animalProductService;

    public AnimalProductController(AnimalProductService animalProductService) {
        this.animalProductService = animalProductService;
    }

    @PostMapping("/addAnimal")
    public AnimalProduct addAnimalProduct(@Valid @RequestBody AnimalProduct animalProduct) {
        return animalProductService.animalProductRepository.save(animalProduct);
    }
}
