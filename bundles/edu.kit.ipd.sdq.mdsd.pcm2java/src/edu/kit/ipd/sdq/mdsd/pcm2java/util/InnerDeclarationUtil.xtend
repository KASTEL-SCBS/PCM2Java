package edu.kit.ipd.sdq.mdsd.pcm2java.util

import org.palladiosimulator.pcm.repository.InnerDeclaration

import static extension edu.kit.ipd.sdq.mdsd.pcm2java.util.DataTypeUtil.*

/**
 * A utility class providing extension methods for InnerDeclarations
 * 
 * @author Moritz Behr
 * @version 0.1
 */
class InnerDeclarationUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}	
	
	/**
	 * Returns the name of the class of the data type, as used in Java, that is contained in the given InnerDeclaration.
	 * 
	 * @param declaration a PCM inner declaration
	 * @return name of the class
	 */ 
	static def String getInnerDeclarationClassName(InnerDeclaration declaration){
		declaration.datatype_InnerDeclaration?.classNameOfDataType
	}
	
}