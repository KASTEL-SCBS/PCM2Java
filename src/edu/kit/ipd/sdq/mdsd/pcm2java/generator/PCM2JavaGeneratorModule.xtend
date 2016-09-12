package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import edu.kit.ipd.sdq.commons.ecore2txt.generator.AbstractEcore2TxtGeneratorModule

class PCM2JavaGeneratorModule extends AbstractEcore2TxtGeneratorModule {
	
	override protected String getLanguageName() {
		return ""
	}

	override protected String getFileExtensions() {
		return "repository"
	}
}