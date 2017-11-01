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

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.util.PCM2JavaTargetNameUtil.*
import static extension edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.resource.ResourceUtil.*

/**
 * This class is used to generate Java source code from PCM Models.
 */
class PCM2JavaGenerator extends AbstractEcore2TxtGenerator {
		
	protected var PCM2JavaGeneratorDataTypes generatorDataTypes // Used to generate code for data types
	protected var PCM2JavaGeneratorClassifier generatorClassifier // Used to generate code for basic components and operation interfaces
		
	/**
	 * Creates new PCM2JavaGenerator
	 */
	new() {
		generatorDataTypes = new PCM2JavaGeneratorDataTypes
		generatorClassifier = new PCM2JavaGeneratorClassifier
	}	
		
	/**
	 * Unsupported operation
	 */
	override getFolderNameForResource(Resource inputResource) throws UnsupportedOperationException {
		throw new UnsupportedOperationException()
	}
	
	/**
	 * Unsupported operation
	 */
	override getFileNameForResource(Resource inputResource) throws UnsupportedOperationException {
		throw new UnsupportedOperationException()
	}
	
	/**
	 * No post processing necessary: does nothing.
	 * 
	 * @param contents contents to be processed
	 * @return the given contents 
	 */
	override postProcessGeneratedContents(String contents) {
		// no post processing: do nothing
		return contents
	}

	/**
	 * Generates Java code, folder names, and file names for a given PCM resource.
	 * Java classes or interfaces will be generated for all basic components, operation interfaces and composite data types within the given resource.
	 * The generated Java code must be verified and the auto-generated method stubs implemented.
	 * 
	 * @param inputResource a PCM resource
	 * @return an Iterable object of string triplets that contain, in order: code, folder name, file name of the generated files
	 */
	override generateContentsFromResource(Resource inputResource) {
		val contentsForFolderAndFileNames = new ArrayList<Triplet<String,String,String>>()
		generateAndAddContents(inputResource, contentsForFolderAndFileNames)
		return contentsForFolderAndFileNames
	}

	/**
	 * Generates Java code, folder names and file names for a given PCM resource and adds them to a given list of string triplets.
	 * 
	 * @param inputResource a PCM resource
	 * @param contentsForFolderAndFiLeNames an Iterable object of string triplets to which the generated string triplets are added
	 */
	private def void generateAndAddContents(Resource inputResource, List<Triplet<String,String,String>> contentsForFolderAndFileNames) {
		for (element : inputResource.getAllContentsIterable()) {
			val content = generateContent(element)
			if (content !== null && !content.equals("")) {
				val folderName = getTargetName(element, false)
				val fileName = getTargetFileName(element) + getTargetFileExt()
				val contentAndFileName = new Triplet<String,String,String>(content,folderName,fileName) 
				contentsForFolderAndFileNames.add(contentAndFileName)
			}
		}
		contentsForFolderAndFileNames.generateAndAddOptionalContents
	}
	
	/**
	 * Generates Java source code for a given EObject. 
	 * The EObject must be an operation interface, basic component or composite data type.
	 * 
	 * @param element the element for which code should be generated
	 * @return the generated code
	 */
	private def String generateContent(EObject element) {
		switch element {
			CompositeDataType: postProcessGeneratedContents(generatorDataTypes.generateContent(element))
			OperationInterface,
			BasicComponent: postProcessGeneratedContents(generatorClassifier.generateContent(element))
			EObject: generateContentUnexpectedEObject(element)
		}
	}
	
	protected def String generateContentUnexpectedEObject(EObject element) {
		 "" //		"Cannot generate content for generic EObject '" + object + "'!"
	}
	
	protected def void generateAndAddOptionalContents(List<Triplet<String,String,String>> contentsForFolderAndFileNames) {
		// No optional content needed for plain pcm2java
	}
}