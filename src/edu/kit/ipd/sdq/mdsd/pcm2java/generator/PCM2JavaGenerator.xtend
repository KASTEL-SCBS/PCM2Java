package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import edu.kit.ipd.sdq.commons.ecore2txt.generator.AbstractEcore2TxtGenerator
import edu.kit.ipd.sdq.vitruvius.framework.util.bridges.EcoreBridge
import edu.kit.ipd.sdq.vitruvius.framework.util.datatypes.Triple
import java.util.ArrayList
import java.util.Collections
import java.util.HashSet
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntity
import org.palladiosimulator.pcm.core.entity.NamedElement
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationProvidedRole
import org.palladiosimulator.pcm.repository.OperationSignature

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaTargetNameUtil.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCMUtil.*
import org.palladiosimulator.pcm.repository.OperationRequiredRole
import org.palladiosimulator.pcm.repository.Interface

class PCM2JavaGenerator extends AbstractEcore2TxtGenerator {
		
	override getFolderNameForResource(Resource inputResource) {
		throw new UnsupportedOperationException()
	}
	
	override getFileNameForResource(Resource inputResource) {
		throw new UnsupportedOperationException()
	}
	
	override postProcessGeneratedContents(String contents) {
		// no postprocessing: do nothing
		return contents
	}

	override generateContentsFromResource(Resource inputResource) {
		val contentsForFolderAndFileNames = new ArrayList<Triple<String,String,String>>()
		generateAndAddContents(inputResource, contentsForFolderAndFileNames)
		return contentsForFolderAndFileNames
	}
	
	private def void generateAndAddContents(Resource inputResource, List<Triple<String,String,String>> contentsForFolderAndFileNames) {
		for (element : EcoreBridge.getAllContents(inputResource)) {
			val content = generateContent(element)
			if (!content?.equals("")) {
				val folderName = getTargetName(element, false)
				val fileName = getTargetFileName(element) + getTargetFileExt()
				val contentAndFileName = new Triple<String,String,String>(content,folderName,fileName)
				contentsForFolderAndFileNames.add(contentAndFileName)
			}
		}
	}
	
	def dispatch String generateContent(EObject object) {
//		"Cannot generate content for generic EObject '" + object + "'!"
		return ""
	}
	
	def dispatch String generateContent(CompositeDataType dataType) {
		val importsAndClassifierHead = generateImportsAndInterfaceHead(dataType)
		// FIXME MK generate fields in composite data types
		// FIXME MK generate constructors in composite data types
		return importsAndClassifierHead + '''{
	// FIXME MK generate fields in composite data types
	// FIXME MK generate constructors in composite data types
}'''
	}
	
	def dispatch String generateContent(OperationInterface iface) {
		val importsAndClassifierHead = generateImportsAndInterfaceHead(iface)
		val methodDeclarations = generateMethodDeclarations(iface)
		// FIXME MK support all cases of method declarations for service signatures in interfaces
		return importsAndClassifierHead + '''{
	«methodDeclarations»
	// FIXME MK support all cases of method declarations for service signatures in interfaces
}'''
	}
	
	private def generateMethodDeclarations(OperationInterface iface) {
		var declarations = generateMethodDeclarations(iface.signatures__OperationInterface).toString
		val arr = new ArrayList<OperationInterface>
		arr.add(iface)
		for (parentIface : getInheritedOperationInterfaces(arr)) {
			declarations += generateMethodDeclarations(parentIface.signatures__OperationInterface)
		}
		return declarations
	}
	
	def generateMethodDeclarations(Iterable<OperationSignature> operationSignatures) '''«
		
		FOR operationSignature : operationSignatures 
			SEPARATOR ';
'
			AFTER ';
'
			»«generateMethodDeclarationWithoutSemicolon(operationSignature)»«
		ENDFOR 
	»'''
	
	private def String generateMethodDeclarationWithoutSemicolon(OperationSignature operationSignature) {
				val returnType = getTargetFileName(operationSignature.returnType__OperationSignature)
				val methodName = getMethodName(operationSignature)
				val parameterDeclarations = '''«
				FOR parameter : operationSignature.parameters__OperationSignature
					SEPARATOR ', '
»«getTargetFileName(parameter.dataType__Parameter)» «getParameterName(parameter)»«
				ENDFOR»'''
				return '''«returnType» «methodName»(«parameterDeclarations»)'''
	}
	
	def dispatch String generateContent(BasicComponent bc) {
		val importsAndClassifierHead = generateImportsAndClassHead(bc)
		val implementsRelations = generateImplementsRelations(bc)
		val fields = generateFields(bc)
		val constructor = generateConstructor(bc)
		
		return importsAndClassifierHead + implementsRelations + '''{
			
	«fields»
	
	«constructor»
	
	«generateMethodDefinitions(bc)»
}'''	
	}
	
	private def generateMethodDefinitions(BasicComponent bc) {
		var methodDefinitions = generateMethodDefinitions(bc.providedRoles_InterfaceProvidingEntity.filter(OperationProvidedRole).map[it.providedInterface__OperationProvidedRole].map[it.signatures__OperationInterface].flatten).toString
		val inheritedInterfaces = getInheritedOperationInterfaces(getProvidedInterfaces(bc))
		for (iface : inheritedInterfaces) {
			methodDefinitions += generateMethodDefinitions(iface.signatures__OperationInterface)
		}
		return methodDefinitions
	}
	
	private def generateMethodDefinitions(Iterable<OperationSignature> operationSignatures) '''«
		FOR operationSignature : operationSignatures 
			SEPARATOR '{
	// TODO: implement and verify auto-generated method stub
	throw new UnsupportedOperationException("TODO: auto-generated method stub")
}

'
			AFTER '{
	// TODO: implement and verify auto-generated method stub
	throw new UnsupportedOperationException("TODO: auto-generated method stub")
}

'
	»«generateMethodDeclarationWithoutSemicolon(operationSignature)»«
		ENDFOR 
	»
	'''

	
	
	private def generateImplementsRelations(BasicComponent bc) '''«
	FOR providedInterface : getProvidedInterfaces(bc)
		BEFORE 'implements '
		SEPARATOR ', '
		AFTER ' '
		»«providedInterface.entityName.toFirstUpper»«
	ENDFOR»'''
	
	private def generateFields(BasicComponent bc) '''«
	FOR iface : getRequiredInterfaces(bc)
		»private «iface.entityName.toFirstUpper» «iface.entityName.toFirstLower»;«
	ENDFOR»''' 
	
	private def generateConstructor(BasicComponent bc) '''
	public «bc.entityName.toFirstUpper»() {
		// TODO: implement and verify auto-generated constructor. Add parameters to constructor calls if necessary.
	«FOR iface : getRequiredInterfaces(bc)
		»    this.«iface.entityName.toFirstLower» = new «iface.entityName.toFirstUpper»();
    «ENDFOR»
	}'''
	
	private def Iterable<? extends EObject> getTypesUsedInSignaturesOfProvidedServices(InterfaceProvidingEntity ipe) {
		val usedTypes = new HashSet<EObject>()
		for (providedSignature : getProvidedInterfaces(ipe).map[it.signatures__OperationInterface].flatten) {
			usedTypes.addAll(getDataTypesToImport(#{providedSignature.returnType__OperationSignature}))
			usedTypes.addAll(getDataTypesToImport(providedSignature.parameters__OperationSignature.map[it.dataType__Parameter]))
		}
		return usedTypes
	}
	
	private def String generateImportsAndInterfaceHead(NamedElement namedElement) {
		return generateImportsAndClassifierHead(namedElement,"interface")
	}
	
	private def String generateImportsAndClassHead(NamedElement namedElement) {
		return generateImportsAndClassifierHead(namedElement,"class")
	}
	
	private def String generateImportsAndClassifierHead(NamedElement namedElement, String classifierType) {
		val packageDeclaration = generatePackageDeclaration(namedElement)
		val imports = generateImports(namedElement)
		val classifierName = namedElement.entityName
		val classifierHead = generateClassifierHeader(classifierType, classifierName)
		return packageDeclaration + imports + classifierHead
	}
	
	private def String generatePackageDeclaration(NamedElement element) {
		return "package " + getTargetName(element, true) + ''';

'''
	}
	
	private def String generateImports(NamedElement namedElement) {
		var imports = ""
		var elementsToImport = getElementsToImport(namedElement)
		for (elementToImport : elementsToImport) {
			imports += generateImport(elementToImport)
		}
		return imports + if (imports.equals("")) "" else '''
		
'''
	}
	
	private def dispatch Iterable<? extends EObject> getElementsToImport(NamedElement namedElement) {
		throw new UnsupportedGeneratorInput("generate imports for", namedElement)
	}
	
	private def dispatch Iterable<? extends EObject> getElementsToImport(CompositeDataType dataType) {
		return dataType.innerDeclaration_CompositeDataType.map[it.datatype_InnerDeclaration].dataTypesToImport
	}
	
	private def Iterable<? extends EObject> getDataTypesToImport(Iterable<DataType> dataTypes) {
		// FIXME MK get util classes to import for collection data types
		dataTypes.filter(CompositeDataType)
	}
	
	private def dispatch Iterable<? extends EObject> getElementsToImport(OperationInterface iface) {
		// FIXME MK generate imports for interfaces
		return Collections.emptyList
	}
	
	private def dispatch Iterable<? extends EObject> getElementsToImport(BasicComponent bc) {
		val elementsToImport = new ArrayList<EObject>()
		elementsToImport.addAll(getProvidedInterfaces(bc))
		elementsToImport.addAll(getRequiredInterfaces(bc))
		elementsToImport.addAll(getTypesUsedInSignaturesOfProvidedServices(bc))
		return elementsToImport
	}
	
	private def String generateImport(EObject eObject) {
		val fullyQualifiedTypeToImport = getTargetName(eObject, true) + getSeparator(true) + getTargetFileName(eObject)
		return generateImport(fullyQualifiedTypeToImport)
	}
	
	private def String generateImport(String fullyQualifiedTypeToImport) '''import «fullyQualifiedTypeToImport»;
	'''
	
	private def String generateClassifierHeader(String classifierType, String classifierName) '''
	public «classifierType» «classifierName.toFirstUpper» '''

	// TODO: Move to PCM helper class.
	private def Iterable<OperationInterface> getInheritedOperationInterfaces(Iterable<OperationInterface> ifaces) {
		val inheritedOperationInterfaces = new ArrayList<OperationInterface>
		val toIterate = new ArrayList<Interface>
		for (Interface iface : ifaces) {
			toIterate.addAll(iface.parentInterfaces__Interface)
		}
		while (!toIterate.isEmpty) {
			val iface = toIterate.get(0)
			toIterate.addAll(iface.parentInterfaces__Interface)
			if (iface instanceof OperationInterface) {
				inheritedOperationInterfaces.add(iface)
			}
			toIterate.remove(0)
		}
		return inheritedOperationInterfaces
	}
}