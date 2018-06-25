package edu.kit.kastel.scbs.pcm2java.tests

import edu.kit.kastel.scbs.pcm2java.tests.data.BasicComponentData
import edu.kit.kastel.scbs.pcm2java.tests.data.CollectionDataTypeData
import edu.kit.kastel.scbs.pcm2java.tests.data.CompositeDataTypeData
import edu.kit.kastel.scbs.pcm2java.tests.data.OperationInterfaceData
import java.util.ArrayList
import java.util.Collection
import java.util.List
import org.eclipse.internal.xtend.util.Pair
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationSignature
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import org.palladiosimulator.pcm.repository.RepositoryFactory

import static extension edu.kit.ipd.sdq.mdsd.pcm2java.util.DataTypeUtil.*

class TestRepositoryBuilderDataUtility {
    
    static final val COLLECTION_DATA_TYPE_NAME_PREFIX = "CollType"
    static final val COMPOSITE_DATA_TYPE_NAME_PREFIX = "CompType"
    static final val OPERATION_SIGNATURE_NAME_PREFIX = "method"
    static final val OPERATION_SIGNATURE_PARAMETER_NAME_PREFIX = "para"
    static final val PRIMITIVE_COLLECTION_DATA_TYPE_NAME_SUFFIXES = #["Empty", "Boolean", "Byte", "Char", "Int", "Long", "Double", "String"] 
    static final val PRIMITIVE_COMPOSITE_DATA_TYPE_NAME_SUFFIXES = #["Empty", "AllPrimitives", "CollTypesPrimitive"]
    static final val COMPLEX_COMPOSITE_DATA_TYPE_NAME_SUFFIXES = #["CompTypes", "CollTypesPrimitive", "CollTypesComplex"]
    static final val INHERITANCE_COMPOSITE_DATA_TYPE_NAME_SUFFIXES = #["Inheritance", "Full"]
    static final val PRIMITIVE_INNER_DECLARATONS_NAMES = #["primBoolean", "primByte", "primChar", "primInt", "primLong", "primDouble", "primString"]
    static final val OPERATION_INTERFACE_NAME_PREFIX = "OpInterface"
    static final val OPERATION_INTERFACE_NAME_SUFFIX = #["Empty", "PrimitiveTypes", "ComplexTypes", "InheritanceOne", "InheritanceTwo", "Diamond", "InheritanceMult", "Full"]
    static final val BASIC_COMPONENT_NAME_PREFIX = "BasicComponent"
    static final val BASIC_COMPONENT_NAME_SUFFIX = #["Empty", "SingleProvRole", "MultProvRole", "SingleReqRole", "MultReqRole", "Full", "Diamond"]
    
    
    def static Iterable<CollectionDataTypeData> buildPrimitiveCollectionDataTypeData(Collection<PrimitiveDataType> primitiveDataTypes) {
        val data = new ArrayList<CollectionDataTypeData> 
        data.add(new CollectionDataTypeData(COLLECTION_DATA_TYPE_NAME_PREFIX + PRIMITIVE_COLLECTION_DATA_TYPE_NAME_SUFFIXES.get(0) , null))
        for (type : primitiveDataTypes) {
            var name = ""
            switch(type.getType) {
                case BOOL: {
                    name = COLLECTION_DATA_TYPE_NAME_PREFIX + PRIMITIVE_COLLECTION_DATA_TYPE_NAME_SUFFIXES.get(1)
                }
                case BYTE: {
                    name = COLLECTION_DATA_TYPE_NAME_PREFIX + PRIMITIVE_COLLECTION_DATA_TYPE_NAME_SUFFIXES.get(2)
                }
                case CHAR: {
                    name = COLLECTION_DATA_TYPE_NAME_PREFIX + PRIMITIVE_COLLECTION_DATA_TYPE_NAME_SUFFIXES.get(3)
                }
                case INT: {
                    name = COLLECTION_DATA_TYPE_NAME_PREFIX + PRIMITIVE_COLLECTION_DATA_TYPE_NAME_SUFFIXES.get(4)
                }
                case LONG: {
                    name = COLLECTION_DATA_TYPE_NAME_PREFIX + PRIMITIVE_COLLECTION_DATA_TYPE_NAME_SUFFIXES.get(5)
                }
                case DOUBLE: {
                    name = COLLECTION_DATA_TYPE_NAME_PREFIX + PRIMITIVE_COLLECTION_DATA_TYPE_NAME_SUFFIXES.get(6)
                    
                }
                case STRING: {
                    name = COLLECTION_DATA_TYPE_NAME_PREFIX + PRIMITIVE_COLLECTION_DATA_TYPE_NAME_SUFFIXES.get(7)
                }
            }
            data.add(new CollectionDataTypeData(name, type))
        }
        return data
    }
    
    def static Iterable<CollectionDataTypeData> buildAdvancedCollectionDataTypeData(CollectionDataType collTypeEmpty, CompositeDataType compTypeEmpty) {
        val data = new ArrayList<CollectionDataTypeData>
        data.add(new CollectionDataTypeData(COLLECTION_DATA_TYPE_NAME_PREFIX + collTypeEmpty.entityName, collTypeEmpty))
        data.add(new CollectionDataTypeData(COLLECTION_DATA_TYPE_NAME_PREFIX + compTypeEmpty.entityName, compTypeEmpty))
        return data
    }
    
    def static CollectionDataTypeData buildDeepCollectionDataTypeData(CollectionDataType innerType) {
        return new CollectionDataTypeData(COLLECTION_DATA_TYPE_NAME_PREFIX + innerType.entityName, innerType)
    }
    
    def static Iterable<CompositeDataTypeData> buildPrimitiveCompositeDataTypeData(Collection<PrimitiveDataType> primitiveTypes, Collection<CollectionDataType> primitiveCollectionTypes) {
        val data = new ArrayList<CompositeDataTypeData>
        data.add(new CompositeDataTypeData(COMPOSITE_DATA_TYPE_NAME_PREFIX + PRIMITIVE_COMPOSITE_DATA_TYPE_NAME_SUFFIXES.get(0) , null))
        data.add(new CompositeDataTypeData(COMPOSITE_DATA_TYPE_NAME_PREFIX + PRIMITIVE_COMPOSITE_DATA_TYPE_NAME_SUFFIXES.get(1), buildInnerDeclarationPairs(primitiveTypes)))
        data.add(new CompositeDataTypeData(COMPOSITE_DATA_TYPE_NAME_PREFIX + PRIMITIVE_COMPOSITE_DATA_TYPE_NAME_SUFFIXES.get(2), buildInnerDeclarationPairs(primitiveCollectionTypes)))
        return data
    }
    
    def static Iterable<CompositeDataTypeData> buildAdvancedCompositeDataTypeData(Collection<CompositeDataType> primitiveCompTypes, Collection<CollectionDataType> primitiveCollTypes, Collection<CollectionDataType> complexCollTypes) {
        val data = new ArrayList<CompositeDataTypeData>
        data.add(new CompositeDataTypeData(COMPOSITE_DATA_TYPE_NAME_PREFIX + COMPLEX_COMPOSITE_DATA_TYPE_NAME_SUFFIXES.get(0), buildInnerDeclarationPairs(primitiveCompTypes)))
        data.add(new CompositeDataTypeData(COMPOSITE_DATA_TYPE_NAME_PREFIX + COMPLEX_COMPOSITE_DATA_TYPE_NAME_SUFFIXES.get(1), buildInnerDeclarationPairs(primitiveCollTypes)))
        data.add(new CompositeDataTypeData(COMPOSITE_DATA_TYPE_NAME_PREFIX + COMPLEX_COMPOSITE_DATA_TYPE_NAME_SUFFIXES.get(2), buildInnerDeclarationPairs(complexCollTypes)))
        return data
    }
    
    def static CompositeDataTypeData buildCompositeDataTypeInheritanceData(CompositeDataType compTypeCollTypesComplex) {
        return new CompositeDataTypeData(COMPOSITE_DATA_TYPE_NAME_PREFIX + INHERITANCE_COMPOSITE_DATA_TYPE_NAME_SUFFIXES.get(0), null, compTypeCollTypesComplex)
    }
    
    def static CompositeDataTypeData buildCompositeDataTypeFullData(CompositeDataType compTypeInheritance, Collection<DataType> innerDeclarationTypes) {
            return new CompositeDataTypeData(COMPOSITE_DATA_TYPE_NAME_PREFIX + INHERITANCE_COMPOSITE_DATA_TYPE_NAME_SUFFIXES.get(1), buildInnerDeclarationPairs(innerDeclarationTypes), compTypeInheritance) 
    }
    
    def static Iterable<OperationInterfaceData> buildPrimitiveOperationInterfacesData(Collection<PrimitiveDataType> primitiveDataTypes) {
        val primitiveInterfaces = new ArrayList<OperationInterfaceData>
        primitiveInterfaces.add(buildOperationInterfaceEmptyData)
        primitiveInterfaces.add(buildOperationInterfacePrimitiveTypesData(primitiveDataTypes))
        return primitiveInterfaces
    }
    
    def static OperationInterfaceData buildOperationInterfaceEmptyData() {
        return new OperationInterfaceData(OPERATION_INTERFACE_NAME_PREFIX + OPERATION_INTERFACE_NAME_SUFFIX.get(0))
    }
    
    def static OperationInterfaceData buildOperationInterfacePrimitiveTypesData(Collection<PrimitiveDataType> primitiveDataTypes) {
        val operationSignatures = new ArrayList<OperationSignature>
        var operationSignature = RepositoryFactory.eINSTANCE.createOperationSignature
        operationSignature.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "Empty"
        operationSignatures.add(operationSignature)
        for (type : primitiveDataTypes) {
            operationSignature = RepositoryFactory.eINSTANCE.createOperationSignature
            operationSignature.entityName = OPERATION_SIGNATURE_NAME_PREFIX + type.classNameOfDataType.primitiveToReferenceName
            operationSignature.returnType__OperationSignature = type
            val param = RepositoryFactory.eINSTANCE.createParameter
            param.dataType__Parameter = type
            param.parameterName = OPERATION_SIGNATURE_PARAMETER_NAME_PREFIX + type.classNameOfDataType.primitiveToReferenceName
            operationSignature.parameters__OperationSignature.add(param)
            operationSignatures.add(operationSignature)
        }
        return new OperationInterfaceData(OPERATION_INTERFACE_NAME_PREFIX + OPERATION_INTERFACE_NAME_SUFFIX.get(1), operationSignatures)
    }
        
    def static OperationInterfaceData buildOperationInterfaceComplexData(CompositeDataType compTypeCollTypesPrimitive,
                                                                         CompositeDataType compTypeCollTypesComplex,
                                                                         CompositeDataType compTypeInheritance,
                                                                         CollectionDataType collTypeInt,
                                                                         CollectionDataType collTypeBool,
                                                                         CollectionDataType collTypeCompTypeEmpty,
                                                                         CollectionDataType collTypeCollTypeCompTypeEmpty) {
        val operationSignatures = new ArrayList<OperationSignature>
        val methodVoid = RepositoryFactory.eINSTANCE.createOperationSignature
        methodVoid.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "Void"
        val methodVoidParaCompType = RepositoryFactory.eINSTANCE.createParameter
        methodVoidParaCompType.parameterName = OPERATION_SIGNATURE_PARAMETER_NAME_PREFIX + "CompType"
        methodVoidParaCompType.dataType__Parameter = compTypeCollTypesComplex
        methodVoid.parameters__OperationSignature.add(methodVoidParaCompType)
        val methodVoidParaCollType = RepositoryFactory.eINSTANCE.createParameter
        methodVoidParaCollType.parameterName = OPERATION_SIGNATURE_PARAMETER_NAME_PREFIX + "CollType"
        methodVoidParaCollType.dataType__Parameter = collTypeBool
        methodVoid.parameters__OperationSignature.add(methodVoidParaCollType)
        operationSignatures.add(methodVoid)
        val methodCompType = RepositoryFactory.eINSTANCE.createOperationSignature
        methodCompType.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "CompType"
        methodCompType.returnType__OperationSignature = compTypeCollTypesPrimitive
        val methodCompTypeParaCollType = RepositoryFactory.eINSTANCE.createParameter
        methodCompTypeParaCollType.parameterName = OPERATION_SIGNATURE_PARAMETER_NAME_PREFIX + "CollType"
        methodCompTypeParaCollType.dataType__Parameter = collTypeCollTypeCompTypeEmpty
        methodCompType.parameters__OperationSignature.add(methodCompTypeParaCollType)
        operationSignatures.add(methodCompType)
        val methodCollType = RepositoryFactory.eINSTANCE.createOperationSignature
        methodCollType.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "CollType"
        methodCollType.returnType__OperationSignature = collTypeInt
        val methodCollTypeParaCompType = RepositoryFactory.eINSTANCE.createParameter
        methodCollTypeParaCompType.parameterName = OPERATION_SIGNATURE_PARAMETER_NAME_PREFIX + "CompType"
        methodCollTypeParaCompType.dataType__Parameter = compTypeInheritance
        methodVoid.parameters__OperationSignature.add(methodVoidParaCompType)
        val methodCollTypeParaCollType = RepositoryFactory.eINSTANCE.createParameter
        methodCollTypeParaCollType.parameterName = OPERATION_SIGNATURE_PARAMETER_NAME_PREFIX + "CollType"
        methodCollTypeParaCollType.dataType__Parameter = collTypeCompTypeEmpty
        methodCollType.parameters__OperationSignature.add(methodVoidParaCollType)
        operationSignatures.add(methodCollType)
        return new OperationInterfaceData(OPERATION_INTERFACE_NAME_PREFIX + OPERATION_INTERFACE_NAME_SUFFIX.get(2), operationSignatures)                                            
    }
    
    def static Collection<OperationInterfaceData> buildOperationInterfacesInheritanceOneAndTwoData(OperationInterface opInterfacePrimitiveTypes,
                                                                              CompositeDataType compTypeAllPrimitives,
                                                                              CompositeDataType compTypeFull,
                                                                              CollectionDataType collTypeString) {
        val interfacesData = new ArrayList<OperationInterfaceData>
        val operationSignaturesOne = new ArrayList<OperationSignature>
        val methodInheritanceOneA = RepositoryFactory.eINSTANCE.createOperationSignature
        methodInheritanceOneA.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "InheritanceOneA"
        methodInheritanceOneA.returnType__OperationSignature = compTypeAllPrimitives
        operationSignaturesOne.add(methodInheritanceOneA)
        val methodInheritanceOneB = RepositoryFactory.eINSTANCE.createOperationSignature
        methodInheritanceOneB.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "InheritanceOneB"
        methodInheritanceOneB.returnType__OperationSignature = collTypeString
        operationSignaturesOne.add(methodInheritanceOneB)
        interfacesData.add(new OperationInterfaceData(OPERATION_INTERFACE_NAME_PREFIX + OPERATION_INTERFACE_NAME_SUFFIX.get(3), operationSignaturesOne, opInterfacePrimitiveTypes))
        val operationSignaturesTwo = new ArrayList<OperationSignature>
        val methodInheritanceTwoA = RepositoryFactory.eINSTANCE.createOperationSignature
        methodInheritanceTwoA.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "InheritanceTwoA"
        methodInheritanceTwoA.returnType__OperationSignature = compTypeAllPrimitives
        operationSignaturesTwo.add(methodInheritanceTwoA)
        val methodInheritanceTwoB = RepositoryFactory.eINSTANCE.createOperationSignature
        methodInheritanceTwoB.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "InheritanceTwoB"
        methodInheritanceTwoB.returnType__OperationSignature = compTypeFull
        operationSignaturesTwo.add(methodInheritanceTwoB)
        interfacesData.add(new OperationInterfaceData(OPERATION_INTERFACE_NAME_PREFIX + OPERATION_INTERFACE_NAME_SUFFIX.get(4), operationSignaturesTwo, opInterfacePrimitiveTypes))
        return interfacesData                                       
    }
    
    def static OperationInterfaceData buildOperationInterfaceDiamondData(OperationInterface opInterfaceInheritanceOne,
                                                                         OperationInterface opInterfaceInheritanceTwo,
                                                                         CollectionDataType collTypeEmpty) {
        val operationSignatures = new ArrayList<OperationSignature>
        val methodDiamond = RepositoryFactory.eINSTANCE.createOperationSignature
        methodDiamond.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "Diamond"
        methodDiamond.returnType__OperationSignature = collTypeEmpty
        operationSignatures.add(methodDiamond)
        val parentInterfaces = new ArrayList<OperationInterface>
        parentInterfaces.add(opInterfaceInheritanceOne)
        parentInterfaces.add(opInterfaceInheritanceTwo)
        return new OperationInterfaceData(OPERATION_INTERFACE_NAME_PREFIX + OPERATION_INTERFACE_NAME_SUFFIX.get(5), operationSignatures, parentInterfaces)
    }
    
    def static OperationInterfaceData buildOperationInterfaceInheritanceMultData(OperationInterface opInterfaceInheritanceOne,
                                                                                 OperationInterface opInterfaceComplexTypes,
                                                                                 PrimitiveDataType primitiveTypeInt) {
        val parentInterfaces = new ArrayList<OperationInterface>
        parentInterfaces.add(opInterfaceComplexTypes)
        parentInterfaces.add(opInterfaceInheritanceOne)
        val operationSignatures = new ArrayList<OperationSignature>
        val methodInheritanceOne = RepositoryFactory.eINSTANCE.createOperationSignature
        methodInheritanceOne.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "InheritanceOne"
        val paraInt = RepositoryFactory.eINSTANCE.createParameter
        paraInt.parameterName = "paraInt"
        paraInt.dataType__Parameter = primitiveTypeInt
        methodInheritanceOne.parameters__OperationSignature.add(paraInt)
        operationSignatures.add(methodInheritanceOne)
        return new OperationInterfaceData(OPERATION_INTERFACE_NAME_PREFIX + OPERATION_INTERFACE_NAME_SUFFIX.get(6), operationSignatures, parentInterfaces)
    }
    
    def static OperationInterfaceData buildOperationInterfaceFullData(OperationInterface opInterfaceInheritanceOne,
                                                                      OperationInterface opInterfaceEmpty,
                                                                      PrimitiveDataType primitiveTypeInt,
                                                                      CollectionDataType collTypeCollTypeCollTypeCompTypeEmpty,
                                                                      CompositeDataType compTypeFull) {
        val parentInterfaces = new ArrayList<OperationInterface>
        parentInterfaces.add(opInterfaceEmpty)
        parentInterfaces.add(opInterfaceInheritanceOne)
        val operationSignatures = new ArrayList<OperationSignature>
        val methodEmpty = RepositoryFactory.eINSTANCE.createOperationSignature
        methodEmpty.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "Empty"
        operationSignatures.add(methodEmpty)
        val methodPrimitiveReturn = RepositoryFactory.eINSTANCE.createOperationSignature
        methodPrimitiveReturn.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "PrimitiveReturn"
        methodPrimitiveReturn.returnType__OperationSignature = primitiveTypeInt
        val methodPrimitiveReturnParaCollType = RepositoryFactory.eINSTANCE.createParameter
        methodPrimitiveReturnParaCollType.parameterName = "paraCollType"
        methodPrimitiveReturnParaCollType.dataType__Parameter = collTypeCollTypeCollTypeCompTypeEmpty
        methodPrimitiveReturn.parameters__OperationSignature.add(methodPrimitiveReturnParaCollType)
        val methodPrimitiveReturnParaCompType = RepositoryFactory.eINSTANCE.createParameter
        methodPrimitiveReturnParaCompType.parameterName = "paraCompType"
        methodPrimitiveReturnParaCompType.dataType__Parameter = compTypeFull
        methodPrimitiveReturn.parameters__OperationSignature.add(methodPrimitiveReturnParaCompType)
        operationSignatures.add(methodPrimitiveReturn)
        val methodCollTypeReturn = RepositoryFactory.eINSTANCE.createOperationSignature
        methodCollTypeReturn.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "CollTypeReturn"
        methodCollTypeReturn.returnType__OperationSignature = collTypeCollTypeCollTypeCompTypeEmpty
        val methodCollTypeReturnParaInt = RepositoryFactory.eINSTANCE.createParameter
        methodCollTypeReturnParaInt.parameterName = "paraInt"
        methodCollTypeReturnParaInt.dataType__Parameter = primitiveTypeInt
        methodCollTypeReturn.parameters__OperationSignature.add(methodCollTypeReturnParaInt)
        operationSignatures.add(methodCollTypeReturn)
        val methodCompTypeReturn = RepositoryFactory.eINSTANCE.createOperationSignature
        methodCompTypeReturn.entityName = OPERATION_SIGNATURE_NAME_PREFIX + "compTypeReturn"
        methodCompTypeReturn.returnType__OperationSignature = compTypeFull
        operationSignatures.add(methodCompTypeReturn)
        return new OperationInterfaceData(OPERATION_INTERFACE_NAME_PREFIX + OPERATION_INTERFACE_NAME_SUFFIX.get(7), operationSignatures, parentInterfaces)
    }
    
    def static BasicComponentData buildBasicComponentEmptyData() {
        return new BasicComponentData(BASIC_COMPONENT_NAME_PREFIX + BASIC_COMPONENT_NAME_SUFFIX.get(0))
    }
    
    def static BasicComponentData buildBasicComponentSingleProvRoleData(OperationInterface opInterfacePrimitiveTypes) {
        val provRoles = new ArrayList<OperationInterface>
        provRoles.add(opInterfacePrimitiveTypes)
        return new BasicComponentData(provRoles, BASIC_COMPONENT_NAME_PREFIX + BASIC_COMPONENT_NAME_SUFFIX.get(1))
    }
    
    def static BasicComponentData buildBasicComponentMultProvRoleData(OperationInterface opInterfaceComplexTypes,
                                                                      OperationInterface opInterfacePrimitiveTypes,
                                                                      OperationInterface opInterfaceEmpty) {
        val provRoles = new ArrayList<OperationInterface>
        provRoles.add(opInterfaceComplexTypes)
        provRoles.add(opInterfacePrimitiveTypes)
        provRoles.add(opInterfaceEmpty)
        return new BasicComponentData(provRoles, BASIC_COMPONENT_NAME_PREFIX + BASIC_COMPONENT_NAME_SUFFIX.get(2))
    }
    
    def static BasicComponentData buildBasicComponentSingleReqRoleData(OperationInterface opInterfaceEmpty) {
        val reqRoles = new ArrayList<OperationInterface>
        reqRoles.add(opInterfaceEmpty)
        return new BasicComponentData(BASIC_COMPONENT_NAME_PREFIX + BASIC_COMPONENT_NAME_SUFFIX.get(3), reqRoles)
    }
    
    def static BasicComponentData buildBasicComponentMultReqRoleData(OperationInterface opInterfacePrimitiveTypes,
                                                                     OperationInterface opInterfaceInheritanceOne,
                                                                     OperationInterface opInterfaceFull) {
        val reqRoles = new ArrayList<OperationInterface>
        reqRoles.add(opInterfacePrimitiveTypes)
        reqRoles.add(opInterfaceInheritanceOne)
        reqRoles.add(opInterfaceFull)
        return new BasicComponentData(BASIC_COMPONENT_NAME_PREFIX + BASIC_COMPONENT_NAME_SUFFIX.get(4), reqRoles)
    }
    
    def static BasicComponentData buildBasicComponentFullData(OperationInterface opInterfaceInheritanceMult,
                                                              OperationInterface opInterfaceEmpty,
                                                              OperationInterface opInterfaceInheritanceOne) {
        val reqRoles = new ArrayList<OperationInterface>
        reqRoles.add(opInterfaceInheritanceOne)
        reqRoles.add(opInterfaceEmpty)
        val provRoles = new ArrayList<OperationInterface>
        provRoles.add(opInterfaceInheritanceMult)
        return new BasicComponentData(BASIC_COMPONENT_NAME_PREFIX + BASIC_COMPONENT_NAME_SUFFIX.get(5), reqRoles, provRoles)
    }
    
    def static BasicComponentData buildBasicComponentDiamondData(OperationInterface opInterfaceDiamond, OperationInterface opInterfaceEmpty) {
        val provRoles = new ArrayList<OperationInterface>
        provRoles.add(opInterfaceDiamond)
        provRoles.add(opInterfaceEmpty)
        return new BasicComponentData(provRoles, BASIC_COMPONENT_NAME_PREFIX + BASIC_COMPONENT_NAME_SUFFIX.get(6))
    }
    
    private def static List<Pair<String, DataType>> buildInnerDeclarationPairs(Collection<?> types) {
        val pairs = new ArrayList<Pair<String, DataType>>
        for (type : types.filter(DataType)) {
            switch (type) {
                PrimitiveDataType: pairs.add(buildInnerDeclarationPair(type as PrimitiveDataType))
                CollectionDataType: pairs.add(buildInnerDeclarationPair(type as CollectionDataType))
                CompositeDataType: pairs.add(buildInnerDeclarationPair(type as CompositeDataType))
            }
        }
        return pairs
    }
    
    private def static dispatch Pair<String, DataType> buildInnerDeclarationPair(PrimitiveDataType type) {
        var name = ""
        switch (type.getType) {
            case BOOL: name = PRIMITIVE_INNER_DECLARATONS_NAMES.get(0)
            case BYTE: name = PRIMITIVE_INNER_DECLARATONS_NAMES.get(1)
            case CHAR: name = PRIMITIVE_INNER_DECLARATONS_NAMES.get(2)
            case INT: name = PRIMITIVE_INNER_DECLARATONS_NAMES.get(3)
            case LONG: name = PRIMITIVE_INNER_DECLARATONS_NAMES.get(4)
            case DOUBLE: name = PRIMITIVE_INNER_DECLARATONS_NAMES.get(5)
            case STRING: name = PRIMITIVE_INNER_DECLARATONS_NAMES.get(6)
        }
        return new Pair(name, type)
    }
        
    private def static dispatch Pair<String, DataType> buildInnerDeclarationPair(CollectionDataType type) {     
            new Pair(type.entityName.toFirstLower, type)
    }
    
    private def static dispatch Pair<String, DataType> buildInnerDeclarationPair(CompositeDataType type) {      
        return new Pair(type.entityName.toFirstLower, type)
    }

}