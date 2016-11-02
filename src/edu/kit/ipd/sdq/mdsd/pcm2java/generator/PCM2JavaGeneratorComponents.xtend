package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.OperationProvidedRole
import org.palladiosimulator.pcm.repository.OperationSignature

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorHeadAndImports.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorUtil.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCMUtil.*

final class PCM2JavaGeneratorComponents {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	def static String generateContent(BasicComponent bc) {
		val importsAndClassifierHead = generateImportsAndClassHead(bc)
		val implementsRelations = generateImplementsRelations(bc)
		val fields = generateFields(bc)
		val constructor = generateConstructor(bc)
		val methods = generateMethodDefinitions(bc)
		
		return importsAndClassifierHead + implementsRelations + '''{
	«fields»
	
	«constructor»
	
	«methods»
}'''	
	}
	
	private static def generateMethodDefinitions(BasicComponent bc) {
		var methodDefinitions = generateMethodDefinitions(bc.providedRoles_InterfaceProvidingEntity.filter(OperationProvidedRole).map[it.providedInterface__OperationProvidedRole].map[it.signatures__OperationInterface].flatten).toString
		val inheritedInterfaces = getAllInheritedOperationInterfaces(bc)
		for (iface : inheritedInterfaces) {
			methodDefinitions += generateMethodDefinitions(iface.signatures__OperationInterface)
		}
		return methodDefinitions
	}
	
	private static def generateMethodDefinitions(Iterable<OperationSignature> operationSignatures) '''«
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
	
	private static def String generateMethodDeclarationWithoutSemicolon(OperationSignature operationSignature) {
				val returnType = operationSignature.returnType__OperationSignature.generateReturnType
				val methodName = getMethodName(operationSignature)
				val parameterDeclarations = '''«
				FOR parameter : operationSignature.parameters__OperationSignature
					SEPARATOR ', '
»«getClassNameOfDataType(parameter.dataType__Parameter)» «getParameterName(parameter)»«
				ENDFOR»'''
				return '''«returnType» «methodName»(«parameterDeclarations»)'''
	}
	
	private static def String generateReturnType(DataType returnType) {
		if (returnType != null) {
			return getClassNameOfDataType(returnType)
		}
		return "void"
	}
		
	private static def generateImplementsRelations(BasicComponent bc) '''«
	FOR providedInterface : getProvidedInterfaces(bc)
		BEFORE 'implements '
		SEPARATOR ', '
		AFTER ' '
		»«providedInterface.entityName»«
	ENDFOR»'''
	
	private static def generateFields(BasicComponent bc) '''«
	FOR iface : getRequiredInterfaces(bc)
		BEFORE '
'
		SEPARATOR '
'
		»private «iface.entityName» «iface.entityName.toFirstLower»;«
	ENDFOR»''' 
	
	private static def generateConstructor(BasicComponent bc) '''
	public «bc.entityName»(«
	FOR iface2 : getRequiredInterfaces(bc)
		SEPARATOR ", "
		»«iface2.entityName» «iface2.entityName.toFirstLower
	»«ENDFOR») {
		// TODO: implement and verify auto-generated constructor.
	«FOR iface : getRequiredInterfaces(bc)
		»    this.«iface.entityName.toFirstLower» = «iface.entityName.toFirstLower»;
    «ENDFOR»
	}'''
	
}