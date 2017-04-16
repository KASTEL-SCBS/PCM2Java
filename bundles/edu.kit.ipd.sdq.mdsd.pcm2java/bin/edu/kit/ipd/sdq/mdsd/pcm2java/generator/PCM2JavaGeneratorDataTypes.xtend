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
	
	private val boolean publicFields
	private val boolean replaceStringsWithCharArrays
	
	new(boolean publicFields, boolean replaceStringsWithCharArrays) {
		this.publicFields = publicFields
		this.replaceStringsWithCharArrays = replaceStringsWithCharArrays 
	}
		
	def String generateContent(CompositeDataType dataType) {
		val importsAndClassifierHead = generateImportsAndClassHead(dataType)
		val extendsRelations = generateExtendsRelation(dataType)
		val fields = generateFields(dataType)
		val constructor = generateConstructor(dataType)
		var methods = ""
		if (!publicFields) {
			methods = generateMethods(dataType).toString
		}
		return importsAndClassifierHead + extendsRelations + '''{
	«fields»
	
	«constructor»
	
	«methods»
}'''
	}
		
	private def generateExtendsRelation(CompositeDataType dataType) '''«
	FOR parent : dataType.parentType_CompositeDataType
		BEFORE 'extends '
		»«parent.entityName» «
	ENDFOR»'''	
		
	private def generateFields(CompositeDataType dataType) {
	val modifier = if (publicFields) "public" else "private"
	'''« 
	FOR declaration : dataType.innerDeclaration_CompositeDataType
		BEFORE newLine
		SEPARATOR newLine
		»«modifier» «getInnerDeclarationClassName(declaration, replaceStringsWithCharArrays)» «declaration.entityName»;«
	ENDFOR»''' 
	}
	
	private def String generateConstructor(CompositeDataType dataType) {
		if (dataType.innerDeclaration_CompositeDataType.size > 0) {
			return generateStandardConstructor(dataType).toString + newLine + generateArgumentConstructor(dataType).toString
		} else {
			return generateStandardConstructor(dataType).toString	
		}
	}
	
	private def generateStandardConstructor(CompositeDataType dataType) '''
	public «dataType.entityName»() {
		// TODO: Implement and verify auto-generated constructor.
		«FOR declaration : getNonPrimitiveDeclarations(dataType)
			»this.«declaration.entityName» = «generateConstructorCall(declaration.datatype_InnerDeclaration)»«
		ENDFOR»
	}
	'''
	private def generateArgumentConstructor(CompositeDataType dataType)'''
	public «dataType.entityName»(«
		FOR declaration : dataType.innerDeclaration_CompositeDataType
			SEPARATOR ", "
			»«getInnerDeclarationClassName(declaration, replaceStringsWithCharArrays).toFirstUpper» «declaration.entityName»«
		ENDFOR»«
	») {
		// TODO: Implement and verify auto-generated constructor.
		«FOR declaration : dataType.innerDeclaration_CompositeDataType
			SEPARATOR newLine
			»this.«declaration.entityName» = «declaration.entityName»;«
		ENDFOR»
	}
	'''
	
	private def generateMethods(CompositeDataType dataType) '''«
		FOR declaration : dataType.innerDeclaration_CompositeDataType
			SEPARATOR newLine
			AFTER newLine
		»«generateGetterSetter(declaration)
		»«ENDFOR
	»'''
	
	private def generateGetterSetter(InnerDeclaration declaration) '''«
	»public «getInnerDeclarationClassName(declaration, replaceStringsWithCharArrays)» get«declaration.entityName.toFirstUpper»() {
«   »    return «declaration.entityName»;
«   »}

«
	»public void set«declaration.entityName.toFirstUpper»(«getInnerDeclarationClassName(declaration, replaceStringsWithCharArrays)» «declaration.entityName») {
«   »    this.«declaration.entityName» = «declaration.entityName»;
«   »}
'''
		
	private dispatch def String generateConstructorCall(CompositeDataType dataType) {
		return '''new «getClassNameOfDataType(dataType)»();«newLine»'''
	}
	
	private dispatch def String generateConstructorCall(CollectionDataType dataType) {
		val innerType = dataType.innerType_CollectionDataType
		if (innerType != null) {
			return '''new ArrayList<«primitiveToReferenceName(getClassNameOfDataType(dataType.innerType_CollectionDataType))»>();«newLine»'''
		} else {
			return '''new ArrayList<Object>();«newLine»'''
		}
	}
	
	private dispatch def String generateConstructorCall(PrimitiveDataType dataType) throws UnsupportedOperationException {
		switch (dataType.type) {
			case STRING : if (replaceStringsWithCharArrays) '''new char[0];«newLine»'''
						  else '''"";«newLine»'''
			default: throw new UnsupportedOperationException("Can only generate constructor calls for primitive type String: " + dataType.type)
		}
	}
		
	private dispatch def String generateConstructorCall(DataType dataType) throws UnsupportedOperationException {
		throw new UnsupportedOperationException("Can only generate constructor calls for String, collection- or composite data types " + dataType.class.toString)
	}
		
}