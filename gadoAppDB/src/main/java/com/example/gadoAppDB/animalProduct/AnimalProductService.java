package com.example.gadoAppDB.animalProduct;

import org.springframework.stereotype.Service;

@Service
public class AnimalProductService
{
    private final AnimalProductRepository animalProductRepository;

    public AnimalProductService(AnimalProductRepository animalProductRepository) {
        this.animalProductRepository = animalProductRepository;
    }
}
