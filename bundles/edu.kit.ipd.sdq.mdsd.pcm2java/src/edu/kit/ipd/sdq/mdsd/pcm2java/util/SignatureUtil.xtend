package edu.kit.ipd.sdq.mdsd.pcm2java.util

import org.palladiosimulator.pcm.repository.Signature

/**
 * A utility class providing extension methods for Signatures
 */
class SignatureUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	static def String getMethodName(Signature operationSignature) {
		return operationSignature.entityName.toFirstLower
	}
		
}
