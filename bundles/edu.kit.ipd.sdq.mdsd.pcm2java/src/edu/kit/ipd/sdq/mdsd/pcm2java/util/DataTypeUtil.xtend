package edu.kit.ipd.sdq.mdsd.pcm2java.util

import org.palladiosimulator.pcm.core.entity.NamedElement
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.PrimitiveDataType

import static edu.kit.ipd.sdq.mdsd.pcm2java.util.PCM2JavaTargetNameUtil.*

/**
 * A utility class providing utility extension methods for PCM data types.
 */
class DataTypeUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}	
	
	/** 
	 * Returns the name of the reference class of the given primitive data type.
	 * 
	 * @param dataType a PCM primitive data type
	 * @return the name of the reference Class of the given primitive data type
	 */
	static dispatch def String getClassNameOfDataType(PrimitiveDataType dataType) {
		return getTargetFileName(dataType)
	}
	
	/**
	 * Returns "Iterable<name of class of inner type>" for a given collection data type.
	 * If the inner type is null "Iterable<Object>" is returned.
	 * 
	 * @param dataType a PCM collection data type
	 * @returns class name as used in Java code for the given collection data type.
	 */
	static dispatch def String getClassNameOfDataType(CollectionDataType dataType) {
		val innerType = dataType.innerType_CollectionDataType
		switch innerType { // TODO: Iterables instead of arrays as possibility
			case CollectionDataType: return (innerType as NamedElement).entityName + "[]"
			case null: return "Object[]"
			default: return innerType.getClassNameOfDataType + "[]"
		}
	}
	
	/**
	 * Returns the entity name of the given composite data type.
	 * 
	 * @dataType a PCM composite data type
	 * @return entity name of given data type
	 */
	static dispatch def String getClassNameOfDataType(CompositeDataType dataType) {
		return dataType.entityName
	}
	
	/**
	 * Transforms a given primitive type name to the name of the corresponding reference class.
	 * If the given string is not the name of a primitive type, the string is returned.
	 * 
	 * @param type a string
	 * @return name of the reference class or the given string
	 */
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