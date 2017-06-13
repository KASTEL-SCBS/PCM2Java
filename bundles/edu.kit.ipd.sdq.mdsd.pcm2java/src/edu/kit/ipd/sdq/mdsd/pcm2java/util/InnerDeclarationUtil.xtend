package edu.kit.ipd.sdq.mdsd.pcm2java.util

import org.palladiosimulator.pcm.repository.InnerDeclaration

import static extension edu.kit.ipd.sdq.mdsd.pcm2java.util.DataTypeUtil.*

/**
 * A utility class providing extension methods for InnerDeclarations
 */
class InnerDeclarationUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}	
	/**
	 * Returns the type of the DataType that is contained in the given InnerDeclaration as String.
	 */ 
	static def String getInnerDeclarationClassName(InnerDeclaration declaration){
		declaration.datatype_InnerDeclaration.classNameOfDataType
	}
	
}