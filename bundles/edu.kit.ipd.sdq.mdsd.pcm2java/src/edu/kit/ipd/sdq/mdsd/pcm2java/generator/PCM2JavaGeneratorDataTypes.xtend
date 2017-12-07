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

/**
 * This class is used to generate Java source code for composite data types from PCM models.
 */
class PCM2JavaGeneratorDataTypes {
	
	private CompositeDataType dataType // the basic component for which code is currently being generated 
	private val generatorHeadAndImports = new PCM2JavaGeneratorHeadAndImports
	
	/**
	 * Generates Java source code for a given PCM composite data type.
	 * A Java class will be generated that represents the given data type.
	 * 
	 * @param dataType a PCM composite data type
	 * @return the generated Java code
	 */
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
	
	/**
	 * Generates a string describing the "extends" relations of the currently processed data type.
	 * The returned string starts with "extends " followed by the names of all data types the currently processed data type inherits from, separated by a comma.
	 * 
	 * @return the generated extends statement
	 */
	private def generateExtendsRelation() '''«
	FOR parent : dataType.parentType_CompositeDataType
		BEFORE 'extends '
		»«parent.entityName» «
	ENDFOR»'''	
		
	/**
	 * Generates field declarations for every inner declaration of the currently processed composite data type.
	 * The visibility modifier of the generated fields are determined by  {@link #generateFieldVisibilityModifier}.
	 * 
	 * @return the generated field declarations
	 */
	private def generateFields() {
	val modifier = generateFieldVisibilityModifier
	'''« 
	FOR declaration : dataType.innerDeclaration_CompositeDataType
		BEFORE newLine
		SEPARATOR newLine
		»«modifier» «declaration.getInnerDeclarationClassName» «declaration.entityName»;«
	ENDFOR»''' 
	}
	
 	/**
 	 * Used to determine the visibility of generated fields.
 	 * In its current form this method will return "private".
 	 * 
 	 * @return the visibility modifier used for fields
 	 */
	protected def generateFieldVisibilityModifier() '''private'''
	
	private def String generateConstructor() {
		if (dataType.innerDeclaration_CompositeDataType.size > 0) {
			return generateStandardConstructor().toString + newLine + generateArgumentConstructor().toString
		} else {
			return generateStandardConstructor().toString	
		}
	}
	
	/**
	 * Generates a constructor with no parameters that will initialize all non-primitive fields with standard constructors and strings with "".
	 * 
	 * @return the generated constructor
	 */
	private def generateStandardConstructor() '''
	public «dataType.entityName»() {
		// TODO: Implement and verify auto-generated constructor.
		«FOR declaration : dataType.getNonPrimitiveDeclarations
			»this.«declaration.entityName» = «generateConstructorCall(declaration.datatype_InnerDeclaration)»«
		ENDFOR»
	}
	'''
	
	/**
	 * Generates a constructor with a parameter for every field of the data type.
	 * All fields are initialized with the corresponding argument.
	 * 
	 * @return the generated constructor
	 */
	private def generateArgumentConstructor()'''
	public «dataType.entityName»(«
		FOR declaration : dataType.innerDeclaration_CompositeDataType
			SEPARATOR ", "
			»«declaration.getInnerDeclarationClassName» «declaration.entityName»«
		ENDFOR»«
	») {
		// TODO: Implement and verify auto-generated constructor.
		«FOR declaration : dataType.innerDeclaration_CompositeDataType
			SEPARATOR newLine
			»this.«declaration.entityName» = «declaration.entityName»;«
		ENDFOR»
	}
	'''
	
	/**
	 * Generates getter/setter methods for every field if the field visibility modifier is set to private.
	 * 
	 * @return a string containing getter/setter methods for every field or an empty string
	 */
	private def generateMethods() {
	if (generateFieldVisibilityModifier.equals("public")) return ""
	'''«FOR declaration : dataType.innerDeclaration_CompositeDataType
			SEPARATOR newLine
			AFTER newLine
		»«generateGetterSetter(declaration)
		»«ENDFOR»'''
	}
	
	/**
	 * Generates a getter- and a setter method for a given inner declaration.
	 * 
	 * @param declaration a PCM inner declaration
	 * @return the generated methods
	 */
	private def generateGetterSetter(InnerDeclaration declaration) '''«
	»public «declaration.getInnerDeclarationClassName» get«declaration.entityName.toFirstUpper»() {
«   »    return «declaration.entityName»;
«   »}

«
	»public void set«declaration.entityName.toFirstUpper»(«declaration.getInnerDeclarationClassName» «declaration.entityName») {
«   »    this.«declaration.entityName» = «declaration.entityName»;
«   »}
'''
		
	/**
	 * Generates a constructor call for a given composite data type.
	 * The constructor without any parameters will be called.
	 * 
	 * @param dataType a PCM composite data type
	 * @return the generated constructor call
	 */
	private dispatch def String generateConstructorCall(CompositeDataType dataType) {
		return '''new «dataType.getClassNameOfDataType»();«newLine»'''
	}
	
	/**
	 * Generates a constructor call for a given collection data type.
	 * As collection data types are represented by Iterable objects in Java code, an ArrayList of the inner type of the given data type is created.
	 * If the inner type of the given data type is null, an ArrayList of objects will be created instead.
	 *  
	 * @param dataType a PCM collection data type
	 * @return the generated constructor call
	 */
	private dispatch def String generateConstructorCall(CollectionDataType dataType) {
		val innerType = dataType.innerType_CollectionDataType
		if (innerType !== null) {
			return '''new «dataType.innerType_CollectionDataType.getClassNameOfDataType»[0];«newLine»'''
		} else {
			return '''Object[];«newLine»'''
		}
	}
	
	/**
	 * Generates of constructor call for a given primitive data type.
	 * If the given primitive type is a string, """;" is returned. 
	 * In other cases an exception is thrown.
	 * 
	 * @param dataType a PCM primitive data type
	 * @throws UnsupportedOperationException if the given primitive data type is not string
	 * @return the generated constructor call
	 */
	private dispatch def String generateConstructorCall(PrimitiveDataType dataType) throws UnsupportedOperationException {
		switch (dataType.type) {
			case STRING : '''"";''' +  newLine
			default: throw new UnsupportedOperationException("Can only generate constructor calls for primitive type String: " + dataType.type)
		}
	}
		
	/**
	 * Will throw a unsupported operation exception because constructor calls can only be generated for primitive -, composite -, or collection data types.
	 * 
	 * @dataType a PCM data type
	 * @throws UnsupportedOperationException will be thrown
	 * @return nothing
	 */	
	private dispatch def String generateConstructorCall(DataType dataType) throws UnsupportedOperationException {
		throw new UnsupportedOperationException("Can only generate constructor calls for String, collection- or composite data types " + dataType.class.toString)
	}
		
}