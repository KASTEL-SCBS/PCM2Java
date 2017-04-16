package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import edu.kit.ipd.sdq.mdsd.ecore2txt.generator.AbstractEcore2TxtGenerator
import edu.kit.ipd.sdq.mdsd.pcm2java.handler.DefaultUserConfiguration
import edu.kit.ipd.sdq.mdsd.pcm2java.handler.UserConfiguration
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.internal.xtend.util.Triplet
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.OperationInterface
import tools.vitruv.framework.util.bridges.EcoreBridge

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaTargetNameUtil.*

class PCM2JavaGenerator extends AbstractEcore2TxtGenerator {
	
	private val PCM2JavaGeneratorDataTypes generatorDataTypes
	private val PCM2JavaGeneratorClassifier generatorClassifier 
	private val UserConfiguration userConfig
	
	new() {
		this(new DefaultUserConfiguration)
	}
	
	new(UserConfiguration userConfiguration) {
		super()
		userConfig = userConfiguration
		generatorDataTypes = new PCM2JavaGeneratorDataTypes(userConfig.publicFields, userConfig.replaceStringsWithCharArrays)
		generatorClassifier = new PCM2JavaGeneratorClassifier(userConfig.replaceStringsWithCharArrays)
	}
				
	override getFolderNameForResource(Resource inputResource) throws UnsupportedOperationException {
		throw new UnsupportedOperationException()
	}
	
	override getFileNameForResource(Resource inputResource) throws UnsupportedOperationException {
		throw new UnsupportedOperationException()
	}
	
	override postProcessGeneratedContents(String contents) {
		// no postprocessing: do nothing
		return contents
	}

	override generateContentsFromResource(Resource inputResource) {
		val contentsForFolderAndFileNames = new ArrayList<Triplet<String,String,String>>()
		generateAndAddContents(inputResource, contentsForFolderAndFileNames)
		return contentsForFolderAndFileNames
	}
	
	private def void generateAndAddContents(Resource inputResource, List<Triplet<String,String,String>> contentsForFolderAndFileNames) {
		for (element : EcoreBridge.getAllContents(inputResource)) {
			val content = generateContent(element)
			if (content != null && !content.equals("")) {
				val folderName = getTargetName(element, false)
				val fileName = getTargetFileName(element) + getTargetFileExt()
				val contentAndFileName = new Triplet<String,String,String>(content,folderName,fileName) 
				contentsForFolderAndFileNames.add(contentAndFileName)
			}
		}
	}
	
	private def String generateContent(EObject element) {
		switch element {
			CompositeDataType: generatorDataTypes.generateContent(element)
			OperationInterface: generatorClassifier.generateContent(element)
			BasicComponent: generatorClassifier.generateContent(element)
			EObject: return "" //		 "Cannot generate content for generic EObject '" + object + "'!"
		}
	}
	
}