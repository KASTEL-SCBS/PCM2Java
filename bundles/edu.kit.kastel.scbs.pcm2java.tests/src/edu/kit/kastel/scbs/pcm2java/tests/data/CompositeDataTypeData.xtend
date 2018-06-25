package edu.kit.kastel.scbs.pcm2java.tests.data

import java.util.ArrayList
import java.util.List
import org.eclipse.internal.xtend.util.Pair
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType

class CompositeDataTypeData {
    
    private String name
    private List<Pair<String, DataType>> innerDeclarationNamesAndTypes
    private List<CompositeDataType> parentCompositeDataTypes
    
    new(String name, List<Pair<String, DataType>> innerDeclarationNamesAndTypes) {
        setName(name)
        setInnerDeclarationNamesAndTypes(innerDeclarationNamesAndTypes)
        setParentCompositeDataType(null)
    }
    
    new(String name, List<Pair<String, DataType>> innerDeclarationNamesAndTypes, CompositeDataType parentCompositeDataType) {
        setName(name)
        setInnerDeclarationNamesAndTypes(innerDeclarationNamesAndTypes)
        setParentCompositeDataType(parentCompositeDataType)
    }
    
    new(String name, List<Pair<String, DataType>> innerDeclarationNamesAndTypes, Iterable<CompositeDataType> parentCompositeDataTypes) {
        setName(name)
        setInnerDeclarationNamesAndTypes(innerDeclarationNamesAndTypes)
        setParentCompositeDataTypes(parentCompositeDataTypes)
    }
    
    def String getName() {
        name
    }
    
    def List<Pair<String, DataType>> getInnerDeclarationNamesAndTypes() {
        innerDeclarationNamesAndTypes
    }
    
    def Iterable<CompositeDataType> getParentCompositeDataTypes() {
        parentCompositeDataTypes
    }
    
    private def void setName(String name) {
        if (name !== null) {
            this.name = name
        } else {
            this.name = ""
        }
    }
    
    private def void setInnerDeclarationNamesAndTypes(List<Pair<String, DataType>> innerDeclarationNamesAndTypes) {
        this.innerDeclarationNamesAndTypes = new ArrayList<Pair<String, DataType>>
        if (innerDeclarationNamesAndTypes !== null) {
            this.innerDeclarationNamesAndTypes.addAll(innerDeclarationNamesAndTypes)
        } 
    }
    
    private def void setParentCompositeDataTypes(Iterable<CompositeDataType> parentCompositeDataTypes) {
        this.parentCompositeDataTypes = new ArrayList<CompositeDataType>
        if (parentCompositeDataTypes !== null) {
            this.parentCompositeDataTypes.addAll(parentCompositeDataTypes)
        }
    }
    
    private def void setParentCompositeDataType(CompositeDataType parentCompositeDataType) {
        parentCompositeDataTypes = new ArrayList<CompositeDataType>
        if (parentCompositeDataType !== null) {
            parentCompositeDataTypes.add(parentCompositeDataType)
        }
    }
    
}