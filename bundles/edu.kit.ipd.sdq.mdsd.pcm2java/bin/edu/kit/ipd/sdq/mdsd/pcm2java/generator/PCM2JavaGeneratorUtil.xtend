package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import java.util.ArrayList
import java.util.HashSet
import org.palladiosimulator.pcm.core.entity.NamedElement
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.InnerDeclaration
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.PrimitiveDataType

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaTargetNameUtil.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCMUtil.*

class PCM2JavaGeneratorUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	static def Iterable<DataType> getInnerTypes(Iterable<CollectionDataType> types) {
		val innerTypes = new ArrayList<DataType>
		for (type : types) {
			innerTypes.add(type.innerType)
		}
		return innerTypes
	}
	
	static def DataType getInnerType(CollectionDataType type) {
		val innerType = type.innerType_CollectionDataType
		switch (innerType) {
			CollectionDataType : return innerType.innerType
			CompositeDataType,
			PrimitiveDataType : return innerType
			default : return null
		}
	}
	
	/**
	 * Returns the type of the DataType that is contained in the given InnerDeclaration as String.
	 * If replaceStringsWithCharArrays is true and the contained DataType is a String type, "char[]" is returned instead.
	 */
	static def String getInnerDeclarationClassName(InnerDeclaration declaration, boolean replaceStringsWithCharArrays){
		val result = getClassNameOfDataType(declaration.datatype_InnerDeclaration)
		if (replaceStringsWithCharArrays && result.equals("String")) return "char[]"
		return result
	}
	
	/**
	 * Returns the type of the DataType that is contained in the given InnerDeclaration as String.
	 */ 
	static def String getInnerDeclarationClassName(InnerDeclaration declaration){
		getClassNameOfDataType(declaration.datatype_InnerDeclaration)
	}
	
	/** 
	 * Returns the name of the reference class of the primitive type the given data type contains.
	 * */
	static dispatch def String getClassNameOfDataType(PrimitiveDataType dataType) {
		return getTargetFileName(dataType)
	}
	
	/**
	 * Returns "Iterable<name of class of inner type>".
	 * If the inner type is null "Iterable<Object>" is returned.
	 */
	static dispatch def String getClassNameOfDataType(CollectionDataType dataType) {
		val innerType = dataType.innerType_CollectionDataType
		switch innerType {
			case CollectionDataType: return "Iterable<" + (innerType as NamedElement).entityName + ">"
			case null: return "Iterable<Object>"
			default: return "Iterable<" + innerType.getClassNameOfDataType.primitiveToReferenceName + ">"
		}
	}
	
	/**
	 * Returns the entity name of the given composite data type.
	 */
	static dispatch def String getClassNameOfDataType(CompositeDataType dataType) {
		return dataType.entityName
	}

	//TODO Move to PCM Helper class?
	static def String primitiveToReferenceName(String type) {
		switch type {
			case "int": return "Integer"
			case "byte": return "Byte"
			case "short": return "Short"
			case "long": return "Long"
			case "float": return "Float"
			case "double": return "Double"
			case "char": return "Character"
			case "boolean": return "Boolean"
			default: return type
		}
	}
	
	/**
	 * Returns a list of all inner declarations of the given data type that are not primitive.
	 * That includes inner declarations with type String as it is a reference type.
	 */
	static def Iterable<InnerDeclaration> getNonPrimitiveDeclarations(CompositeDataType dataType) {
		val nonPrimitiveFields = new ArrayList<InnerDeclaration>
		for (declaration : dataType.innerDeclaration_CompositeDataType) {
			switch (declaration.datatype_InnerDeclaration) {
				CollectionDataType, 
				CompositeDataType: nonPrimitiveFields.add(declaration) 
				PrimitiveDataType: if (declaration.datatype_InnerDeclaration.classNameOfDataType.equals("String")) {
								   	   nonPrimitiveFields.add(declaration)
								   }
			}
		}
		return nonPrimitiveFields
	}
	
	static def Iterable<OperationInterface> getAllInheritedOperationInterfaces(OperationInterface iface) {
		val inheritedIfaces = new HashSet<OperationInterface>
		inheritedIfaces.addAll(iface.directInheritedOperationInterfaces)
		inheritedIfaces.addAll(iface.indirectInheritedOperationInterfaces)
		return inheritedIfaces
	}

	static def Iterable<OperationInterface> getDirectInheritedOperationInterfaces(OperationInterface iface) {
		return iface.parentInterfaces__Interface.toSet.filter(OperationInterface)
	}
	
	static def Iterable<OperationInterface> getIndirectInheritedOperationInterfaces(OperationInterface iface) {	
		return iface.parentInterfaces__Interface.map[it.parentInterfaces__Interface].filter(OperationInterface)
	}

	static def Iterable<OperationInterface> getAllInheritedOperationInterfaces(BasicComponent bc) {
		val inheritedIfaces = new HashSet<OperationInterface>
		inheritedIfaces.addAll(bc.directInheritedOperationInterfaces)
		inheritedIfaces.addAll(bc.indirectInheritedOperationInterfaces)
		return inheritedIfaces
	}
	
	static def Iterable<OperationInterface> getDirectInheritedOperationInterfaces(BasicComponent bc) {
		return getProvidedInterfaces(bc).map[it.parentInterfaces__Interface].flatten.filter(OperationInterface)
	}
	
	static def Iterable<OperationInterface> getIndirectInheritedOperationInterfaces(BasicComponent bc) {
		return getProvidedInterfaces(bc).map[it.parentInterfaces__Interface].flatten.filter(OperationInterface).map[it.allInheritedOperationInterfaces].flatten
	}
	
}