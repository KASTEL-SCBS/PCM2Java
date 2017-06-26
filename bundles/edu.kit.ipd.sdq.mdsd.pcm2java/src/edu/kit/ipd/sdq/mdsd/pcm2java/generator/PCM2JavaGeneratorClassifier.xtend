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

class PCM2JavaGeneratorClassifier {

	private BasicComponent bc
	protected OperationInterface iface
	protected PCM2JavaGeneratorHeadAndImports generatorHeadAndImports

	new() {
		generatorHeadAndImports = new PCM2JavaGeneratorHeadAndImports
	}

	def dispatch String generateContent(BasicComponent bc) {
		this.bc = bc
		val importsAndClassifierHead = generatorHeadAndImports.generateImportsAndClassHead(this.bc)
		val implementsRelations = generateImplementsRelations()
		val fields = generateFields()
		val constructor = generateConstructor()
		val methods = generateMethodDefinitions()
		return importsAndClassifierHead + implementsRelations + '''{
	«fields»
	
	«constructor»
	
	«methods»
}'''	
	}
		
	private def generateMethodDefinitions() {
		var methodDefinitions = generateMethodDefinitions(bc.providedRoles_InterfaceProvidingEntity.filter(OperationProvidedRole).map[it.providedInterface__OperationProvidedRole].map[it.signatures__OperationInterface].flatten).toString
		val inheritedInterfaces = bc.getAllInheritedOperationInterfaces
		for (iface : inheritedInterfaces) {
			methodDefinitions += generateMethodDefinitions(iface.signatures__OperationInterface)
		}
		return methodDefinitions
	}
	
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

'
	»public «generateMethodDeclarationWithoutSemicolon(operationSignature)»«
		ENDFOR 
	»
	'''

	private def String generateReturnType(DataType returnType) {
		if (returnType !== null) {
			return returnType.getClassNameOfDataType
		}
		return "void"
	}
		
	private def generateImplementsRelations() '''«
	FOR providedInterface :bc.getProvidedInterfaces()
		BEFORE 'implements '
		SEPARATOR ', '
		AFTER ' '
		»«providedInterface.entityName»«
	ENDFOR»'''
	
	private def generateFields() '''«
	FOR iface : bc.getRequiredInterfaces()
		BEFORE '
'
		SEPARATOR '
'
		»private «iface.entityName» «iface.entityName.toFirstLower»;«
	ENDFOR»''' 
	
	private def generateConstructor() '''
	public «bc.entityName»(«
	FOR iface2 : bc.getRequiredInterfaces()
		SEPARATOR ", "
		»«iface2.entityName» «iface2.entityName.toFirstLower
	»«ENDFOR») {
		// TODO: implement and verify auto-generated constructor.
	«FOR iface : bc.getRequiredInterfaces()
		»    this.«iface.entityName.toFirstLower» = «iface.entityName.toFirstLower»;
    «ENDFOR»
	}'''
	
	def dispatch String generateContent(OperationInterface iface) {
		this.iface = iface
		val importsAndClassifierHead = generateImportsAndHead()
		val extendsRelations = generateExtendsRelations()
		val methodDeclarations = generateMethodDeclarations()
		return importsAndClassifierHead + extendsRelations + '''{
			
	«methodDeclarations»

}'''
	}
	
	protected def String generateImportsAndHead() '''«
		generatorHeadAndImports.generateImportsAndInterfaceHead(iface)
	»'''
	
	private def generateExtendsRelations() '''«
	FOR providedInterface : iface.getAllInheritedOperationInterfaces
		BEFORE 'extends '
		SEPARATOR ', '
		AFTER ' '
		»«providedInterface.entityName»«
	ENDFOR»'''
	
	
	private def generateMethodDeclarations() '''«
		FOR operationSignature : iface.signatures__OperationInterface
			SEPARATOR "; " + newLine
			AFTER "; " + newLine
			»«generateMethodDeclaration(operationSignature)»«
		ENDFOR 
	»'''
	
	protected def generateMethodDeclaration(OperationSignature operationSignature) '''«
		generateMethodDeclarationWithoutSemicolon(operationSignature)
	»'''
		
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