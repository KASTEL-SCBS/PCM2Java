package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import edu.kit.ipd.sdq.mdsd.ecore2txt.generator.AbstractEcore2TxtGenerator
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
import static edu.kit.ipd.sdq.mdsd.pcm2java.util.PCM2JavaTargetNameUtil.*

class PCM2JavaGenerator extends AbstractEcore2TxtGenerator {
		
	protected var PCM2JavaGeneratorDataTypes generatorDataTypes
	protected var PCM2JavaGeneratorClassifier generatorClassifier
		
	new() {
		generatorDataTypes = new PCM2JavaGeneratorDataTypes
		generatorClassifier = new PCM2JavaGeneratorClassifier
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
			if (content !== null && !content.equals("")) {
				val folderName = getTargetName(element, false)
				val fileName = getTargetFileName(element) + getTargetFileExt()
				val contentAndFileName = new Triplet<String,String,String>(content,folderName,fileName) 
				contentsForFolderAndFileNames.add(contentAndFileName)
			}
		}
	}
	
	protected def String generateContent(EObject element) {
		switch element {
			CompositeDataType: postProcessGeneratedContents(generatorDataTypes.generateContent(element))
			OperationInterface,
			BasicComponent: postProcessGeneratedContents(generatorClassifier.generateContent(element))
			EObject: return "" //		"Cannot generate content for generic EObject '" + object + "'!"
		}
	}
}