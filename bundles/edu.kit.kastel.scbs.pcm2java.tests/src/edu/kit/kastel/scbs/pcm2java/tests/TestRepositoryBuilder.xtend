package edu.kit.kastel.scbs.pcm2java.tests

import edu.kit.kastel.scbs.pcm2java.tests.data.MinimalPCM2JavaExampleData
import java.util.ArrayList
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.Repository
import org.palladiosimulator.pcm.repository.RepositoryFactory

import static edu.kit.kastel.scbs.pcm2java.tests.TestCollectionDataTypeBuilder.*
import static edu.kit.kastel.scbs.pcm2java.tests.TestCompositeDataTypeBuilder.*
import static edu.kit.kastel.scbs.pcm2java.tests.TestOperationInterfaceBuilder.*
import static edu.kit.kastel.scbs.pcm2java.tests.TestBasicComponentBuilder.*
import static edu.kit.kastel.scbs.pcm2java.tests.TestPrimitiveDataTypeBuilder.*
import static edu.kit.kastel.scbs.pcm2java.tests.TestRepositoryBuilderDataUtility.*

class TestRepositoryBuilder {
    
    boolean repositoryBuilt = false
    final Repository repository
    final MinimalPCM2JavaExampleData added
    
    new() {
        repository = RepositoryFactory.eINSTANCE.createRepository
        added = new MinimalPCM2JavaExampleData
    }
    
    def Repository getMinimal2JavaExampleRepository() {
        if (!repositoryBuilt) buildMinimal2JavaExampleRepository
        return repository
    }
    
    private def void buildMinimal2JavaExampleRepository() {
        addDataTypes
        addInterfaces
        addComponents
        repositoryBuilt = true
    }
    
    private def void addDataTypes() {
        addPrimitiveDataTypes
        addPrimitiveCollectionDataTypes
        addPrimitiveCompositeDataTypes
        addAdvancedCollectionDataTypes
        addDeepCollectionDataTypes
        addAdvancedCompositeDataTypes
        addInheritanceCompositeDataTypes
    }
    
   
    private def void addInterfaces() {
        addPrimitiveInterfaces
        addAdvancedInterfaces
    }
    
    private def void addComponents() {
        addBasicComponentEmpty
        addBasicComponentSingleProvRole
        addBasicComponentMultProvRole
        addBasicComponentSingleReqRole
        addBasicComponentMultReqRole
        addBasicComponentFull
        addBasicComponentDiamond
    }
    
    private def void addPrimitiveDataTypes() {
        val primitiveTypes = buildAllPrimitiveTypes
        repository.dataTypes__Repository.addAll(primitiveTypes)
        for (primitiveType : primitiveTypes) {
            added.addPrimitiveDataType(primitiveType)
        }
    }
    
    private def void addPrimitiveCollectionDataTypes() {
        val primitiveCollTypes = buildCollectionDataTypes(buildPrimitiveCollectionDataTypeData(added.primitiveDataTypes))
        repository.dataTypes__Repository.addAll(primitiveCollTypes)
        for (primitiveCollType : primitiveCollTypes) {
            added.addCollectionDataType(primitiveCollType)
        }
    }
    
    private def void addAdvancedCollectionDataTypes() {
        val advancedCollTypes = buildCollectionDataTypes(buildAdvancedCollectionDataTypeData(added.collTypeEmtpy, added.compTypeEmpty)) 
        repository.dataTypes__Repository.addAll(advancedCollTypes)
        for (advancedCollType : advancedCollTypes) {
            added.addCollectionDataType(advancedCollType)
        }
    }
    
    private def void addDeepCollectionDataTypes() {
        val collTypeCollTypeCompTypeEmpty = buildCollectionDataType(buildDeepCollectionDataTypeData(added.collTypeCompTypeEmpty))
        repository.dataTypes__Repository.add(collTypeCollTypeCompTypeEmpty)
        added.addCollectionDataType(collTypeCollTypeCompTypeEmpty)
        val collTypeCollTypeCollTypeCompTypeEmpty = buildCollectionDataType(buildDeepCollectionDataTypeData(added.collTypeCollTypeCompTypeEmpty))
        repository.dataTypes__Repository.add(collTypeCollTypeCollTypeCompTypeEmpty)
        added.addCollectionDataType(collTypeCollTypeCollTypeCompTypeEmpty)
    }
    
    private def void addPrimitiveCompositeDataTypes() {
        val primitiveCompTypes = buildCompositeDataTypes(buildPrimitiveCompositeDataTypeData(added.primitiveDataTypes, added.primitiveCollectionDataTypes))
        repository.dataTypes__Repository.addAll(primitiveCompTypes)
        for (primitiveCompType : primitiveCompTypes) {
            added.addCompositeDataType(primitiveCompType)
        }
    }
    
    private def void addAdvancedCompositeDataTypes() {
        val advancedCompTypes = buildCompositeDataTypes(buildAdvancedCompositeDataTypeData(added.primitiveCompositeDataTypes, added.primitiveCollectionDataTypes, added.complexCollectionDataTypes))
        repository.dataTypes__Repository.addAll(advancedCompTypes)
        for (advancedCompType : advancedCompTypes) {
            added.addCompositeDataType(advancedCompType)
        }   
    }
    
    private def void addInheritanceCompositeDataTypes() {
        val compTypeInheritance = buildCompositeDataType(buildCompositeDataTypeInheritanceData(added.compTypeCollTypesComplex))
        repository.dataTypes__Repository.add(compTypeInheritance)
        added.addCompositeDataType(compTypeInheritance)
        val compTypeFull = buildCompositeDataType(buildCompositeDataTypeFullData(compTypeInheritance, added.compTypeFullInnerDeclarationTypes))
        repository.dataTypes__Repository.add(compTypeFull)
        added.addCompositeDataType(compTypeFull)
    }
    
    private def void addPrimitiveInterfaces() {
        val primitiveInterfaces = buildOperationInterfaces(buildPrimitiveOperationInterfacesData(added.primitiveDataTypes))
        repository.interfaces__Repository.addAll(primitiveInterfaces)
        for (iface : primitiveInterfaces) {
            added.addInterface(iface)
        }
    }
    
    private def void addAdvancedInterfaces() {
        addInterfaceComplexTypes
        addInterfacesInheritanceOneAndTwo
        addInterfaceDiamond
        addInterfaceInheritanceMult
        addInterfaceFull
    }
    
    private def void addInterfaceComplexTypes() {
        val compTypeCollTypesPrimitive = added.compTypeCollTypesPrimitive
        val compTypeCollTypesComplex = added.compTypeCollTypesComplex
        val compTypeInheritance = added.compTypeInheritance
        val collTypeInt = added.collTypeInt
        val collTypeBool = added.collTypeBool
        val collTypeCompTypeEmpty = added.collTypeCompTypeEmpty
        val collTypeCollTypeCompTypeEmpty = added.collTypeCollTypeCompTypeEmpty
        val iface = buildOperationInterface(buildOperationInterfaceComplexData(compTypeCollTypesPrimitive, compTypeCollTypesComplex, compTypeInheritance, collTypeInt, collTypeBool, collTypeCompTypeEmpty, collTypeCollTypeCompTypeEmpty))
        repository.interfaces__Repository.add(iface)
        added.addInterface(iface)
    }
    
    private def void addInterfacesInheritanceOneAndTwo() {
        val opInterfacePrimitiveTypes = added.opInterfacePrimitiveTypes
        val compTypeAllPrimitives = added.compTypeAllPrimitives
        val compTypeFull = added.compTypeFull
        val collTypeString = added.collTypeString
        val interfaces = buildOperationInterfaces(buildOperationInterfacesInheritanceOneAndTwoData(opInterfacePrimitiveTypes, compTypeAllPrimitives, compTypeFull, collTypeString))
        repository.interfaces__Repository.addAll(interfaces)
        for (iface : interfaces) {
            added.addInterface(iface)
        }
    }
    
    private def void addInterfaceDiamond() {
        val opInterfaceInheritanceOne = added.opInterfaceInheritanceOne
        val opInterfaceInheritanceTwo = added.opInterfaceInheritanceTwo
        val collTypeEmpty = added.collTypeEmtpy
        val iface = buildOperationInterface(buildOperationInterfaceDiamondData(opInterfaceInheritanceOne, opInterfaceInheritanceTwo, collTypeEmpty))
        repository.interfaces__Repository.add(iface)
        added.addInterface(iface)
    }
    
    private def void addInterfaceInheritanceMult() {
        val opInterfaceInheritanceOne = added.opInterfaceInheritanceOne
        val opInterfaceComplexTypes = added.opInterfaceComplexTypes
        val primitiveTypeInt = added.getInt
        val iface = buildOperationInterface(buildOperationInterfaceInheritanceMultData(opInterfaceInheritanceOne, opInterfaceComplexTypes, primitiveTypeInt))
        repository.interfaces__Repository.add(iface)
        added.addInterface(iface)
    }
    
    private def void addInterfaceFull() {
        val opInterfaceInheritanceOne = added.opInterfaceInheritanceOne
        val opInterfaceEmpty = added.opInterfaceEmpty
        val primitiveTypeInt = added.getInt
        val collTypeCollTypeCollTypeCompTypeEmpty = added.collTypeCollTypeCollTypeCompTypeEmpty
        val compTypeFull = added.compTypeFull
        val iface = buildOperationInterface(buildOperationInterfaceFullData(opInterfaceInheritanceOne, opInterfaceEmpty, primitiveTypeInt, collTypeCollTypeCollTypeCompTypeEmpty, compTypeFull))
        repository.interfaces__Repository.add(iface)
        added.addInterface(iface)
    }
    
    private def void addBasicComponentEmpty() {
        val bc = buildBasicComponent(buildBasicComponentEmptyData)
        repository.components__Repository.add(bc)
        added.addComponent(bc)
    }
    
    private def void addBasicComponentSingleProvRole() {
        val opInterfacePrimitiveTypes = added.opInterfacePrimitiveTypes
        val bc = buildBasicComponent(buildBasicComponentSingleProvRoleData(opInterfacePrimitiveTypes))
        repository.components__Repository.add(bc)
        added.addComponent(bc)
    }
    
    private def void addBasicComponentMultProvRole() {
        val opInterfaceComplexTypes = added.opInterfaceComplexTypes
        val opInterfacePrimitiveTypes = added.opInterfacePrimitiveTypes
        val opInterfaceEmpty = added.opInterfaceEmpty
        val bc = buildBasicComponent(buildBasicComponentMultProvRoleData(opInterfaceComplexTypes, opInterfacePrimitiveTypes, opInterfaceEmpty))
        repository.components__Repository.add(bc)
        added.addComponent(bc)
    }
    
    private def void addBasicComponentSingleReqRole() {
        val opInterfaceEmpty = added.opInterfaceEmpty
        val bc = buildBasicComponent(buildBasicComponentSingleReqRoleData(opInterfaceEmpty))
        repository.components__Repository.add(bc)
        added.addComponent(bc)
    }
    
    private def void addBasicComponentMultReqRole() {
        val opInterfacePrimitiveTypes = added.opInterfacePrimitiveTypes
        val opInterfaceInheritanceOne = added.opInterfaceInheritanceOne
        val opInterfaceFull = added.opInterfaceFull
        val bc = buildBasicComponent(buildBasicComponentMultReqRoleData(opInterfacePrimitiveTypes, opInterfaceInheritanceOne, opInterfaceFull))
        repository.components__Repository.add(bc)
        added.addComponent(bc)
    }
    
    private def void addBasicComponentFull() {
        val opInterfaceInheritanceMult = added.opInterfaceInheritanceMult
        val opInterfaceEmpty = added.opInterfaceEmpty
        val opInterfaceInheritanceOne = added.opInterfaceInheritanceOne
        val bc = buildBasicComponent(buildBasicComponentFullData(opInterfaceInheritanceMult, opInterfaceEmpty, opInterfaceInheritanceOne))
        repository.components__Repository.add(bc)
        added.addComponent(bc)
    }

    private def void addBasicComponentDiamond() {
        val opInterfaceDiamond = added.opInterfaceDiamond
        val opInterfaceEmpty = added.opInterfaceEmpty
        val bc = buildBasicComponent(buildBasicComponentDiamondData(opInterfaceDiamond, opInterfaceEmpty))
        repository.components__Repository.add(bc)
        added.addComponent(bc)
    }
}
																										