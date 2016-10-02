package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import edu.kit.ipd.sdq.commons.ecore2txt.generator.AbstractEcore2TxtGenerator
import tools.vitruv.framework.util.bridges.EcoreBridge
import java.util.ArrayList
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
import org.palladiosimulator.pcm.repository.Interface
import org.eclipse.internal.xtend.util.Triplet
import org.palladiosimulator.pcm.repository.InnerDeclaration
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import org.palladiosimulator.pcm.repository.CollectionDataType

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
		val contentsForFolderAndFileNames = new ArrayList<Triplet<String,String,String>>()
		generateAndAddContents(inputResource, contentsForFolderAndFileNames)
		return contentsForFolderAndFileNames
	}
	
	private def void generateAndAddContents(Resource inputResource, List<Triplet<String,String,String>> contentsForFolderAndFileNames) {
		for (element : EcoreBridge.getAllContents(inputResource)) {
			val content = generateContent(element)
			if (!content?.equals("")) {
				val folderName = getTargetName(element, false)
				val fileName = getTargetFileName(element) + getTargetFileExt()
				val contentAndFileName = new Triplet<String,String,String>(content,folderName,fileName)
				contentsForFolderAndFileNames.add(contentAndFileName)
			}
		}
	}
	
	def dispatch String generateContent(EObject object) {
//		"Cannot generate content for generic EObject '" + object + "'!"
		return ""
	}
	
	def dispatch String generateContent(CompositeDataType dataType) {
		// FIXME full support for collection data types as inner data types
		val importsAndClassifierHead = generateImportsAndClassHead(dataType)
		val extendsRelations = generateExtendsRelation(dataType)
		val fields = generateFields(dataType)
		val constructor = generateConstructor(dataType)
		return importsAndClassifierHead + extendsRelations + '''{
	// FIXME full support for collection data types as inner data types
	«fields»
	
	«constructor»
	
}'''
	}
		
	private def generateExtendsRelation(CompositeDataType dataType) '''«
	FOR parent : dataType.parentType_CompositeDataType
		BEFORE 'extends '
		»«parent.entityName.toFirstUpper» «
	ENDFOR»'''	
		
	private def generateFields(CompositeDataType dataType) '''«
	FOR declaration : dataType.innerDeclaration_CompositeDataType
		BEFORE '
'
		SEPARATOR '
'
		»private «declaration.getInnerDeclarationClassName» «declaration.entityName.toFirstLower»;«
	ENDFOR»''' 

	/**
	 * Returns the type of the DataType that is contained in the given InnerDeclaration as String.
	 * 
	 * TODO: Move to PCM Helper class
	 */
	private def String getInnerDeclarationClassName(InnerDeclaration declaration){
		val dataType = declaration.datatype_InnerDeclaration
		if (dataType instanceof PrimitiveDataType) {
			val type = (dataType as PrimitiveDataType).type.toString
			switch type {
				case "BOOL" : return "boolean"
				case "STRING" : return "String"
				default : return type.toLowerCase
			}
		}
		if (dataType instanceof CollectionDataType) {
			return (dataType as CollectionDataType).entityName.toFirstUpper
		} 
		if (dataType instanceof CompositeDataType) {
			return (dataType as CompositeDataType).entityName.toFirstUpper
		}
		// FIXME Throw exception if dataType is not a Primitive-, Collection-, or CompositeDataType?
	}
	
	private def String generateConstructor(CompositeDataType dataType) {
		var nonPrimitiveFields = ""
		for (declaration : dataType.innerDeclaration_CompositeDataType) {
			if (declaration.datatype_InnerDeclaration instanceof CollectionDataType || 
				declaration.datatype_InnerDeclaration instanceof CompositeDataType) {
				nonPrimitiveFields += '''this.«declaration.entityName.toFirstLower» = new «declaration.innerDeclarationClassName»();
				'''
			}
		}
		return '''
		public «dataType.entityName.toFirstUpper»() {
			// TODO: Implement and verify auto-generated constructor.
			«nonPrimitiveFields»
		}'''
	}
		
	def dispatch String generateContent(OperationInterface iface) {
		val importsAndClassifierHead = generateImportsAndInterfaceHead(iface)
		val extendsRelations = generateExtendsRelations(iface)
		val methodDeclarations = generateMethodDeclarations(iface.signatures__OperationInterface)
		// FIXME MK support all cases of method declarations for service signatures in interfaces
		return importsAndClassifierHead + extendsRelations + '''{
	«methodDeclarations»
	// FIXME MK support all cases of method declarations for service signatures in interfaces
}'''
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
	
	private def String generateImportsAndInterfaceHead(NamedElement namedElement) {
		return generateImportsAndClassifierHead(namedElement,"interface")
	}
	
	private def generateExtendsRelations(OperationInterface iface) '''«
	FOR providedInterface : getInheritedOperationInterfaces(iface)
		BEFORE 'extends '
		SEPARATOR ', '
		AFTER ' '
		»«providedInterface.entityName.toFirstUpper»«
	ENDFOR»'''
	
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
		val inheritedInterfaces = getInheritedOperationInterfaces(bc)
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
	public «bc.entityName.toFirstUpper»(«
	FOR iface2 : getRequiredInterfaces(bc)
		»«iface2.entityName.toFirstUpper» «iface2.entityName.toFirstLower
	»«ENDFOR») {
		// TODO: implement and verify auto-generated constructor.
	«FOR iface : getRequiredInterfaces(bc)
		»    this.«iface.entityName.toFirstLower» = «iface.entityName.toFirstLower»;
    «ENDFOR»
	}'''
	
	private def Iterable<? extends EObject> getTypesUsedInSignaturesOfProvidedServices(InterfaceProvidingEntity ipe) {
		val usedTypes = new HashSet<EObject>()
		for (providedInterface : getProvidedInterfaces(ipe)) {
			usedTypes.addAll(getTypesUsedInSignaturesOfProvidedServices(providedInterface))
		}
		return usedTypes
	}
	
	private def Iterable<? extends EObject> getTypesUsedInSignaturesOfProvidedServices(OperationInterface iface) {
		val usedTypes =  new HashSet<EObject>
		for (providedSignature : iface.signatures__OperationInterface) {
			usedTypes.addAll(getDataTypesToImport(#{providedSignature.returnType__OperationSignature}))
			usedTypes.addAll(getDataTypesToImport(providedSignature.parameters__OperationSignature.map[it.dataType__Parameter]))
		}
		return usedTypes
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
		val elementsToImport = new ArrayList<EObject>
		elementsToImport.addAll(getTypesUsedInSignaturesOfProvidedServices(iface))
		return elementsToImport
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
	private def Iterable<OperationInterface> getInheritedOperationInterfaces(OperationInterface iface) {
		val inheritedOperationInterfaces = new ArrayList<OperationInterface>
		val toIterate = new ArrayList<Interface>
		toIterate.addAll(iface.parentInterfaces__Interface)
		while (!toIterate.isEmpty) {
			val iterator = toIterate.get(0)
			toIterate.addAll(iterator.parentInterfaces__Interface)
			if (iterator instanceof OperationInterface) {
				inheritedOperationInterfaces.add(iterator)
			}
			toIterate.remove(0)
		}
		return inheritedOperationInterfaces
	}
	
	// TODO: Move to PCM helper class.
	private def Iterable<OperationInterface> getInheritedOperationInterfaces(BasicComponent bc) {
		val inheritedOperationInterfaces = new ArrayList<OperationInterface>
		for (iface : getProvidedInterfaces(bc)) {
			inheritedOperationInterfaces.addAll(getInheritedOperationInterfaces(iface))
		}
		return inheritedOperationInterfaces
	}
}