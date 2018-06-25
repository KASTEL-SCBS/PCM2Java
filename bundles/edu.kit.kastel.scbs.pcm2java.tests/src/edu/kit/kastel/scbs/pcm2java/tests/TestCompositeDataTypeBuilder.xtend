package edu.kit.kastel.scbs.pcm2java.tests

import edu.kit.kastel.scbs.pcm2java.tests.data.CompositeDataTypeData
import java.util.ArrayList
import org.eclipse.internal.xtend.util.Pair
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.RepositoryFactory

class TestCompositeDataTypeBuilder {
    
    def static Iterable<CompositeDataType> buildCompositeDataTypes(Iterable<CompositeDataTypeData> data) {
        val dataTypes = new ArrayList<CompositeDataType>
        for (type : data) {
            dataTypes.add(buildCompositeDataType(type))
        }
        return dataTypes    
    }
    
    def static CompositeDataType buildCompositeDataType(CompositeDataTypeData typeData) {
        buildCompositeDataType(typeData.name, typeData.innerDeclarationNamesAndTypes, typeData.parentCompositeDataTypes)
    }
    
    private def static CompositeDataType buildCompositeDataType(String name, Iterable<Pair<String, DataType>> innerDeclarationNamesAndTypes, Iterable<CompositeDataType> parentCompositeDataTypes) {
        val dataType = RepositoryFactory.eINSTANCE.createCompositeDataType
        dataType.entityName = name
        dataType.parentType_CompositeDataType.addAll(parentCompositeDataTypes)
        for (pair : innerDeclarationNamesAndTypes) {
            val innerDeclaration = RepositoryFactory.eINSTANCE.createInnerDeclaration
            innerDeclaration.entityName = pair.first
            innerDeclaration.datatype_InnerDeclaration = pair.second
            dataType.innerDeclaration_CompositeDataType.add(innerDeclaration)
        }
        return dataType
    }
}