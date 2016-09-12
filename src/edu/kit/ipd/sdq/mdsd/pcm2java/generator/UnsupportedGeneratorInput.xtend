package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import java.lang.UnsupportedOperationException
import org.eclipse.emf.ecore.EObject

class UnsupportedGeneratorInput extends UnsupportedOperationException {
	
	new(String generationTask, EObject generatorInput) {
		super("Cannot " + generationTask + " for generic EObject '" + generatorInput + "'!")
	}
	
}