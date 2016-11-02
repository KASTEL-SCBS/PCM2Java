package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationSignature

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorHeadAndImports.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorUtil.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCMUtil.*

final class PCM2JavaGeneratorInterfaces {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	static def String generateContent(OperationInterface iface) {
		val importsAndClassifierHead = generateImportsAndInterfaceHead(iface)
		val extendsRelations = generateExtendsRelations(iface)
		val methodDeclarations = generateMethodDeclarations(iface.signatures__OperationInterface)
		return importsAndClassifierHead + extendsRelations + '''{
			
	«methodDeclarations»

}'''
	}	
		
	private static def generateMethodDeclarations(Iterable<OperationSignature> operationSignatures) '''«
		
		FOR operationSignature : operationSignatures 
			SEPARATOR "; " + newLine
			AFTER "; " + newLine
			»«generateMethodDeclarationWithoutSemicolon(operationSignature)»«
		ENDFOR 
	»'''
	
	private static def generateExtendsRelations(OperationInterface iface) '''«
	FOR providedInterface : getAllInheritedOperationInterfaces(iface)
		BEFORE 'extends '
		SEPARATOR ', '
		AFTER ' '
		»«providedInterface.entityName»«
	ENDFOR»'''
	
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
	
}