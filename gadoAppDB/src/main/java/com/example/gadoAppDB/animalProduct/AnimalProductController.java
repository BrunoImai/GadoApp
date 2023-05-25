package com.example.gadoAppDB.animalProduct;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/animalController")
public class AnimalProductController {
    private final AnimalProductService animalProductService;

    public AnimalProductController(AnimalProductService animalProductService) {
        this.animalProductService = animalProductService;
    }
}
