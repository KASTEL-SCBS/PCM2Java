package edu.kit.kastel.scbs.pcm2java.tests.data

import java.util.ArrayList
import java.util.Collection
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import org.palladiosimulator.pcm.repository.BasicComponent

class MinimalPCM2JavaExampleData {
    
    private PrimitiveDataType primBool
    private PrimitiveDataType primByte
    private PrimitiveDataType primChar
    private PrimitiveDataType primInt
    private PrimitiveDataType primLong
    private PrimitiveDataType primDouble
    private PrimitiveDataType primString
    private CompositeDataType compTypeEmpty
    private CompositeDataType compTypeAllPrimitives
    private CompositeDataType compTypeCompTypes
    private CompositeDataType compTypeCollTypesPrimitive
    private CompositeDataType compTypeCollTypesComplex
    private CompositeDataType compTypeInheritance
    private CompositeDataType compTypeFull
    private CollectionDataType collTypeEmpty
    private CollectionDataType collTypeBool
    private CollectionDataType collTypeByte
    private CollectionDataType collTypeChar
    private CollectionDataType collTypeInt
    private CollectionDataType collTypeLong
    private CollectionDataType collTypeDouble
    private CollectionDataType collTypeString
    private CollectionDataType collTypeCompTypeEmpty
    private CollectionDataType collTypeCollTypeEmpty
    private CollectionDataType collTypeCollTypeCompTypeEmpty
    private CollectionDataType collTypeCollTypeCollTypeCompTypeEmpty
    private OperationInterface opInterfaceEmpty
    private OperationInterface opInterfacePrimitiveTypes
    private OperationInterface opInterfaceComplexTypes
    private OperationInterface opInterfaceInheritanceOne
    private OperationInterface opInterfaceInheritanceTwo
    private OperationInterface opInterfaceDiamond
    private OperationInterface opInterfaceInheritanceMult
    private OperationInterface opInterfaceFull
    private BasicComponent basicComponentEmpty
    private BasicComponent basicComponentSingleProvRole
    private BasicComponent basicComponentMultProvRole
    private BasicComponent basicComponentSingleReqRole
    private BasicComponent basicComponentMultReqRole
    private BasicComponent basicComponentFull
    private BasicComponent basicComponentDiamond
    
    new() {
    }
    
    def void addPrimitiveDataType(PrimitiveDataType primType) {
        switch(primType?.type) {
            case BOOL: primBool = primType
            case BYTE: primByte = primType
            case CHAR: primChar = primType
            case DOUBLE: primDouble = primType 
            case INT: primInt = primType
            case LONG: primLong = primType
            case STRING: primString = primType
        }
    }
    
    def Collection<PrimitiveDataType> getPrimitiveDataTypes() {
        val primitiveTypes = new ArrayList<PrimitiveDataType>
        primitiveTypes.add(primBool)
        primitiveTypes.add(primByte)
        primitiveTypes.add(primChar)
        primitiveTypes.add(primInt)
        primitiveTypes.add(primLong)
        primitiveTypes.add(primDouble)
        primitiveTypes.add(primString)
        return primitiveTypes
    }
    
    def void addCollectionDataType(CollectionDataType collType) {
        val innerType = collType.innerType_CollectionDataType
        if (innerType === null) {
            collTypeEmpty = collType
        } else {
            switch (innerType) {
                PrimitiveDataType: {
                    switch ((innerType as PrimitiveDataType).type) {
                        case BOOL: collTypeBool = collType
                        case BYTE: collTypeByte = collType
                        case CHAR: collTypeChar = collType
                        case DOUBLE: collTypeDouble = collType
                        case INT: collTypeInt = collType
                        case LONG: collTypeLong = collType
                        case STRING: collTypeString = collType
                    }
                }
                CollectionDataType: {
                    val innerTypeInnerType = (innerType as CollectionDataType).innerType_CollectionDataType
                    if (innerTypeInnerType === null) {
                        collTypeCollTypeEmpty = collType
                    } else {
                        switch ((innerType as CollectionDataType).innerType_CollectionDataType) {
                            CollectionDataType: collTypeCollTypeCollTypeCompTypeEmpty = collType
                            CompositeDataType: collTypeCollTypeCompTypeEmpty = collType
                        }
                    }
                }
                CompositeDataType: collTypeCompTypeEmpty = collType
            }
        }
    }
        
    def Collection<CollectionDataType> getPrimitiveCollectionDataTypes() {
        val primitiveCollTypes = new ArrayList<CollectionDataType>
        primitiveCollTypes.add(collTypeEmpty)
        primitiveCollTypes.add(collTypeBool)
        primitiveCollTypes.add(collTypeByte)
        primitiveCollTypes.add(collTypeChar)
        primitiveCollTypes.add(collTypeInt)
        primitiveCollTypes.add(collTypeLong)
        primitiveCollTypes.add(collTypeDouble)
        primitiveCollTypes.add(collTypeString)
        return primitiveCollTypes
    }
    
    def Collection<CollectionDataType> getComplexCollectionDataTypes() {
        val complexCollTypes = new ArrayList<CollectionDataType>
        complexCollTypes.add(collTypeCollTypeEmpty)
        complexCollTypes.add(collTypeCompTypeEmpty)
        complexCollTypes.add(collTypeCollTypeCompTypeEmpty)
        complexCollTypes.add(collTypeCollTypeCollTypeCompTypeEmpty)
        return complexCollTypes
    }
    
    def void addCompositeDataType(CompositeDataType compType) {
        val amountInnerDeclarations = compType.innerDeclaration_CompositeDataType.length
        switch (amountInnerDeclarations) {
            case 0: if (compType.parentType_CompositeDataType.length == 0) compTypeEmpty = compType
                    else compTypeInheritance = compType
            case 3: compTypeCompTypes = compType
            case 4: compTypeCollTypesComplex = compType
            case 5: compTypeFull = compType
            case 7: compTypeAllPrimitives = compType
            case 8: compTypeCollTypesPrimitive = compType
        }
    }
    
    def void addInterface(OperationInterface iface) {
        val amountOperationSignatures = iface.signatures__OperationInterface.length
        switch (amountOperationSignatures) {
            case 0: opInterfaceEmpty = iface
            case 1: if (iface.signatures__OperationInterface.get(0).parameters__OperationSignature.isEmpty) opInterfaceDiamond = iface
                    else opInterfaceInheritanceMult = iface
            case 2: if (iface.signatures__OperationInterface.map[it.returnType__OperationSignature].filter(CompositeDataType).length == 2) opInterfaceInheritanceTwo = iface
                    else opInterfaceInheritanceOne = iface
            case 3: opInterfaceComplexTypes = iface
            case 4: opInterfaceFull = iface
            case 8: opInterfacePrimitiveTypes = iface
        }
    }
    
    def void addComponent(BasicComponent bc) {
        val amountReqRoles = bc.requiredRoles_InterfaceRequiringEntity.length
        val amountProvRoles = bc.providedRoles_InterfaceProvidingEntity.length
        switch (amountReqRoles) {
            case 0: switch (amountProvRoles) {
                        case 0: basicComponentEmpty = bc
                        case 1: basicComponentSingleProvRole = bc
                        case 2: basicComponentDiamond = bc
                        case 3: basicComponentMultProvRole = bc
                    }
            case 1: basicComponentSingleReqRole = bc
            case 2: basicComponentFull = bc
            case 3: basicComponentMultReqRole = bc
        }
    }
    
    def Collection<CompositeDataType> getPrimitiveCompositeDataTypes() {
        val primitiveCompTypes = new ArrayList<CompositeDataType>
        primitiveCompTypes.add(compTypeEmpty)
        primitiveCompTypes.add(compTypeAllPrimitives)
        primitiveCompTypes.add(compTypeCollTypesPrimitive)
        return primitiveCompTypes
    }
    
    def Collection<DataType> getCompTypeFullInnerDeclarationTypes() {
        val innerDeclarationTypes = new ArrayList<DataType>
        innerDeclarationTypes.add(primInt)
        innerDeclarationTypes.add(primString)
        innerDeclarationTypes.add(compTypeAllPrimitives)
        innerDeclarationTypes.add(collTypeEmpty)
        innerDeclarationTypes.add(collTypeCollTypeEmpty)
        return innerDeclarationTypes
    }
    
    def PrimitiveDataType getBool() {
        primBool
    }
    
    def PrimitiveDataType getByte() {
        primByte
    }
    
    def PrimitiveDataType getChar() {
        primChar
    }
    
    def PrimitiveDataType getInt() {
        primInt
    }
    
    def PrimitiveDataType getLong() {
        primLong
    }
    
    def PrimitiveDataType getDouble() {
        primDouble
    }
    
    def PrimitiveDataType getString() {
        primString
    }
    
    def CompositeDataType getCompTypeEmpty() {
        compTypeEmpty
    }
    
    def CompositeDataType getCompTypeAllPrimitives() {
        compTypeAllPrimitives
    }
    
    def CompositeDataType getCompTypeCompTypes() {
        compTypeCompTypes
    }
    
    def CompositeDataType getCompTypeCollTypesPrimitive() {
        compTypeCollTypesPrimitive
    }
    
    def CompositeDataType getCompTypeCollTypesComplex() {
        compTypeCollTypesComplex
    }
    
    def CompositeDataType getCompTypeInheritance() {
        compTypeInheritance
    }
    
    def CompositeDataType getCompTypeFull() {
        compTypeFull
    }
    
    def CollectionDataType getCollTypeEmtpy() {
        collTypeEmpty
    }
    
    def CollectionDataType getCollTypeBool() {
        collTypeBool
    }
    
    def CollectionDataType getCollTypeByte() {
        collTypeByte
    }
    
    def CollectionDataType getCollTypeChar() {
        collTypeChar
    }
    
    def CollectionDataType getCollTypeInt() {
        collTypeInt
    }
    
    def CollectionDataType getCollTypeLong() {
        collTypeLong
    }
    
    def CollectionDataType getCollTypeDouble() {
        collTypeDouble
    }
    
    def CollectionDataType getCollTypeString() {
        collTypeString
    }
    
    def CollectionDataType getCollTypeCompTypeEmpty() {
        collTypeCompTypeEmpty
    }
    
    def CollectionDataType getCollTypeCollTypeEmpty() {
        collTypeCollTypeEmpty
    }
    
    def CollectionDataType getCollTypeCollTypeCompTypeEmpty() {
        collTypeCollTypeCompTypeEmpty
    }
    
    def CollectionDataType getCollTypeCollTypeCollTypeCompTypeEmpty() {
        collTypeCollTypeCollTypeCompTypeEmpty
    }
    
    def OperationInterface getOpInterfaceEmpty() {
        opInterfaceEmpty
    }
    
    def OperationInterface getOpInterfacePrimitiveTypes() {
        opInterfacePrimitiveTypes
    }
    
    def OperationInterface getOpInterfaceComplexTypes() {
        opInterfaceComplexTypes
    }
    
    def OperationInterface getOpInterfaceInheritanceOne() {
        opInterfaceInheritanceOne
    }
    
    def OperationInterface getOpInterfaceInheritanceTwo() {
        opInterfaceInheritanceTwo
    }
    
    def OperationInterface getOpInterfaceDiamond() {
        opInterfaceDiamond
    }
    
    def OperationInterface getOpInterfaceInheritanceMult() {
        opInterfaceInheritanceMult
    }
    
    def OperationInterface getOpInterfaceFull() {
        opInterfaceFull
    }
    
    def BasicComponent getBasicComponentEmpty() {
        basicComponentEmpty
    }
    
    def BasicComponent getBasicComponentSingleProvRole() {
        basicComponentSingleProvRole
    }
    
    def BasicComponent getBasicComponentMultProvRole() {
        basicComponentMultProvRole
    }
    
    def BasicComponent getBasicComponentSingleReqRole() {
        basicComponentSingleReqRole
    }
    
    def BasicComponent getBasicComponentMultReqRole() {
        basicComponentMultReqRole
    }
    
    def BasicComponent getBasicComponentFull() {
        basicComponentFull
    }
    
    def BasicComponent getBasicComponentDiamond() {
        basicComponentDiamond
    }
    
    def void setBool(PrimitiveDataType primBool) {
        this.primBool = primBool
    }
    
    def void setByte(PrimitiveDataType primByte) {
        this.primByte = primByte
    }
    
    def void setChar(PrimitiveDataType primChar) {
        this.primChar = primChar
    }
    
    def void setInt(PrimitiveDataType primInt) {
        this.primInt = primInt
    }
    
    def void setLong(PrimitiveDataType primLong) {
        this.primLong = primLong
    }
    
    def void setDouble(PrimitiveDataType primDouble) {
        this.primDouble = primDouble
    }
    
    def void setString(PrimitiveDataType primString) {
        this.primString = primString
    }
    
    def void setCompTypeEmpty(CompositeDataType compTypeEmpty) {
        this.compTypeEmpty = compTypeEmpty
    }
    
    def void setCompTypeAllPrimitives(CompositeDataType compTypeAllPrimitives) {
        this.compTypeAllPrimitives = compTypeAllPrimitives
    }
    
    def void setCompTypeCompTypes(CompositeDataType compTypeCompTypes) {
        this.compTypeCompTypes = compTypeCompTypes
    }
    
    def void setCompTypeCollTypesPrimitive(CompositeDataType compTypeCollTypesPrimitive) {
        this.compTypeCollTypesPrimitive = compTypeCollTypesPrimitive
    }
    
    def void setCompTypeCollTypesComplex(CompositeDataType compTypeCollTypesComplex) {
        this.compTypeCollTypesComplex = compTypeCollTypesComplex
    }
    
    def void setCompTypeInheritance(CompositeDataType compTypeInheritance) {
        this.compTypeInheritance = compTypeInheritance
    }
    
    def void setCompTypeFull(CompositeDataType compTypeFull) {
        this.compTypeFull = compTypeFull
    }
    
    def void setCollTypeEmtpy(CollectionDataType collTypeEmpty) {
        this.collTypeEmpty = collTypeEmpty
    }
    
    def void setCollTypeBool(CollectionDataType collTypeBool) {
        this.collTypeBool = collTypeBool
    }
    
    def void setCollTypeByte(CollectionDataType collTypeByte) {
        this.collTypeByte = collTypeByte
    }
    
    def void setCollTypeChar(CollectionDataType collTypeChar) {
        this.collTypeChar = collTypeChar
    }
    
    def void setCollTypeInt(CollectionDataType collTypeInt) {
        this.collTypeInt = collTypeInt
    }
    
    def void setCollTypeLong(CollectionDataType collTypeLong) {
        this.collTypeLong = collTypeLong
    }
    
    def void setCollTypeDouble(CollectionDataType collTypeDouble) {
        this.collTypeDouble = collTypeDouble
    }
    
    def void setCollTypeString(CollectionDataType collTypeString) {
        this.collTypeString = collTypeString
    }
    
    def void setCollTypeCompTypeEmpty(CollectionDataType collTypeCompTypeEmpty) {
        this.collTypeCompTypeEmpty = collTypeCompTypeEmpty
    }
    
    def void setCollTypeCollTypeEmpty(CollectionDataType collTypeCollTypeEmpty) {
        this.collTypeCollTypeEmpty = collTypeCollTypeEmpty
    }
    
    def void setCollTypeCollTypeCompTypeEmpty(CollectionDataType collTypeCollTypeCompTypeEmpty) {
        this.collTypeCollTypeCompTypeEmpty = collTypeCollTypeCompTypeEmpty
    }
    
    def void setCollTypeCollTypeCollTypeEmpty(CollectionDataType collTypeCollTypeCollTypeCompTypeEmpty) {
        this.collTypeCollTypeCollTypeCompTypeEmpty = collTypeCollTypeCollTypeCompTypeEmpty
    }
    
    def void setOpInterfaceEmpty(OperationInterface opInterfaceEmpty) {
        this.opInterfaceEmpty = opInterfaceEmpty
    }
    
    def void setOpInterfacePrimitiveTypes(OperationInterface opInterfacePrimitiveTypes) {
        this.opInterfacePrimitiveTypes = opInterfacePrimitiveTypes
    }
    
    def void setOpInterfaceComplexTypes(OperationInterface opInterfaceComplexTypes) {
        this.opInterfaceComplexTypes = opInterfaceComplexTypes
    }
    
    def void setOpInterfaceInheritanceOne(OperationInterface opInterfaceInheritanceOne) {
        this.opInterfaceInheritanceOne = opInterfaceInheritanceOne
    }
    
    def void setOpInterfaceInheritanceTwo(OperationInterface opInterfaceInheritanceTwo) {
        this.opInterfaceInheritanceTwo = opInterfaceInheritanceTwo
    }
    
    def void setOpInterfaceDiamond(OperationInterface opInterfaceDiamond) {
        this.opInterfaceDiamond = opInterfaceDiamond
    }
    
    def void setOpInterfaceInheritanceMult(OperationInterface opInterfaceInheritanceMult) {
        this.opInterfaceInheritanceMult = opInterfaceInheritanceMult
    }
    
    def void setOpInterfaceFull(OperationInterface opInterfaceFull) {
        this.opInterfaceFull = opInterfaceFull
    }
    
    def void setBasicComponentEmpty(BasicComponent basicComponentEmpty) {
        this.basicComponentEmpty = basicComponentEmpty
    }
    
    def void setBasicComponentSingleProvRole(BasicComponent basicComponentSingleProvRole) {
        this.basicComponentSingleProvRole = basicComponentSingleProvRole
    }

    def void setBasicComponentMultProvRole(BasicComponent basicComponentMultProvRole) {
        this.basicComponentMultProvRole = basicComponentMultProvRole
    }
    
    def void setBasicComponentSingleReqRole(BasicComponent basicComponentSingleReqRole) {
        this.basicComponentSingleReqRole = basicComponentSingleReqRole    
    }
    
    def void setBasicComponentMultReqRole(BasicComponent basicComponentMultReqRole) {
        this.basicComponentMultReqRole = basicComponentMultReqRole
    }
    
    def void setBasicComponentFull(BasicComponent basicComponentFull) {
        this.basicComponentFull = basicComponentFull
    }
    
    def void setBasicComponentDiamond(BasicComponent basicComponentDiamond) {
        this.basicComponentDiamond = basicComponentDiamond
    }
    
}