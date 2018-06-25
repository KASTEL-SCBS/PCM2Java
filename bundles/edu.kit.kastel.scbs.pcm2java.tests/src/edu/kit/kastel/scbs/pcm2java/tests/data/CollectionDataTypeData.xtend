package edu.kit.kastel.scbs.pcm2java.tests.data

import org.palladiosimulator.pcm.repository.DataType

class CollectionDataTypeData {
    
    private final String name
    private final DataType innerType
    
    new(String name, DataType innerType) {
        this.name = name
        this.innerType = innerType
    }
    
    def String getName() {
        name
    }
    
    def DataType getInnerType() {
        innerType
    }
}