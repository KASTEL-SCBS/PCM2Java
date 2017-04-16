package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.OperationProvidedRole
import org.palladiosimulator.pcm.repository.OperationSignature

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorHeadAndImports.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorUtil.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCMUtil.*
import static extension edu.kit.ipd.sdq.mdsd.pcm2java.generator.OperationInterfaceStereotypeUtil.*
import org.palladiosimulator.pcm.repository.OperationInterface
import edu.kit.kastel.scbs.confidentiality.repository.ParametersAndDataPair

final class PCM2JavaGeneratorClassifier {
	
	private static final boolean GENERATE_ANNOTATIONS = true
	
	private val boolean replaceStringsWithCharArrays
	
	new(boolean replaceStringsWithCharArrays) {
		this.replaceStringsWithCharArrays = replaceStringsWithCharArrays
	}
	
	def dispatch String generateContent(BasicComponent bc) {
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
	
	private def generateMethodDefinitions(BasicComponent bc) {
		var methodDefinitions = generateMethodDefinitions(bc.providedRoles_InterfaceProvidingEntity.filter(OperationProvidedRole).map[it.providedInterface__OperationProvidedRole].map[it.signatures__OperationInterface].flatten).toString
		val inheritedInterfaces = getAllInheritedOperationInterfaces(bc)
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
		if (returnType != null) {
			val result = getClassNameOfDataType(returnType)
			if (replaceStringsWithCharArrays && result.equals("String")) return "char[]"
			else return result
		}
		return "void"
	}
		
	private def generateImplementsRelations(BasicComponent bc) '''«
	FOR providedInterface : getProvidedInterfaces(bc)
		BEFORE 'implements '
		SEPARATOR ', '
		AFTER ' '
		»«providedInterface.entityName»«
	ENDFOR»'''
	
	private def generateFields(BasicComponent bc) '''«
	FOR iface : getRequiredInterfaces(bc)
		BEFORE '
'
		SEPARATOR '
'
		»private «iface.entityName» «iface.entityName.toFirstLower»;«
	ENDFOR»''' 
	
	private def generateConstructor(BasicComponent bc) '''
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
	
	dispatch def String generateContent(OperationInterface iface) {
		val importsAndClassifierHead = generateImportsAndInterfaceHead(iface)
		val extendsRelations = generateExtendsRelations(iface)
		val methodDeclarations =  if (GENERATE_ANNOTATIONS) generateMethodDeclarationsWithAnnotations(iface) 
								  else generateMethodDeclarations(iface.signatures__OperationInterface)
		return importsAndClassifierHead + extendsRelations + '''{
			
	«methodDeclarations»

}'''
	}
	
	private def generateMethodDeclarations(Iterable<OperationSignature> operationSignatures) '''«
		FOR operationSignature : operationSignatures 
			SEPARATOR "; " + newLine
			AFTER "; " + newLine
			»«generateMethodDeclarationWithoutSemicolon(operationSignature)»«
		ENDFOR 
	»'''
	
	private def generateMethodDeclarationsWithAnnotations(OperationInterface iface) {
	
	val interfaceStereotypeAnnotation = '''«
		FOR pair : iface.parametersAndDataPairs
			SEPARATOR newLine
			AFTER newLine
			»«generateAnnotation(pair)»«
	ENDFOR»'''
	
	'''«
		FOR operationSignature : iface.signatures__OperationInterface 
			SEPARATOR "; " + newLine
			AFTER "; " + newLine
			»«interfaceStereotypeAnnotation»«
			»«generateAnnotations(operationSignature.parametersAndDataPairs)»«
			»«generateMethodDeclarationWithoutSemicolon(operationSignature)»«
		ENDFOR 
	»'''
	}
	
	private def generateExtendsRelations(OperationInterface iface) '''«
	FOR providedInterface : getAllInheritedOperationInterfaces(iface)
		BEFORE 'extends '
		SEPARATOR ', '
		AFTER ' '
		»«providedInterface.entityName»«
	ENDFOR»'''
	
	private def String generateMethodDeclarationWithoutSemicolon(OperationSignature operationSignature) {
				val returnType = operationSignature.returnType__OperationSignature.generateReturnType
				val methodName = getMethodName(operationSignature)
				var parameterDeclarations = '''«
				FOR parameter : operationSignature.parameters__OperationSignature
					SEPARATOR ', '
»«getClassNameOfDataType(parameter.dataType__Parameter)» «getParameterName(parameter)»«
				ENDFOR»'''
				if (replaceStringsWithCharArrays) parameterDeclarations = parameterDeclarations.replace("String", "char[]")
				return '''«returnType» «methodName»(«parameterDeclarations»)'''
	}
	
	private def String generateAnnotations(Iterable<ParametersAndDataPair> parametersAndDataPairs) '''«
		FOR pair : parametersAndDataPairs
			SEPARATOR newLine
			AFTER newLine
			»«generateAnnotation(pair)»«
	ENDFOR»'''
	
	private def String generateAnnotation(ParametersAndDataPair parametersAndDataPair) {
		val dataSetName = parametersAndDataPair.name.split(" - ").get(1).substring(2)
		val parameterNames = parametersAndDataPair.name.split(" - ").get(0).substring(2)
		return "@InformationFlow " + dataSetName +  " includes " + parameterNames
	}
	
}