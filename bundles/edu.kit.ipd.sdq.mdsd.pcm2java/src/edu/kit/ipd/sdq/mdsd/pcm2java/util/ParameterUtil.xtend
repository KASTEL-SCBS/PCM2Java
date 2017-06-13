package edu.kit.ipd.sdq.mdsd.pcm2java.util

import org.palladiosimulator.pcm.repository.Parameter

/**
 * A utility class providing extension methods for Parameters
 */
class ParameterUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	static def String getParameterName(Parameter parameter) {
		parameter.parameterName.toFirstLower
	}
	
}
