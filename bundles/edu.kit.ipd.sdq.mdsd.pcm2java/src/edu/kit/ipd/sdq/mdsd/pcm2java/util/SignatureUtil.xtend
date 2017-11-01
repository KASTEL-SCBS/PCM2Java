package edu.kit.ipd.sdq.mdsd.pcm2java.util

import org.palladiosimulator.pcm.repository.Signature

/**
 * A utility class providing extension methods for Signatures
 */
class SignatureUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	/**
	 * Returns the name of the given operation signature, starting with a lower-case letter.
	 * That name will be used for a generated Java method that represents the operation signature.
	 * 
	 * @param operationSignature a PCM operation signature
	 * @return the generated method name
	 */
	static def String getMethodName(Signature operationSignature) {
		return operationSignature.entityName.toFirstLower
	}
		
}
