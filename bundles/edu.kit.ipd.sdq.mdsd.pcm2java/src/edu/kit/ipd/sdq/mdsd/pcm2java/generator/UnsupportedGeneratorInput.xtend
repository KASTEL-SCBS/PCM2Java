package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import java.lang.UnsupportedOperationException
import org.eclipse.emf.ecore.EObject

/**
 * An Exception class that is used when a generator is confronted with unsupported input.
 * 
 * @author Moritz Behr
 * @version 0.1
 */
class UnsupportedGeneratorInput extends UnsupportedOperationException {
	
	/**
	 * Creates a new UnsupportedGeneratorInput that occured in the given context.
	 * 
	 * @param generationTask the generation task during which the unsupported input was received
	 * @param generatorInput the unsupported input
	 */
	new(String generationTask, EObject generatorInput) {
		super("Cannot " + generationTask + " for generic EObject '" + generatorInput + "'!")
	}
	
}