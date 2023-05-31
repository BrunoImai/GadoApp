package com.example.gadoAppDB.animalProduct;

import jakarta.validation.Valid;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Service
public class AnimalProductService
{
    public final AnimalProductRepository animalProductRepository;

    public AnimalProductService(AnimalProductRepository animalProductRepository) {
        this.animalProductRepository = animalProductRepository;
    }



}
