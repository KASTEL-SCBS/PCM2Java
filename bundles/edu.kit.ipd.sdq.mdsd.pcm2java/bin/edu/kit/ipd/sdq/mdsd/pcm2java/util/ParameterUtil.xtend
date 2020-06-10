package edu.kit.ipd.sdq.mdsd.pcm2java.util

import org.palladiosimulator.pcm.repository.Parameter

/**
 * A utility class providing utility extension methods for Parameters.
 * 
 * @author Moritz Behr
 * @version 0.1
 */
class ParameterUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	/**
	 * Returns the parameter name of the given parameter, starting with a lower case letter.
	 * 
	 * @param parameter a PCM parameter
	 * @return the parameter name
	 */
	static def String getParameterName(Parameter parameter) {
		parameter.parameterName.toFirstLower
	}
	
}
