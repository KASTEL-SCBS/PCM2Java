package edu.kit.kastel.scbs.pcm2java.tests

import edu.kit.kastel.scbs.pcm2java.tests.data.CollectionDataTypeData
import java.util.ArrayList
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.RepositoryFactory

class TestCollectionDataTypeBuilder {
    
    def static Iterable<CollectionDataType> buildCollectionDataTypes(Iterable<CollectionDataTypeData> typeData) {
        val dataTypes = new ArrayList<CollectionDataType>
        for (type : typeData) {
            dataTypes.add(buildCollectionDataType(type))
        }
        return dataTypes    
    }
    
    def static CollectionDataType buildCollectionDataType(CollectionDataTypeData typeData) {
        buildCollectionDataType(typeData.name, typeData.innerType)
    }
    
    private def static CollectionDataType buildCollectionDataType(String name, DataType innerType) {
        val dataType = RepositoryFactory.eINSTANCE.createCollectionDataType
        dataType.innerType_CollectionDataType = innerType
        dataType.entityName = name
        return dataType
    }
    
}