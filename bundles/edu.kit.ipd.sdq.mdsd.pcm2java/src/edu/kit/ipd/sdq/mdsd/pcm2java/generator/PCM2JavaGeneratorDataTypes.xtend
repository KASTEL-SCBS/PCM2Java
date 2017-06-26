package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.InnerDeclaration
import org.palladiosimulator.pcm.repository.PrimitiveDataType

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*

import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity.CompositeDataTypeUtil.*
import static extension edu.kit.ipd.sdq.mdsd.pcm2java.util.DataTypeUtil.*
import static extension edu.kit.ipd.sdq.mdsd.pcm2java.util.InnerDeclarationUtil.*

class PCM2JavaGeneratorDataTypes {
	
	private CompositeDataType dataType
	private val generatorHeadAndImports = new PCM2JavaGeneratorHeadAndImports
	
	def String generateContent(CompositeDataType dataType) {
		this.dataType = dataType
		val importsAndClassifierHead = generatorHeadAndImports.generateImportsAndClassHead(this.dataType)
		val extendsRelations = generateExtendsRelation()
		val fields = generateFields()
		val constructor = generateConstructor()
		val methods = generateMethods()
		this.dataType = null
		return importsAndClassifierHead + extendsRelations + '''{
	«fields»
	
	«constructor»
	
	«methods»
}'''
	}
		
	private def generateExtendsRelation() '''«
	FOR parent : dataType.parentType_CompositeDataType
		BEFORE 'extends '
		»«parent.entityName» «
	ENDFOR»'''	
		
	private def generateFields() {
	val modifier = generateFieldVisibilityModifier
	'''« 
	FOR declaration : dataType.innerDeclaration_CompositeDataType
		BEFORE newLine
		SEPARATOR newLine
		»«modifier» «declaration.getInnerDeclarationClassName» «declaration.entityName»;«
	ENDFOR»''' 
	}
	
	protected def generateFieldVisibilityModifier() '''private'''
	
	private def String generateConstructor() {
		if (dataType.innerDeclaration_CompositeDataType.size > 0) {
			return generateStandardConstructor().toString + newLine + generateArgumentConstructor().toString
		} else {
			return generateStandardConstructor().toString	
		}
	}
	
	private def generateStandardConstructor() '''
	public «dataType.entityName»() {
		// TODO: Implement and verify auto-generated constructor.
		«FOR declaration : dataType.getNonPrimitiveDeclarations
			»this.«declaration.entityName» = «generateConstructorCall(declaration.datatype_InnerDeclaration)»«
		ENDFOR»
	}
	'''
	private def generateArgumentConstructor()'''
	public «dataType.entityName»(«
		FOR declaration : dataType.innerDeclaration_CompositeDataType
			SEPARATOR ", "
			»«declaration.getInnerDeclarationClassName.toFirstUpper» «declaration.entityName»«
		ENDFOR»«
	») {
		// TODO: Implement and verify auto-generated constructor.
		«FOR declaration : dataType.innerDeclaration_CompositeDataType
			SEPARATOR newLine
			»this.«declaration.entityName» = «declaration.entityName»;«
		ENDFOR»
	}
	'''
	
	private def generateMethods() {
	if (generateFieldVisibilityModifier.equals("public")) return ""
	'''«FOR declaration : dataType.innerDeclaration_CompositeDataType
			SEPARATOR newLine
			AFTER newLine
		»«generateGetterSetter(declaration)
		»«ENDFOR»'''
	}
	
	private def generateGetterSetter(InnerDeclaration declaration) '''«
	»public «declaration.getInnerDeclarationClassName» get«declaration.entityName.toFirstUpper»() {
«   »    return «declaration.entityName»;
«   »}

«
	»public void set«declaration.entityName.toFirstUpper»(«declaration.getInnerDeclarationClassName» «declaration.entityName») {
«   »    this.«declaration.entityName» = «declaration.entityName»;
«   »}
'''
		
	private dispatch def String generateConstructorCall(CompositeDataType dataType) {
		return '''new «dataType.getClassNameOfDataType»();«newLine»'''
	}
	
	private dispatch def String generateConstructorCall(CollectionDataType dataType) {
		val innerType = dataType.innerType_CollectionDataType
		if (innerType !== null) {
			return '''new ArrayList<«dataType.innerType_CollectionDataType.getClassNameOfDataType.primitiveToReferenceName»>();«newLine»'''
		} else {
			return '''new ArrayList<Object>();«newLine»'''
		}
	}
	
	private dispatch def String generateConstructorCall(PrimitiveDataType dataType) throws UnsupportedOperationException {
		switch (dataType.type) {
			case STRING : '''"";''' +  newLine
			default: throw new UnsupportedOperationException("Can only generate constructor calls for primitive type String: " + dataType.type)
		}
	}
		
	private dispatch def String generateConstructorCall(DataType dataType) throws UnsupportedOperationException {
		throw new UnsupportedOperationException("Can only generate constructor calls for String, collection- or composite data types " + dataType.class.toString)
	}
		
}