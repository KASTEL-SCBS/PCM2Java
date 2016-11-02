package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.InnerDeclaration
import org.palladiosimulator.pcm.repository.PrimitiveDataType

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorHeadAndImports.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorUtil.*

final class PCM2JavaGeneratorDataTypes {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	static def String generateContent(CompositeDataType dataType) {
		val importsAndClassifierHead = generateImportsAndClassHead(dataType)
		val extendsRelations = generateExtendsRelation(dataType)
		val fields = generateFields(dataType)
		val constructor = generateConstructor(dataType)
		val methods = generateMethods(dataType)
		return importsAndClassifierHead + extendsRelations + '''{
	«fields»
	
	«constructor»
	
	«methods»
}'''
	}
		
	private static def generateExtendsRelation(CompositeDataType dataType) '''«
	FOR parent : dataType.parentType_CompositeDataType
		BEFORE 'extends '
		»«parent.entityName» «
	ENDFOR»'''	
		
	private static def generateFields(CompositeDataType dataType) '''«
	FOR declaration : dataType.innerDeclaration_CompositeDataType
		BEFORE newLine
		SEPARATOR newLine
		»private «getInnerDeclarationClassName(declaration)» «declaration.entityName»;«
	ENDFOR»''' 
	
	private static def generateConstructor(CompositeDataType dataType) '''
	public «dataType.entityName»() {
		// TODO: Implement and verify auto-generated constructor.
		«FOR declaration : getNonPrimitiveDeclarations(dataType)
			»this.«declaration.entityName» = «generateConstructorCall(declaration.datatype_InnerDeclaration)»«
		ENDFOR»
	}
	'''
	
	private static def generateMethods(CompositeDataType dataType) '''«
		FOR declaration : dataType.innerDeclaration_CompositeDataType
			SEPARATOR newLine
			AFTER newLine
		»«generateGetterSetter(declaration)
		»«ENDFOR
	»'''
	
	private static def generateGetterSetter(InnerDeclaration declaration) '''«
	»public «getInnerDeclarationClassName(declaration)» get«declaration.entityName.toFirstUpper»() {
«   »    return «declaration.entityName»;
«   »}

«
	»public void set«declaration.entityName.toFirstUpper»(«getInnerDeclarationClassName(declaration)» «declaration.entityName») {
«   »    this.«declaration.entityName» = «declaration.entityName»;
«   »}
'''
		
	private static dispatch def String generateConstructorCall(CompositeDataType dataType) {
		return '''new «getClassNameOfDataType(dataType)»();«newLine»'''
	}
	
	private static dispatch def String generateConstructorCall(CollectionDataType dataType) {
		val innerType = dataType.innerType_CollectionDataType
		if (innerType != null) {
			return '''new ArrayList<«primitiveToReferenceName(getClassNameOfDataType(dataType.innerType_CollectionDataType))»>();«newLine»'''
		} else {
			return '''new ArrayList<Object>();«newLine»'''
		}
	}
	
	private static dispatch def String generateConstructorCall(PrimitiveDataType dataType) throws UnsupportedOperationException {
		switch (dataType.type) {
			case STRING : '''"";'''
			default: throw new UnsupportedOperationException("Can only generate constructor calls for primitive type String: " + dataType.type)
		}
	}
		
	private static dispatch def String generateConstructorCall(DataType dataType) throws UnsupportedOperationException {
		throw new UnsupportedOperationException("Can only generate constructor calls for String, collection- or composite data types " + dataType.class.toString)
	}
		
}