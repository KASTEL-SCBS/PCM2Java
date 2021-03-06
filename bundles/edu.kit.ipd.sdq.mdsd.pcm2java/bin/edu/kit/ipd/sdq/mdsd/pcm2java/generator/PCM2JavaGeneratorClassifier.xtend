package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationProvidedRole
import org.palladiosimulator.pcm.repository.OperationSignature

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*

import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntityUtil.*
import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity.InterfaceRequiringEntityUtil.*
import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.repository.BasicComponentUtil.*
import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.repository.OperationInterfaceUtil.*
import static extension edu.kit.ipd.sdq.mdsd.pcm2java.util.DataTypeUtil.*
import static extension edu.kit.ipd.sdq.mdsd.pcm2java.util.SignatureUtil.*
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * This class is used to generate Java source code for basic components and operation interfaces from PCM models.
 * 
 * @author Moritz Behr
 * @version 0.1
 */
class PCM2JavaGeneratorClassifier {
	
	@Accessors(PROTECTED_GETTER) private BasicComponent bc // the basic component for which code is currently being generated 
	protected OperationInterface iface // the operation interface for which code is currently being generated
	protected PCM2JavaGeneratorHeadAndImports generatorHeadAndImports // used to generate class/interface heads and imports

	/**
	 * Creates a new PCM2JavaGeneratorClassifier
	 */
	protected new() {
		generatorHeadAndImports = new PCM2JavaGeneratorHeadAndImports
	}
	
	/**
	 * Generates Java source code for a given PCM basic component.
	 * A Java class will be generated that represents the given PCM basic component as good as possible without additional information.
	 * This means that all generated methods are auto-generated stubs that must be implemented after generation.
	 * 
	 * @param bc a PCM basic component
	 * @return generated Java source code of a class representing the given component 
	 */
	def dispatch String generateContent(BasicComponent bc) {
		this.bc = bc
		val importsAndClassifierHead = generatorHeadAndImports.generateImportsAndClassHead(this.bc)
		val implementsRelations = generateImplementsRelations()
		val fields = generateFields()
		val constructor = generateConstructor()
		val methods = generateMethodDefinitions()
		this.bc = null
		return importsAndClassifierHead + implementsRelations + '''{
	«fields»
	
	«constructor»
	
	«methods»
}'''	
	}
	
	/**
	 * Generates method definitions for all methods declared in interfaces that are implemented by the currently processed basic component.
	 * This includes inherited method declarations.
	 * The definitions are, however, only auto-generated method stubs, as a real implementation cannot be generated without additional information.
	 * 
	 * @return the generated method definitions
	 */
	private def generateMethodDefinitions() {
		var methodDefinitions = generateMethodDefinitions(bc.providedRoles_InterfaceProvidingEntity.filter(OperationProvidedRole).map[it.providedInterface__OperationProvidedRole].map[it.signatures__OperationInterface].flatten).toString
		val inheritedInterfaces = bc.getAllInheritedOperationInterfaces
		for (iface : inheritedInterfaces) {
			methodDefinitions += generateMethodDefinitions(iface.signatures__OperationInterface)
		}
		return methodDefinitions
	}
	
	/**
	 * Generates method definitions for all given operation signatures.
	 * The definitions are, however, only auto-generated method stubs as a real implementation cannot be generated without additional information.
	 * 
	 * @param operationSignatures an Iterable object of OperationSignatures
	 * @return the generated method definitions
	 */
	private def generateMethodDefinitions(Iterable<OperationSignature> operationSignatures) '''«
		FOR operationSignature : operationSignatures 
			SEPARATOR '{
	// TODO: implement and verify auto-generated method stub
	throw new UnsupportedOperationException("TODO: auto-generated method stub");
}

'
			AFTER '{
	// TODO: implement and verify auto-generated method stub
	throw new UnsupportedOperationException("TODO: auto-generated method stub");
}

'	»
	«generateCommentariesForMethod(operationSignature)»
	public «generateMethodDeclarationWithoutSemicolon(operationSignature)»«
		ENDFOR 
	»
	'''
	
	
	/**
	 * Generates commentaries for the given operation signature. 
	 * This method serves as a hook for possible extensions for providision of commentaries (e.g. Javadoc) or annotations and therefore returns an empty string.  
	 */
	protected def String generateCommentariesForMethod(OperationSignature signature) {
		return ""  
	}

	/**
	 * Returns the name of the type the given data type would have in Java code that was generated by this class.
	 * If null is given, "void" is returned.
	 * 
	 * @param dataType a PCM data type
	 * @return the name
	 */
	private def String generateReturnType(DataType dataType) {
		if (dataType !== null) {
			return dataType.getClassNameOfDataType
		}
		return "void"
	}
		
	/**
	 * Generates a string describing the "implements" relations of the currently processed basic component.
	 * The returned string starts with "implements " followed by the names of all implemented operation interfaces, separated by a comma.
	 * 
	 * @return the generated implements statement
	 */
	private def generateImplementsRelations() '''«
	FOR providedInterface :bc.getProvidedInterfaces()
		BEFORE 'implements '
		SEPARATOR ', '
		AFTER ' '
		»«providedInterface.entityName»«
	ENDFOR»'''
	
	/**
	 * Generates field declarations for every required interfaces declared in the currently processed basic component.
	 * The generated fields are private.
	 * 
	 * @return the generated field declarations
	 */
	private def generateFields() '''«
	FOR iface : bc.getRequiredInterfaces()
		BEFORE '
'
		SEPARATOR '
'
		»private «iface.entityName» «iface.entityName.toFirstLower»;«
	ENDFOR»''' 
	
	/**
	 * Generates a constructor method for the currently processed basic component.
	 * The generated methods will have a parameter for every required interface of the component.
	 * Each field of the new object will be initialized with the corresponding argument.
	 * 
	 * @return the generated constructor
	 */
	private def generateConstructor() '''
	public «bc.entityName»(«
	FOR iface2 : bc.getRequiredInterfaces() // generate parameter list
		SEPARATOR ", "
		»«iface2.entityName» «iface2.entityName.toFirstLower
	»«ENDFOR») {
		// TODO: implement and verify auto-generated constructor.
	«FOR iface : bc.getRequiredInterfaces() // generate field assignments
		»    this.«iface.entityName.toFirstLower» = «iface.entityName.toFirstLower»;
    «ENDFOR»
	}'''
	
	/**
	 * Generates Java source code for a given PCM operation interface.
	 * A Java interface will be generated that represents the given PCM operation interface.
	 * 
	 * @param iface a PCM operation interface
	 * @return generated Java code
	 */
	def dispatch String generateContent(OperationInterface iface) {
		this.iface = iface
		val importsAndClassifierHead = generateImportsAndInterfaceHead
		val extendsRelations = generateExtendsRelations()
		val methodDeclarations = generateMethodDeclarations()
		this.iface = null
		return importsAndClassifierHead + extendsRelations + '''{
			
	«methodDeclarations»

}'''
	}
	
	/**
	 * Generates imports and a head for the currently processed operation interface.
	 * 
	 * @return generated imports and heads
	 */
	protected def String generateImportsAndInterfaceHead() {
	    generatorHeadAndImports.generateImportsAndInterfaceHead(iface)
	}
	
	/**
	 * Generates a string describing the "extends" relations of the currently processed operation interface.
	 * The returned string starts with "extends " followed by the names of all inherited operation interfaces, separated by a comma.
	 * 
	 * @return the generated extends statement
	 */
	private def generateExtendsRelations() '''«
	FOR providedInterface : iface.getAllInheritedOperationInterfaces
		BEFORE 'extends '
		SEPARATOR ', '
		AFTER ' '
		»«providedInterface.entityName»«
	ENDFOR»'''
	
	/**
	 * Generates method declarations for all operation signatures of the currently processed operation interface.
	 * 
	 * @return the generated method declarations
	 */
	private def generateMethodDeclarations() '''«
		FOR operationSignature : iface.signatures__OperationInterface
			SEPARATOR "; " + newLine
			AFTER "; " + newLine
			»«generateMethodDeclaration(operationSignature)»«
		ENDFOR 
	»'''
	
	/**
	 * Generates a method declaration for the given operation signature.
	 * 
	 * @param operationSignature a PCM operation signature
	 * @return the generated method declaration
	 */
	protected def generateMethodDeclaration(OperationSignature operationSignature) '''«
		generateMethodDeclarationWithoutSemicolon(operationSignature)
	»'''
		
	/**
	 * Generates a method declaration for the given operation signature without a final semicolon.
	 * 
	 * @param operationSignature a PCM operation signature
	 * @return the generated method declaration
	 */
	protected def String generateMethodDeclarationWithoutSemicolon(OperationSignature operationSignature) {
				val returnType = operationSignature.returnType__OperationSignature.generateReturnType
				val methodName = operationSignature.getMethodName
				val parameterDeclarations = '''«
				FOR parameter : operationSignature.parameters__OperationSignature
					SEPARATOR ', '
»«parameter.dataType__Parameter.getClassNameOfDataType» «parameter.getParameterName»«
				ENDFOR»'''
				return '''«returnType» «methodName»(«parameterDeclarations»)'''
	}
	
}