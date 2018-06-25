package edu.kit.kastel.scbs.pcm2java.tests

import java.util.ArrayList
import java.util.List
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import org.palladiosimulator.pcm.repository.PrimitiveTypeEnum
import org.palladiosimulator.pcm.repository.RepositoryFactory

class TestPrimitiveDataTypeBuilder {
    
    def static List<PrimitiveDataType> buildAllPrimitiveTypes() {
        val dataTypes = new ArrayList<PrimitiveDataType>
        dataTypes.add(buildPrimitiveDataType(PrimitiveTypeEnum.BOOL))
        dataTypes.add(buildPrimitiveDataType(PrimitiveTypeEnum.BYTE)) 
        dataTypes.add(buildPrimitiveDataType(PrimitiveTypeEnum.CHAR))
        dataTypes.add(buildPrimitiveDataType(PrimitiveTypeEnum.INT))
        dataTypes.add(buildPrimitiveDataType(PrimitiveTypeEnum.LONG))
        dataTypes.add(buildPrimitiveDataType(PrimitiveTypeEnum.DOUBLE))
        dataTypes.add(buildPrimitiveDataType(PrimitiveTypeEnum.STRING))
        return dataTypes
    }
    
    private def static PrimitiveDataType buildPrimitiveDataType(PrimitiveTypeEnum type) {
        val primType = RepositoryFactory.eINSTANCE.createPrimitiveDataType
        primType.type = type
        return primType
        
    }
    
}