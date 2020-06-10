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
 * 
 * @author Moritz Behr
 * @version 0.1
 */
class PCM2JavaGeneratorDataTypes {
	
	private CompositeDataType dataType // the basic component for which code is currently being generated 
	private boolean replaceIterablesWithArrays // if true, use arrays instead of iterables for collection data types
	private val generatorHeadAndImports = constructGeneratorHeadAndImports // is used to gnerate class heads and imports
	
	/**
	 * Creates new PCM2JAvaGeneratorDataTypes
	 */
	protected new() {
	    replaceIterablesWithArrays = false
	}
	
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
		»«modifier» «generateInnerDeclarationClassName(declaration)» «declaration.entityName»;«
	ENDFOR»''' 
	}
	
 	/**
 	 * Used to determine the visibility of generated fields.
 	 * In its current form this method will return "private".
 	 * 
 	 * @return the visibility modifier used for fields
 	 */
	protected def generateFieldVisibilityModifier() '''private'''
	
	/**
	 * Generates two constructors for the currently processed data type.
	 * One constructor that expects no arguments and initializes all field with standard values and one constructor that expects an argument for every field-
	 * 
	 * @return the generated constructors
	 */
	private def String generateConstructor() {
		if (dataType.innerDeclaration_CompositeDataType.size > 0) {
			return generateStandardConstructor().toString + newLine + generateArgumentConstructor().toString
		} else {
			return generateStandardConstructor().toString	
		}
	}
	
	/**
	 * Generates a constructor with no parameters for the currently processed data:
     * The generated constructor will initialize all non-primitive fields with standard constructors and strings with "".
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
			»«generateInnerDeclarationClassName(declaration)» «declaration.entityName»«
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
        generateCollectionDataTypeConstructorCall(dataType)
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
    
    // This method is extracted from the generateConstructorCall method for collection data types for reasons concerning inheritance.
    /**
     * Generates a constructor call for a given collection data type.
     * As collection data types are represented by Iterable objects in Java code, an ArrayList of the inner type of the given data type is created.
     * If the inner type of the given data type is null, an ArrayList of objects will be created instead.
     *  
     * @param dataType a PCM collection data type
     * @return the generated constructor call
     */
    protected def String generateCollectionDataTypeConstructorCall(CollectionDataType type) {
        val innerType = getCollectionDataTypeInnerTypeAsString(type)
        '''new ArrayList<«innerType»>();«newLine»'''
    }
    
    /**
     * Returns the class name of the inner type of a given collection data type, as string.
     * If either the given collection data type or the inner type is null, "Object" is returned.
     * 
     * @param type a PCM collection data type
     * @return the class name of the inner type of the given collection data type
     */
    private def String getCollectionDataTypeInnerTypeAsString(CollectionDataType type) {
        val innerType = type.innerType_CollectionDataType
        if (innerType !== null) {
            return innerType.classNameOfDataType.primitiveToReferenceName
        } else {
            return "Object"
        }
    }
	
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
	»public «generateInnerDeclarationClassName(declaration)» get«declaration.entityName.toFirstUpper»() {
«   »    return «declaration.entityName»;
«   »}

«
	»public void set«declaration.entityName.toFirstUpper»(«generateInnerDeclarationClassName(declaration)» «declaration.entityName») {
«   »    this.«declaration.entityName» = «declaration.entityName»;
«   »}
'''
	
	/**
     * Returns the name of the class of the data type, as used in Java, that is contained in the given InnerDeclaration.
     * 
     * @param declaration a PCM inner declaration
     * @return name of the class
     */ 
	protected def String generateInnerDeclarationClassName(InnerDeclaration declaration) {
	    declaration.innerDeclarationClassName
	}
	
	/**
	 * Creates and returns a new head and imports generator that is suited for plain java code generation.
	 * 
	 * @return the created generator
	 */
	protected def PCM2JavaGeneratorHeadAndImports constructGeneratorHeadAndImports() {
	    new PCM2JavaGeneratorHeadAndImports
	}
	
}