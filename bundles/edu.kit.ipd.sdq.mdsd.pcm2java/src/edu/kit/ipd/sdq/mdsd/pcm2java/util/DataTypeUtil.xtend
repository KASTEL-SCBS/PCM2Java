package edu.kit.ipd.sdq.mdsd.pcm2java.util

import org.palladiosimulator.pcm.core.entity.NamedElement
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.PrimitiveDataType

import static edu.kit.ipd.sdq.mdsd.pcm2java.util.PCM2JavaTargetNameUtil.*

/**
 * A utility class providing extension methods for DataTypes
 */
class DataTypeUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
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
	
}